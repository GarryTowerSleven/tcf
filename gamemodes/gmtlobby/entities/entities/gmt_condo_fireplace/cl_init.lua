
-----------------------------------------------------
include("shared.lua")

function ENT:Think()

  if self:PlayerCanSeeFlame(LocalPlayer(), 900) then
	  if CurTime() < (self.Delay or 0) then return end

	  self.Delay = CurTime() + 0.1

	  local vPoint = self:GetPos() + Vector(0,0,-5)
	  local effectdata = EffectData()
	  effectdata:SetOrigin( vPoint )
	  util.Effect( "fireplace", effectdata )
  end
  
end

function ENT:PlayerCanSeeFlame(ply, dist)

  return self:GetPos():DistToSqr( ply:GetPos() ) < ( dist*dist )
	
end

