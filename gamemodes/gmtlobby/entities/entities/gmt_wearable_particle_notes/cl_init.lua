
-----------------------------------------------------
include('shared.lua')
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Particles = {
	rate = .1,
	amount = 1,
	material = "sprites/music",
}

function ENT:DrawParticles()

	local owner = self:GetOwner()

	local modelsize = GTowerModels.Get( owner ) or 1
	
	local pos = util.GetCenterPos( owner ) + Vector( 0, 0, -5 * modelsize )

	local grav = Vector( 0, 0, math.random( 50, 60 ) * modelsize )

	local offset = Vector( 0, 0, 0 )

	local col = Color( 255,255,255 )



	for i = 1, 2 do

		local particle = self.Emitter:Add( "sprites/music", pos + offset )

		particle:SetVelocity( ( Vector( 0, 0, 1 ) + ( VectorRand() * 0.1 ) ) * math.random( 15, 30 ) )

		particle:SetDieTime( math.random( 0.5, 0.8 ) )

		particle:SetStartAlpha( 255 )

		particle:SetEndAlpha( 0 )

		particle:SetStartSize( 4 * modelsize )

		particle:SetEndSize( 1.5 * modelsize )

		particle:SetRoll( math.random(0.5, 10) )

		particle:SetRollDelta( math.Rand(-0.2, 0.2) )

		particle:SetColor( col.r, col.g, col.b )

		particle:SetCollide( false )



		particle:SetGravity( grav )

		offset = offset + Vector( math.random(-15, 15) * modelsize, math.random(.5, 5) * modelsize, math.random(-1.5, 6) * modelsize )

	end



	--self.Emitter:Finish()


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
