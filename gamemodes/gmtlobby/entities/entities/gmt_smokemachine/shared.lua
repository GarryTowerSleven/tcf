
-----------------------------------------------------
AddCSLuaFile("shared.lua")



ENT.Base		= "base_anim"

ENT.Type		= "anim"

ENT.PrintName	= "Smoke Machine"



ENT.SmokeOffset = Vector(0, -1, 3)

ENT.SmokeEjectVelocity = Vector( 0, -250, 0)

ENT.SmokeScaleFactor = 1

ENT.SmokeConeSize = 30

ENT.FogVolumeSize = 700

ENT.FogVolumeForward = 350



ENT.Model		= Model("models/gmod_tower/halloween_fogmachine.mdl")

--ENT.SmokeSound  = Sound() --TODO: this

ENT.SmokeMats = {

	Model("particle/particle_smokegrenade"),

	Model("particle/particle_noisesphere")

}



ENT.IsSmoking = false



function ENT:Initialize()



	if CLIENT then return end



	self:SetModel( self.Model )

	self:PhysicsInit( SOLID_VPHYSICS )

	self:SetSolid(SOLID_VPHYSICS)

	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )



end



function ENT:Think()



end



if SERVER then return end



ENT.Color = Color( 255, 128, 40, 255 )

ENT.SpriteMat = Material( "sprites/powerup_effects" )



function ENT:Initialize()





end



function ENT:Think()

	self.IsSmoking = CurTime() % 60 < 15



	// if self.IsSmoking then

		-- Spew some particles

		self:ThinkSmoke()

		self:ThinkSmokeVolume()



	-- Finish them off if we stopped

	// elseif IsValid(self.Emitter) then

		--self.Emitter:Finish()

	// end

end



function ENT:ThinkSmokeVolume()

	if !LocalPlayer():GetPos():WithinDistance( self:GetPos(), 2048 ) then

		/*if IsValid( self.Emitter ) then

			self.Emitter:Finish()

		end
*/
		return

	end



	if self.NextVolParticle and CurTime() < self.NextVolParticle then return end



	self.NextVolParticle = CurTime() + 0.3



	if not IsValid( self.Emitter ) then

		self.Emitter = ParticleEmitter( self:GetPos() )

	end



	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), -90 + math.random(-75, 75))

	local prpos = ang:Forward() * math.random(32, 400) // + self:GetForward() * math.random(128, 200)

	prpos.z = 32

	local p = self.Emitter:Add( table.Random( self.SmokeMats ), self:GetPos() + prpos )



	if p then



		local gray = math.random(75, 200)

		p:SetColor(gray, gray, gray)

		p:SetStartAlpha(0)

		p:SetEndAlpha(255)

		p:SetLifeTime(0)



		p:SetDieTime(math.Rand(10, 20))



		p:SetStartSize(math.random(140, 150))

		p:SetEndSize(185)

		p:SetRoll(math.random(-180, 180))

		p:SetRollDelta(math.Rand(-0.1, 0.1))

		p:SetAirResistance(600)



		p:SetCollide(true)

		p:SetBounce(0.4)



		p:SetLighting(false)

		local id = "PARTICLE" .. CurTime()

		// FIXME: This should be in one think hook. It doesn't cause much performance drop, but...
		hook.Add( "Think", id, function()


			if !p || p:GetLifeTime() / p:GetDieTime() >= 1 then


				hook.Remove("Think", id)

				return


			end

			local val = p:GetLifeTime() / p:GetDieTime()

			p:SetEndAlpha(255 * (1 - val))

			p.LastThink = p.LastThink or CurTime()


			if p.LastThink < CurTime() then


				local DISCO = IsValid(DISCO) and DISCO
				local lc = DISCO and DISCO:GetColor() or color_white // render.GetLightColor(p:GetPos()):ToColor()
				local m = DISCO and 1.25 or 1
				m = m * (1 - val)

				p:SetColor(lc.r * m, lc.g * m, lc.b * m)
				p.LastThink = CurTime() + 0.1


				if p and Location.Find(p:GetPos()) != LocalPlayer():Location() then


					p:SetDieTime(0.01)
					p:SetLifeTime(9999)
	

				end


			end


		end )



	end

end



function ENT:ThinkSmoke()



	if not self.Emitter then

		self.Emitter = ParticleEmitter( self:GetPos() )

	end



	if self.NextParticle and self.NextParticle > CurTime() then

		return

	else

		self.NextParticle = CurTime() + .1

	end







	local smokeOffset = self.SmokeOffset * 1.0

	local smokeVelocity = self.SmokeEjectVelocity * 1.0 + Vector(math.random(-self.SmokeConeSize,self.SmokeConeSize),0,math.random(-self.SmokeConeSize,self.SmokeConeSize))

	smokeVelocity:Rotate( self:GetAngles() )

	smokeOffset:Rotate( self:GetAngles() )



	local pos = self:GetPos() + smokeOffset * 1 --Optional scale value if yall want



	for i=1, 2 do



		if math.random( 3 ) > 1 then


			local particle = self.Emitter:Add( "particles/smokey", pos )

			if particle then

				particle:SetVelocity( (VectorRand() * 10 + smokeVelocity ) * self.SmokeScaleFactor )

				particle:SetLifeTime( 0 )

				particle:SetDieTime( 0.33 )

				particle:SetStartAlpha( math.Rand( 50, 100 ) / 2 )

				particle:SetEndAlpha( 0 )

				particle:SetStartSize( math.random( 0, self.SmokeScaleFactor ) / 2 )

				particle:SetEndSize( math.random( 10, 15 ) * self.SmokeScaleFactor )

				particle:SetRoll( math.Rand( -10, 10 ) )

				particle:SetRollDelta( math.Rand( -5, 5 ) )



				local dark = math.Rand( 100, 200 )

				particle:SetColor( dark, dark, dark )

				particle:SetAirResistance( math.random(10, 200) )

				particle:SetGravity( Vector( 0, 0, math.random( 10, 30 ) ) )

				particle:SetCollide( true )

				particle:SetBounce( 0.2 )

			end



		end



	end



end



