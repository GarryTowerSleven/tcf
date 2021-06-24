
-----------------------------------------------------
include('shared.lua')

ENT.StringLength = 100
ENT.StringWidth = 1
ENT.PlaneModelPath  = Model("models/map_detail/toystore_plane.mdl")
ENT.StringMaterial = Material("cable/rope")

ENT.PlaneVerticalOffset = 10
ENT.Speed = 200
ENT.SpinAngle = 0
function ENT:Initialize()
	self.Speed =  10

	-- Randomize their beginning spin angle
	self.SpinAngle = math.Rand(0,360)
end

function ENT:OnRemove()
	self:RemoveModels()
end

function ENT:Draw()
	self:DrawModel()
	if not IsValid(self.PlaneModel) then return end 
	render.SetMaterial(self.StringMaterial)

	local planePos = self.PlaneModel:GetPos() + self.PlaneModel:GetAngles():Up() * self.PlaneVerticalOffset
	render.DrawBeam(self:GetPos(), planePos, self.StringWidth, 0, self.StringLength/10 )
end

function ENT:Think()
	self:CheckModels()

	self.Speed = math.sin( UnPredictedCurTime() /10) * 200

	self.SpinAngle = self.SpinAngle + FrameTime() * self.Speed * 2
	local spinHeight = math.atan(self.Speed * math.pi/ 180) * 180 / math.pi

	local angle = Angle(spinHeight, self.SpinAngle, 0)
	angle:RotateAroundAxis(angle:Up(),-90)
	self.PlaneModel:SetAngles(angle)
	self.PlaneModel:SetPos( self:GetPos() + -angle:Up() * self.StringLength )

	self:SetRenderBounds(Vector(-self.StringLength,-self.StringLength,-self.StringLength), Vector(self.StringLength,self.StringLength,0))
end

-- Check the validity of the clientside models, recreating/refreshing as necessary
function ENT:CheckModels()

	self.PlaneModel = IsValid(self.PlaneModel) and self.PlaneModel or ClientsideModel(self.PlaneModelPath)
	self.PlaneModel:SetPos(self:GetPos() - Vector(0,0,self.StringLength))
end

-- Remove all clientside models
function ENT:RemoveModels()
	if IsValid(self.PlaneModel) then
		self.PlaneModel:Remove()
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
