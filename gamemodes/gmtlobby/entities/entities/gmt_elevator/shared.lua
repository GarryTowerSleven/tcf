
-----------------------------------------------------
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "GMT Elevator"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model("models/sunabouzu/elevator_door.mdl")
ENT.Guts 			= Model("models/sunabouzu/elevator_guts.mdl")

-- Offset the door from the center of the elevator
ENT.DoorOffset 			= Vector(-104, 0,0)

-- The width of the active area that teleports players
ENT.RoomWidth			= 192

-- How far in a player must walk in order to activate the elevator
ENT.ActivateDistance 	= 40

-- Time it takes to close the door
ENT.DoorMoveTime 		= 5

-- Delay before the door will close
ENT.ActivateDelayTime 	= 1

ENT.BOUNDSTYPE = {}
ENT.BOUNDSTYPE.ALL 		= 1
ENT.BOUNDSTYPE.ACTIVATE = 2

local FixAngs = {
	Vector( 7448.000000, 504.000000, -608.000000 ),
	Vector( 7448.000000, -503.000000, -608.000000 ),
	Vector( -2278.000000, 1591.000000, 14983.000000 ),
	Vector( -2278.000000, 967.000000, 14983.000000 )
}

ENT.angoffset = Angle(0,0,0)

function ENT:Initialize()

	if table.HasValue( FixAngs, self:GetPos() ) then self.angoffset = Angle( 0, 180, 0 ) end

	self:SetModel( self.Model )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetNoDraw(true)
	self:SetAngles(self:GetAngles() + self.angoffset)
	self:SetNWBool( "DoorState", true )
	self:GenerateBounds()

	local ent = ents.Create("prop_dynamic")
	ent:SetPos( self:GetPos() )
	ent:SetAngles( self:GetAngles() )
	ent:SetModel( self.Guts )
	ent:Spawn()
	ent:DrawShadow(false)

end

function ENT:GenerateBounds()
	-- Generate the full active bounds
	self.Bounds = {}
	local min = Vector(-self.RoomWidth/2, -self.RoomWidth/2, -10)
	local max = Vector(self.RoomWidth/2, self.RoomWidth/2, self.RoomWidth)

	if self.angoffset != Angle(0,0,0) then
		min = Vector(-self.RoomWidth/2, -self.RoomWidth/2, -10)
		max = Vector(self.RoomWidth/2, self.RoomWidth/2, self.RoomWidth)
	end

	self.Bounds[self.BOUNDSTYPE.ALL] = {}
	self.Bounds[self.BOUNDSTYPE.ALL].min = min
	self.Bounds[self.BOUNDSTYPE.ALL].max = max

	-- Now the activate bounds
	self.ActivateBounds = {}
	local min = min + Vector(self.ActivateDistance, 0, 0)
	self.Bounds[self.BOUNDSTYPE.ACTIVATE] = {}
	self.Bounds[self.BOUNDSTYPE.ACTIVATE].min = min
	self.Bounds[self.BOUNDSTYPE.ACTIVATE].max = max
end
