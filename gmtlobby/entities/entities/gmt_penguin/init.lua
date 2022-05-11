AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/gmod_tower/plush_penguin.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:SetTrigger(true)

	self:DrawShadow(false)
	self:SetPos(self:GetPos() + Vector(0,0,10))

	self.WaitTime = 0
	self:SetNWBool("Wait", false)
	self.WaterWait = true

end

function ENT:Use(eOtherEnt)

	if self:GetNWBool("Wait") then return end
	self.WaitTime = CurTime() + 5
	self:SetNWBool("Wait", true)
	self:Squish()

end

function ENT:Think()

	if self.WaitTime < CurTime() && self:GetNWBool("Wait") then
		self:SetNWBool("Wait", false)
	end

end
