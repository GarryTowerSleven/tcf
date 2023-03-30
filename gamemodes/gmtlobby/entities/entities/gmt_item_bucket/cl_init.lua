
-----------------------------------------------------
include("shared.lua")

ENT.Color = nil
ENT.SpriteMat = Material( "sprites/powerup_effects" )

function ENT:Initialize()

	timer.Simple( 1, function()

		if IsValid( self ) then
			self.BaseClass:Initialize()
			self.OriginPos = self:GetPos()
			self.NextParticle = CurTime()
			self.TimeOffset = math.Rand( 0, 3.14 )

			self.Emitter = ParticleEmitter( self:GetPos() )
		end

	end )

end

function ENT:Draw()

	if !self.OriginPos || !self.TimeOffset then return end

	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(Color(255,255,255,0))

	self:DrawModel()

	render.SetMaterial( self.SpriteMat )
	render.DrawSprite( self:GetPos(), 50, 50, self.Color )

end

function ENT:Think()

	local rot = self:GetAngles()
	rot.y = rot.y + 90 * FrameTime()

	self.Color = colorutil.Rainbow(200)

	self:SetAngles(rot)
	self:SetRenderAngles(rot)

	if !self.OriginPos || !self.TimeOffset then return end

	local SinTime = math.sin( CurTime() + self.TimeOffset )
	self:SetRenderOrigin( self.OriginPos + Vector(0,0, 5 +  SinTime * 4 ) )

end
