---------------------------------
GTowerClick = {}
GTowerClick.MaxDis = 2048

local oldGuiEnable = gui.EnableScreenClicker

IsClickerEnabled = false

function gui.EnableScreenClicker( bool )
	oldGuiEnable( bool )
	IsClickerEnabled = bool
end

function gui.ScreenClickerEnabled()
	return IsClickerEnabled
end

function GetMouseVector()
	return gui.ScreenToVector( gui.MousePos() )
end

function GetMouseAimVector()
	if gui.ScreenClickerEnabled() then
		return GetMouseVector()
	else
		return LocalPlayer():GetAimVector()
	end
end

local function CanMouseEnt()
	return hook.Call("CanMousePress", GAMEMODE ) != false
end

hook.Add("GUIMousePressed", "GtowerMousePressed", function( mc )
	if !CanMouseEnt() then return end

	GtowerMenu:CloseAll()
	local trace = LocalPlayer():GetEyeTrace()

	local cursorvec = GetMouseVector()
	local origin = LocalPlayer():GetShootPos()
	trace = util.TraceLine( { start = origin,
							  endpos = origin + cursorvec * 9000,
							  filter = { LocalPlayer() }
	} )

	if !IsValid(trace.Entity) then return end

	if trace.Entity:IsPlayer() then
		GTowerClick:ClickOnPlayer( trace.Entity, mc )
	else
		hook.Call("GtowerMouseEnt", GAMEMODE, trace.Entity )
	end
end )



hook.Add( "KeyPress", "GtowerMousePressedEmpty", function( ply, key )
	if !IsFirstTimePredicted() || key != IN_ATTACK || !CanMouseEnt() || IsValid(LocalPlayer():GetActiveWeapon()) then return end

	
	local trace = LocalPlayer():GetEyeTrace()


	if !IsValid(trace.Entity) || trace.Entity:IsPlayer() then return end

	hook.Call("GtowerMouseEnt", GAMEMODE, trace.Entity )
end )
hook.Add( "GUIMousePressed", "GTowerMousePressed", function( mc )

	if !CanMouseEnt() then return end

	GTowerMenu:CloseAll()
	local trace = LocalPlayer():GetEyeTrace()

	// More precise handling of mouse vector + third person support
	if IsLobby then

		local cursorvec = GetMouseVector()
		local origin = LocalPlayer().CameraPos
		trace = util.TraceLine( {
			start = origin, 
			endpos = origin + cursorvec * 9000,
			filter = { LocalPlayer() }
		} )

	end

	// World click pulls up menu
	if LocalPlayer():IsAdmin() && trace.HitWorld && mc != MOUSE_LEFT then
		GTowerClick:ClickOnPlayer( LocalPlayer(), mc )
		return
	end

	if !IsValid( trace.Entity ) then return end

	// Click on players
	if trace.Entity:IsPlayer() then
		GTowerClick:ClickOnPlayer( trace.Entity, mc )

	// Click on players in a ball
	elseif trace.Entity:GetClass() == "gmt__ballrace" then
		GTowerClick:ClickOnPlayer( trace.Entity:GetOwner(), mc )

	// Inventory items
	else
		hook.Call("GTowerMouseEnt", GAMEMODE, trace.Entity, mc )
	end

end )

hook.Add( "KeyPress", "GTowerMousePressedEmpty", function( ply, key )

	if !IsFirstTimePredicted() || key != IN_ATTACK || !CanMouseEnt() || IsValid(LocalPlayer():GetActiveWeapon()) then return end
	
	local trace = LocalPlayer():GetEyeTrace()

	if IsLobby then
		local cursorvec = GetMouseVector()
		local origin = LocalPlayer().CameraPos
		trace = util.TraceLine( { 
			start = origin, 
			endpos = origin + cursorvec * 9000,
			filter = { LocalPlayer() }
		} )
	end

	if !IsValid(trace.Entity) || trace.Entity:IsPlayer() then return end

	hook.Call("GTowerMouseEnt", GAMEMODE, trace.Entity, mc )

end )