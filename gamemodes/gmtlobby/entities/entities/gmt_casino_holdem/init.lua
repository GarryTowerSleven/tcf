AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_panel_board.lua" )
AddCSLuaFile( "cl_panel_player.lua" )

include( "shared.lua" )

function ENT:KeyValue(key, value)

	if key == "minbet" then
		self.DefaultMinBet = tonumber(value)
	end

	if key == "maxbet" then
		self.DefaultMaxBet = tonumber(value)
	end

end

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

    timer.Simple(1,function()
      self:SetupChairs()
    end)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		phys:Sleep()
	end

	self:SetMinBet(self.DefaultMinBet)
	self:SetMaxBet(self.DefaultMaxBet)

end

local function HandleRollercoasterAnimation( vehicle, player )
	return player:SelectWeightedSequence( ACT_GMOD_SIT_ROLLERCOASTER )
end

function ENT:SetupChairs()

	local one80vec = {
		"-50 60 0",
		"-55 30 0",
		"-60 0 0",
		"-55 -30 0",
		"-50 -60 0",
	}

	local one80ang = {
		"0 -20 0",
		"0 -10 0",
		"0 0 0",
		"0 10 0",
		"0 20 0",
	}

	local vec = {
		"50 -60 0",
		"55 -30 0",
		"60 0 0",
		"55 30 0",
		"50 60 0",
	}

	local ang = {
		"0 160 0",
		"0 170 0",
		"0 180 0",
		"0 -170 0",
		"0 -160 0",
	}

	self.TableChairsMdl = {}

	for k,v in pairs(vec) do
		// Chair Model
		self.chairMdl = ents.Create("prop_physics_multiplayer")
		self.chairMdl:SetModel("models/gmod_tower/aigik/casino_stool.mdl")

		if self:GetAngles().y == 180 then
			self.chairMdl:SetPos( self:GetPos() + Vector(one80vec[k]) )
		else
			self.chairMdl:SetPos( self:GetPos() + Vector(vec[k]) )
		end

		if self:GetAngles().y == 180 then
			self.chairMdl:SetAngles( Angle(one80ang[k]) )
		else
			self.chairMdl:SetAngles( Angle(ang[k]) )
		end

		self.chairMdl:PhysicsInit(SOLID_VPHYSICS)
		self.chairMdl:SetMoveType(MOVETYPE_NONE)
		self.chairMdl:SetSolid(SOLID_VPHYSICS)

		self.chairMdl:Spawn()
		self.chairMdl:Activate()
		self.chairMdl:SetParent(self)

		local phys = self.chairMdl:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
			phys:Sleep()
		end

		self.chairMdl:SetKeyValue( "minhealthdmg", "999999" )
		table.insert( self.TableChairsMdl, self.chairMdl )
	end

end

function ENT:Use(caller)
	caller:Msg2( "Poker is currently in development, check back later!", "cards" )
end

function ENT:SetupVehicles()

	self.TableChairs = {}

	for k,v in pairs(self.TableChairsMdl) do
		// Chair Vehicle
		self.chair = ents.Create("prop_vehicle_prisoner_pod")
		self.chair:SetModel("models/nova/airboat_seat.mdl")
		self.chair:SetKeyValue("vehiclescript","scripts/vehicles/prisoner_pod.txt")
		self.chair:SetParent(v)
		self.chair:SetPos( v:GetPos() + Vector(0,0,30) )

		self.chair:SetAngles( Angle(0,self:GetAngles().y+90,0) )

		self.chair:SetNotSolid(true)
		self.chair:SetNoDraw(true)
		self.chair:DrawShadow( false )

		self.chair.HandleAnimation = HandleRollercoasterAnimation
		--self.chair.bSlots = true

		self.chair:Spawn()
		self.chair:Activate()

		local phys = self.chair:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end

		if (phys:IsValid()) then
			phys:EnableMotion(false)
		end
		table.insert( self.TableChairs, self.chair )
	end

end
