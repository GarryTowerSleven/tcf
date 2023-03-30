AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetNoDraw(true)
end

function ENT:Think()
    for k,v in pairs( ents.FindInSphere(self:GetPos(),64) ) do
      if v:IsPlayer() && CurTime() > (v.DiveDelay or 0) then
        v.DiveDelay = CurTime() + 2
          v:SetVelocity( v:GetForward() * 200 + Vector(0, 0, 250) )
        self:EmitSound( self.Sound, 80, 150 )
      end
    end
end