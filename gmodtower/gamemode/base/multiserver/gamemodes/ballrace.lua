---------------------------------
GMode.Name = "Ball Race"
GMode.Gamemode = "ballrace"
GMode.ThemeColor = Color(172, 121, 84)

//Set true if players should be kicked if their "goserver" value on the database is not the same as the local server
GMode.Private = true

//This is amount of time between the players being server to play
//And the players be able to join the game
GMode.WaitingTime = 20.0

//This setting is for large group join
//When you want all people to connect at once, the server must be empty to people be able to join.
//Set this to false if you want people to be able to go in and out of the server at any time.
//Set also the min amount of players to join the sevrer
GMode.OneTimeJoin = true
GMode.MinPlayers = 1

//Set this if only a group can join
GMode.GroupJoin = false

GMode.MaxPlayers = 8 //Leave nil if the maxplayers are suppost to be the server maxplayers
GMode.Gameplay = "Physics-based Rolling"

GMode.View = {
	pos = Vector( 3553, -6116, -778 ),
	ang = Angle( 5, -108, 0 )
}
GMode.Tips = {
	"Falling will result in popping, which is altogether unpleasant.",
	"Radioactive waste is hazardous to your health.",
	"Watch for falling hazards.",
	"Collect the most bananas to get the most GMC.",
	"In Memories, be weary of the Repellers and Attractors, they can be quite dangerous!",
	"New to Ball Race? Play Skyworld first."
}

GMode.Music = {
	"GModTower/balls/BallsMusicWGrass.mp3",
	"GModTower/balls/BallsMusicWKhromidro.mp3",
	"GModTower/balls/BallsMusicWMemories.mp3",
	"GModTower/balls/BallsMusicWParadise.mp3",
	"GModTower/balls/BallsMusicWSky.mp3",
}

GMode.Maps = Maps.GetMapsInGamemode( GMode.Gamemode )

function GMode:GetMapTexture( map )

	if map == "gmt_ballracer_nightball" /*or map == "gmt_ballracer_miracle"*/ or map == "gmt_ballracer_neonlights" or map == "gmt_ballracer_metalworld" or map == "gmt_ballracer_summit" or map == "gmt_ballracer_tranquil" or map == "gmt_ballracer_facile" or map == "gmt_ballracer_waterworld" or map == "gmt_ballracer_spaceworld" or map == "gmt_ballracer_rainbowworld" then
		map = map
	else
		map = string.sub(map,0,#map-2)
	end

	return "gmod_tower/maps/" .. map

end

local bonustext = "BONUS ROUND!"

function GMode:ProcessData( ent, data )

	if #data == 0 then
		ent.NoData = true
		return
	end

	ent.NoData = false

	if data == "#nogame" then
		ent.NoGameMarkup = markup.Parse( T( "GamemodeNoGame" ) )
		ent.NoGameMarkup.PosX = ent.TotalMinX + ent.TotalWidth * 0.5 - ent.NoGameMarkup:GetWidth() / 2
		ent.NoGameMarkup.PosY = ent.TotalMinY + ent.TopHeight * 0.75 - ent.NoGameMarkup:GetHeight() / 2
		return
	else
		ent.NoGameMarkup = nil
	end

	local RoundStatus = string.Explode("/", data )
	local cur, max = tonumber(RoundStatus[1]), tonumber(RoundStatus[2])

	ent.InBonusRound = (cur < 0)

	local frac = (math.abs(cur) / max)

	ent.ProgressX = ent.TotalMinX + ent.TotalWidth * 0.05
	ent.ProgressY = ent.TotalMinY + ent.TopHeight * 0.65

	local tr = (ent.TotalMinX + ent.TotalWidth * 0.45)

	local tw = (tr - ent.ProgressX)

	ent.ProgressWidth = tw * frac
	ent.CompleteWidth = tw

	ent.ProgressHeight = 72

	local text = "<font=MultiSubDeluxe><color=white>Round:</color> " .. string.format("%d / %d", math.abs(cur), max) .. "</font>"
	ent.ProgressText = markup.Parse(text)

	ent.ProgressText.PosX = ent.ProgressX + ( tw / 2 ) - ( ent.ProgressText:GetWidth() / 2 )
	ent.ProgressText.PosY = ent.ProgressY + ( ent.ProgressHeight / 2 ) - ( ent.ProgressText:GetHeight() / 2 )

	surface.SetFont("MultiSubDeluxe")
	local w, h = surface.GetTextSize(bonustext)

	ent.BonusX = ent.TotalMinX + ent.TotalWidth * 0.75 - (w/2)
	ent.BonusY = ent.TotalMinY + ent.TopHeight * 0.75 - (h/2)

end

local color_red = Color(255, 255, 255, 100)
local color_black = Color(255, 255, 255, 150)
local color_redbonus = Color(255, 255, 255, 255)

GMode.DrawData = function( ent )

	if ent.NoData then
		return
	end

	if ent.NoGameMarkup then
		ent.NoGameMarkup:Draw( ent.NoGameMarkup.PosX, ent.NoGameMarkup.PosY )
		return
	end

	surface.SetDrawColor(255, 255, 255, 50)
	surface.DrawRect(ent.ProgressX, ent.ProgressY, ent.ProgressWidth, ent.ProgressHeight)
	surface.SetDrawColor(color_black)
	surface.DrawOutlinedRect(ent.ProgressX, ent.ProgressY, ent.CompleteWidth, ent.ProgressHeight)

	if ent.ProgressText then
		ent.ProgressText:Draw( ent.ProgressText.PosX, ent.ProgressText.PosY )
	end

	if ent.InBonusRound then
		surface.SetTextColor(color_redbonus)
		surface.SetTextPos(ent.BonusX, ent.BonusY)
		surface.SetFont("MultiSubDeluxe")
		surface.DrawText(bonustext)
	end

end
