module( "Scoreboard.Customization", package.seeall )

// HEADER
HeaderTitle = "Halloween"

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