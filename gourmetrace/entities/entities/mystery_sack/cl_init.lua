include("shared.lua")

ENT.Color = nil
ENT.SpriteMat = Material( "sprites/powerup_effects" )
ENT.GlowMat = Material("effects/brightglow_y")

local Glow = true

net.Receive("DoSpark",function()
  local Sack = net.ReadEntity()
  Sack:DoSpark()
end)

function ENT:Initialize()

	self.NextParticle = CurTime() + 0.15

	self.csModel = ClientsideModel(self.Model)
  self.csModel:SetRenderMode(RENDERMODE_TRANSALPHA)
  self.csModel:SetModelScale(1.5,0)
	self:DrawShadow(false)

		if IsValid( self ) then
			self.BaseClass:Initialize()
			self.OriginPos = self:GetPos()
			self.NextParticle = CurTime()
			self.TimeOffset = math.Rand( 0, 3.14 )

			self.Emitter = ParticleEmitter( self:GetPos() )
		end

end

function ENT:Draw()

	local SackAngle = math.sin(CurTime() * 8) * 16
	local SackHeight = math.sin(CurTime() * 2) * 8
  local CurAng = self:GetAngles()

	self.csModel:SetPos(self:GetPos() + Vector(0,0, SackHeight))
	self.csModel:SetAngles(Angle(CurAng.p,CurAng.y,CurAng.r + SackAngle))

	render.SetMaterial( self.SpriteMat )
	render.DrawSprite( self.csModel:GetPos() + Vector(0,0,10), 75, 75, self.Color )

  if Glow then
    render.SetMaterial( self.GlowMat )
    render.DrawSprite( self.csModel:GetPos() + Vector(0,0,10), 100 + math.sin(CurTime()*4)*30, 100 + math.sin(CurTime()*4)*30, Color(255,255,50,255) )
  end

end

function ENT:OnRemove()
	self.csModel:Remove()
end

function ENT:Think()

	self.Color = Color(255,255,0)

	if CurTime() > self.NextParticle then
		local emitter = self.Emitter

		local pos = self.csModel:GetPos() + ( VectorRand() * ( self:BoundingRadius() * 0.75 ) )
		local vel = VectorRand() * 3

		vel.z = vel.z * ( vel.z > 0 && -3 or 3 )

		local particle = emitter:Add( "sprites/powerup_effects", pos )

		if particle then
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand( 1, 3 ) )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 18 )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )


			particle:SetColor( self.Color.r, self.Color.g, self.Color.b )
		end

		self.NextParticle = CurTime() + 0.15
	end

end

function ENT:DoSpark()

  Glow = false

  self.csModel:SetColor(Color(255,255,255,50))

  timer.Simple(self.RespawnTime,function()
    self.csModel:SetColor(Color(255,255,255,255))
    Glow = true
  end)

  local vPoint = self.csModel:GetPos()
  local effectdata = EffectData()
  effectdata:SetOrigin( vPoint )
  util.Effect( "sack_pickup", effectdata )
end
