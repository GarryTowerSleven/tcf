AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "SCHED.lua" )
include( "shared.lua" )
include( "schedules.lua" )

function ENT:Initialize()

	self:SetModel( self.Model )

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetCustomCollisionCheck(true)

	self:SetColor( Color(255, 255, 255, 255) )
	construct.SetPhysProp( nil, self, 0, nil, { GravityToggle = true, Material = "ice" } )
	self.ShootNoise = 0
	self.Walking = false
	self.WalkAngle = Angle( 0, 0, 0 )
	self.LastStep = 0
	self.CanGrav = true
	self.CurrentEndFunc = nil
	self.WallCheck = 0
	self.ShouldWalk = true //We just spawned, we should start out walking
	self.WalkTimeMin = .5
	self.WalkTimeMax = .9
	self:SetupSchedules()

	self:SetUseType(SIMPLE_USE)

	if !self.SpawnWithHat then

		local rnd = math.random( 1, 12 ) //Mr. Saturn gets a hat almost as often as TF2 players do ( hurf durf never )
		if rnd == 1 then

			local rndhat = math.random( 1, #MrSaturnHatTable ) //So many choices!
			self:SetHat( rndhat )

		end

	end

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	local eff = EffectData()
		eff:SetOrigin( self:GetPos() )
	util.Effect( "saturn_spawn", eff )

	self:StartMotionController()

	if IsValid(self:GetOwner()) then
		self.PlayerSaturn = self:GetOwner()
	end

	self:CheckOwnerFix()

end

function ENT:CheckOwnerFix()
	timer.Simple(2,function()
		if self:GetOwner() == null then return end
		if IsValid( self:GetOwner() ) then
			self:CheckOwnerFix()
		else
			self:Remove()
		end
	end)
end

function ENT:UpdatePetName()
	local ply = self:GetOwner()
	if IsValid( ply ) then
		self:SetPetName( string.sub(ply:GetInfo("gmt_petname_saturn"),1,15) )
	end
end

function ENT:PhysicsUpdate( phys )

	local velocity = phys:GetVelocity()

	local ply = self:GetOwner()

	if !IsValid(ply) then return end

	self.PlayerDistance = self:GetPos():Distance( ply:GetPos() )

	if ( self.PlayerDistance > 1000 ) then self:SetPos( ply:GetPos() ) end

	local angle = self:GetOwner():GetPos() - self:GetPos()

	local vect = angle:GetNormalized() * ( self.PlayerDistance / 4 )
	vect.z = math.Clamp( vect.z, 0, 100 ) // don't move too far up

	phys:ApplyForceCenter( vect )

end

function ENT:SetHat( num, skin )

	if num < 0 || num > #MrSaturnHatTable then
		print( "INVALID SATURN HAT! : " .. tostring( num ) )
		return
	end

	skin = skin or 1

	if MrSaturnHatTable[num].body then
		self:SetBodygroup( 1, 1 )
	end

	timer.Simple( .1, function()
		umsg.Start( "SaturnHat" )
			umsg.Entity( self )
			umsg.Long( num )
			umsg.Long( skin )
		umsg.End()
	end )

end

function ENT:FeetPlanted()

	local trace = util.TraceLine( {
		start = self:GetPos(),
		endpos = self:GetPos() + ( ( self:GetUp() * -1 ) * 16 ),
		filter = self
	} )

	if trace.Hit && trace.Entity && !trace.Entity:IsPlayer() && !trace.Entity:IsNPC() then
		return true
	else
		return false
	end

end

function ENT:TouchingGround()

	if self:FeetPlanted() then return false end

	local trace = util.TraceLine( {
		start = self:GetPos(),
		endpos = ( self:GetPos() + Vector( 0, 0, -16 ) ),
		filter = self
	} )

	if trace.Hit && trace.Entity && !trace.Entity:IsPlayer() && !trace.Entity:IsNPC() then
		return true
	else
		return false
	end

end

function ENT:PhysicsCollide( data, phys )

	if data.Speed >= 65 then

		if data.Speed <= 400 && data.DeltaTime > 0.2 then
			self:EmitSound( "UCH/saturn/saturn_collide.wav", 60 )
		end

		if data.Speed > 400 then

			if data.DeltaTime > 0.2 then
				self:EmitSound( "UCH/saturn/saturn_hit.wav", 60, math.random( 80, 120 ) )
			end

		end

		local eff = EffectData()
			eff:SetOrigin( data.HitPos )
			eff:SetNormal( data.HitNormal )
		util.Effect( "saturn_stars", eff, true, true )

	end

	if self.Descending then
		self.SCHEDTime = 0
	end

end

function ENT:OnTakeDamage( dmg )

	self.Walking = false
	self.SCHEDTime = 0
	self.ShouldWalk = true

	if !dmg:IsBulletDamage() then

		self:EmitSound( "UCH/saturn/saturn_hit.wav", 60, math.random( 80, 120 ) )

	else

		if CurTime() >= self.ShootNoise then
			self.ShootNoise = CurTime() + .4
			self:EmitSound( "UCH/saturn/saturn_hit.wav", 60, math.random( 80, 120 ) )
		end

	end

end

function ENT:MakeBalloon( force, length, offset )

	for i=1,20 do
		local balloon = ents.Create( "saturn_balloon" )
		/*if !balloon:IsValid() then
			return
		end*/

		balloon:SetPos( self:GetPos() + Vector( 0, 0, length ) )

		balloon:Spawn()

		balloon:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
		balloon:SetRenderMode( RENDERMODE_TRANSALPHA )
		balloon:SetColor( Color(250, 0, 100, 255) )
		balloon:SetForce( force )

		local ent1, ent2 = self, balloon

		local bone = self:LookupBone( "nose1" )
		local bpos, bang = self:GetBonePosition( bone )
		local bone1, bone2 = 0, 0

		bpos = bpos + offset

		local pos1, pos2 = bpos, balloon:GetPos()
		pos1 = self:WorldToLocal( pos1 )
		pos2 = balloon:WorldToLocal( ( pos2 + Vector( 0, 0, -10 ) ) )

		local length = length

		local forcelimit, width, material, rigid = 0, .1, "cable/cable2", false

		constraint.Rope( ent1, ent2, bone1, bone2, pos1, pos2, length, 0, forcelimit, width, material, rigid )

		//self.Balloon = balloon
	end

end

function ENT:RemoveBalloon()
	for _, v in ipairs( ents.FindByClass( "saturn_balloon" ) ) do
		v:TakeDamage( 1 )
	end
	/*if IsValid( self.Balloon ) then
		self.Balloon:TakeDamage( 1 ) // *pop*
		self.Balloon = nil
	end*/

end

function ENT:GetUpSC()

	local shadow = {}
	shadow.secondstoarrive = math.Rand( .2, .4 )
	shadow.pos = self:GetPos()
	shadow.angle = self:GetAngles()
	shadow.angle.p = 0
	shadow.angle.r = 0
	shadow.maxangular = 5000
	shadow.maxangulardamp = 10000
	shadow.maxspeed = 0
	shadow.maxspeeddamp = 0
	shadow.dampfactor = 1
	shadow.teleportdistance = 0
	shadow.deltatime = delta
	return shadow

end

function ENT:DoAnimations()

	local anim = "idle"

	if self.Idling || ( IsValid( self.PlayerSaturn ) && self.Walking ) then
		anim = "idle2"
	end

	if self.Turning then
		anim = "walk"
		self:SetPlaybackRate( .8 )
	end

	if self.ShouldSpaz then //We're being held...
		anim = "walk" //walking takes priority
		self:SetPlaybackRate( 5 )
	end

	local vel = self:GetVelocity():Length()
	if self:FeetPlanted() && vel >= 15 then
		local chk = ( vel * .02 )
		chk = math.Clamp( chk, .025, 4 )
		anim = "walk"
		self:SetPlaybackRate( chk )
	end

	anim = self:LookupSequence( anim )
	self:ResetSequence( anim )

end

function ENT:ResetGetUp()

	self.ShouldGetUp = false
	self.CanGetUp = false
	timer.Destroy( tostring( self ) .. "GetUpTimer" )

end

function ENT:Scare()

	self.IsScared = true
	self:StartFly() // force him to fly

	local endfly = math.random( 6, 8 )
	self.SCHEDTime = CurTime() + endfly

	timer.Simple( endfly, function() if IsValid(self) then self:EndFly() end end )

end

function ENT:Think()

	if IsValid(self:GetOwner()) then self:UpdatePetName() end

	if self:WaterLevel() >= 1 then //We are in water

		construct.SetPhysProp( nil, self, 0, nil, {GravityToggle = true, Material = "rubber"} )
		local anim = self:LookupSequence( "walk" )
		self:SetPlaybackRate( 5 )
		self:ResetSequence( anim )
		self:GetPhysicsObject():ApplyForceCenter( Vector( 0, 0, 100 ) )
		self:NextThink( CurTime() )
		return true

	end

	if ( self.Fishing || self.Flying ) && !IsValid( self.Balloon ) then

		self.Balloon = nil
		self.ShouldWalk = true
		self.SCHEDTime = 0

	end

	self:DoAnimations()

	local phys = self:GetPhysicsObject()
	if !phys:IsValid() then
		return
	end

	//schedule stuff
	local vel = self:GetVelocity():Length()
	local angvel = phys:GetAngleVelocity():Length()
	local pos, fwd = self:GetPos(), self:GetForward()

	local timeleft = ( self.SCHEDTime - CurTime() )

	if self.Flying && IsValid( self.Balloon ) then

		if timeleft <= 6 then
			self.Descending = true //going down!
		end

		if self.FlyCheck && self:TouchingGround() then
			self.SCHEDTime = 0
			self.CanGetUp = true
		end

		local num = 30
		local vel = Vector( 0, 0, 0 )
		local fwd = self:GetUp()
		local right = self:GetRight()
		local back, left = ( fwd * -1 ), ( right * -1 )

		vel = fwd
		num = 2

		local phys = self.Balloon:GetPhysicsObject()
		if phys:IsValid() then
			vel.z = 0
			phys:ApplyForceCenter( ( vel * num ) )
		end

	end

	if self.Descending && IsValid( self.Balloon ) then
		self.Balloon:SetForce( 122 )
	end

	local u = phys:GetAngles():Up()
	if u.z > .9 then

		if self.Walking then
			local num = 100

			local vel = ( fwd * num )
			if self:IsOnFire() then
				vel = ( vel * 2.5 ) //GO NUTS!!!!1
			end
			phys:ApplyForceCenter( vel )
		end

		self:ResetGetUp()

		local pos, fwd = self:GetPos(), self:GetForward()

		//Hop check
		local tr = util.QuickTrace( ( pos + Vector( 0, 0, -7 ) ), ( fwd * 16 ), self )
		local chk = ( ( pos + Vector( 0, 0, 16 ) ) + ( fwd * 16 ) )
		chk = util.PointContents( chk )
		if tr.HitWorld then
			if chk != CONTENTS_SOLID then
				phys:ApplyForceCenter( Vector( 0, 0, 300 ) )
				timer.Simple( .25, function()
					if IsValid( self ) then
						phys:ApplyForceCenter( ( fwd * 100 ) )
					end
				end )
			end
		end

		//Turn Check
		local tr = util.QuickTrace( ( pos + Vector( 0, 0, -7 ) ), ( fwd * 128 ), self )
		local chk = ( ( pos + Vector( 0, 0, 16 ) ) + ( fwd * 128 ) )
		chk = util.PointContents( chk )
		if tr.HitWorld && chk == CONTENTS_SOLID && !IsValid( self.PlayerSaturn ) then //You're walking into a wall man...

			if CurTime() >= self.WallCheck then
				self.WallCheck = ( CurTime() + 1 )
				self.WalkTimeMin = .1
				self.WalkTimeMax = .1
				self.WalkAngle.y = ( self.WalkAngle.y + 180 ) //away from the wall, son
			end

		else

			local mn, mx = .5, .9
			if IsValid( self.PlayerSaturn ) then
				mn, mx = .1, .3
			end
			self.WalkTimeMin = mn
			self.WalkTimeMax = mx

		end

	else //We're knocked over

		local vel = self:GetVelocity():Length()
		local angvel = phys:GetAngleVelocity():Length()
		if self:TouchingGround() && !self.ShouldGetUp && vel <= 30 && angvel <= 200 && !self.Fishing && !self.Sitting then
			self.ShouldGetUp = true
			timer.Create( tostring( self ) .. "GetUpTimer", math.random( 3, 6 ), 1, function()
				if IsValid( self ) then
					self.CanGetUp = true
					self.ShouldGetUp = false
					self:EmitSound( "UCH/saturn/saturn_getup.wav", 60, 100 )
				end
			end )
		end

	end

	if ( self:FeetPlanted() && vel <= 100 && angvel <= 75 ) || self.Fishing || self.Sitting || self.Flying then
		self:RandomSchedule()
	end

	if !self:FeetPlanted() then
		self.ShouldWalk = true
	end

	self:NextThink( CurTime() )
	return true

end

function ENT:PhysicsSimulate( phys, delta )

	phys:Wake()
	if self:WaterLevel() >= 1 then
		return
	end
	//Simulated friction, since we need to use ice as our physprop ( it negates the collsion dust )
	local forward, right = 0
	local vel = phys:GetVelocity()
	local forwardvel = phys:GetAngles():Forward():Dot( vel )
	local rightvel = phys:GetAngles():Right():Dot( vel )
	local spd = vel:Length()

	local wlkchk = phys:GetAngles():Up().z
	if self.Walking && wlkchk > .9 then
		phys:ComputeShadowControl( self:WalkSC( delta ) )
	end

	if self.CanGetUp then
		phys:ComputeShadowControl( self:GetUpSC( delta ) )
	end

	if self.Fishing || self.Sitting then
		phys:ComputeShadowControl( self:FishSC( delta ) )
	end

	if self.Flying then
		phys:ComputeShadowControl( self:FlySC( delta ) )
	end

	//We be rollin, they laughin
	if self:TouchingGround() || spd >= 200 then
		construct.SetPhysProp( nil, self, 0, nil, {GravityToggle = true, Material = "rubber"} )
	end

	//We're firmly planted on the ground
	if self:FeetPlanted() then

		if spd < 200 && wlkchk > .9 then
			construct.SetPhysProp( nil, self, 0, nil, {GravityToggle = true, Material = "ice"} )
			forward = ( forwardvel * .25 ) * -1
			right = ( rightvel * .25 )
			if self.Fishing || self.Sitting then
				self:SetLocalVelocity( Vector( 0, 0, 0 ) )
				phys:ApplyForceCenter( Vector( 0, 0, 400 ) )
			end
		end

	else

		if self.Walking && !self.CanGetUp then
			if self.CurrentEndFunc then
				local f, err = pcall( self.CurrentEndFunc, self )
				if !f then
					print( "ERROR: " .. err )
					return
				end
			end
			self.Walking = false
			self.SCHEDTime = 0
		end

	end

	local linear = ( Vector( forward, right, 0 ) * delta * 1000 )

	return Vector( 0, 0, 0 ), linear, SIM_LOCAL_ACCELERATION
end

function ENT:Explode()

	local ef = EffectData()
	local pos = ( self:GetPos() + Vector( 0, 0, 25 ) )
	ef:SetStart( Vector( 255, 200, 175 ) )
	ef:SetOrigin( pos )
	ef:SetScale( 1 )
	util.Effect( "piggy_pop", ef )
	util.Effect( "piggy_pop", ef )
	util.Effect( "piggy_pop", ef )
	ef:SetStart( Vector( 255, 0, 0 ) )
	util.Effect( "piggy_pop", ef )
	self:EmitSound( "UCH/saturn/saturn_hit.wav", 60, math.random( 35, 60 ) )
	self:Remove()

	for _, v in ipairs( player.GetAll() ) do
		GAMEMODE:HUDMessage( v, MSG_MRSATURNDEAD, 6 )
	end

end

function ENT:OnRemove()

	self:RemoveBalloon()
	--GAMEMODE:NewSaturn()

end

function ENT:Use( ply )

	--if self.IsScared || !ply:IsPig() || ply.IsScared || ply.IsTaunting || ply.HasSaturn then return end

	ply:EmitSound( "UCH/saturn/saturn_pickup.wav", 40, 100 )
	if self.Sitting then
		self:EndSit()
		if timer.Exists("SitTimer"..self:EntIndex()) then
			timer.Destroy("SitTimer"..self:EntIndex())
		end
	else
		self:StartSit()
		timer.Create("SitTimer"..self:EntIndex(), 5, 1, function()
			if IsValid(self) and self.Sitting then
				self:EndSit()
			end
		end)
	end


end
