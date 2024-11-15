---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.BlastRange	= 300
ENT.BlastDmg	= 256
ENT.Bounce = 2.25

function ENT:PhysicsCollide( data, phys )
	local ent = data.HitEntity
	self.Bounce = self.Bounce * .75
	
	if data.Speed > 80 && data.DeltaTime > 0.2 then
		self:EmitSound(self.BlastSound, 80)
	end
	
	local LastSpeed = data.OurOldVelocity:Length()
	local NewVelocity = phys:GetVelocity():GetNormalized()
	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	phys:SetVelocity( NewVelocity * LastSpeed * self.Bounce )
end
