include("nwvar/shared.lua")
include("sh_load.lua")
include("shared.lua")
include("sh_loadables.lua")

// this is to protect console commands you believe could be called at bad times (the player isn't valid to the server yet)
// or the game would put the command in the buffer to execute on the map change
hook.Add("Think", "PlayerValid", function()
	if IsValid(LocalPlayer()) && (GetWorldEntity() != NULL) then
		SafeToSend = true
		hook.Remove("Think", "PlayerValid")
	end
end)

hook.Add( "CalcView", "FullyConnected", function()
	hook.Remove( "CalcView", "FullyConnected" )
	
	net.Start( "ClientFullyConnected" )
	net.SendToServer()
end )