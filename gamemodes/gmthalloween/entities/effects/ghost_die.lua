EFFECT.SmokeMat = Material( "particles/smokey" )
EFFECT.StarMat = Material( "effects/strider_muzzle" )
EFFECT.SparkMat = Material( "effects/yellowflare" )

function EFFECT:Init( data )

	local Pos 		= data:GetOrigin()
	local Norm	 	= data:GetNormal()
	local Scale 	= data:GetScale() or 0.5
	if Scale == 0 then Scale = 0.5 end

	local emitter = ParticleEmitter( Pos )

	-- Dark Red smoke
	local particle = emitter:Add( self.SmokeMat, Pos )
	if particle then
		particle:SetDieTime( math.Rand( .2, .5 ) * Scale )
		particle:SetStartAlpha( 20 )
		particle:SetStartSize( math.Rand( 12, 32 ) * ( Scale / 7 ) )
		particle:SetEndSize( math.Rand( 64, 82 ) * ( Scale / 6 ) )
		particle:SetRollDelta( math.Rand( -0.2, 0.2 ) )
		particle:SetColor( 30, 0, 0 )
	end

	-- Start dlight
	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.Pos = Pos
		dlight.r = 100
		dlight.g = 100
		dlight.b = 255
		dlight.Brightness = 2
		dlight.Decay = 200
		dlight.size = 256
		dlight.DieTime = CurTime() + 5
		--dlight.Style = 4
	end

	-- Star-like particles
	local particle = emitter:Add( self.StarMat, Pos + Vector(0,0,10) )
	if particle then
		particle:SetVelocity( Vector( 0, 0, 0 ) )
		particle:SetDieTime( 1 )
		particle:SetStartAlpha( 200 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 80 )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random( -200, 200 ) )
		particle:SetColor( 100, 100, 255 )
	end	
	for i=1, 30 do
	
		local particle = emitter:Add( self.SparkMat, Pos + VectorRand() * 5 )
		if particle then
			particle:SetColor( 80, 80, 255 )
			particle:SetStartSize( math.Rand( 1, 5 ) )
			particle:SetEndSize( 0 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetDieTime( math.Rand( 5, 8 ) )
			particle:SetVelocity( VectorRand() * 100 + Vector(0,0,50) )
			
			particle:SetBounce( 0.5 )
			particle:SetGravity( Vector(0,0,-200) )
			particle:SetCollide( true )
		end
	
	end

	-- Smoke
	for i=1, 20 do
		local particle = emitter:Add( self.SmokeMat, Pos + ( VectorRand() * 25 ) )
		if particle then

			local LightColor = render.GetLightColor( Pos ) * 255
			LightColor.r = math.Clamp( LightColor.r, 90, 255 )
			LightColor.g = math.Clamp( LightColor.g, 90, 255 )
			LightColor.b = math.Clamp( LightColor.b, 90, 255 )

			particle:SetVelocity( Vector(0,0,20) )
			particle:SetDieTime( math.Rand( 2, 5 ) )
			particle:SetStartAlpha( math.Rand( 50, 100 ) )
			particle:SetStartSize( math.Rand( .5, 1 ) )
			particle:SetEndSize( math.Rand( 20, 30 ) )
			particle:SetRoll( math.Rand( -25, 25 ) )
			particle:SetRollDelta( math.Rand( -0.1, 0.1 ) )
			particle:SetColor( LightColor.r, LightColor.g, LightColor.b )

		end
	end

	emitter:Finish()

end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end