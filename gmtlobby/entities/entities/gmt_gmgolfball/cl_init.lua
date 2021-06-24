
-----------------------------------------------------
include('shared.lua')

ENT.SmokeScale = 1.2
ENT.SmokeEjectVelocity = Vector( 0, 0, 110 ) -- The vertical velocity the smoke is ejected from the engine
ENT.SmokeOffset = Vector(6,0,6)

ENT.EngineModelPath  = Model("models/sunabouzu/golf_ball.mdl")
ENT.CarModelPath 	 = Model("models/sunabouzu/golf_ball.mdl")
ENT.CabooseModelPath = Model("models/sunabouzu/golf_ball.mdl")

ENT.LastNum = 0

local ChuggaSound  = Sound( "GModTower/lobby/stores/train/track.wav" )
local ChooChooSound = Sound( "GModTower/lobby/stores/train/whistle.wav")

function ENT:Initialize()
	self.Cars = {}

	-- Generate the clientside train models
	self:CheckModels()
	self:DrawShadow(false)
end

function ENT:DrawSmokeParticles( vel, color )

	if not self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end
	self.HIOModel.LastParticlePos = self.HIOModel.LastParticlePos or self.HIOModel:GetPos()
	local vDist = self.HIOModel:GetPos() - self.HIOModel.LastParticlePos
	local Length = vDist:Length()
	local vNorm = vDist:GetNormalized()

	for i = 0, Length, 8 do

		self.HIOModel.LastParticlePos = self.HIOModel.LastParticlePos + vNorm * 8

		if math.random( 3 ) > 1 then

			local particle = self.Emitter:Add( "particles/smokey", self.HIOModel.LastParticlePos )
			particle:SetVelocity( VectorRand() * 40 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 1.0, 1.5 ) )
			particle:SetStartAlpha( math.Rand( 100, 150 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.random( 2, 5 ) )
			particle:SetEndSize( math.random( 20, 35 ) )

			local dark = math.Rand( 100, 200 )
			particle:SetColor( dark, dark, dark )
			particle:SetAirResistance( 50 )
			particle:SetGravity( Vector( 0, 0, math.random( -50, 50 ) ) )
			particle:SetCollide( true )
			particle:SetBounce( 0.2 )

		end

		self.Emitter:SetPos( self.HIOModel:GetPos() )

	end

end

function ENT:DoEffects(num)

	if num == 5 && self.LastNum != 5 then
		self:EmitSound( self.SwingSound, 65, math.random(90,110) )
	end

	if num == 57 && self.LastNum != 57 then

		if IsValid(self.HIOModel) then
			self.HIOModel:Remove()
			self.HIOModel = nil
		end

		self.HIOModel = nil

		self:EmitSound( self.CupSound, 65, math.random(90,110) )

		self.HIOTime = CurTime()

	end

	self.LastNum = num

end

local HIOStartPos = Vector(7068.599609375, -5543.7153320313, -886.65618896484)

function ENT:Think()

	if LocalPlayer().GLocation != 28 && LocalPlayer().GLocation != 55 && LocalPlayer().GLocation != 54 then
		if LocalPlayer().FixedBall then return end
		LocalPlayer().FixedBall = true

		self:CheckModels()

		for i=1, self.CarCount do
			local car = self.Cars[i]
			if IsValid(car) then
				car:SetPos(HIOStartPos)
			end
		end

		return
	end

	if CurTime()-(self.HIOTime or 0) < 2 then

		if !self.HIOModel then
			self.HIOModel = ClientsideModel( self.EngineModelPath )
			self.HIOModel:SetPos(HIOStartPos)
			self.HIOModel:SetColor(clr)

			local edata = EffectData()
				edata:SetOrigin( self.HIOModel:GetPos() + Vector( 0, 0, 8 ) )
				edata:SetEntity( self )
				edata:SetNormal( Vector( 0, 0, 0 ) )
			util.Effect( "golfholeinone", edata, true, true )

		end

			if IsValid(self.HIOModel) then
				self:DrawSmokeParticles( 25, self.HIOModel:GetClass() )
				self.HIOModel:SetPos( self.HIOModel:GetPos() + Vector(0,0, FrameTime() * 125 ) )
			end

	else
		if IsValid(self.HIOModel) then
			local eff = EffectData()
				eff:SetOrigin( self.HIOModel:GetPos() )
				eff:SetEntity( self.HIOModel )
				local color = self.HIOModel:GetColor()
				eff:SetStart( Vector( color.r, color.g, color.b ) )
			util.Effect( "golffirework", eff, true, true )
			self.HIOModel:Remove()
			self.HIOModel = nil
		end
	end

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

		car:SetPos(pos)
		car:SetAngles(Angle(CurTime() * -1400,0,0))

		local num

	for k=1, #self.Curve.KeyPoints do
		if self.Curve.KeyPoints[k].TotalDistance > self:GetDistance() then
			num = k
			self:DoEffects(k)
			break
		end
	end

		local colors = {
			Color( 200, 0, 0 ),
			Color( 0, 200, 0 ),
			Color( 0, 0, 200 ),
			Color( 200, 200, 0 ),
			Color( 0, 200, 200 ),
			Color( 255, 255, 255 )
		}

		if pos.z < -895.96875 then
			local clr = table.Random(colors)
			self.CurCarColor = clr
			car:SetColor( clr )
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
			self.Cars[i]:SetModelScale(1,0)
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
