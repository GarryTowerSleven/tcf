
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
  self:SetModel(self.Model)
  self:DrawShadow(false)
  self:SetMaterial("models/wireframe")
  self:SetColor(Color(200,200,255,255))
  self:GetOwner():GetKart():SetIsInvincible(true)
  self.ShieldSound = CreateSound( self, self.Sound )
  self.ShieldSound:Play()

end

function ENT:OnRemove()
    self:GetOwner():GetKart():SetIsInvincible(false)
    self.ShieldSound:Stop()
end
