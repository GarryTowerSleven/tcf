GMode.Name = "PVP Battle"
GMode.Gamemode = "pvpbattle"

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
GMode.MinPlayers = 4

//Set this if only a group can join,
GMode.GroupJoin = false

GMode.View = {
	pos = Vector( 9601, 9737, 6715 ),
	ang = Angle( -6.5, 160.2, 0 )
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
	if map == "gmt_pvp_neo" or map == "gmt_pvp_mars" or map == "gmt_pvp_aether" then
		map = map
	else
		map = string.sub(map,0,#map-2)
	end

	return "gmod_tower/maps/" .. map

end

function GMode:ProcessData( ent, data )

	// No game
	ent.NoData = ( #data == 0 )
	if ent.NoData then return end
	
	// No game
	if data == "#nogame" then
		ent.NoGameMarkup = markup.Parse( T( "GamemodePanelNoGame" ) )
		ent.NoGameMarkup.PosX = ent.TotalMinX + ent.TotalWidth * 0.5 - ent.NoGameMarkup:GetWidth() / 2
		ent.NoGameMarkup.PosY = ent.TotalMinY + ent.TopHeight * 0.75 - ent.NoGameMarkup:GetHeight() / 2
		return
	end

	ent.NoGameMarkup = nil

	local leftTitle = "TIME LEFT"
	local rightTitle = "ROUND"
	
	local Exploded = string.Explode( "||||", data )
	local Timeleft = tonumber( Exploded[1] )
	
	local leftString = string.NiceTimeShort( Timeleft, true )
	
	// Rounds
	local roundExploded = string.Explode( "/", Exploded[2] )
	local CurRound = roundExploded[1]
	local MaxRounds = roundExploded[2]
	
	local rightString = string.format( "%d <color=ltgrey>/</color> %d", CurRound, MaxRounds )
	
	// Parse and set position
	ent.LeftTitle = markup.Parse( "<font=GTowerGMTitle><color=grey>" .. leftTitle .. "</color></font>" )
	ent.LeftMarkup = markup.Parse( "<font=GTowerHUDMainLarge>" .. leftString .. "</font>" )
	
	PositionCenter( ent, ent.LeftTitle, 0.15, 0.60 )
	PositionCenter( ent, ent.LeftMarkup, 0.15, 0.85 )
	
	ent.RightTitle = markup.Parse( "<font=GTowerGMTitle><color=grey>" .. rightTitle .. "</color></font>" )
	ent.RightMarkup = markup.Parse( "<font=GTowerHUDMainLarge>" .. rightString .. "</font>" )
	
	PositionCenter( ent, ent.RightTitle, 0.85, 0.60 )
	PositionCenter( ent, ent.RightMarkup, 0.85, 0.85 )

end

GMode.DrawData = function( ent )

	if ent.NoGameMarkup then
		ent.NoGameMarkup:Draw( ent.NoGameMarkup.PosX, ent.NoGameMarkup.PosY )
		return
	end
	
	if ent.LeftMarkup then
		ent.LeftTitle:Draw( ent.LeftTitle.PosX, ent.LeftTitle.PosY )
		ent.LeftMarkup:Draw( ent.LeftMarkup.PosX, ent.LeftMarkup.PosY )
	end
	
	if ent.RightMarkup then
		ent.RightTitle:Draw( ent.RightTitle.PosX, ent.RightTitle.PosY )
		ent.RightMarkup:Draw( ent.RightMarkup.PosX, ent.RightMarkup.PosY )
	end

end
