
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.PrintName = "Balloon"

ENT.Model = Model( "models/maxofs2d/balloon_classic.mdl" )

function ENT:SetupDataTables()

	self:NetworkVar( "Float", 0, "Force" )

	if SERVER then
		self:SetForce( 45 )
	end

end

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel( self.Model )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )

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

	local c = self:GetColor()

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetStart( Vector( c.r, c.g, c.b ) )
	util.Effect( "balloon_pop", effectdata )

	local attacker = dmginfo:GetAttacker()
	if ( IsValid( attacker ) && attacker:IsPlayer() ) then
		attacker:SendLua( "achievements.BalloonPopped()" )

		hook.Run( "BalloonPopped", attacker, self )
	end

	self:Remove()

end

function ENT:PhysicsSimulate( phys, deltatime )

	local vLinear = Vector( 0, 0, self:GetForce() * 5000 ) * deltatime
	local vAngular = vector_origin

	return vAngular, vLinear, SIM_GLOBAL_FORCE

end