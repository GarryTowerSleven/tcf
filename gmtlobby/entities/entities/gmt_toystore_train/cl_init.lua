
-----------------------------------------------------
include('shared.lua')

ENT.SmokeScale = 1.2
ENT.SmokeEjectVelocity = Vector( 0, 0, 110 ) -- The vertical velocity the smoke is ejected from the engine
ENT.SmokeOffset = Vector(6,0,6)

ENT.EngineModelPath  = Model("models/minitrains/loco/swloco007.mdl")
ENT.CarModelPath 	 = Model("models/minitrains/wagon/swwagon003.mdl")
ENT.CabooseModelPath = Model("models/minitrains/wagon/swwagon004.mdl")

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

		car:SetPos(pos)
		car:SetAngles(ang)

		-- If it's an engine car, draw some smoke
		if car:GetModel() == self.EngineModelPath then
			local posOffset = Vector(self.SmokeOffset.x, self.SmokeOffset.y, self.SmokeOffset.z)
			posOffset:Rotate(ang)

			self:SmokeThink( pos + posOffset )
		end
	end

	-- Add our train sound to the soundscape if it isnt already defined
	if self.TrainSoundscape and soundscape.IsDefined(self.TrainSoundscape) then
		if not self.ChooRuleName or not self.ChuggaRuleName then return end

		-- Add the chugga
		if not soundscape.HasRule(self.TrainSoundscape, self.ChuggaRuleName) then
			soundscape.AppendRuleDefinition(self.TrainSoundscape, self.LoopRule, self.ChuggaRuleName)
		end
		-- Choo choo
		if not soundscape.HasRule(self.TrainSoundscape, self.ChooRuleName ) then
			soundscape.AppendRuleDefinition(self.TrainSoundscape, self.TootRule, self.ChooRuleName )
		end
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
			self.Cars[i]:SetModelScale(0.45,0)
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

	if not self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	if not self.NextParticle then
		self.NextParticle = CurTime() + .001
	end

	if CurTime() > self.NextParticle then
		self.NextParticle = CurTime() + .001
	end

	local smokeScale = self.SmokeScale

	for i=1, 2 do

		if math.random( 3 ) > 1 then

			local particle = self.Emitter:Add( "particles/smokey", pos )
			if particle then
				particle:SetVelocity( (VectorRand() * 10 + self.SmokeEjectVelocity ) * smokeScale )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1.5, 2 ) )
				particle:SetStartAlpha( math.Rand( 100, 150 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( math.random( 0, smokeScale ) )
				particle:SetEndSize( math.random( 10, 15 ) * smokeScale )
				particle:SetRoll( math.Rand( -10, 10 ) )
				particle:SetRollDelta( math.Rand( -5, 5 ) )

				local dark = math.Rand( 100, 200 )
				particle:SetColor( dark, dark, dark )
				particle:SetAirResistance( 800 )
				particle:SetGravity( Vector( 0, 0, math.random( 150, 200 ) ) )
				particle:SetCollide( true )
				particle:SetBounce( 0.2 )
			end
		end
	end
end

function ENT:Draw()

end

function ENT:OnRemove()
	self:RemoveModels()
end
