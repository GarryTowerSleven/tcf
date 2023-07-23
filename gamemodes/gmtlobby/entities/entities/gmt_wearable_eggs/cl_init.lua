include('shared.lua')
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.EggCount = 3

local eggModelPath = Model("models/map_detail/toy_yoshiegg.mdl")

function ENT:Initialize()

end

function ENT:Draw()

end

local function CreateEgg(self, num)

	num = num or 0
	local egg = ClientsideModel(eggModelPath)

	egg:SetColor(colorutil.GetRandomColor())
	egg.CurPos = self:GetPos()
	egg.CurAngle = self:GetAngles()

	return egg

end

function ENT:CheckModels()

	-- Check all the eggs
	self.Eggs = self.Eggs or {}

	for i=1, self.EggCount do

		-- Make sure each egg is valid n' stuff
		if not IsValid(self.Eggs[i]) then
			self.Eggs[i] = CreateEgg(self, i)
		end
	end

end

function ENT:OnRemove()

	for _, egg in pairs( self.Eggs ) do
		if IsValid( egg ) then egg:Remove() end
	end

end

ENT.MoveSpeed = 12
ENT.AngleSpeed = 1

function ENT:Think()

	self:CheckModels()

	local ply = self:GetOwner()
	if !IsValid( ply ) then return end

	for i, egg in pairs( self.Eggs ) do

		if ply:InVehicle() then
			egg:SetNoDraw( true )
		else
			egg:SetNoDraw( false )
			local pos = ply:GetPos()
			local ang = ply:EyeAngles()
			local offset = ang:Forward() * ( i * -35 )
			offset.z = 3

			egg.GoalPos = pos + offset + Vector( 0, 0, math.sin( CurTime() * 1.2 ) * 2 )
			egg.GoalAngle = Angle( 0, ang.y - 90, ang.r )

			-- Do the splinin' here
			egg.CurPos = LerpVector( FrameTime() * self.MoveSpeed/i, egg.CurPos, egg.GoalPos )
			egg.CurAngle = LerpAngle( FrameTime() * self.AngleSpeed/i, egg.CurAngle, egg.GoalAngle )

			egg:SetPos( egg.CurPos )
			egg:SetAngles( egg.CurAngle )
		end

	end

end


--[[function ENT:Initialize()

	self.CurPos = self:GetPos()
	self.CurAngle = self:GetAngles()

	self.NextParticle = RealTime()
	self.TimeOffset = math.Rand( 0, 3.14 )

	self.Emitter = ParticleEmitter( self:GetPos() )

end

function ENT:Think()

	if !IsValid( self:GetOwner() ) || self:GetColor().a == 0 then return end

	local ply = self:GetOwner()
	local pos = util.GetHeadPos( ply )
	local ang = ply:EyeAngles()

	local offset = ( ang + Angle( 0, 40, 0 ) ):Right() * self.OffsetAmount

	self.GoalPos = pos + offset	+ Vector( 0, 0, math.sin( CurTime() * 1.2 ) * 4 )
	self.GoalAngle = Angle( 0, ang.y - 90, ang.r )

	//Do the splinin' here
	self.CurPos = LerpVector( FrameTime() * self.MoveSpeed, self.CurPos, self.GoalPos )
	self.CurAngle = LerpAngle( FrameTime() * self.AngleSpeed, self.CurAngle, self.GoalAngle )
	self:SetPos( self.CurPos )
	self:SetAngles( self.CurAngle )

end]]
