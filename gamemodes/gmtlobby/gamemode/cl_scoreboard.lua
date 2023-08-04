module( "Scoreboard.Customization", package.seeall )

if ( not IsLobbyOne ) then
	ColorNormal = Color( 55, 55, 111, 255 )
	ColorBright = Color( 125, 125, 175, 255 )
	ColorDark = Color( 25, 25, 61, 255 )

	ColorBackground = colorutil.Brighten( ColorNormal, 0.75 )

	ColorTabActive = colorutil.Brighten( ColorDark, .75, 200 )
	ColorTabDivider = ColorBright
	ColorTabInnerActive = ColorTabActive
	ColorTabHighlight = colorutil.Brighten( ColorBright, 3 )

	ColorAwardsDescription = Color( 162, 203, 233, 255 )
	ColorAwardsBarAchieved = Color( 125, 125, 175, 150 )
	ColorAwardsBarNotAchieved = Color( 55, 55, 111, 255 )
	ColorAwardsAchievedIcon = Color( 225, 225, 225, 150 )

	HeaderTitle = "GMT: Deluxe"

	HeaderMatHeader = Scoreboard.GenTexture( "ScoreboardDeluxeLogo", "main_header_deluxe" )
	HeaderMatFiller = Scoreboard.GenTexture( "ScoreboardDeluxeFiller", "main_filler_deluxe" )
	HeaderMatRightBorder = Scoreboard.GenTexture( "ScoreboardDeluxeRightBorder", "main_rightborder_deluxe" )
end

// PLAYER
PlayersSort = function( a, b )
	return a:Name() and b:Name() and string.lower( a:Name() ) < string.lower( b:Name() )
end

// Subtitle (under name)
PlayerSubtitleText = function( ply )

	//if !ply.IsLoading && !ply:GetNWBool("FullyConnected") then return "Sending client info..." end

	local text = "Somewhere"

	//Check if the location module is loaded
	if ply.LocationName then
		text = ply:LocationName()
	end

	return text

end

// Subtitle right (under name)
PlayerSubtitleRightText = function( ply )

	if ply.IsLoading or ply:IsBot() or !IsValid( ply ) then return "" end

	if ply then
		-- Room number
		local roomid = ply:GetNWInt("RoomID")
		if roomid and roomid > 0 then
			local room = tostring( roomid ) or ""
			if room != "" then
				return "Suite #" .. room
			end
		end

		-- Dueling
		local duel = ply:GetNWEntity( "DuelOpponent" )
		if IsValid( duel ) then
			return "Dueling " .. duel:Name()
		end
	end

	return ""

end

// Info Value
PlayerInfoValueVisible = function( ply )
	return false
end

PlayerInfoValueIcon = nil
PlayerInfoValueGet = function( ply )
	return nil
end

// Cache Location Backgrounds
local LocationBackgrounds = {}

if ( Location ) then
	for location, _ in pairs( Location.Locations ) do
		if ( Location.IsSuite( location ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Suite
			continue
		elseif ( Location.IsNarnia( location ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Narnia
			continue
		elseif ( Location.IsGroup( location, "lakeside" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Lakeside
			continue
		elseif ( Location.Is( location, "Pool" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Pool
			continue
		elseif ( Location.IsGroup( location, "eplaza" ) or Location.IsGroup( location, "stores" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Eplaza
			continue
		elseif ( Location.Is( location, "Arcade" ) or Location.Is( location, "Arcade Stairs" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Arcade
			continue
		elseif ( Location.Is( location, "Casino" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Casino
			continue
		elseif ( Location.IsGroup( location, "bar" ) ) or Location.Is( location, "Bar Stairs" ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Bar
			continue
		elseif ( Location.Is( location, "Theater" ) or Location.Is( location, "Theater Hallway" ) or Location.Is( location, "Theater Vents" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Theater
			continue
		elseif ( Location.Is( location, "Moon" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Moon
			continue
		elseif ( Location.IsGroup( location, "gamemodeports" ) or Location.Is( location, "Gamemode Teleporters" ) or Location.IsGroup( location, "minigolf" ) or Location.IsGroup( location, "sourcekarts" ) or Location.IsGroup( location, "pvpbattle" ) or Location.IsGroup( location, "ballrace" ) or Location.IsGroup( location, "ultimatechimerahunt" ) or Location.IsGroup( location, "zombiemassacre" ) or Location.IsGroup( location, "virus" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Gamemodes
			continue
		elseif ( Location.IsGroup( location, "trainstation" ) ) then
			LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Train
			continue
		end
		
		LocationBackgrounds[ location ] = Scoreboard.PlayerList.LOCATIONS.Lobby
	end
end

// Background
PlayerBackgroundMaterial = function( ply )

	if ( not IsLobbyOne ) then return end
	if ( not Location or not ply.Location ) then return end

	return LocationBackgrounds[ ply:Location() ] or Scoreboard.PlayerList.LOCATIONS.Lobby

end

// Notification (above avatar)
PlayerNotificationIcon = function( ply )

	if ply:GetNet( "AFK" ) then
		return Scoreboard.PlayerList.MATERIALS.Timer
	end

	if GTowerGroup then
		if GTowerGroup.GroupOwner == ply && GTowerGroup:IsInGroup( LocalPlayer() ) then
			return Scoreboard.PlayerList.MATERIALS.Crown
		end
	end

	return nil

end