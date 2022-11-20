module( "Scoreboard.Customization", package.seeall )

ShowBackgrounds = false

// COLORS
ColorFont = color_white
ColorFontShadow = Color( 6, 76, 127, 255 )

ColorNormal = Color( 34, 100, 156, 255 )
ColorBright = Color( 57, 131, 181, 255 )
ColorDark = Color( 17, 50, 78, 255 )

ColorBackground = colorutil.Brighten( ColorNormal, 0.75 )

ColorTabActive = Color( 0, 0, 64, 64 )
ColorTabDivider = ColorBright
ColorTabInnerActive = colorutil.Brighten( ColorDark, 0.75, 200 )
ColorTabHighlight = Color( 77, 151, 201, 255 )

ColorAwardsDescription = Color( 162, 203, 233, 255 )
ColorAwardsBarAchieved = Color( 178, 215, 243, 255 )
ColorAwardsBarNotAchieved = Color( 3 + 10, 67 + 10, 114 + 10, 200 )
ColorAwardsAchievedIcon = Color( 32, 255, 4, 150 )


// HEADER
HeaderTitle = "GMTower"
HeaderMatHeader = Scoreboard.GenTexture( "ScoreboardLogo", "main_header" )
HeaderMatFiller = Scoreboard.GenTexture( "ScoreboardFiller", "main_filler" )
HeaderMatRightBorder = Scoreboard.GenTexture( "ScoreboardRightBorder", "main_rightborder" )


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
		local duel = ply:GetNWBool("DuelOpponent")
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