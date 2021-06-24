
-----------------------------------------------------
module( "Scoreboard.Customization", package.seeall )

// COLORS
// COLORS

ColorFont = color_white

ColorFontShadow = Color( 6, 76, 127, 255 )



ColorNormal = Color( 34, 100, 156, 255 )

ColorBright = Color( 57, 131, 181, 255 )

ColorDark = Color( 17, 50, 78, 255 )



ColorBackground = colorutil.Brighten( ColorNormal, 0.75 )



ColorTabActive = colorutil.Brighten( ColorDark, .75, 200 )

ColorTabDivider = ColorBright

ColorTabInnerActive = ColorTabActive

ColorTabHighlight = colorutil.Brighten( ColorBright, 3 )



ColorAwardsDescription = Color( 162, 203, 233, 255 )

ColorAwardsBarAchieved = Color( 178, 215, 243, 150 )

ColorAwardsBarNotAchieved = colorutil.Brighten( Color( 3, 67, 114 ), 2, 150 )

ColorAwardsAchievedIcon = Color( 32, 255, 4, 150 )



// HEADER
HeaderTitle = ""
HeaderMatHeader = Scoreboard.GenTexture( "ScoreboardSKLogo", "sourcekarts/main_header" )
HeaderMatFiller = Scoreboard.GenTexture( "ScoreboardSKFiller", "sourcekarts/main_filler" )
HeaderMatRightBorder = Scoreboard.GenTexture( "ScoreboardSKRightBorder", "sourcekarts/main_rightborder" )

// RANK SYSTEM
local function CalculateRanks()

	if NextCalcRank && NextCalcRank > CurTime() then
		return
	end

	local Players = player.GetAll()

	table.sort( Players, function( a, b )

		local aScore, bScore = a:Frags(), b:Frags()

		if aScore == bScore then
			return a:Deaths() < b:Deaths()
		end

		return aScore > bScore

	end )

	for k, ply in pairs( Players ) do
		ply.TrophyRank = k
	end

	NextCalcRank = CurTime() + 1

end

local Trophies =
{
	Scoreboard.PlayerList.MATERIALS.Trophy1,
	Scoreboard.PlayerList.MATERIALS.Trophy2,
	Scoreboard.PlayerList.MATERIALS.Trophy3
}

// PLAYER

PlayersSort = function( a, b )

	if GAMEMODE:IsBattle() then
		CalculateRanks()

		if !a.TrophyRank || !b.TrophyRank then
			return
		end

		return a.TrophyRank < b.TrophyRank
	end

	return string.lower( a:Name() ) < string.lower( b:Name() )

end


// Notification (above avatar)
PlayerNotificationIcon = function( ply )

	if not GAMEMODE:IsBattle() then

		if ply:Team() == TEAM_FINISHED then
			return Scoreboard.PlayerList.MATERIALS.Finish
		end

	else

		if ply:Frags() > 0 then

			CalculateRanks()

			if ply.TrophyRank then
				return Trophies[ ply.TrophyRank ]
			end

		end

	end

	return nil

end

// Subtitle (under name)
PlayerSubtitleText = function( ply )

	if ply:Team() == TEAM_FINISHED then
		if GAMEMODE:IsBattle() then
			return "ELIMINATED"
		else
			return "FINISHED " .. string.NumberToNth( ply:GetPosition() )
		end
	end

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
		"LAP",
		function( ply )
			if ply:Team() == TEAM_PLAYING && !GAMEMODE:IsBattle() then
				return ply:GetLap()
			end
		end,
		nil
	)

	Scoreboard.ActionBoxLabel(
		panel,
		nil,
		"LAP TIME",
		function( ply )
			if ply:Team() == TEAM_PLAYING && !GAMEMODE:IsBattle() then
				return string.FormattedTime( GAMEMODE:GetTimeElapsed( ply:GetLapTime() ), "%02i:%02i:%02i" )
			end
		end,
		nil,
		95
	)

	Scoreboard.ActionBoxLabel(
		panel,
		nil,
		"BEST LAP",
		function( ply )
			if ply:Team() == TEAM_FINISHED && !GAMEMODE:IsBattle() then
				return string.FormattedTime( ply:GetBestLapTime() or 0, "%02i:%02i:%02i" )
			end
		end,
		nil
	)

	Scoreboard.ActionBoxLabel(
		panel,
		nil,
		"HITS",
		function( ply )
			if GAMEMODE:IsBattle() then
				return ply:Frags()
			end
		end,
		nil
	)

	Scoreboard.ActionBoxLabel(
		panel,
		nil,
		"LIVES",
		function( ply )
			if GAMEMODE:IsBattle() then
				return ( GAMEMODE.MaxLives - ply:Deaths() )
			end
		end,
		nil
	)

end )
