
-----------------------------------------------------
include( "shared.lua" )

include("cl_passenger.lua")



ENT.RenderGroup = RENDERGROUP_BOTH



local STATE_IDLE 		= 1

local STATE_ARRIVING 	= 2

local STATE_UNLOADING 	= 3

local STATE_LEAVING 	= 4





-- The length of the entire track, including before and after the stop station

ENT.TrackLength = 4000



-- Time lengths. The entire process will take the total of these three values

ENT.ArriveTime = 10

ENT.UnloadTime = 2

ENT.LeaveTime = 10



-- Control how fast the train slows to a stop and speeds up out of the station

ENT.ArriveSlowdown = 1.1

ENT.LeaveSpeedup = 1.1



ENT.MaxVolume = 0.7



ENT.EngineSoundPath = Sound("GModTower/lobby/monorail/engine.wav")



local Offsets = {

	Front =

	{

		Angle = Angle(0,-90,0),

		Position = Vector(0,93.5,36),

		LengthOffset = 240 -- Make sure the nose stops right at the entity

	},

	Middle =

	{

		Angle = Angle(0, -90, 0),

		Position = Vector(0,0,30),

		LengthOffset = 0

	},

	Rear =

	{

	Angle = Angle(0,90,0),

		Position = Vector(0,-88.7,36),

		LengthOffset = 0

	}

}



ENT.State = STATE_IDLE



function ENT:Initialize()

	self.Cars = {}

	self.EventTime = 0

	self.EventStartTime = 0

	self.MoveAmount = 0

end



function ENT:Think()



	-- Make sure the clientside models exist and all that fun stuff

	self:CheckModels()



	-- Think about our state logic

	self:StateThink()



	--if Location.GetGroup(LocalPlayer():Location()) == Location.GetGroup(self:Location()) then

		self:SoundThink()

	--elseif self.EngineSound then

		--self.EngineSound:Stop()

		--self.EngineSound = nil

	--end



	-- Don't do anything if we're idle, we shouldn't be at the station at all

	if self.State == STATE_IDLE then return end



	-- Base position

	local moveAmt = 0

	local percent = 0

	if self.State ~= STATE_UNLOADING then

		percent = 1-(CurTime() - self.EventTime ) / (self.EventStartTime - self.EventTime)

	end



	-- If we're leaving, make it the inverse so it goes farther

	if self.State == STATE_ARRIVING then

		percent = math.EaseInOut(percent, 0, self.ArriveSlowdown) - 1

	elseif self.State == STATE_LEAVING then

		percent = math.EaseInOut(percent, self.LeaveSpeedup, 0)

	end



	moveAmt = percent * self.TrackLength



	-- Just do this so we have poor man's velocity

	self.MoveAmount = moveAmt



	-- To keep track of the total length offset throughout the carts

	local lengthOffset = 0

	for i=1, self.CarCount do

		local car = self.Cars[i]

		local offsets = self:GetTrainOffsets(i)



		lengthOffset = lengthOffset + offsets.LengthOffset

		local posOffset = Vector(offsets.Position.x,offsets.Position.y, offsets.Position.z)

		local angOffset = self:GetAngles() + offsets.Angle

		posOffset:Rotate(angOffset)



		local pos = -self:GetAngles():Forward() * moveAmt + self:GetPos()

		pos = pos + self:GetAngles():Forward() * lengthOffset



		car:SetPos(pos + posOffset)

		car:SetAngles(angOffset)



		-- Move the general offset over by one car's length

		lengthOffset = lengthOffset + car.Size.y

	end

end



-- Thinkin' bout sound stuff

