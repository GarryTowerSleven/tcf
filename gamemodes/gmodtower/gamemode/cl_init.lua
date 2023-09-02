include("shared.lua")
include("sh_load.lua")
include("sh_loadables.lua")

// this is to protect console commands you believe could be called at bad times (the player isn't valid to the server yet)
// or the game would put the command in the buffer to execute on the map change

function GM:CalcVehicleView()
end

if !HA then
	HA = hook.Add
	hook.Add = function(...)
		local a = {...}
		if a[1] == "OnViewModelChanged" then return end
		HA(...)
	end
end

hook.Add( "Think", "PlayerValid", function()

	if IsValid( LocalPlayer() ) && ( GetWorldEntity() != NULL ) then
		SafeToSend = true
		hook.Remove( "Think", "PlayerValid" )
	end

end )