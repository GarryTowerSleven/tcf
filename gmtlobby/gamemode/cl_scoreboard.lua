module( "Scoreboard.Customization", package.seeall )

// PLAYER
PlayersSort = function( a, b )
	return a:Name() and b:Name() and string.lower( a:Name() ) < string.lower( b:Name() )
end

// Subtitle (under name)
PlayerSubtitleText = function( ply )

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
		local roomid = ply:GetNWBool("RoomID")
		if roomid and roomid > 0 then
			local room = tostring( roomid ) or ""
			if room != "" then
				return "Condo #" .. room
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

// Background
/*PlayerBackgroundMaterial = function( ply )

	if ply.Location then
		local location = ply:Location()

		for material, ids in pairs( Scoreboard.PlayerList.LOCATIONVALS ) do
			if table.HasValue( ids, location ) then
				return material
			end
		end
	end

end*/

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