function ENT:SoundThink()

	if not self.EngineSound then

		self.EngineSound = self.EngineSound or CreateSound(self, self.EngineSoundPath)

		self.EngineSound:PlayEx(0, 100)

	end



	if self.State == STATE_IDLE then

		self.EngineSound:Stop()

	else self.EngineSound:PlayEx(0, 100) end



	local percent = 0

	if self.State ~= STATE_UNLOADING then

		percent = 1-(CurTime() - self.EventTime ) / (self.EventStartTime - self.EventTime)

	end



	-- If we're leaving, make it the inverse so it goes farther

	if self.State == STATE_ARRIVING then

		percent = math.EaseInOut(percent, 0, -0.1) - 1

	elseif self.State == STATE_LEAVING then

		percent = math.EaseInOut(percent, -0.1, 0)

	end





	self.EngineSound:ChangePitch( math.Clamp(math.abs(percent) * 200,0,255) , 0)



	local volume = math.Clamp((3000 - math.abs(self.MoveAmount)) / 3000,0,1)

	self.EngineSound:ChangeVolume(volume * self.MaxVolume, 0)

	self.EngineSound:SetSoundLevel(85)

end



function ENT:SetState( newState, nextEventTime )

	self.State = newState



	-- Quick hack to shut down model drawing when idle

	self:SetNoDrawModels(self.State == STATE_IDLE)



	self.EventStartTime = CurTime()

	self.EventTime = CurTime() + (nextEventTime or 0)

end



-- Manage our state and transitioning to the next

function ENT:StateThink()

	-- Arriving at the station with a cargo of peeps

	if self.State == STATE_ARRIVING then

		if self.EventTime < CurTime() then

			self:SetState(STATE_UNLOADING, self.UnloadTime)

		end

	end



	-- Unloading the people

	if self.State == STATE_UNLOADING then

		if self.EventTime < CurTime() then

			self:SetState(STATE_LEAVING, self.LeaveTime)

		end

	end



	-- Leaving the station

	if self.State == STATE_LEAVING then

		if self.EventTime < CurTime() then

			self:SetState(STATE_IDLE)



			-- If we had a new load of people while leaving, queue an arrival now

			if self.ArrivalQueued then

				self:QueueArrival()

			end

		end

	end



	-- If someone passively queued an arrival, act now

	if self.State == STATE_IDLE then

		if self.ArrivalQueued then

			self:QueueArrival()

		end



		-- Make triply sure they aren't being drawn

		self:SetNoDrawModels(true)

	end

end



function ENT:OnRemove()

	self:RemoveModels()

end



function ENT:QueueArrival()

	-- If we're idle then transition to arriving

	if self.State == STATE_IDLE then

		self:SetState(STATE_ARRIVING, self.ArriveTime)

		self.ArrivalQueued = false

	-- If it's too late to slap anyone on board, queue a new arrival

	elseif self.State == STATE_LEAVING then

		self.ArrivalQueued = true

	end

end



function ENT:GetTrainOffsets(index)

	if index == 1 then

		return Offsets.Front

	elseif index == self.CarCount then

		return Offsets.Rear

	end



	return Offsets.Middle

end



-- Return the train model based on its position in the track

function ENT:GetTrainModel( index )



	if index == 1 then

		return self.EngineModel

	elseif index == self.CarCount then

		return self.EngineModel

	end



	return self.PassengerModel

end



-- Check the validity of the clientside models, recreating/refreshing as necessary

function ENT:CheckModels()



	-- If our car count changed, regenerate the cars

	if #self.Cars ~= self.CarCount then

		self:RemoveModels()

	end



	for i=1, self.CarCount do

		if not IsValid(self.Cars[i]) then



			-- Create the clientside model

			local model =  ClientsideModel(self:GetTrainModel(i))

			-- Store their physical width too

			local min, max = model:GetRenderBounds()

			model.Size = max - min

			self.Cars[i] = model

		end

	end

end



-- Remove all clientside models

function ENT:RemoveModels()

	for i=1, table.Count(self.Cars) do

		if IsValid(self.Cars[i]) then self.Cars[i]:Remove() end



		self.Cars[i] = nil

	end

end



function ENT:SetNoDrawModels( bool )

	for i=1, table.Count(self.Cars) do

		if IsValid(self.Cars[i]) then

			self.Cars[i]:SetNoDraw(bool)

		end

	end

end
