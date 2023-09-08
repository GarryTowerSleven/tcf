
-----------------------------------------------------
include('shared.lua')
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Particles = {
	rate = .075,
	amount = 1,
	material = "sprites/pickup_light",
}

function ENT:DrawParticles()

	local owner = self:GetOwner()

	local pos = util.GetCenterPos( owner ) + ( VectorRand():GetNormal() * 20 ) + Vector( 0, 0, -5 )

	local size = math.random( 0.5, 2 ) 
	
	for i=1, self.Particles.amount do

		local particle = self.Emitter:Add( self.Particles.material, pos )
		if particle then
		
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 1 )

			particle:SetStartAlpha( 50 )
			particle:SetEndAlpha( 150 )
			particle:SetStartSize( 8 * size )
			particle:SetEndSize( 0 )

			particle:SetColor( math.random(1,255), math.random(1,255), math.random(1,255) )

			particle:SetAirResistance( 150 )
			
			particle:SetGravity( Vector(math.random(-15,15),math.random(-15,15),math.random(-15,15)) )
			
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -3, 3 ) )
				
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
