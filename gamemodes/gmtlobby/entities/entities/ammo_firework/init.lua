---------------------------------
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/gmod_tower/firework_rocket.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
      phys:EnableGravity(false)
      phys:SetVelocity(Vector(0,0,0))
      local direction = self:GetOwner():EyePos() - self:GetPos()
      direction:Normalize()
      phys:ApplyForceCenter( direction *-1 * 200000 )
    end
end

function ENT:Think()
  local CurVel = self:GetVelocity():Length()

  if CurVel <= 1200 then
    self:Remove()
  end

end

function ENT:OnRemove()
  self:EmitSound(self.SoundExplosion)
end
