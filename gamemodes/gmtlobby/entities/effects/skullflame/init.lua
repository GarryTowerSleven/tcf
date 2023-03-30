
function EFFECT:Init(data)
	local Pos = data:GetOrigin() + Vector(0, 0, 1)
	self.EndPos = Pos
	self.DieTime = RealTime() + 2
	self.StartPos = Pos + Vector(0, 0, 22500)
	self.EndPos = util.TraceLine({start=Pos, endpos=Pos + Vector(0, 0, -40000), mask=MASK_SOLID}).HitPos
	self:SetRenderBoundsWS(self.StartPos, self.EndPos, Vector(256, 256, 256))
	self.Emitter = ParticleEmitter(Pos)
	local emitter = self.Emitter
	emitter:SetNearClip(32, 48)

	local i = math.random(1,4)
	if i == 2 then i = math.random(3,4) end

	for i=1, 5 do
		local particle = emitter:Add("particles/flamelet3", Pos + Vector(math.random(-5,5),math.random(-5,5),math.random(-3,3)))
		particle:SetVelocity(Vector(math.random(-6,6),math.random(-6,6),math.random(15,40)))
		particle:SetDieTime(math.Rand(0.5, 0.6))
		particle:SetStartAlpha(math.Rand(220, 240))
		particle:SetStartSize(5)
		particle:SetEndSize(0)
		particle:SetRoll(math.Rand(0, 359))
		particle:SetRollDelta(math.Rand(-1, 1))
		particle:SetAirResistance(20)
	end


end

function EFFECT:Think()
	if self.DieTime < RealTime() then
		self.Emitter:Finish()
		return false
	end

	return true
end

local matBeam = Material("Effects/laser1")
local matGlow = Material("sprites/light_glow02_add")
local colBeam = Color(255, 180, 0)
function EFFECT:Render()
	local delta = self.DieTime - RealTime()
	local size

	if delta > 1 then
		size = 270 + (1 - delta) * 70
	else
		size = delta * 270
	end


end
