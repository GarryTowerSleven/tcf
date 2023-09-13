ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.RenderGroup 	= RENDERGROUP_OPAQUE
ENT.PrintName 		= "Beach Ball"
ENT.Spawnable 		= true
ENT.AdminSpawnable 	= true
ENT.SleepPhysics 	= 20
ENT.NextCheck = 0
ENT.ResetOnSleep = false

AddCSLuaFile()

function ENT:Initialize()

	if SERVER then
	    self:SetModel( "models/gmod_tower/beachball.mdl" )
	    self:PhysicsInit( SOLID_VPHYSICS )
	    self:SetMoveType( MOVETYPE_VPHYSICS )
	    self:SetSolid( SOLID_VPHYSICS )

	    local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:AddGameFlag( FVPHYSICS_NO_IMPACT_DMG )
			phys:AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG )
			phys:SetMass( 5 )
			phys:Wake()
		end

		//self.LastKicker = nil
		self:SetTrigger( true )

		timer.Simple( 1, function()
			if IsValid( self ) then
				self.OriginalPos = self:GetPos()
				self.OriginalLocation = self:Location()

				self.ResetOnSleep = Location.IsGroup( self.OriginalLocation, "pool" )
			end
		end )
	end

	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )

	self.NextImpact = CurTime()
	self.NextKickSound = CurTime()
	self.PhysDelay = CurTime() + self.SleepPhysics

end

function ENT:OnTakeDamage( dmginfo )

	if dmginfo:GetDamage() < 2 then return end

	local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
	util.Effect( "confetti", effectdata )
	
	self:Remove()
	
end

function ENT:PhysicsCollide( data, physobj )
	
	local ent = data.HitEntity

	self:PhysicsWake()

	if self.NextImpact < CurTime() && data.DeltaTime > 0.2 && data.OurOldVelocity:Length() > 100 && !self:IsPlayerHolding() then 
		self:EmitSound("Rubber.ImpactHard")
		self.NextImpact = CurTime() + 0.1
	end

end

function ENT:StartTouch( ent )

	if !IsValid( ent ) || !ent:IsPlayer() && !self:IsPlayerHolding() then return end

	self:PhysicsWake()
	//self.LastKicker = ent

	/*if ent:GetVelocity():Length() < 5 then
		return
	end*/

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then

		local mult = .65
		local velocity = ent:GetVelocity() * mult

		phys:AddVelocity( velocity + Vector( 0, 0, 300 ) )
		
		if self.NextKickSound < CurTime() then 
			self:EmitSound( "Rubber.BulletImpact" )
			self.NextKickSound = CurTime() + 0.1
		end

	end

end

function ENT:Think()

	if SERVER then
		self:HandlePhysicsSleep()
		self:CheckLocation()
	end

end

function ENT:HandlePhysicsSleep()

	if not self.ResetOnSleep then return end

	if not self._Sleep && self.PhysDelay && self.PhysDelay < CurTime() then

		self:ResetPos()

		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
			self._Sleep = true
		end

	end

end

function ENT:PhysicsWake()

	local phys = self:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( true )
		phys:Wake()
		self._Sleep = false
	end

	self.PhysDelay = CurTime() + self.SleepPhysics

end

function ENT:ResetPos()
	if self.NoReset then return end
	if self.OriginalPos then
		self:SetPos( self.OriginalPos )
	end
end

function ENT:CheckLocation()

	if not self.OriginalLocation then return end
	if (self.NextCheck or 0) > CurTime() then return end

	if self:Location() != self.OriginalLocation then
		self:ResetPos()
	end

	self.NextCheck = CurTime() + 5

end