AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:InteractiveAction()
	self:EmitSound(Sound("gmodtower/inventory/use_portal.wav") , 60 )
end