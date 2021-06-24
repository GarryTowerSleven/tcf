
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
end

function ENT:KeyValue(key,val)
    if key == "up" then
      self:SetNWBool( "Up", (val == "1") )
    end
end
