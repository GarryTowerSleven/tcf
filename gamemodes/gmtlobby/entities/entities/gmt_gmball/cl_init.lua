
-----------------------------------------------------
include('shared.lua')

ENT.SmokeScale = 1.2
ENT.SmokeEjectVelocity = Vector( 0, 0, 110 ) -- The vertical velocity the smoke is ejected from the engine
ENT.SmokeOffset = Vector(6,0,6)

ENT.EngineModelPath  = Model("models/gmod_tower/ball.mdl")
ENT.CarModelPath 	 = Model("models/gmod_tower/ball.mdl")
ENT.CabooseModelPath = Model("models/gmod_tower/ball.mdl")

local ChuggaSound  = Sound( "GModTower/lobby/stores/train/track.wav" )
local ChooChooSound = Sound( "GModTower/lobby/stores/train/whistle.wav")

function ENT:Initialize()
	self.Cars = {}

	-- Generate the clientside train models
	self:CheckModels()
	self:DrawShadow(false)
end


function ENT:Think()
	self:CheckModels()

	-- Go through each car, finding its accordant position
	for i=1, self.CarCount do
		local car = self.Cars[i]

		-- Something is wrong, have CheckModels run another frame
		if not IsValid(car) then break end

		local pos, ang, num = self:GetPosAngle(i * -18, car.Num )

		-- Use to give a hint for the linear curve distance for performance
		car.Num = num

		ang:RotateAroundAxis(ang:Up(), 90)
		pos = pos - Vector(0,0,3)

		-- Just store the position for the first one for useful things
		if i == 1 then self.TrainPos = pos end

		local curPos = car:GetPos()
		local pos2 = LerpVector(5*FrameTime(),curPos,pos)

		car:SetPos(pos2)
		car:SetAngles(Angle(0,0,CurTime() * -400))

	end


end

-- Return the train model based on its position in the track
function ENT:GetTrainModel( index )

	if index == 1 then
		return self.EngineModelPath
	elseif index == self.CarCount then return
		self.CabooseModelPath
	end

	return self.CarModelPath
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
			self.Cars[i] = ClientsideModel(self:GetTrainModel(i))
			self.Cars[i]:SetModelScale(2,0)
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

function ENT:SmokeThink( pos )

end

function ENT:Draw()

end

function ENT:OnRemove()
	self:RemoveModels()
end
