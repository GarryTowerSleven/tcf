include('shared.lua')

net.Receive("TurtleUse",function()
	local bool = net.ReadBool()
	local turtle = net.ReadEntity()

	if IsValid(turtle) then
	
		if bool then
			turtle:EmitSound( "garrysmod/save_load1.wav", 60, 50, 1, CHAN_AUTO )
		else
			turtle:EmitSound( "garrysmod/save_load3.wav", 60, 25, 1, CHAN_AUTO )
		end
	
	end
end)

hook.Add( "DisableThirdpersonAll", "LimboDisableThirdperson", function()
	if ( LocalPlayer():GetNWBool( "InLimbo", false ) ) then
		return true
	end
end )

hook.Add( "DisableMenu", "LimboDisableMenus", function()
	if ( LocalPlayer():GetNWBool( "InLimbo", false ) ) then
		return true
	end
end )

hook.Add( "GTowerInventoryDisable", "LimboDisableInventory", function()
	if ( LocalPlayer():GetNWBool( "InLimbo", false ) ) then
		return true
	end
end )

hook.Add( "GTowerHUDShouldDraw", "LimboHide", function()

	if LocalPlayer():GetNWBool( "InLimbo", false ) then
		return false
	end

end )