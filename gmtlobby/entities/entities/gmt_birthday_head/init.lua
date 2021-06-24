AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:DrawShadow(false)
    self:SetSolid(SOLID_NONE)
end
