AddCSLuaFile()

game.AddParticles( "particles/scary_ghost.pcf" )

ENT.Type 			= "anim"
ENT.Base 			= "gmt_minigame_balloon"

ENT.PrintName			= "Minigame Ghost"
ENT.Author				= "kity"
ENT.Spawnable			= true

ENT.Model = Model( "models/props_halloween/smlprop_ghost.mdl" )

ENT.DieSounds = {
	Sound( "misc/halloween/hwn_plumes_short.wav" ),
}

function ENT:Initialize()

	PrecacheParticleSystem( "ghost_appearation" )
	PrecacheParticleSystem( "ghost_glow" )

	if ( CLIENT ) then
		self:CreateParticleEffect( "ghost_glow", 0, { attachtype = PATTACH_ABSORIGIN_FOLLOW	 } )

		return
	end

	self:SetModel( self.Model )

	local min, max = self:GetModelRenderBounds()

	self:PhysicsInitBox( min * 2, max * 2 )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )

	self:SetModelScale( 1.5 )

	-- Set up our physics object here
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then

		phys:SetMass( 100 )
		phys:Wake()
		phys:EnableGravity( false )

	end

	self:StartMotionController()

end

function ENT:OnTakeDamage( dmginfo )

	local attacker = dmginfo:GetAttacker()
	if ( IsValid( attacker ) && attacker:IsPlayer() ) then
		hook.Run( "BalloonPopped", attacker, self )
	end

	ParticleEffect( "ghost_appearation", self:GetPos(), angle_zero )

	self:EmitSound( table.Random( self.DieSounds ), 95, math.random( 90, 120 ), .3, CHAN_AUTO )

	self:Remove()

end