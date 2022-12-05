
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

ENT.SpinSpeed = 20

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)
end

function ENT:Think()

	self:SetAngles(Angle(0,CurTime() * self.SpinSpeed,0))

end
