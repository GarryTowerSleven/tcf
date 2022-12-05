function EFFECT:Init( data )

	local pos = data:GetOrigin()
	local num = 50
	
	local emitter = ParticleEmitter( pos )
	for i=1, num do

		/*local sprite = "effects/muzzleflash" .. math.random( 1, 4 )
		if math.random( 1, 2 ) == 1 then
			sprite = "sprites/flamelet" .. tostring( math.random( 1, 5 ) )
		end*/

		local particle = emitter:Add( "sprites/flamelet" .. tostring( math.random( 1, 5 ) ), pos )
		if (particle) then

			particle:SetVelocity( ( VectorRand() * 1 ) * math.Rand( 25, 150 )  )
			particle:SetAngleVelocity( Angle( math.Rand( -1, 1 ), math.Rand( -1, 1 ), math.Rand( -1, 1 ) ) * 1200 )
			//particle:SetAngles( Angle( math.Rand( 0, 360 ), math.Rand( 0, 360 ), math.Rand( 0, 360 ) ) )
				
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 6 )
				
			particle:SetStartSize( 8 )
			particle:SetEndSize( 0 )

			particle:SetColor( 70, 255, 70, 100 )

			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-2, 2) )
				
			particle:SetAirResistance( 5 )

			particle:SetGravity( Vector( 0, 0, -800 ) )
			particle:SetBounce( 0.1 )
			particle:SetCollide( true )
			
		end
	end

	emitter:Finish()

end

function EFFECT:Think()

	return false

end

function EFFECT:Render()

end