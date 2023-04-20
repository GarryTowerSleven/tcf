---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

-- Let's get started
function ENT:Initialize()

	-- Set Model
	self:SetModel( "models/func_touchpanel/terminal04.mdl" )

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )

	self.Think = self.LookingRoomThink

	self:SetUseType(SIMPLE_USE)

	self:InitDoor()
	
end

function ENT:InitDoor()
	for _, v in ipairs( ents.FindInSphere( self.Entity:GetPos(), 75 ) ) do
		if (v:GetClass() == "func_door_rotating") then
			self.DoorEntity = v
			break
		end
	end
end

function ENT:GetDoor()
	return self.DoorEntity or nil
end

function ENT:LookingRoomThink()

	if !GTowerRooms then
		return
	end

	
	if Location.GetSuiteID(self:Location()) == 0 then
		if IsValid(self.JB) then
			self.JB:Remove()
		end

	else
		if !IsValid(self.JB) then
			self.JB = ents.Create("gmt_jukebox")
			self.JB:SetPos(self:GetPos() + self:GetForward() * 32)
			self.JB:Spawn()
			self.JB:SetSolid(SOLID_NONE)
		end
	end


	local NewRoomId =  GTowerRooms.ClosestRoom( self:GetPos() )

	if NewRoomId then
		self:SetId( NewRoomId )

		self.Think = EmptyFunction

		if GTowerRooms.DEBUG then Msg("Found room for: " .. tostring( self ) .. " to roomID: " .. tostring( self:Id() ) .. "\n") end
	end

	self:NextThink( CurTime() + 1.0 )

	return true
end

function ENT:Use( ply )
	local cur_x, cur_y = self:MakeEyeTrace( ply )
	self:UsePanel( ply, cur_x, cur_y )
end

function ENT:SetId( id )
	self.RoomId = id
	self:SetSkin( self.RoomId )

	local door = self:GetDoor()

	if ( door ) then
		door.Id = id
	end
end

function ENT:Id()
	return self.RoomId
end


function ENT:DoorFire(str, ti)
	local door = self:GetDoor()

	if ( door ) then
		door:Fire(str, "", ti)
		if ( str == "Lock" ) then
			door:Fire("close","")
		end
	end
end

function ENT:RoomUnload( room )
	self:CloseDoor()
end

local function Allow( owner, ply, Room )
	if !IsValid( ply ) || !IsValid( owner ) then return false end

	// admins always get access
	if ( ply:IsAdmin() ) then return true end

	if ( owner:GetNet( "RoomLock" ) && owner != ply ) then
		if Room:PlayerInRoom( ply ) then
			Suite.RemovePlayer( ply )
		end
		return false
	end
	return true

end

local function LockAllow( owner, ply, Room )

	if !IsValid( ply ) || !IsValid( owner ) then return false end

	// admins always get access
	if ( ply:IsAdmin() ) then return true end

	if ( owner != ply ) then return false end

	return true

end

function ENT:Think()
	local Room = GTowerRooms.Get( self:Id() )
	local owner = GTowerRooms.GetOwner(self:Id())

	for k,v in pairs(player.GetAll()) do
		Allow( owner, ply, Room )
	end

	
end

-- Use Terminal
function ENT:UsePanel( ply, cur_x, cur_y )
	local Room = GTowerRooms.Get( self:Id() )
	local owner = GTowerRooms.GetOwner(self:Id())

	if !Allow( owner, ply, Room ) then return end

	if ply._SuitePanelClick && ply._SuitePanelClick > CurTime() then
		return
	end

	ply._SuitePanelClick = CurTime() + 0.25

    if ( cur_x < 80 && cur_x > -70 && cur_y > -30 && cur_y < 160 ) then // Button 1: Open

        self.Entity:EmitSound( self.soundGranted )
		self:DoorFire("Open")

    elseif ( cur_x > 80 && cur_x < 240 && cur_y > -30 && cur_y < 160 ) then // Button 2: Close

        self.Entity:EmitSound( self.soundGranted )
		self:DoorFire("Close")

	elseif ( cur_x < -70 && cur_x > -240 && cur_y > -30 && cur_y < 60 ) then // Button 3: Lock

		if !LockAllow( owner, ply, Room ) then return end

        self.Entity:EmitSound( self.soundGranted )
		//GTowerRooms:RoomLock( self:Id(), true )
		self:DoorFire("Lock")
		owner:SetNet( "RoomLock", true )

	elseif ( cur_x < -70 && cur_x > -240 && cur_y > 70 && cur_y < 160 ) then // Button 4: Unlock

		if !LockAllow( owner, ply, Room ) then return end

        self.Entity:EmitSound( self.soundGranted )
		//GTowerRooms:RoomLock( self:Id(), false )
		self:DoorFire("Unlock")
		owner:SetNet( "RoomLock", false )

	end

end

function ENT:SetText( text )
	if !text || !isstring( text ) then return end
	self:SetNWString( "RoomName", text:sub( 1, 24 ) )
end

concommand.Add( "gmt_usesuitepanel", function(ply, command, args)

    if #args != 3 then return end

    local ent = ents.GetByIndex( tonumber( args[1] ) )

    if !IsValid(ent) || ent:GetClass() != "func_suitepanel" then return end

    ent:UsePanel( ply, tonumber( args[2] ), tonumber( args[3] ) )

end )
