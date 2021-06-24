
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:DrawShadow(false)
end

function ENT:Think()

  if !self.TargetEnt then
    local ent = ents.FindByClass("gmt_duelrot")[1]

    if IsValid(ent) then
      self.TargetEnt = true
      self:SetTargetEntity(ent)
    end
  end

    for k,v in pairs( ents.FindInSphere( self:GetPos(), 128 ) ) do
      if v:IsPlayer() then
        self:OnPlayerTouch(v, CurTime())
      end
    end
end
