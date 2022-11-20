module( "Scoreboard.Customization", package.seeall )

// COLORS
ColorFont = color_white
ColorFontShadow = Color( 66, 35, 13, 255 )

ColorNormal = Color( 200, 158, 28, 255 )
ColorBright = Color( 249, 204, 71, 255 )
ColorDark = Color( 115, 72, 16, 255 )

ColorBackground = colorutil.Brighten( ColorNormal, 0.75 )

ColorTabActive = colorutil.Brighten( ColorDark, .75, 200 )
ColorTabDivider = ColorBright
ColorTabInnerActive = ColorTabActive
ColorTabHighlight = colorutil.Brighten( ColorBright, 3 )

ColorAwardsDescription = Color( 220, 220, 220, 255 )
ColorAwardsBarAchieved = Color( 174, 126, 91, 150 )
ColorAwardsBarNotAchieved = Color( 90, 60, 38, 150 )
ColorAwardsAchievedIcon = Color( 161, 219, 93, 255 )


// HEADER
HeaderTitle = ""
HeaderMatHeader = Scoreboard.GenTexture( "ScoreboardGRLogo", "gourmetrace/main_header" )
HeaderMatFiller = Scoreboard.GenTexture( "ScoreboardGRFiller", "gourmetrace/main_filler" )
HeaderMatRightBorder = Scoreboard.GenTexture( "ScoreboardGRRightBorder", "gourmetrace/main_rightborder" )

// PLAYER

/*PlayersSort = function( a, b )

	if !a:GetNWInt( "Pos" ) || !b:GetNWInt( "Pos" ) then
		return
	end

	return a:GetNWInt( "Pos" ) < b:GetNWInt( "Pos" )

end*/

// Subtitle (under name)
PlayerSubtitleText = function( ply )

	if ply:Team() == TEAM_FINISHED then
		return "FINISHED #" .. tostring(ply:GetNWInt("Pos"))
	end

	return ""

end

// Background
PlayerBackgroundMaterial = function( ply )
end

local Trophies =
{
	Scoreboard.PlayerList.MATERIALS.Trophy1,
	Scoreboard.PlayerList.MATERIALS.Trophy2,
	Scoreboard.PlayerList.MATERIALS.Trophy3
}

// Notification (above avatar)
PlayerNotificationIcon = function( ply )

	if ply.TrophyRank && ply:Team() == TEAM_FINISHED then
		if Trophies[ ply.TrophyRank ] then
			return Trophies[ ply.TrophyRank ]
		end
		return Scoreboard.PlayerList.MATERIALS.Finish
	end

	if ply:Team() == TEAM_COMPLETED then
		return Scoreboard.PlayerList.MATERIALS.Finish
	end

	return nil

end

// Jazz the player avatar? (for winner only)
PlayerAvatarJazz = function( ply )

	--if GetState() != STATE_INTERMISSION then return false end
	--if not game.GetWorld():GetNet( "Passed" ) then return false end

	return ( ply:GetNWInt( "Pos" ) == 1 )

end

// Action Box
PlayerActionBoxEnabled = true
PlayerActionBoxAlwaysShow = true
PlayerActionBoxWidth = 80
PlayerActionBoxRightPadding = 6
PlayerActionBoxBGAlpha = 80

hook.Add( "PlayerActionBoxPanel", "ActionBoxDefault", function( panel )

	Scoreboard.ActionBoxLabel(
		panel,
		nil,
		"FOOD",
		function( ply )
			return ply:GetNWInt("Points")
		end,
		nil
	)

end )
