AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/props/cs_office/microwave.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetTrigger(true)

	self:DrawShadow(false)

	self.WaitTime = 0
	self.Wait = false

end

function ENT:Use(eOtherEnt)

	if self.Wait then return end
	self.WaitTime = CurTime() + 2
	self.Wait = true
	self:EmitSound(Sound("gmodtower/inventory/use_microwave.wav") , 60 )

end

function ENT:Think()

	if self.WaitTime < CurTime() && self.Wait then
		self.Wait = false
	end

end