include( "shared.lua" )

ENT.OffsetAmount = 30 //Amount, in units, to offset ourselves from the player
ENT.MoveSpeed = 7 //Speed to move to goal position
ENT.AngleSpeed = 6 //Speed to move the angle to goal angle

ENT.GoalPos = Vector( 0, 0, 0 ) //Our "goal position" to always try to be at
ENT.CurPos = Vector( 0, 0, 0 )

ENT.GoalAngle = Angle( 0, 0, 0 )//same as above
ENT.CurAngle = Angle( 0, 0, 0 )

ENT.Rotation = 0

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()

	self.CurPos = self:GetPos()
	self.CurAngle = self:GetAngles()

	local owner = self:GetOwner()
	if IsValid( owner ) then
		self.CurPos = owner:GetPos()
		self.CurAngle = owner:GetAngles()

		owner.Helicopter = self
	end

	self.NextParticle = RealTime()
	self.TimeOffset = math.Rand( 0, 3.14 )

	self.Emitter = ParticleEmitter( self:GetPos() )
	self:SetModelScale( self.ModelScale, 0 )

end

function ENT:DrawRotors()
	if !IsValid(self.TopRotor) then
		self.TopRotor = ClientsideModel( self.RotorModel )
		self.TopRotor:SetPos( self:GetPos() )
		self.TopRotor:SetAngles( Angle( 0, 0, 0 ) )
		self.TopRotor:SetModelScale( self.ModelScale * 0.8, 0 )

		self.TopRotor:Spawn()
		self.TopRotor:SetParent(self)
	end

	if !IsValid(self.BackRotor) then
		self.BackRotor = ClientsideModel( self.BackRotorModel )
		self.BackRotor:SetPos( self:GetPos() )
		self.BackRotor:SetAngles( Angle( 0, 0, 0 ) )
		self.BackRotor:SetModelScale( self.ModelScale, 0 )

		self.BackRotor:Spawn()
		self.BackRotor:SetParent(self)
	end

	self.TopRotor:SetPos( self:GetPos() + self:GetUp() * 6 )
	self.BackRotor:SetPos( self:GetPos() + self:GetRight() * 1 + self:GetForward() * -28 + self:GetUp() * 7 )

	local rotationFactor = 50

	local owner = self:GetOwner()
	if IsValid( owner ) then
		rotationFactor = rotationFactor + owner:GetVelocity():Length() * 2

		if owner:KeyDown( IN_JUMP ) then
			rotationFactor = rotationFactor + 100
		end

		if owner:Crouching() then
			rotationFactor = 5
		end
	end

	self.Rotation = self.Rotation + ( RealFrameTime() * rotationFactor ) % 360

	local newTopAng = self:GetAngles()
	newTopAng:RotateAroundAxis( newTopAng:Up(), self.Rotation )
	self.TopRotor:SetAngles(newTopAng)

	local newBackAng = self:GetAngles()
	newBackAng.x = self.Rotation * 10
	self.BackRotor:SetAngles(newBackAng)
end

function ENT:OnRemove()
	if self.ActiveSound then self.ActiveSound:Stop() end
	if IsValid( self.TopRotor ) then self.TopRotor:Remove() end
	if IsValid( self.BackRotor ) then self.BackRotor:Remove() end
	if IsValid( self.Emitter ) then self.Emitter:Finish() end
end

function ENT:Draw()

	self:SetModelScale( .075, 0 )
	self:DrawModel()

	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos()
	
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	self:DrawRotors()
end

function ENT:Think()
	
	if !IsValid( self:GetOwner() ) || self:GetColor().a == 0 then return end
	
	local ply = self:GetOwner()
	local pos = util.GetHeadPos( ply )
	local ang = ply:EyeAngles()

	if ply == LocalPlayer() && ply:InVehicle() then ang.y = ang.y + ply:GetVehicle():GetAngles().y end

	local offset = ( ang + Angle( 0, 40, 0 ) ):Right() * self.OffsetAmount

	local speedPitch = math.Clamp( ply:GetVelocity():Dot( ply:GetForward() ) / 12, -45, 45 )

	if ply:Crouching() and ply:OnGround() then
		if !self.DuckZ then
			self.DuckZ = ply:GetPos().z
		end

		self.MoveSpeed = 2

		self.GoalAngle.p = 0
		self.GoalPos.z = self.DuckZ + 2
	else
		self.DuckZ = nil
		self.MoveSpeed = 7

		self.GoalPos = pos + offset	+ Vector( 0, 0, math.sin( CurTime() * 1.2 ) * 4 )
		self.GoalAngle = Angle( speedPitch, ang.y, ang.r )
	end

	//Do the splinin' here
	self.CurPos = LerpVector( FrameTime() * self.MoveSpeed, self.CurPos, self.GoalPos )
	self.CurAngle = LerpAngle( FrameTime() * self.AngleSpeed, self.CurAngle, self.GoalAngle )
	self:SetPos( self.CurPos )
	self:SetAngles( self.CurAngle )

	self:DrawParticles()

	if LocalPlayer() != ply then return end

	if !self.ActiveSound then 
		self.ActiveSound = CreateSound( self, self.Sound )
		self.ActiveSound:ChangePitch( 90, 0 )
		self.ActiveSound:ChangeVolume( 0, 0 )
		self.ActiveSound:Play()
	else
		local velocity = ply:GetVelocity():Length()
		self.ActiveSound:ChangePitch( math.Clamp( velocity / 4, 90, 125 ), 0 )
		self.ActiveSound:ChangeVolume( math.Clamp( velocity / 2000, 0, .5 ), 0 )

		if !self.ActiveSound:IsPlaying() then
			self.ActiveSound:Play()
		end
	end
end

function ENT:DrawParticles()

	if !IsValid(self.Emitter) then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	if RealTime() > self.NextParticle then

		local vel = VectorRand() * math.Rand( .25, 1 )
		vel.z = vel.z * ( vel.z > 0 && -3 or 3 )
		local pos = self:GetPos() + Vector( 0, 0, 10 )

		local particle = self.Emitter:Add( "sprites/powerup_effects", pos + ( VectorRand() * ( self:BoundingRadius() * 0.5 ) ) )

		if particle then
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand( .75, 2 ) )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.random( 4, 8 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
			particle:SetColor( math.random( 240, 255 ), math.random( 5, 15 ), math.random( 5, 15 ) )
			particle:SetCollide( true )
		end

		self.NextParticle = RealTime() + 0.2

	end

end

function ENT:Shoot()
	self:EmitSound( "npc/attack_helicopter/aheli_mine_drop1.wav", 50, 125, .75 )

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetNormal( self:GetForward() )
	util.Effect( "gunhit", effectdata )

	local effectdata = EffectData()
	
	local owner = self:GetOwner()
	local trace

	if IsValid(owner) then
		trace = owner:GetEyeTrace()
	else
		trace = util.QuickTrace( self:GetPos(), self:GetForward() * 10000, self )
	end

	effectdata:SetOrigin( trace.HitPos )
	effectdata:SetStart( self:GetPos() )
	util.Effect( "flak", effectdata )

	util.Decal( "ExplosiveGunshot", self:GetPos(), trace.HitPos + trace.Normal * 25, self )
end

net.Receive("PetHeliShoot", function()
	local heli = net.ReadEntity()

	if IsValid( heli ) and heli.Shoot then
		heli:Shoot()
	end
end)
