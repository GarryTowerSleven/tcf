
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_NONE)
    self:DrawShadow(false)
    self:SetAngles(Angle(0,90,0))
end
