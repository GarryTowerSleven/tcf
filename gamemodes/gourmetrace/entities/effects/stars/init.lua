local COLOR_RED = Color(255, 255, 255)
local COLOR_YELLOW = Color(255, 255, 0)

EFFECT.Mat = Material("sprites/star")

function EFFECT:Init( data )

	local vOffset = data:GetOrigin()
	local vNorm = data:GetNormal()

	local NumParticles = 8

	local emitter = ParticleEmitter( vOffset )

		for i=1, NumParticles do

			local particle = emitter:Add( "sprites/star", vOffset )
			if (particle) then

				local angle = vNorm:Angle()
				particle:SetVelocity( VectorRand() * 250 )

				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.random(0.2,1) )

				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.random(5,8) )
				particle:SetEndSize( math.random(2,5) )

				local col = COLOR_RED
				if math.random(0,1) == 0 then
					col = COLOR_YELLOW
				end

				col.g = col.g - math.random(0, 50)

				particle:SetColor( col.r, col.g, math.Rand(0, 50) )

				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )

				particle:SetAirResistance( 100 )

				particle:SetGravity( vNorm * 100 )

			end

		end

	emitter:Finish()

end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
