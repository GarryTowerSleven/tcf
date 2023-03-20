module( "Scoreboard.Customization", package.seeall )

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

// ehhh
local gamemodelocations = {
	[Location.GetIDByName( "Ballrace Port" )] = true,
	[Location.GetIDByName( "Minigolf Port" )] = true,
	[Location.GetIDByName( "Source Karts Port" )] = true,
	[Location.GetIDByName( "PVP Battle Port" )] = true,
	[Location.GetIDByName( "Ballrace Port" )] = true,
	[Location.GetIDByName( "UCH Port" )] = true,
	[Location.GetIDByName( "ZM Port" )] = true,
	[Location.GetIDByName( "Virus Port" )] = true,
}

// Background
PlayerBackgroundMaterial = function( ply )

	if ply.Location then
		local location = ply:Location()

		if ( Location.IsSuite( location ) ) then
			return Scoreboard.PlayerList.LOCATIONS.Suite
		elseif ( Location.IsNarnia( location ) ) then
			return Scoreboard.PlayerList.LOCATIONS.Narnia
		elseif ( Location.IsGroup( location, "gamemodeports" ) or Location.Is( location, "Gamemode Teleporters" ) or gamemodelocations[ location ] ) then
			return Scoreboard.PlayerList.LOCATIONS.Gamemode
		end
	end

	return Scoreboard.PlayerList.LOCATIONS.Lobby

end

// Notification (above avatar)
PlayerNotificationIcon = function( ply )

	if ply.IsAFK && ply:IsAFK() then
		return Scoreboard.PlayerList.MATERIALS.Timer
	end

	if GTowerGroup then
		if GTowerGroup.GroupOwner == ply && GTowerGroup:IsInGroup( LocalPlayer() ) then
			return Scoreboard.PlayerList.MATERIALS.Crown
		end
	end

	return nil

end