

-----------------------------------------------------
EFFECT.Mat = Material("particles/balloon_bit")



function EFFECT:Init( data )

	

	local vOrigin = data:GetOrigin()

	local snow = data:GetFlags() == 2

	local NumParticles = snow && 256 || 128

	

	local emitter = ParticleEmitter( vOrigin, !snow )

	

		for i=0, NumParticles do

		

			local Pos = VectorRand()

		

			local particle = emitter:Add( snow && "particle/snow" || "particles/balloon_bit", vOrigin + Pos * 8 )

			if (particle) then

				

				particle:SetVelocity( Pos:GetNormal() * 800 )

				

				particle:SetLifeTime( 0 )

				particle:SetDieTime( 10 )

				

				particle:SetStartAlpha( 255 )

				particle:SetEndAlpha( 255 )

				

				local Size = math.Rand( 2, 3 )

				particle:SetStartSize( Size )

				particle:SetEndSize( 0 )

				

				particle:SetRoll( math.Rand(0, 360) )

				particle:SetRollDelta( math.Rand(-2, 2) )

				

				particle:SetAirResistance( 400 )

				particle:SetGravity( Vector(0,0,-300) )

				

				particle:SetColor( math.Rand(50,255), math.Rand(50,255), math.Rand(50, 255) )

				

				particle:SetCollide( true )

				

				particle:SetAngleVelocity( Angle( math.Rand( -160, 160 ), math.Rand( -160, 160 ), math.Rand( -160, 160 ) ) ) 

				

				particle:SetBounce( 1 )

				particle:SetLighting( false )


				if snow then

					local special = i % 2 == 0
					particle:SetColor( 255, 255, 255 )
					particle:SetStartAlpha( special && 255 || 100 )
					particle:SetEndAlpha( 0 )
					particle:SetAirResistance( 200 )
					particle:SetGravity( Vector( 0, 0, -24 ) )
					particle:SetStartSize( math.Rand( 0.4, 0.6 ) )
					particle:SetVelocity( Pos:GetNormal() * math.random( 100, 250 ) )
					particle:SetRollDelta( 0 )

				end

				

			end

			

		end

		

	emitter:Finish()

	

end



function EFFECT:Think( )

	return false

end



function EFFECT:Render()

end

