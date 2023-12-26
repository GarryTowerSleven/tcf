
AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );

include('shared.lua');

ENT.Occupant = nil
ENT.OccupantWeaps = {}
ENT.LastUseTime = 0

ENT.OutOfBounds = false
ENT.KickoutDelay = 8
ENT.TimeOOB = 0

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 32

	local ent = ents.Create( "gmt_pooltube" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent
end

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetSkin( math.random( 1, 4 ) )

	self:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	if( phys:IsValid() )then
		phys:Wake()
	end
end

function ENT:Pop()
	if self.Occupant && IsValid(self.Occupant) then
		self:Exit( self.Occupant )
	end

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	util.Effect( "confetti", effectdata )

	self:EmitSound( "weapons/ar2/npc_ar2_altfire.wav" )
	self:Remove()
end

function ENT:Think()

	// check if tubes in the boardwalk
	if self:Location() != 56 && !self.OutOfBounds then
		self.OutOfBounds = true
		self.OldColor = self:GetColor()
		self.TimeOOB = CurTime() + self.KickoutDelay
	elseif self:Location() == 56 && self.OutOfBounds then
		self.OutOfBounds = false
		self:SetColor(self.OldColor)
		self.OldColor = nil
		self.TimeOOB = 0
	end

	// make em a little red
	if self.OutOfBounds && self.TimeOOB && self.TimeOOB > CurTime() then
		local diff = (self.KickoutDelay - math.Clamp( self.TimeOOB - CurTime(), 0, 10 )) / self.KickoutDelay

		local color = colorutil.TweenColor( self.OldColor, Color( 255, 80, 80 ), diff )
		self:SetColor(color)
	end

	// if not, pop em after X seconds
	if self.OutOfBounds && self.TimeOOB && self.TimeOOB < CurTime() then
		self:Pop()
		self.OutOfBounds = false
		self.TimeOOB = 0
	end

	if self.Ready then

		local pos, ang, num = self:GetPosAngle()

		self:SetPos(pos)
		self:SetAngles(ang)

		self.Velocity = 250 + self:GetDistance()/35
		self:SetMoveType(MOVETYPE_NONE)
		if self:GetDistance() > 9200 then
			self.OldPos = self:GetPos()
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self.Ready = false
			self:SetNWBool("Ready",false)
			self.CurrentCurve = nil
			self:SetPos( self.OldPos )
			local phys = self:GetPhysicsObject()

			phys:ApplyForceCenter( Vector( 0, 25000, 5000 ) )

		end

	end

	local ply = self.Occupant

	if IsValid(ply) then
		local ang = ply:GetAngles()
		ply:SetAngles( Angle( 0, ang.yaw, 0 ) )
		ply:SetPos( self:GetPos() + Vector( 0, 0, -32 ) )

		if !ply:Alive() then
			self:Exit( ply )
		end

		if ply:KeyDown( IN_USE ) && self.LastUseTime < RealTime() && !self.Ready then
			self:Exit( ply )
		end

      if ply:KeyDown(IN_FORWARD) then
        self:GetPhysicsObject():AddVelocity(ply:GetForward() * FrameTime() * 250)
      end

	  if ply:KeyDown(IN_BACK) then
        self:GetPhysicsObject():AddVelocity(ply:GetForward() * FrameTime() * -250)
      end


      if ply:KeyDown(IN_MOVELEFT) then
        self:GetPhysicsObject():AddVelocity(ply:GetRight() * FrameTime() * -250)
      end

	   if ply:KeyDown(IN_MOVERIGHT) then
        self:GetPhysicsObject():AddVelocity(ply:GetRight() * FrameTime() * 250)
      end


	end

	self:NextThink( CurTime() )
	return true
end

function ENT:Use( ply )
	if self.Occupant then return end

	if ply.PoolTube != nil then return end

	self:Enter( ply )

	self.LastUseTime = RealTime() + 2.5
end

function ENT:Enter( ply )
	ply.PoolTube = self
	self.Occupant = ply
	self:SetOwner( ply )

	self:SetAngles( Angle( 0, 0, 0 ) )
	--ply:SetPos( self:GetPos() + Vector( 0, 0, -32 ) )
	--ply:SetParent( self )
	ply:SetMoveType( MOVETYPE_NONE )
	ply:SetNoDraw( false )
	if ply.CosmeticEquipment then
		for k,v in pairs(ply.CosmeticEquipment) do
			// What the fuck 
			if IsValid( v ) then
				v:SetNoDraw( false )
			end
		end
	end
	constraint.Keepupright( self, Angle( 0, 0, 0 ), self.PhysicsBone, 0 )

	local rp = RecipientFilter()
	rp:AddAllPlayers()

	umsg.Start( "PoolTube", rp )
		umsg.Entity( self )
		umsg.Entity( ply )
		umsg.Bool( true )
	umsg.End()

	self:StartMotionController()

	/*for k, v in pairs( ply:GetWeapons() ) do
		self.OccupantWeaps[k] = v:GetClass()
	end*/
	ply:StripWeapons()
end

function ENT:Exit( ply )
	ply.PoolTube = nil
	self.Occupant = nil
	self:SetOwner( NULL )

	ply:SetPos( self:GetPos() + Vector( 0, 0, 64 ) )
	ply:SetParent( nil )
	ply:SetMoveType( MOVETYPE_WALK )
	ply:SetNoDraw( false )
	if ply.CosmeticEquipment then
		for k,v in pairs(ply.CosmeticEquipment) do
			// What the fuck 
			if IsValid( v ) then
				v:SetNoDraw( false )
			end
		end
	end
	constraint.RemoveConstraints( self, "Keepupright" )

	local rp = RecipientFilter()
	rp:AddAllPlayers()

	umsg.Start( "PoolTube", rp )
		umsg.Entity( self )
		umsg.Entity( ply )
		umsg.Bool( false )
	umsg.End()

	/*for k, v in pairs( self.OccupantWeaps ) do
		ply:Give( v )
	end*/
end

function ENT:PhysicsCollide( data, physobj )
	if data.Speed > 100 && data.DeltaTime >= 1 then
		local edata = EffectData()
		edata:SetOrigin(data.HitPos)
		edata:SetNormal(data.HitNormal * -1)
		util.Effect("ball_hit", edata)
	end

	if data.HitEntity then
		if !IsValid(self:GetOwner()) then return end
		local phys = data.HitEntity:GetPhysicsObject()
		local ply = self:GetOwner()
		if IsValid(phys) then
			phys:AddVelocity(ply:GetForward() * FrameTime() * 12500)
		end
	end

end

--[[function ENT:PhysicsSimulate( phys, deltatime )
	local ply = self:GetOwner()

	if !IsValid(ply) then return SIM_NOTHING end

	local vMove = Vector(0,0,0)
	local vAngle = Vector(0,0,0)
	local aEyes = ply:EyeAngles()

	local mass = phys:GetMass()
	local velocity = phys:GetVelocity()
	local anglevel = phys:GetAngleVelocity()

	if ( ply:KeyDown( IN_FORWARD ) ) then vMove = vMove + aEyes:Forward() end
	if ( ply:KeyDown( IN_BACK) ) then vMove = vMove - aEyes:Forward() end
	if ( ply:KeyDown( IN_MOVELEFT ) ) then vMove = vMove - aEyes:Right() end
	if ( ply:KeyDown( IN_MOVERIGHT ) ) then vMove = vMove + aEyes:Right() end

	vMove.z = 0;

	if vMove:Length() > 0 then
		local dir = vMove:GetNormal()

		local dot = 1 - dir:Dot(velocity:GetNormal())

		vMove = dir * mass * 20000 * deltatime

		vMove = vMove + (vMove * dot)

	elseif math.abs(velocity.z) <= 10 then

		velocity.z = 0

		local length = velocity:Length()
		velocity:Normalize()

		vMove = phys:GetVelocity() + velocity * -length * 200 * (1 - deltatime)

	end

	return vAngle, vMove, SIM_GLOBAL_FORCE

end]]
