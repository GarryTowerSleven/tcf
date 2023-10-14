hook.Add( "CanOpenMenu", "CanOpenMenuRide", function()

	return !(IsValid( LocalPlayer():GetVehicle() ) && LocalPlayer():GetVehicle().IsRide)

end )

hook.Add( "GTowerHUDShouldDraw", "DisableHUDRide", function()

	if IsValid( LocalPlayer():GetVehicle() ) && LocalPlayer():GetVehicle().IsRide then
		return false
	end

end )

hook.Add( "DisableThirdpersonAll", "DisableThirdpersonAllRide", function()

	return IsValid( LocalPlayer():GetVehicle() ) && LocalPlayer():GetVehicle().IsRide

end )

net.Receive( "UseRide", function()

	vgui.CloseDermaMenus()
	GTowerMenu:CloseAll()

end )