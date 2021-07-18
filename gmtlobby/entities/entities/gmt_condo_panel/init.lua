
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
end

function ENT:Think()
    if self:GetNWInt("condoID") == 0 then
      local loc = Location.Find( self:GetPos() )
      self:SetNWInt( "condoID", loc-1 )
    end

    for k,v in pairs(ents.FindByClass("gmt_condoplayer")) do
      if v:GetNWInt("condoID") == 0 then
        local loc = Location.Find( v:GetPos() )
        v:SetNWInt( "condoID", loc-1 )
      end
    end
end
