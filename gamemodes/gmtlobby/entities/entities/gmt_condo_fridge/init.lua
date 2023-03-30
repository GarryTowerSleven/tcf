
-----------------------------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:SetModel(self.Model)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetUseType(SIMPLE_USE)
end

function ENT:Use()

  local isOpen = !self:GetOpen()
  self:EmitSound("gmodtower/lobby/misc/fridge_" .. ( isOpen && "open" or "close" ) .. ".wav", 80)
  self:SetOpen( isOpen )
end
