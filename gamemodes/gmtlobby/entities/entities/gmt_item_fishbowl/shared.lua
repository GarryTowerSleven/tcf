
-----------------------------------------------------
AddCSLuaFile("shared.lua")

ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName		= "Fish Bowl"

ENT.Model		= Model( "models/map_detail/toystore_fishbowl.mdl")
ENT.FishModel 	= Model("models/map_detail/toystore_fish.mdl")

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel(self.Model)
	self:PhysicsInitBox(self:GetModelBounds())
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:GetPhysicsObject():EnableMotion(false)
	self:SetUseType(SIMPLE_USE)

end

if SERVER then return end 

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.FishSpeed = 0.25


ENT.LastThinkTime = 0
ENT.LastPos = Vector()
ENT.FishPos = Vector()

function ENT:Initialize()
	-- Random offset so the fish aren't in the same exact position everywhere
	self.RandomOffset = math.random(0, 100)
end

function ENT:SetFishPos(t, last)
	
	-- Set either the last fish pos variable or the current one
	local var = last and self.LastPos or self.FishPos 

	var.x = (2+math.cos(2*t))*math.cos(3*t) * 2
	var.y = (2+math.cos(2*t))*math.sin(3*t) * 2
	var.z = math.sin(4*t) * 2
end

local lastPos = Vector()
function ENT:Draw()
	self:DrawModel()

	-- Draw is only called when it's being drawn, which is ideal
	-- However it's called multiple times per frame, so let's not do that
	if self.LastThinkTime >= UnPredictedCurTime() then return end 
	self.LastThinkTime = UnPredictedCurTime() 

	self:CheckModel()

	-- Fish movement
	local t = UnPredictedCurTime() * self.FishSpeed + self.RandomOffset

	-- Get the fish's position at two different times to get the angle between
	self:SetFishPos(t)
	self:SetFishPos(t-0.000001, true)

	-- Orient the fish correctly and set its position/orientation
	local ang = (self.LastPos - self.FishPos):Angle()
	ang:RotateAroundAxis(ang:Up(), -90)
	self.Fish:SetPos(self:GetPos() + self.FishPos)
	self.Fish:SetAngles(ang)

end

function ENT:CheckModel()
	self.Fish = IsValid(self.Fish) and self.Fish or ClientsideModel(self.FishModel)
end

function ENT:OnRemove()
	if IsValid(self.Fish) then
		self.Fish:Remove()
	end
end