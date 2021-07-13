---------------------------------
GMode.Name = "PVP Battle"
GMode.Gamemode = "pvpbattle"

//Set true if players should be kicked if their "goserver" value on the database is not the same as the local server
GMode.Private = true

//This is amount of time between the players being server to play
//And the players be able to join the game
GMode.WaitingTime = 15.0

//This setting is for large group join
//When you want all people to connect at once, the server must be empty to people be able to join.
//Set this to false if you want people to be able to go in and out of the server at any time.
//Set also the min amount of players to join the sevrer
GMode.OneTimeJoin = true
GMode.MinPlayers = 2

//Set this if only a group can join,
GMode.GroupJoin = false

GMode.View = {
	pos = Vector( 5522, -6125, -812 ),
	ang = Angle( 3, -111, 0.000000 )
}
GMode.Music = {
	"GModTower/pvpbattle/StartOfColonyRound.mp3",
	"GModTower/pvpbattle/StartOfConstructionRound.mp3",
	"GModTower/pvpbattle/StartOfContainerShipRound.mp3",
	"GModTower/pvpbattle/StartOfFrostbiteRound.mp3",
	"GModTower/pvpbattle/StartOfMeadowRound.mp3",
	"GModTower/pvpbattle/StartOfOneSlipRound.mp3",
	"GModTower/pvpbattle/StartOfThePitRound.mp3",
}

GMode.Tips = {
	"Pickup the Rage powerup and punch smash all your foes with your fists", -- Frost Bite & Colony
	"With the Headphones On Your Heart powerup, you'll regain health", -- Construction
	"With the Pulp Vibe powerup, you can jump off of walls", -- Container Ship
	"The Candy Corn Of Death is unlimited - fire like crazy!", -- Pit
	"Grab the pimp hat to become invincible", -- Meadows
	"Get the Take On Me ball to run faster", -- Frost Bite
	"Be careful not to fall out into space",  -- Oneslip
	"Use the secondary attack with the sword and dash towards your foes",
	"You can throw the chainsaw with secondary attack",
	"Did you find the secret to the Toy Hammer?",
	"When crouched with the Stealth Pistol, you'll be partially invisible",
	"The Akimbo fires with both primary and secondary",
	"Did you know you can fly up with the Patriot?",
	"Blast yourself into the air with the Super Shotty",
	"The Raging Bull ricochets everywhere - don't ever forget that!",
	"Throwing babies is unhealthy",
	"The Stealth Box makes you invisible, as long as you don't move",
	"PVP is all about killing everyone as quickly as possible",
	"Don't be shy - use all of your ammo!",
}

GMode.Maps = Maps.GetMapsInGamemode( GMode.Gamemode )

GMode.MaxPlayers = 8 //Leave nil if the maxplayers are suppost to be the server maxplayers
GMode.Gameplay = "FPS"

function GMode:GetMapTexture( map )
	map = string.sub(map,0,#map-2)

	return "gmod_tower/maps/" .. map

end

function GMode:ProcessData( ent, data )
	if data == "#nogame" then
		ent.TimeLeftMarkup = markup.Parse( "<font=Gtowerbig><color=ltgrey>NO GAME RUNNING - JOIN IT!</color><font>" )
		ent.TimeLeftMarkup.PosX = ent.TotalMinX + ent.TotalWidth * 0.5 - ent.TimeLeftMarkup:GetWidth() / 2
		ent.TimeLeftMarkup.PosY = ent.TotalMinY + ent.TopHeight * 0.75 - ent.TimeLeftMarkup:GetHeight() / 2
		ent.RoundsMarkup = nil
	return end

	local Exploded = string.Explode( "||||", data )

	local Timeleft = string.Explode("/", Exploded[1] )
	local TimeLeftString = ""

	if #Timeleft == 2 then
		TimeLeftString = "<font=Gtowerbig><color=white>"..Timeleft[1].."</color> <color=ltgrey>min</color> / <color=white>"..Timeleft[2].."</color> <color=ltgrey>min</color></font>"
	else
		TimeLeftString = Exploded[1]
	end


	local Rounds = "<font=Gtowerbig><color=ltgrey>Round: </color> " .. string.sub( Exploded[2], 4 ) .. "</font>"

	ent.TimeLeftMarkup = markup.Parse( TimeLeftString )
	ent.RoundsMarkup = markup.Parse( Rounds )

	ent.TimeLeftMarkup.PosX = ent.TotalMinX + ent.TotalWidth * 0.25 - ent.TimeLeftMarkup:GetWidth() / 2
	ent.TimeLeftMarkup.PosY = ent.TotalMinY + ent.TopHeight * 0.75 - ent.TimeLeftMarkup:GetHeight() / 2

	ent.RoundsMarkup.PosX = ent.TotalMinX + ent.TotalWidth * 0.75 - ent.RoundsMarkup:GetWidth() / 2
	ent.RoundsMarkup.PosY = ent.TotalMinY + ent.TopHeight * 0.75 - ent.RoundsMarkup:GetHeight() / 2

end

GMode.DrawData = function( ent )

	if ent.TimeLeftMarkup then
		ent.TimeLeftMarkup:Draw( ent.TimeLeftMarkup.PosX, ent.TimeLeftMarkup.PosY )
	end

	if ent.RoundsMarkup then
		ent.RoundsMarkup:Draw( ent.RoundsMarkup.PosX, ent.RoundsMarkup.PosY )
	end

end
