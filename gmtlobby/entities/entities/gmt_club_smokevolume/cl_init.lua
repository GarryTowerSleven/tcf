
-----------------------------------------------------
include( "shared.lua" )

-- Should we draw the smoke?
local DrawSmokeConvar = CreateClientConVar("gmt_club_smoke", "1", true, false)

local function RandomAngle( ang, amt )

	local arc = ang
		arc:RotateAroundAxis(arc:Up(),math.random(-amt,amt))
		arc:RotateAroundAxis(arc:Forward(),math.random(-amt,amt))
		arc:RotateAroundAxis(arc:Right(),math.random(-amt,amt))
	return arc

end

ENT.Color = Color( 255, 255, 255 )

ENT.SmokeMats = {
	Model("particle/particle_smokegrenade"),
	Model("particle/particle_noisesphere")
}

function ENT:Draw()

	if DrawSmokeConvar:GetBool() then
		self:DrawParticles()
	else
		if IsValid( self.Emitter ) then
			self.Emitter:Finish()
		end
	end

end

function ENT:DrawParticles()

	if LocalPlayer():GetPos():WithinDistance(self:GetPos(), 2048) then
		if IsValid( self.Emitter ) then
			self.Emitter:Finish()
		end
		return
	end

	if self.NextParticle and RealTime() < self.NextParticle then return end

	self.NextParticle = RealTime() + .5

	if not IsValid( self.Emitter ) then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	local r = 256

	local prpos = VectorRand() * r
	prpos.z = 32
	local p = self.Emitter:Add( table.Random( self.SmokeMats ), self:GetPos() + prpos )

	if p then

		local gray = math.random(75, 200)
		p:SetColor(gray, gray, gray)
		p:SetStartAlpha(0)
		p:SetEndAlpha(50)
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

	end

end
