AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/uch/saturn.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:PhysWake()

	construct.SetPhysProp( nil, self, 0, nil, { Material = "ice" })
	self:StartMotionController()

	self.LastThink = 0
	self.LastJump = 0
	self.LastRandom = 0
	self.TargetPos = self:GetPos()
	self.Balloons = {}

	self.Nav = ents.Create( "mr_saturn_navigator" )
	self.Nav:SetPos( self:GetPos() )
	self.Nav:Spawn()
end

function ENT:Think()

	local phys = self:GetPhysicsObject()

	if self.LastThink < CurTime() then

		local pos, ang = self:GetPos(), self:GetAngles()
		local onground = util.QuickTrace( self:GetPos(), Vector(0, 0, -24), self ).Hit

		// AI
		if !IsValid( self.Pig ) || self.Pig:Team() != TEAM_PIGS then
			self.Pig = team.GetPlayers( TEAM_PIGS )
			self.Pig = self.Pig[math.random( 1, #self.Pig )]
		end

		if IsValid(self.Pig) && self:GetPos():DistToSqr( self.Pig:GetPos() ) > (512 * 512) && !self.Reached then
			self.TargetPos = self.Pig:GetPos()
		else
			self.Reached = true

			if self.LastRandom < CurTime() || pos:DistToSqr( self.TargetPos ) < (64 * 64) then
				self.TargetPos = table.Random( navmesh.GetAllNavAreas() ):GetRandomPoint() // self:GetPos() + Vector(math.random(-200, 200), math.random(-200, 200), 0)
				self.LastRandom = CurTime() + 8
			end
		end

		// Stuck
		local down = math.abs( ang.p ) > 24 && 1 || math.abs( ang.r ) > 24 && 2 || 0

		if ( down == 1 || down == 2 ) && onground then
			self.LastJump = self.LastJump or CurTime() + 1

		elseif !onground && self.LastJump && self.LastJump > CurTime() then
			self.LastJump = CurTime() + 0.2
		else
			self.LastJump = nil
		end

		// Nav
		self.Nav:SetPos( self:GetPos() )

		if self.PosCache != self.TargetPos then

			self.Nav.Path:Compute( self.Nav, self.TargetPos )
			self.Segments = self.Nav.Path:GetAllSegments()
			self.PosCache = self.TargetPos

		end

		local flying = #self.Balloons > 0

		phys:EnableGravity( !flying )

		if flying then
			
			phys:ApplyForceCenter( Vector( 0, 0, 256 ) )

		elseif self.Segments then

			if self.Segments[1] && self:GetPos():Distance( self.Segments[1].pos ) < 64 then
				table.remove(self.Segments, 1)
			end

			self.MoveTo = #self.Segments > 2 && self.Segments[1] && self.Segments[1].pos || self.TargetPos

			phys:ApplyForceCenter( tang:Forward() * 184 * ( 1 - math.Clamp( phys:GetVelocity():Length2D() / 184, 0, 1 ) ) )

		end

		self.LastThink = CurTime() + 0.1
	end

	// Animation
	self:ResetSequence( self:LookupSequence( "walk" ) )
	self:SetPlaybackRate( math.Clamp( phys:GetVelocity():Length2D() / 256, 0, 1 ) * 4 )

	self:NextThink( CurTime() )
	return true
end

function ENT:PhysicsSimulate( phys, ft )

	// Due to a bug within Garry's Mod, Mr. Saturn will become a landmine if he is left sleeping.
	phys:Wake()

	if self.LastJump && self.LastJump < CurTime() then

		local shadow = {}
		shadow.secondstoarrive = 0.1
		shadow.pos = self:GetPos()
		shadow.angle = self:GetAngles()
		shadow.angle.p = 0
		shadow.angle.r = 0
		shadow.maxangular = 256
		shadow.maxangulardamp = 1000
		shadow.maxspeed = 0
		shadow.maxspeeddamp = 10000
		shadow.dampfactor = 0
		shadow.teleportdistance = 200
		shadow.deltatime = ft
	
		phys:ComputeShadowControl( shadow )

	end

	if !self.MoveTo then return end

	local tang = ( self.MoveTo - phys:GetPos() ):Angle()

	local shadow = {}
	shadow.secondstoarrive = 0.1
	shadow.pos = vector_origin
	shadow.angle = tang
	shadow.angle.p = 0
	shadow.angle.r = 0
	shadow.maxangular = 2048
	shadow.maxangulardamp = 10000
	shadow.maxspeed = 0
	shadow.maxspeeddamp = 0
	shadow.dampfactor = 1
	shadow.teleportdistance = 0
	shadow.deltatime = ft

	phys:ComputeShadowControl( shadow )

end

function ENT:OnRemove()

	if IsValid( self.Nav ) then

		self.Nav:Remove()

	end

	self:PopBalloons()

end

function ENT:CreateBalloons()

	for i = 1, math.random( 4, 8 ) do
		
		timer.Simple( i * 0.4, function()
		
			if IsValid( self ) then

				local ent = ents.Create( "saturn_balloon" )
				ent:SetPos( self:GetPos() + Vector( 0, 0, 8 ) )
				ent:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
				ent:SetColor( Color( 255, 0, 100 ) )
				ent:SetForce( 1024 )
				ent:Spawn()

				ent.Sound = i <= 2

				constraint.NoCollide( ent, self, 0, 0 )
				constraint.Rope( ent, self, 0, 0, vector_origin, vector_origin, 32, 32, 0, 0.2, "cable/cable2", false, color_white )

				table.insert( self.Balloons, ent )

			end
		
		end )

	end

end

function ENT:PopBalloons()

	for _, ent in ipairs( self.Balloons ) do

		ent:OnTakeDamage( )

	end

	table.Empty( self.Balloons )

end

function ENT:Scare()

	if #self.Balloons == 0 then
		
		self:CreateBalloons()
		self:EmitSound( "uch/saturn/saturn_hit.wav", 80, 130 )
		self:GetPhysicsObject():AddVelocity( Vector( 0, 0, 256 ) )

		timer.Simple( math.random( 8, 12 ), function()
		
			if IsValid( self ) then

				self:PopBalloons()

			end

		end )

	end

end

function ENT:PhysicsCollide( data, phys )

	if data.Speed >= 75 && data.DeltaTime > 0.2 then

		self:EmitSound( "uch/saturn/saturn_collide.wav" )

	end

	if data.Speed >= 400 then

		if data.DeltaTime > 0.2 then
		
			self:EmitSound( "uch/saturn/saturn_hit.wav", 80, math.random( 80, 120 ) )
		
		end

		self:StopMotionController()

		local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
		local NewVelocity = phys:GetVelocity()
		NewVelocity:Normalize()
	
		LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	
		local TargetVelocity = NewVelocity * LastSpeed * 0.75
	
		phys:SetVelocity( TargetVelocity )

		local effect = EffectData()
		effect:SetOrigin( data.HitPos )
		effect:SetNormal( data.HitNormal )
		effect:SetFlags( 0 )
		util.Effect( "saturn_stars", effect )

	else

		self:StartMotionController()

	end

end

function ENT:Explode()

	self:EmitSound( "uch/saturn/saturn_hit.wav", 80, 80 )

	local effect = EffectData()
	effect:SetOrigin( self:GetPos() )
	effect:SetStart( Vector( 255, 200, 175 ) )

	for i = 1, 6 do

		if i == 6 then
			
			effect:SetStart( Vector( 255, 0, 0 ) )

		end

		util.Effect( "piggy_pop", effect )
	end

end

local ENT2 = {}

ENT2.Type = "nextbot"
ENT2.Base = "base_nextbot"

function ENT2:Initialize()
	self:SetNoDraw(true)
	self:SetSolid(SOLID_NONE)

	self.Path = Path( "Follow" )
end

function ENT2:Think()
	if self.TPos then
		self.Path:Compute( self, self.TPos )
	end
end

scripted_ents.Register(ENT2, "mr_saturn_navigator")