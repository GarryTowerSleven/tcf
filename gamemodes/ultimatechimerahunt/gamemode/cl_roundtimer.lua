local sw, sh = ScrW(), ScrH()
local timerticks = {}
	
surface.CreateFont( "UCH_Box", { font = "AlphaFridgeMagnets ", size = ScreenScale( 12), weight = 500 } )
surface.CreateFont( "UCH_Box2", { font = "AlphaFridgeMagnets ", size = ScreenScale( 16), weight = 500 } )

local function UpdateRoundTimer( um )

	local num = um:ReadLong()
	table.insert( timerticks, { CurTime(), num } )

	GAMEMODE.LastTimerAdd = GAMEMODE.LastTimerAdd || 0

	if CurTime() >= GAMEMODE.LastTimerAdd then
		GAMEMODE.LastTimerAdd = CurTime() + .4
		surface.PlaySound( "UCH/newmusic/roundtimer_add.wav" )
	end

end
usermessage.Hook( "UpdateRoundTimer", UpdateRoundTimer )

function GM:DrawTimerTicks()

	for k, v in ipairs( timerticks ) do

		local t, num = v[1] + 1, v[2]
		local fade = t - CurTime()
		
		local alpha = math.Clamp( fade, 0, 255 )
		self:DrawNiceText( "+" .. tostring( num ), "UCH_TargetIDName", ( ( sw * .58 ) - ( fade * ( sw * .1 ) ) ), 0, Color( 255, 255, 255, alpha * 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, alpha * 150 )

		if CurTime() >= t then
			table.remove( timerticks, k )
		end

	end

end

local pmat = surface.GetTextureID( "UCH/hud/pighud_time" )
local pemat = surface.GetTextureID( "UCH/hud/pighude_time" )
local pCmat = surface.GetTextureID( "UCH/hud/pighudc_time" )
local ucmat = surface.GetTextureID( "UCH/hud/chimerahud_time" )
local rect = Material("uch/hud/hud_box")
local ensignLogo = surface.GetTextureID( "UCH/ranks/ensign" )
local deadLogo = surface.GetTextureID( "UCH/ranks/ensign_dead" )

local ranks = {
	[RANK_ENSIGN] = {
		surface.GetTextureID( "UCH/ranks/ensign" ),
		surface.GetTextureID( "UCH/ranks/ensign_dead" )
	},
	[RANK_CAPTAIN] = {
		surface.GetTextureID( "UCH/ranks/captain" ),
		surface.GetTextureID( "UCH/ranks/captain_dead" )
	},
	[RANK_MAJOR] = {
		surface.GetTextureID( "UCH/ranks/major" ),
		surface.GetTextureID( "UCH/ranks/major_dead" )
	},
	[RANK_COLONEL] = {
		surface.GetTextureID( "UCH/ranks/colonel" ),
		surface.GetTextureID( "UCH/ranks/colonel_dead" )
	},
}

local function drawBox(x, y, w, h, color, thick, round, rot)

	if rot then
		local matrix = Matrix()
		matrix:Translate(Vector(x, y, 0))
		matrix:Rotate(Angle(0, rot, 0))

		cam.PushModelMatrix(matrix)

		x = 0
		y = 0
	end

	thick = thick or 3
	round = round or 8
	draw.RoundedBox(round, x, y, w, h, color[2])
	draw.RoundedBox(round - 2, x + thick, y + thick, w - thick * 2, h - thick * 2, color[1])

	if rot then
		cam.PopModelMatrix()
	end
end

local round = 1

function GM:DrawRoundTime()

	round = math.Approach(round, !LocalPlayer():KeyDown(IN_SCORE) && self:GetState() == STATE_PLAYING && CurTime() - globalnet.GetNet( "RoundStart" ) > 3 && 0 || 1, FrameTime() * 2)
	local round = math.ease.InSine(round)

	local color = LocalPlayer():GetRankColor()
	local color3 = color
	color = Color(color.r / 1.5, color.g / 1.5, color.b / 1.5)
	local color2 = Color(color.r / 2, color.g / 2, color.b / 2)
	local colors = {color, color2}

	local ply = LocalPlayer()
	local rank = ply:GetNet( "Rank" )

	local tm = self:GetTimeLeft()

	if tm then

		tm = string.FormattedTime( tm, "%2i:%02i" )

	end

	if !self:GetTimeLeft() || self:GetTimeLeft() < 0 then
		tm = "-:-"
	end

	//tm = string.Trim( tm )

	surface.SetFont( "UCH_Box2" )
	local txtw, txth = surface.GetTextSize( "Waiting" )
	
	local rounds = "-/" .. self.NumRounds
	if self:IsPlaying() || self:GetState() == STATE_INTERMISSION then
		rounds = globalnet.GetNet( "Round" ) .. "/" .. self.NumRounds
	end

	local tw = surface.GetTextSize(string.Replace(tm, ":", "-"))

	if !ply:IsGhost() then

		if rank == RANK_ENSIGN then

			local base = (Vector(200, 100, 150) / 255)
			colors = {Color(200, 120, 160), Color(100, 64, 64)}
			color3 = color_white

		elseif rank == RANK_COLONEL then

			colors = {Color(220, 220, 220), Color(80, 80, 80)}
			color3 = color_white

		elseif rank == RANK_MAJOR then

			colors = {Color(71, 163, 71), Color(32, 82, 32)}
			color3 = Color(71, 163, 71)

		end
		
		if ply:GetNet( "IsChimera" ) then

			colors = {Color(230, 25, 111), Color(85, 15, 54)}
			color3 = Color(255, 200, 0)

		end

	end

	local x, y = ScrW() / 2, 0
	local round2 = 1 - round
	x = ScrW() * 0.5

	local add = 64 + 24

	local w, h = 200, 60


	if round != 0 then

		colors[1].a = 255 * round
		colors[2].a = 255 * round

		drawBox(ScrW() / 2 - 64 + add * round, -16, 128, 72 + 8, colors)

		colors[1].a = 255
		colors[2].a = 255

		draw.SimpleTextOutlined( "ROUND", "UCH_Box", ScrW() / 2 + add * round, -4, Color(color3.r, color3.g, color3.b, 255 * round), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, Color(colors[2].r, colors[2].g, colors[2].b, 255 * round) )
	
	self:DrawNiceText( rounds, "UCH_Box2", ScrW() / 2 + add * round, 18, Color( 255, 255, 255, round * 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, round * 200 )

	end

	drawBox(ScrW() / 2 - 64 - add * round, -16, 128, 72 + 8, colors)
	draw.SimpleTextOutlined( "TIME", "UCH_Box", ScrW() / 2 - add * round, -4, color3, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, colors[2] )
	self:DrawNiceText( tm, "UCH_Box2", ScrW() / 2 - add * round - tw / 2, 18, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, 200 )

	local x, y = ScrW() * 0.9, ScrH() * 0.875
	local w, h = 128, 80
	local pigs = #team.GetPlayers( TEAM_PIGS )
	local tw = surface.GetTextSize( pigs )
	drawBox( x, y, w, h, colors )
	draw.SimpleTextOutlined( "PIGS", "UCH_Box", x + w / 2, y + 8, color3, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, colors[2] )
	self:DrawNiceText( pigs, "UCH_Box2", x + w / 2 + tw / 2 + (string.len(pigs) > 1 && -8 or pigs == 1 && 2 || 0), y + h - 48, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, 200 )

	surface.SetTexture(ranks[ply:GetNet("IsChimera") && RANK_ENSIGN || ply:GetNet("Rank")][1])
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(x + w / 2 - tw / 2 - 24, y + h - 48, 48, 48)
end