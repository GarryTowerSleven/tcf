
-----------------------------------------------------
include('shared.lua')
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Particles = {
	rate = .1,
	amount = 1,
	material = "sprites/banana",
}

function ENT:DrawParticles()

	local owner = self:GetOwner()

	local modelsize = GTowerModels.Get( owner ) or 1
	
	local pos = util.GetCenterPos( owner ) + Vector( 0, 0, -5 * modelsize )

	local angle = Angle( 0, SinBetween( -240, -120, CurTime() * 2 ), 0 )

	local pitch = angle.p
	local yaw = angle.y

	local color = Color(225,225,0,100)

	for i=1, self.Particles.amount do

		//local flare = Vector( 0, math.random( -10, 10 ), 0 )
		//local flare = Vector( 0, 0, math.random( -25, 25 ) )
		local flaresizemin = -16 * modelsize
		local flaresizemax = 16 * modelsize
		local flare = Vector( CosBetween( flaresizemin, flaresizemax, CurTime() * 16 ), SinBetween( flaresizemin, flaresizemax, CurTime() * 16 ), 0 )

		local particle = self.Emitter:Add( self.Particles.material, pos + flare )
		if particle then

			local rad = math.rad(0)
			--local coord = self.EPos + (self.Radius * Vector(math.cos(rad), math.sin(rad), 0))

			particle:SetLifeTime( 0 )
			particle:SetDieTime( 1 )

			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 5 * modelsize )
			particle:SetEndSize( 5 * modelsize )

			particle:SetColor( 255, 230, 25 )

			particle:SetAirResistance( 100 )

			self.EPos = self:GetPos() + Vector( 0, 0, 40 )

			--local inward = (self.EPos - coord):GetNormal() * 40 + Vector(0,0,60 + self.EmitOffset/15)
			particle:SetGravity( Vector(math.random(-25,25) * modelsize, math.random(-25,25) * modelsize, 25 * modelsize ) )

			particle:SetVelocity( Vector(math.random(-25,25) * modelsize, math.random(-25,25) * modelsize, 25 * modelsize ) )

			particle:SetAngleVelocity( Angle( math.Rand( -2, 2 ), math.Rand( -2, 2 ), math.Rand( -2, 2 ) ) )

		end

	end

end

function ENT:ParticlePosition( owner, bound )

	local pos = owner:GetPos() + Vector(0,0,50)
	if bound then
		pos = pos + ( VectorRand() * ( self:BoundingRadius() * ( bound or .35 ) ) )
	end

	return pos

end

function ENT:GetNextColorID()

	if self.CurColorID > ( #self.Colors - 1 ) then
		self.CurcolorID = 1
		return self.CurcolorID
	end

	return self.CurColorID + 1

end

function ENT:GetTimedColor()

	local nextColor = self.Colors[ self:GetNextColorID() ]

	if !( math.abs( self.CurrentColor.r ) >= math.abs( nextColor.r ) &&
	   math.abs( self.CurrentColor.g ) >= math.abs( nextColor.g ) &&
	   math.abs( self.CurrentColor.b ) >= math.abs( nextColor.b ) ) then

		self.CurrentColor.r = math.Approach( self.CurrentColor.r, nextColor.r, FrameTime() * 30 )
		self.CurrentColor.g = math.Approach( self.CurrentColor.g, nextColor.g, FrameTime() * 30 )
		self.CurrentColor.b = math.Approach( self.CurrentColor.b, nextColor.b, FrameTime() * 30 )

	else
		self.CurColorID = self:GetNextColorID()
	end

	return self.CurrentColor

end

function ENT:Initialize()

	self.NextParticle = CurTime()
	self.Emitter = ParticleEmitter( self:GetPos() )

end

function ENT:TranslateOffset( vec )
	return ( self:GetForward() * vec.x ) + ( self:GetRight() * -vec.y ) + ( self:GetUp() * vec.z )
end

function ENT:Think()

	if !EnableParticles:GetBool() then

		self:RemoveEmitter()

		return

	end

	local owner = self:GetOwner()
	if !IsValid( owner ) || self:GetColor().a == 0 then return end

	if LocalPlayer() == owner && !LocalPlayer().ThirdPerson then return end

	if not self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	if CurTime() > self.NextParticle then

		self.NextParticle = CurTime() + self.Particles.rate

		self:DrawParticles()

	end

end

function ENT:OnRemove()

	self:RemoveEmitter()

end

function ENT:RemoveEmitter()

	if IsValid( self.Emitter ) then
		self.Emitter:Finish()
		self.Emitter = nil
	end

end
