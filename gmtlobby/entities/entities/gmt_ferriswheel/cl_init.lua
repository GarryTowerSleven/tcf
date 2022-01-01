include( "shared.lua" )

local wheelModelPath = Model("models/gmod_tower/ferriswheel_wheel.mdl")
local carriageModelPath = Model("models/gmod_tower/ferriswheel_carriage.mdl")

ENT.CarriageColor1 = Color(255,255,255)
ENT.CarriageColor2 = Color(66, 111, 193)
ENT.SwingPower = 0.07
ENT.SwingFrequency = 1.8
ENT.SwingFriction = 0.17

ENT.RefreshInterval = 10 -- Interval to do a full update of passengers
ENT.SeatsPerCarriage = 2 -- Support for more exists only on the client for now

ENT.Passengers = ENT.Passengers or {}

local function GetCarPosAng(self, num, rotation, carriageOffset )
	local ang = (num / #self.Carriages) * math.pi * 2 - (rotation * math.pi / 180)
	local pos = Vector(0,math.cos(ang), math.sin(ang)) * self.WheelRadius + (carriageOffset or Vector(0))
	pos:Rotate(self:GetAngles())


	local carAngle = self:GetAngles()
	carAngle:RotateAroundAxis(carAngle:Forward(), 0)

	return self:GetPos() + self.WheelCenter + pos, carAngle
end

-- Utility function for creating fake client models as needed
local function GetFakePlayer(ply)
	if IsValid(ply.FerrisFakePlayer) then return true end
	ply.FerrisFakePlayer = ClientsidePlayer(ply)

	local seq = "sit_rollercoaster"
	ply.FerrisFakePlayer:SetSequence( seq )

	return IsValid(ply.FerrisFakePlayer)
end

-- Our table structure is one big list of players, but players of the same cart are close together
-- The 2nd carriage of a ferris wheel that holds 2 per carriage would be at indices 3 and 4
-- Arguments: (1) The carriage number, (2) total seats per carriage, (3) seat index within the carriage
local function ToPlayerIndex( carriageIndex, seatsPerCarriage, seatIndex)
	return (carriageIndex) * seatsPerCarriage - (seatsPerCarriage-1) + (seatIndex or 0)
end

-- Given a player's index, find the index of the corresponding carriage they're in
-- Arguments: (1) Player index within the passenger list, (2) Seats per carriage
local function ToCarriageIndex(playerIndex, seatsPerCarriage)
	return math.floor((playerIndex-1) / seatsPerCarriage) + 1
end

function ENT:Initialize()

	self.ToRemove = {}
	self.Passengers = {}
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	self:PositionCarriages()

	if not self.NextUpdateTime or CurTime() > self.NextUpdateTime then
		self.NextUpdateTime = CurTime() + self.RefreshInterval

		self:RefreshPlayerList()
	end
end


function ENT:OnRemove()
	-- Remove all the models when we are removed
	self:RemoveModels()

	-- Safely remove the players
	for k, ply in pairs( self.Passengers ) do
		-- If they're no longer valid/riding, fuck em
		if IsValid(ply) then

			-- Remove their client model
			if IsValid(ply.FerrisFakePlayer) then
				ply.FerrisFakePlayer:Remove()
			end

			-- Set them to visible
			ply:SetNoDrawAll(false)
		end
	end
end

local function GetSwingAngle(period, amplitude, time)
	time = time or UnPredictedCurTime()
	return  math.sin(period * time) * amplitude
end
local function GetSwingSpeed(period, amplitude, time)
	time = time or UnPredictedCurTime()
	return  math.cos(period * time) * amplitude
end
local function GetSwingDirection(period, time)
	time = time or UnPredictedCurTime()
	return math.cos(period * time) <= 0 and -1 or 1
end

function ENT:UpdatePassengerModel(ply, car, dir)
	if not GetFakePlayer(ply) then return end

	local viewOffset = Vector(-self.CarriageOffset.x, 35 * dir, -85)

	viewOffset:Rotate(car:GetAngles())

	local ang = car:GetAngles()
	ang:RotateAroundAxis(ang:Up(), dir * -90)

	-- Hide the model if we shouldnt' draw it
	ply.FerrisFakePlayer:Get():SetNoDraw(not ply.FerrisFakePlayer:ShouldDraw())

	ply.FerrisFakePlayer:Draw(car:GetPos() + viewOffset, ang )

	--playerModel:DrawPlayerName(car:GetPos() + viewOffset )

end

function ENT:PositionCarriages()
	-- Make sure all our models are valid always forever no take backsies
	self:CheckModels()
	self:CheckPlayers()

	local CurrentRotation = self:GetCurrentRotation()

	-- Go through each carriage and make sure their position is ya'll good
	for num, v in pairs( self.Carriages ) do
		local pos, ang = self:GetCarPosAng(num, CurrentRotation, self.CarriageOffset)

		local startIndex = ToPlayerIndex(num, self.SeatsPerCarriage )

		-- Go through the seat's passengers
		for i=startIndex, startIndex + self.SeatsPerCarriage-1 do
			local ply = self.Passengers[i]
			if not IsValid(ply) then continue end

			-- Store the player's seat direction
			-- TODO: Add support for more than 2 seat positions
			local dir = ply:GetNWBool("FerriswheelSeat") and 1 or -1

			-- Retrieve their eye angles and compare to the last frame
			local eyeAng = ply:EyeAngles()
			ply.LastViewPitch = ply.LastViewPitch or eyeAng.p
			local delta = ply.LastViewPitch - eyeAng.p
			v.SwingAmplitude = v.SwingAmplitude + delta*v.SwingDirection*dir*self.SwingPower

			-- Store the pitch for the next frame's delta
			ply.LastViewPitch = eyeAng.p

		end

		-- If we've gotta swing, do the tango
		--if v.SwingAmplitude > 0 then

			v.SwingAmplitude = Lerp(FrameTime() * self.SwingFriction, v.SwingAmplitude, 0)
			v.SwingAngle = GetSwingAngle(self.SwingFrequency, v.SwingAmplitude)
			v.SwingDirection = GetSwingDirection(self.SwingFrequency)

			-- Rotate the carriage to take into account the swing
			ang:RotateAroundAxis(ang:Forward(), v.SwingAngle)
		--end

		v:SetPos(pos)
		v:SetAngles(ang)

		-- Now that we set the car angles, go through the player list and tell em to update
		for i=startIndex, startIndex + self.SeatsPerCarriage do
			local ply = self.Passengers[i]
			if not IsValid(ply) then continue end

			-- First, let's set their fake client's position
			self:UpdatePassengerModel(ply, v, ply:GetNWBool("FerriswheelSeat") and -1 or 1)
		end
	end

	-- Rotate the wheel
	local angs = self:GetAngles()
	angs:RotateAroundAxis(angs:Right(), 90)
	angs:RotateAroundAxis(angs:Up(),CurrentRotation)

	self.Wheel:SetAngles(angs)
end

-- Check if all of our players are valid
function ENT:CheckPlayers()

	-- Loop through each carriage
	local updateRequired = false
	for k, ply in pairs( self.Passengers ) do

		-- If they're no longer valid/riding, fuck em
		if not IsValid(ply) or ply:GetOwner() ~= self then

			-- Unhide the player if they exist
			if IsValid(ply) then
				ply:SetNoDrawAll(false)
			end

			-- Remove the fake player object
			if IsValid(ply.FerrisFakePlayer) then
				ply.FerrisFakePlayer:Remove()
			end

			-- Kick em out
			self.Passengers[k] = nil
			updateRequired = true
			continue
		end

		-- Hide the REAL player
		ply:SetNoDrawAll(true)

		-- Move onto choosing their car index
		local num = ply:GetNWInt("FerriswheelCarriage")
		local seat = ply:GetNWBool("FerriswheelSeat")

		local car = self.Carriages[num]
		if not IsValid(car) then continue end
	end

	-- If a player was removed, we need to call a full update
	if updateRequired then
		self:RefreshPlayerList()
	end
end

-- Called when it's time to update the user list, adding or removing users as necessary
function ENT:RefreshPlayerList()
	-- Clear all passenger information
	self.Passengers = {}

	for _, ply in pairs( player.GetAll() ) do

		-- Make sure the player is one of our passengers
		if not IsValid(ply) or ply:GetOwner() ~= self then continue end

		-- Retrieve some info about their placement on the wheel
		local num = ply:GetNWInt("FerriswheelCarriage")
		local seat = ply:GetNWBool("FerriswheelSeat") == true and 0 or 1 -- Their seat index within the carriage

		if num < 1 or num > self.CarriageCount then continue end

		-- Our table structure is one big list of players, but players of the same cart are close together
		-- The 2nd carriage of a ferris wheel that holds 2 per carriage would be at indices 3 and 4
		local index = ToPlayerIndex(num, self.SeatsPerCarriage, seat)

		-- This is a new person in this car, wowzerss
		if self.Passengers[index] ~= ply then
			self.Passengers[index] = ply
		end
	end
end

local function CreateCarriage(self, num)
	num = num or 0
	local car = ClientsideModel(carriageModelPath)

	--car:SetColor(HSVToColor(num * 720 / self.CarriageCount, 1, 1))
	car:SetColor(num % 2 == 0 and self.CarriageColor1 or self.CarriageColor2)
	car.SwingAngle = 0
	car.SwingAmplitude = 0
	car.SwingDirection = 0

	return car

end

local function CreateWheel(self)
	local wheel = ClientsideModel(wheelModelPath)
	local angs = self:GetAngles()
	angs:RotateAroundAxis(angs:Right(), 90)

	local pos = self:GetPos() + self.WheelCenter

	wheel:SetPos(pos)
	wheel:SetAngles(angs)
	wheel:SetParent(self)

	-- Deluxify the wheel.
	wheel:SetSubMaterial( 1, "models/gmod_tower/ferriswheel/ferriswheel_lights_d" )

	return wheel
end

function ENT:CheckModels()
	-- Make sure the main wheel is in tact
	self.Wheel = IsValid(self.Wheel) and self.Wheel or CreateWheel(self)

	-- Check all the carriages as well
	local shouldUpdate = false
	self.Carriages = self.Carriages or {}
	for i=1, self.CarriageCount do

		-- Make sure each carriage is valid n' stuff
		if not IsValid(self.Carriages[i]) then
			shouldUpdate = true
			self.Carriages[i] = CreateCarriage(self, i)
		end
	end

	if shouldUpdate and self.RefreshUserList then
		self:RefreshUserList()
	end
end

function ENT:RemoveModels()
	if IsValid( self.Wheel ) then self.Wheel:Remove() end

	for _, v in pairs( self.Carriages ) do
		if IsValid(v) then v:Remove() end
	end

	self.Carriages = {}
end

net.Receive("FerrisWheelPlayerAdded", function()

	local self = net.ReadEntity()
	local ply = net.ReadEntity()
	local carriageNumber = net.ReadUInt(8)
	local seat = net.ReadUInt(1)

	if not IsValid(self) or not self:GetClass() == "gmt_ferriswheel" then return end

	-- Force update the local data to reflect what was sent
	if IsValid(ply) then
		ply:SetNWInt("FerriswheelCarriage", carriageNumber)
		ply:SetNWBool("FerriswheelSeat", seat == 1)
		ply:SetOwner(self)
	end

	self:RefreshPlayerList()

end )

local view = {}
local function CalculateWheelView(ply, pos, ang, fov, nearz, farz )
	local wheel = ply:GetOwner()

	if not IsValid(wheel) or wheel:GetClass() ~= "gmt_ferriswheel" then return end

	local num = ply:GetNWInt("FerriswheelCarriage")
	local seat = ply:GetNWBool("FerriswheelSeat")

	-- Retrieve the carriage
	local car = wheel.Carriages[num]
	if not IsValid(car) then return end

	local viewOffset = Vector(0, seat and -35 or 35, -40)
	viewOffset:Rotate(Angle(0,0,GetSwingAngle(wheel.SwingFrequency, car.SwingAmplitude or 0)))
	local pos = wheel:GetCarPosAng(num, wheel:GetCurrentRotation(), viewOffset)

	view.origin = pos

	-- If they're third person, move the camera according to how it usually would
	if ply.ThirdPerson then
		view.origin = view.origin - ang:Forward() * ThirdPerson.Dist:GetInt()
	end

	return view
end

hook.Add("PostCalcView", "FerrisWheelCamera", function(ply, pos, ang, fov, nearZ, farZ )
	if ply.ThirdPerson then
		return CalculateWheelView(ply, pos, ang, fov, nearz, farz )
	end
end )

hook.Add("CalcView", "FerrisWheelCamera",function(ply, pos, ang, fov, nearZ, farZ )
	return CalculateWheelView(ply, pos, ang, fov, nearz, farz )
end)

local function SafeRemoveClientModel(ply)
	if ply == LocalPlayer() then return end
	if ply and IsValid(ply.FerrisWheelPlayerModel) then
		ply.FerrisWheelPlayerModel:Remove()
		ply.FerrisWheelPlayerModel = nil
	end
end
