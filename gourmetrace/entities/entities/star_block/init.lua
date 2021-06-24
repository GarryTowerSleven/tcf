
----------------------------------------------------------

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
end

function ENT:Break()

	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "stars", effectdata )

	self:SetSolid(SOLID_NONE)

	self:SetModelScale(0,0.25)
	timer.Simple(0.25,function() if IsValid(self) then self:Remove() end end)
end
