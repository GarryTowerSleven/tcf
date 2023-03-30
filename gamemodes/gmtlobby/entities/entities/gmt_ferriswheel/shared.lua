ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Ferris Wheel"
ENT.Author			= "Foohy"
ENT.Information		= "It spins around"
ENT.Category		= "Foohy"

ENT.Spawnable		= false
ENT.AdminSpawnable	= true

ENT.Model			= Model("models/gmod_tower/ferriswheel_support.mdl")

---
-- Ride specific information here
---
-- The number of spokes on the ferris wheel
ENT.CarriageCount = 20

-- The time it takes to complete one whole spin-stop cycle
ENT.CycleTime = 300

-- How many times to spin around before stopping
ENT.SpinCount = 3

-- The ratio of time to turning vs stopped.
-- For example, 0.75 would be 75% of the time the ferris wheel is spinning
ENT.Distribution = 0.925


-- Offsets
ENT.WheelRadius = 615
ENT.WheelCenter = Vector(0,0,0)
ENT.CarriageOffset = Vector(56.0,0,0)

function ENT:GetBottomCarriage(rotation)
	rotation = rotation or self:GetCurrentRotation()

	-- The angle of one single 'segment' of the wheel
	local segmentAngle = 360 / self.CarriageCount

	-- Make it so the center of the bottom is the midpoint
	rotation = rotation - segmentAngle*0.5 + 270

	-- Make sure it's normalized just in case
	rotation = rotation % 360

	-- This is the current carriage
	return math.floor(rotation / (self.CarriageCount-2))+1
end

function ENT:GetCarPosAng(num, rotation, carriageOffset )
	local ang = (num / self.CarriageCount) * math.pi * 2 - (rotation * math.pi / 180)
	local pos = Vector(0,math.cos(ang), math.sin(ang)) * self.WheelRadius + (carriageOffset or Vector(0))
	pos:Rotate(self:GetAngles())


	local carAngle = self:GetAngles()
	carAngle:RotateAroundAxis(carAngle:Forward(), 0)

	return self:GetPos() + self.WheelCenter + pos, carAngle
end

-- Code the stuff here since it's all dependent on shared stuff ANYWAY
function ENT:GetCurrentRotation()
	local time = UnPredictedCurTime()

	-- The angle of one single 'segment' of the wheel
	local segmentAngle = 360 / self.CarriageCount

	-- The percentage of time we are through the whole cycle. Counts 0 to 1
	local waitPerc = (time % self.CycleTime) / self.CycleTime

	-- The angle offset of the current carriage to stop at
	local currentStopCarriage = math.floor(time / self.CycleTime) * (segmentAngle)
	local nextStopCarriage = currentStopCarriage + segmentAngle

	-- Keep this normalized within 360
	nextStopCarriage = nextStopCarriage % 360

	-- If the percent is past a certain threshold, we're in the 'idle' mode
	local IsWaitRotation = waitPerc > self.Distribution

	if IsWaitRotation then return nextStopCarriage end

	-- If we're not idle, spin smoothly around toward the next carriage
	return math.EaseInOut(waitPerc*(1/self.Distribution), 0.2, 0.2) * 360 * self.SpinCount + currentStopCarriage + Lerp(waitPerc*(1/self.Distribution), 0, segmentAngle)
end

function TranslateToPlayerModel( model )

	if model == "models/player/urban.mbl" then
		return "models/player/urban.mdl"
	end

	if model == "models/killingfloor/haroldlott.mdl" then
		return "models/player/haroldlott.mdl"
	end

	model = string.Replace( model, "models/humans/", "models/" )
	model = string.Replace( model, "models/", "models/" )

	/*if !string.find( model, "models/player/" ) then
		model = string.Replace( model, "models/", "models/player/" )
	end*/

	return model

end

local meta = FindMetaTable( "Player" )
if !meta then
	return
end

function meta:SetNoDrawAll( bool )

	self:SetNoDraw( bool )
	self:DrawShadow( bool )
	self._NoDraw = bool

	-- Hide weapons
	local weapon = self:GetActiveWeapon()
	if IsValid( weapon ) then
		weapon:SetNoDraw( bool )
	end

	-- Wearables (hats, etc.)
	if self.CosmeticEquipment then
		for k,v in pairs( self.CosmeticEquipment ) do
			if IsValid( v ) then
				v:SetNoDraw( bool )
				v:DrawShadow( bool )
			end
		end
	end

end

function meta:GetTranslatedModel()
	return util.TranslateToPlayerModel( self:GetModel() )
end

function meta:SetPlayerProperties( ply )
	if !IsValid( ply ) then return end

	if !self.GetPlayerColor then
		self.GetPlayerColor = function() return ply:GetPlayerColor() end
	end

	self:SetBodygroup( ply:GetBodygroup(1), 1 )
	self:SetMaterial( ply:GetMaterial() )
	self:SetSkin( ply:GetSkin() or 1 )

	--[[if self.MinecraftMat then
		self:SetMaterial( self.MinecraftMat )
	end]]
end

function meta:ResetSpeeds()
	if IsValid( self.TakeOn ) then
		self:SetWalkSpeed( 550 )
	else
		self:SetWalkSpeed( 200 )
	end
	self:SetRunSpeed( 320 )
	self:SetCanWalk( true )
end

function meta:SetCanMove( bool )
	self.CanMove = bool
	if bool then
		self:ResetSpeeds()
		self:SetJumpPower( 200 )
	else
		self:SetWalkSpeed(1)
		self:SetRunSpeed(1)
		self:SetCanWalk(false)
		self:SetJumpPower( 0 )
	end
end
