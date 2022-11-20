
include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetCollisionGroup(COLLISION_GROUP_WEAPON)

    timer.Simple(6,function()
      if IsValid(self) then self:Remove() end
    end)
    self:DrawShadow(false)
end

local BounceMats = {
  MAT_CONCRETE, MAT_GRATE, MAT_METAL, MAT_COMPUTER, MAT_TILE, MAT_VENT, MAT_GLASS
}

function ENT:PhysicsCollide( data, phys )
  local trace = { start = self:GetPos(), endpos = data.HitPos + (data.HitNormal * 10), filter = self }

  local tr = util.TraceLine(trace)

  if tr.Hit && table.HasValue( BounceMats, tr.MatType ) then

    if !self.BounceCount then self.BounceCount = 0 end

    self.BounceCount = self.BounceCount + 1

    local phys = self:GetPhysicsObject()
    local BounceMultiplier = math.Clamp(-(50 - (self.BounceCount * 2)), 0, 25)

    if IsValid(phys) then
      // Back to physics angles.
      self:SetNWBool( "Bouncing", true )
      phys:ApplyForceCenter( data.HitNormal * BounceMultiplier )
      self:EmitSound( self.ImpactSound, 60, math.random( 125, 150 ) )
    end
    return
  end

	local phys = self:GetPhysicsObject()

  if IsValid(phys) then
    self:SetNWBool( "Bouncing", false )
    phys:EnableMotion(false)

    self:EmitSound( self.ImpactDirtSound, 60, math.random( 80, 100 ) )

    if IsValid(data.HitEntity) then
      self:SetPos(data.HitPos)
      self:SetParent(data.HitEntity)

      // Sets it back to it's natural position, instead of forcing it to go straight.
      self:SetNWBool( "Bouncing", true )
    end

  end
end
