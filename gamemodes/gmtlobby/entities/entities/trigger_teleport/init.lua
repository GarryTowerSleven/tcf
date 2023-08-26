include("shared.lua")
AddCSLuaFile("shared.lua")

local function locateTarget(trigger)
	local destination = ents.FindByName(trigger.Target)[1]
	if !IsValid(destination) then return end

	trigger.TargetName = destination:GetName()

	-- If there's a trigger_teleport in the destination, use that instead for more accurate results.
	for k, v in pairs( ents.FindInSphere(destination:GetPos(), 256) ) do
		if v:GetClass() == "trigger_teleport" then
			destination = v
			break
		end
	end

	trigger.TargetEntity = destination
end

hook.Add("InitPostEntity", "FindTeleporters", function()
	for _, trigger in pairs( ents.FindByClass("trigger_teleport") ) do
		if trigger.Target then
			locateTarget(trigger)
		end
	end
end)