module( "Scoreboard.Customization", package.seeall )

// COLORS
ColorFont = color_white

ColorNormal = Color( 37, 37, 37)
ColorBright = Color( 56, 56, 56)
ColorDark = Color( 14, 14, 14)

ColorBackground = colorutil.Brighten( ColorNormal, 0.75 )

ColorTabActive = colorutil.Brighten( ColorDark, 0.75, 150 )
ColorTabDivider = ColorBright
ColorTabInnerActive = ColorTabActive
ColorTabHighlight = colorutil.Brighten( ColorBright, 3 )

ColorAwardsDescription = Color( 255, 255, 255)
ColorAwardsBarAchieved = Color( 255, 255, 255, 150)
ColorAwardsBarNotAchieved = Color( 177, 177, 177, 150)
ColorAwardsAchievedIcon = Color( 255, 255, 255)

// HEADER
HeaderTitle = "Halloween"

-- Dark default texture
HeaderMatHeader = Material( "tools/toolsblack" )
HeaderMatFiller = Material( "tools/toolsblack" )


// PLAYER
// Subtitle (under name)
PlayerSubtitleText = function( ply )

	if ( ply:GetNet( "PlayerLocation" ) > 1 ) then
		return "Into the Madness"
	elseif ply:InVehicle() && ply:GetNet( "PlayerLocation" ) == 1 then
		return "On the Ride"
	else
		return "Halloween Ride"
	end

end