AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function InteractiveAction()
	self:EmitSound(Sound("gmodtower/inventory/use_microwave.wav") , 60 )
end