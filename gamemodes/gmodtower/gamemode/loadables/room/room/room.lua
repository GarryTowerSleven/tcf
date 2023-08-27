---------------------------------
local setmetatable = setmetatable
local getfenv = getfenv
local CurTime = CurTime
local _G = _G
local table = table
local CurTime = CurTime
local hook = hook
local ipairs = ipairs
local SQLLog = SQLLog
local tostring = tostring
local math = math
local ents = ents

include("entity.lua")
include("sql.lua")
include("reset.lua")
include("load.lua")

module( "Suite" )

local modenv = getfenv()

function New( pos1, pos2, refent )

	if !refent || !refent:IsValid() then
		Error("Loading room with invalid refent!")
	end

	_G.OrderVectors( pos1, pos2 )

	local o = setmetatable( {
		Id = Id,
		Owner = nil,
		RefEnt = refent,
		StartPos = pos2,
		EndPos = pos1,
		Middle = (pos1 + pos2) / 2,
		LastActive = CurTime(),
		ToAdd = {},
		StartEnts = {},
		Bans = {},
	}, { __index = modenv } )

	o.Id = table.insert( _G.GTowerRooms.Rooms, o )
	//o.LocationId = o.Id
	o.LocationId = refent:Location()

	refent:SetId( o.Id )
	o:SaveDefault()

	return o

end

function IsValid( self )
	return self.Owner && self.Owner:IsValid()
end

function CanRent( self )
	if self and self:IsValid() then
		if self.Owner.AFK then
			return true
		end
	end

	return !self:IsValid()
end

function SetLock( self, state )
	if self.Owner then
		self.Owner:SetNet( "RoomLock", state )
	end
end

function Lock( self )
	self:SetLock( true )
end

function Unlock( self )
	self:SetLock( false )
end

function CanManageDoor( self, ply )
	return self.Owner && (self.Owner:GetNet( "RoomLock" ) == false || ply == self.Owner || ply:IsAdmin() )
end

function SendToDoor( self, ply )
	for k,v in pairs( ents.FindByClass( 'func_suitepanel' ) ) do
		if !table.HasValue(GTowerRooms.SuitePanelPos, v:GetPos()) then continue end
		if v.RoomId == tonumber(self.Id) then
			ply:SafeTeleport( v:GetPos() + v:GetRight() * -75 + v:GetForward() * 48, nil, v:GetAngles() + Angle( 0, -90, 0 ) )
			ply:DropToFloor()
		end
	end
end

/*function Location( self )
	return self.Id
end*/

function BanPlayer( self, ply )
	if ( !ply or !ply:IsValid() ) then return end
	self.Bans[ ply:SteamID() ] = true

	local owner = self.Owner
	if ( !owner or !owner:IsValid() ) then return end

	ply:Msg2( T( "RoomBanFrom", owner:GetName() ) )
	owner:Msg2( T( "RoomBanPlayer", ply:GetName() ) )
end

function UnBanPlayer( self, ply )
	self.Bans[ ply:SteamID() ] = false
end

function UnBanAll( self )
	self.Bans = {}

	local owner = self.Owner
	if ( !owner or !owner:IsValid() ) then return end

	owner:Msg2( T("RoomClearedBans") )
end

function IsBanned( self, steamid )
	return self.Bans[ ply:SteamID() ] or false
end

local function CheckPlayerLocked( ply, room, group, owner )

	if room:CanManageDoor( ply ) then return end

	if group && group:HasPlayer( ply ) then return end

	if ply:GetSetting( "GTNoClip" ) || ply:IsStaff() || Friends.IsFriend( owner, ply ) then return end

	room.RemovePlayer( ply )

	local Name = ply:Name()
	local steamid = ply:SteamID()

	local ownerName = owner:Name()
	local ownerSteam = owner:SteamID()

	ply:Msg2( T( "RoomRemovedFrom", ownerName ) )
end

hook.Add( "RoomThink", "GRoomThink", function( ply )

	local room = ply:GetRoom()
	if !room then return end

	local owner = room.Owner
	if ( !owner or !owner:IsValid() ) then return end

	local players = room:GetPlayers()
	local group = ply:GetGroup()

	for _, v in ipairs( players ) do

		// Blocked
		if ( Friends.IsBlocked( ply, v ) ) then
			room.RemovePlayer( v )
			v:MsgT( "RoomKickedFrom", ply:GetName() )
		end

		// Locked
		if ( owner:GetNet( "RoomLock" ) ) then
			CheckPlayerLocked( v, room, group, ply )
		end

		// Bans
		if ( table.Count( room.Bans ) > 0 ) then
			if ( v:IsStaff() ) then return end

			if ( room.Bans[ v:SteamID() ] && room.Bans[ v:SteamID() ] == true ) then
				room.RemovePlayer( v )
				v:Msg2( T( "RoomBannedFrom", owner:GetName() ) )
				owner:Msg2( T( "RoomBannedPlayer", v:GetName() ) )
			end
		end

	end

end )
