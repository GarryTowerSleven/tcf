function EFFECT:Init( data )
	local vOffset = data:GetOrigin()
	local vNorm = data:GetNormal()
	local uc = data:GetFlags() == 2

	self.UC = uc
	self.Ent = data:GetEntity()

	if uc then
		self.Time = CurTime() + 5
		self.Rand = math.random(360)
		self.Add = 0
		return
	end

	local NumParticles = 8
	
	local emitter = ParticleEmitter( vOffset )
		for i=1, NumParticles do
			local particle = emitter:Add( "sprites/star", vOffset )
			if (particle) then
				local angle = vNorm:Angle()
				particle:SetVelocity( angle:Forward() * math.Rand(0, 200) + angle:Right() * math.Rand(-200, 200) + angle:Up() * math.Rand(-200, 200) )

				particle:SetDieTime( 3 )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( math.random( 3, 5 ) )
				particle:SetEndSize( 2 )

				particle:SetColor( 255, 255, math.Rand(0, 50) )

				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				
				particle:SetAirResistance( 100 )

				particle:SetGravity( vNorm * 50 )
			
			end
		end
	emitter:Finish()
end

function EFFECT:Think( )
	if IsValid(self.Ent) then
		self:SetPos(self.Ent:GetPos())
	end

	return self.Time and self.Time > CurTime() || false
end

local mat = Material("sprites/star")
local sparks = Material("cable/blue_elec")

function EFFECT:Render()

	if self.UC then
		local uc = self.Ent

		if IsValid( uc ) then

			local pos = uc:GetBonePosition(36)
			local pos2, ang = uc:GetBonePosition(2)
			self.Add = self.Add + FrameTime() * 64


			for i = 1, 6 do
				render.SetMaterial(mat)
				render.DrawSprite(pos + Angle(0, uc:GetRenderAngles().y + self.Rand + self.Add + i * (360 / 6), 0):Forward() * (10 + math.sin(CurTime() + i) * 2) + Vector(0, 0, 4 + math.sin(CurTime() + i * 2) * 2), 8, 8, Color(255, 255 - i * 64, 0))
			end
			
			render.SetMaterial(sparks)

			for i2 = 1, 1 do
				local tr = util.QuickTrace(uc:WorldSpaceCenter(), Angle(math.random(20, 40), math.random(360), 0):Forward() * 128, uc)
				
				local pos = pos2
				local ang = Angle(0, ang.y, 0)
				pos = pos + ang:Right() * (-28 + 16 * 2) + ang:Up() * 22 - ang:Forward() * 8

				local start = pos

				for i = 1, 8 do

					pos = pos + VectorRand() * 4

					if i == 1 then
						start = pos
					end

					local s = 12 + i2 * 2
					// s = s * math.Rand(0.8, 1.2)

					sparks:SetFloat("$alpha", math.Rand(0.2, 1))
					render.DrawBeam(pos, i == 8 and start or pos + ang:Forward() * s, 16, 0, 0.6 + math.Rand(0, 0.4), color_white)

					if math.random(2) == 1 then
						render.DrawBeam(pos, pos + AngleRand():Forward() * math.random(8, 32), 16, 0, 0.6 + math.Rand(0, 0.4), color_white)
					end

					pos = pos + ang:Forward() * s
					ang.p = ang.p + (360 / 8)
				end

			end

		end
	end
	

end