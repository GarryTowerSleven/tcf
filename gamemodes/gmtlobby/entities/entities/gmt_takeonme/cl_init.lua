include('shared.lua')
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.SpriteMat = Material( "sprites/powerup_effects" )

CreateClientConVar( "gmt_takeonmat", "1", true, true )

function ENT:Initialize()

	self.Owner = self:GetOwner()
	self.NextParticle = CurTime()
	self.TimeOffset = math.Rand( 0, 3.14 )

	//self.Emitter = ParticleEmitter( self:GetPos() )

end

function ENT:Draw()

	local owner = self:GetOwner()
	if IsValid( owner ) then

		if LocalPlayer() == owner && !LocalPlayer().ThirdPerson then return end

		local plycol = owner:GetPlayerColor()

		local size = GTowerModels.Get( owner ) or 1

		local pos, ang

		local Torso = owner:LookupBone( "ValveBiped.Bip01_Spine2" )
		if Torso then
			pos, ang = owner:GetBonePosition( Torso )
		else
			pos, ang = owner:GetPos(), owner:GetAngles()
		end

		if IsValid( owner:GetBallRaceBall() ) then
			pos = owner:GetBallRaceBall():GetPos()
		end
		
		render.SetMaterial( self.SpriteMat )
		render.DrawSprite( pos, 64 * size, 64 * size, Color(plycol.x * 255, plycol.y * 255, plycol.z * 255)  )

	end

end

function ENT:OnRemove()

	if self.Emitter then

		self.Emitter:Finish()
		self.Emitter = nil

	end

	local owner = self:GetOwner()
	if IsValid( owner ) && IsValid( owner:GetBallRaceBall() ) && IsValid( owner:GetBallRaceBall().PlayerModel ) then
		owner:GetBallRaceBall().PlayerModel:SetMaterial( "" )
	end

end


function ENT:Think()

	local owner = self:GetOwner()
	if !IsValid( owner ) then return end

	local plycol = owner:GetPlayerColor()

	local size = GTowerModels.Get( owner ) or 1

	if !self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	if CurTime() > self.NextParticle then

		local vel = VectorRand() * math.random( 4, 8 )
		vel.z = vel.z * ( vel.z > 0 && -3 or 3 )
		local pos = self:GetPos() + Vector( 0, 0, 32 )

		local Torso = owner:LookupBone( "ValveBiped.Bip01_Spine2" )
		local ang
		if Torso then
			pos, ang = owner:GetBonePosition( Torso )
		else
			pos, ang = owner:GetPos(), owner:GetAngles()
		end
		
		if IsValid( owner:GetBallRaceBall() ) then

			if IsValid( owner:GetBallRaceBall().PlayerModel ) then
				owner:GetBallRaceBall().PlayerModel:SetMaterial( "gmod_tower/pvpbattle/aha_skin" )
			end

			pos = owner:GetBallRaceBall():GetPos()
			size = 1

		end
		pos = pos - Vector( 0, 0, 16 * size )



		for i=0, 10 do
			local particle = self.Emitter:Add( "sprites/powerup_effects", pos + ( VectorRand() * ( self:BoundingRadius() * 0.35 * size ) ) )

			if particle then
				particle:SetVelocity( vel )
				particle:SetDieTime( math.Rand( .75, 2 ) )
				particle:SetStartAlpha( 100 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.random( 8 * size, 16 * size ) )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
				particle:SetColor( plycol.x * 255, plycol.y * 255, plycol.z * 255 )
				particle:SetCollide( true )
			end
		end

		self.NextParticle = CurTime() + 0.1

	end

end
