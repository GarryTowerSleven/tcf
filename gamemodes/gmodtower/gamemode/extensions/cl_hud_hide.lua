
HudToHide = { "CHUDQuickInfo", "CHudSuitPower", "CHudZoom" }

if IsLobby && !table.HasValue( HudToHide, "CHudCrosshair" ) then
	table.insert( HudToHide, "CHudCrosshair" )
end

//Somewhy when I hook two things to HUDShouldDraw, only 1 get's called
//Making this global D:

function GM:HUDShouldDraw( Name )
	return !table.HasValue( HudToHide, Name )
end

function GM:HUDDrawPickupHistory()
	return false
end