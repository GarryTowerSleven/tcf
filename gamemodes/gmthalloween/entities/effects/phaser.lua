EFFECT.Mat		 = Material( "effects/spark" )
EFFECT.MatMuzzle = Material( "effects/strider_muzzle" )

EFFECT.Color	 = Color( 60, 60, 255 )

function EFFECT:Init( data )

	self.MatMuzzle = Material( "sprites/flamelet" .. tostring( math.random( 1, 5 ) ) )

	self.StartPos	= data:GetStart()
	self.EndPos		= data:GetOrigin()
	self.Dir		= self.EndPos - self.StartPos

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

	self.TracerTime = 0.05
	self.Length = math.Rand( 0.4, 0.6 )

	self.DieTime = CurTime() + self.TracerTime

	-- Heat wave
	local emitter = ParticleEmitter( self.StartPos )
	local particle = emitter:Add( "sprites/heatwave", self.StartPos )
	if particle then
		particle:SetVelocity( 80 * VectorRand() )
		particle:SetAirResistance( 200 )
		particle:SetDieTime( math.Rand(0.2, 0.25) )
		particle:SetStartSize( math.random(15,20) )
		particle:SetEndSize( 3 )
		particle:SetRoll( math.Rand(180,480) )
		particle:SetRollDelta( math.Rand(-1,1) )
	end

	emitter:Finish()

	-- Start dlight
	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.Pos = self.StartPos
		dlight.r = self.Color.r
		dlight.g = self.Color.g
		dlight.b = self.Color.b
		dlight.Brightness = 1
		dlight.Decay = 128
		dlight.size = 64
		dlight.DieTime = CurTime() + .5
	end

	-- End dlight
	local dlight2 = DynamicLight( self:EntIndex() .. "2" )
	if dlight2 then
		dlight2.Pos = self.EndPos
		dlight2.r = self.Color.r
		dlight2.g = self.Color.g
		dlight2.b = self.Color.b
		dlight2.Brightness = 1
		dlight2.Decay = 256
		dlight2.size = 128
		dlight2.DieTime = CurTime() + .5
	end

end

function EFFECT:Think( )
	if CurTime() > self.DieTime then
		return false 
	end
	return true
end

function EFFECT:Render( )
	local fDelta = (self.DieTime - CurTime()) / self.TracerTime
	fDelta = math.Clamp( fDelta, 0, 1 ) ^ 0.5

	for i = 1, 10 do
		render.SetMaterial( self.Mat )
		local sinWave = math.sin( fDelta * math.pi )

		local color = self.Color
		color.a = 255 * fDelta

		render.DrawBeam( self.EndPos - self.Dir * (fDelta - sinWave * self.Length ),
			self.EndPos - self.Dir * (fDelta + sinWave * self.Length ),
			1 + sinWave * 10,
			1,
			0,
			Color( color.r, color.g, color.b, color.a )
		)

		color.r = 30
		color.g = 30

		render.SetMaterial( self.MatMuzzle )
		render.DrawSprite( self.StartPos, i * 1 * fDelta, i * .5 * fDelta, Color( color.r, color.g, color.b, color.a ) )
		render.DrawSprite( self.EndPos, i * 2 * (fDelta*1.25), i * 2 * (fDelta*1.25), Color( color.r, color.g, color.b, 255 ) )
	end
end