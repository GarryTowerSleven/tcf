
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:KeyValue(key,val)
    if key == "model" then
      self.Model = val
    elseif key == "modelscale" then
      self:SetModelScale( tonumber(val) )
    elseif key == "skin" then
      self:SetSkin( tonumber(val) )
    end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
end