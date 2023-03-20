function EFFECT:Init( data )

	local vOffset = data:GetOrigin()
	local Color = data:GetStart()

	if data:GetFlags() == 1 then
		sound.Play( "weapons/ar2/npc_ar2_altfire.wav", vOffset, 160, 130 )
	end

	local Low = vOffset - Vector( 32, 32, 32 )
	local High = vOffset + Vector( 32, 32, 32 )

	local NumParticles = 32

	local emitter = ParticleEmitter( vOffset, true )

	for i=0, NumParticles do

		local Pos = VectorRand()
		local particle = emitter:Add( "particles/balloon_bit", vOffset + Pos * 8 )

		if particle then
			particle:SetVelocity( Pos * 800 )

			particle:SetLifeTime( 0 )
			particle:SetDieTime( 10 )

			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 255 )

			local Size = math.Rand( 1, 3 )
			particle:SetStartSize( Size )
			particle:SetEndSize( 0 )

			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand(-2, 2 ) )

			particle:SetAirResistance( 400 )
			particle:SetGravity( Vector( 0,0,-300 ) )

			local RandDarkness = math.Rand( 0.8, 1.0 )
			particle:SetColor( Color.r * RandDarkness, Color.g * RandDarkness, Color.b * RandDarkness )

			particle:SetCollide( true )

			particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) ) 

			particle:SetBounce( 1 )
			particle:SetLighting( true )

		end

	end

	emitter:Finish()
	
end

function EFFECT:Think() return false end
function EFFECT:Render() end