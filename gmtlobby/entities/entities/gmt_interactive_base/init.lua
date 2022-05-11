AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetTrigger(true)

	self:DrawShadow(false)

end

function InteractiveAction()
end

function ENT:Use()

	if self.Wait then return end
	self.WaitTime = CurTime() + self.SetWaitTime
	self.Wait = true
	InteractiveAction()

end

function ENT:Think()

	if self.WaitTime < CurTime() && self.Wait then
		self.Wait = false
	end

end
