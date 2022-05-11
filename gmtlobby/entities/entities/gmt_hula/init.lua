AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:InteractiveAction()
	self:Dance()
	self:EmitSound(Sound("gmodtower/inventory/use_hula.wav") , 60 )
end