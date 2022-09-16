function EFFECT:Init( data )
	local low = data:GetOrigin()
	local high = data:GetOrigin() + Vector( 25, 25, 25 )
	local num = 50

	local emitter = ParticleEmitter( low )
	for i = 0, num do
		local pos = Vector( math.Rand( low.x, high.x ), math.Rand( low.y, high.y ), math.Rand( low.z, high.z ) )

		local particle = emitter:Add( "effects/yellowflare", pos )
		if particle then
			particle:SetVelocity( VectorRand() * 100 )
			particle:SetColor( 255, 255, 200 )
			particle:SetDieTime( math.Rand( 2.0, 4.0 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand( 10, 15 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( -360, 360 ) )
			particle:SetRollDelta( math.Rand( -50, 50 ) )

			particle:SetAirResistance( math.random( 50, 100 ) )
			particle:SetGravity( Vector( 0, 0, math.random( -100, -50 ) ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.5 )
		end
	end
	emitter:Finish()

	local emitter2 = ParticleEmitter( low )
	local particle = emitter2:Add( "effects/brightglow_y", self:GetPos() )
	if particle then
		particle:SetVelocity( Vector( 0, 0, 0 ) )
		particle:SetDieTime( 0.5 )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 50 )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.random( -360, 360 ) )
		particle:SetRollDelta( math.random( -200, 200 ) )
		particle:SetColor( 255, 225, 255 )
	end
	emitter2:Finish()
end

function EFFECT:Think( ) return false end
function EFFECT:Render() end
