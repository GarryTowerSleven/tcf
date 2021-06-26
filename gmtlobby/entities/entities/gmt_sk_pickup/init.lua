
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.CoolDown = 0
ENT.CoolDownTime = 3

function ENT:Initialize()
    self:SetModel(self.Model)
    self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
end
