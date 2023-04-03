---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile("shared.lua")
AddCSLuaFile("room_maps.lua")
AddCSLuaFile("cl_closet.lua")
AddCSLuaFile("cl_party.lua")
//AddCSLuaFile("upgrades.lua")

module("GTowerRooms", package.seeall )

include("shared.lua")
include("sql.lua")
include("room_maps.lua")
include("concommand.lua")
include("hook.lua")
include("network.lua")
include("player.lua")
include("room/room.lua")
//include("upgrades.lua")

Rooms = Rooms or {}
AddingEntsRooms = AddingEntsRooms or {}

//The items that will be added in the default room
//Any item can be put more than once
DefaultItems = {
	"chair1",
	"barstool",
	"tvcabinet",
	"tv",
	"trunk",
	"bed",
}

SuitePanelPos = {
	Vector(4732.000000, -11127.599609, 4152.009766),
	Vector(4732.000000, -11511.599609, 4152.009766),
	Vector(4732.000000, -11895.599609, 4152.009766),
	Vector(4732.000000, -12279.599609, 4152.009766),
	Vector(4496.000000, -12507.599609, 4152.009766),
	Vector(4356.000000, -12071.599609, 4152.009766),
	Vector(4356.000000, -11687.599609, 4152.009766),
	Vector(4356.000000, -11303.599609, 4152.009766),
	Vector(4356.000000, -10919.599609, 4152.009766),
	Vector(2703.600098, -10364.000000, 4152.009766),
	Vector(2319.600098, -10364.000000, 4152.009766),
	Vector(1935.599976, -10364.000000, 4152.009766),
	Vector(2080.399902, -9987.990234, 4152.009766),
	Vector(2464.399902, -9987.990234, 4152.009766),
	Vector(2848.399902, -9987.990234, 4152.009766),
	Vector(4356.000000, -9223.629883, 4152.009766),
	Vector(4356.000000, -8839.629883, 4152.009766),
	Vector(4356.000000, -8455.629883, 4152.009766),
	Vector(4356.000000, -8071.629883, 4152.009766),
	Vector(4592.000000, -7855.629883, 4152.009766),
	Vector(4732.000000, -8279.629883, 4152.009766),
	Vector(4732.000000, -8663.629883, 4152.009766),
	Vector(4732.000000, -9047.629883, 4152.009766),
	Vector(4732.000000, -9431.629883, 4152.009766),
}

function Get( id )
	return Rooms[ id ]
end

function GetOwner( id )

	if !id then return end
	local Room = Get( id )

	if Room then
		return Room.Owner
	end

end

function OpenStore( ply )
	GTowerStore:OpenStore( ply, StoreId )
end

function ClosestRoom( vec )

	local Shortest = nil
    local GoRoom = nil

	for k, v in pairs( Rooms ) do

		local VecDistance = vec:Distance( v.Middle )

        if Shortest == nil || Shortest > VecDistance then

			Shortest = VecDistance
			GoRoom = k

		end

	end

	return GoRoom

end

hook.Add("InitPostEntity", "RoomsAddOtherEnts", function()

	local function OrderEntities( entlist )

		local EntMidPoint = Vector(0,0,0)
		local EntAngle = {}

		for _, v in pairs( entlist ) do
			EntMidPoint = EntMidPoint + v:GetPos()
		end

		EntMidPoint = EntMidPoint / #entlist

		for k, v in pairs( entlist ) do
			local AngDif = ( v:GetPos() - EntMidPoint ):Angle()

			EntAngle[ v ] = AngDif.y

			if EntAngle[ v ] < 0 then
				EntAngle[ v ] = EntAngle[ v ] + 360
			end

		end

		table.sort( entlist, function(a,b)
			return EntAngle[a] > EntAngle[b]
		end )

	end

	local MapTbl = GTowerRooms.RoomMapData[game.GetMap()] or GTowerRooms.RoomMapData["gmt_build0s2b"]

	if MapTbl then

		local EntList = ents.FindByClass( "gmt_roomloc" )

		OrderVectors( MapTbl.min, MapTbl.max )

		OrderEntities( EntList )

		for _, v in pairs( EntList ) do
			SafeCall( Suite.New, v:LocalToWorld( MapTbl.min ), v:LocalToWorld( MapTbl.max ), v )
		end

		if #EntList == 0 then
			MsgC( co_color2, "[Room] Could not find condos for entity: " .. MapTbl.refobj .. "\n")
		end

	end

end )

function VecInRoom( vec )

	for _, v in pairs( Rooms ) do
		if IsVecInRoom( v, vec ) then
			return v
		end
	end

end

function SendEntIDs( ply )

	umsg.Start("GRoom", ply)

		umsg.Char( 14 )

		local MaxIndex = table.maxn(GTowerRooms.Rooms)

		umsg.Char( MaxIndex )

		for i=1, MaxIndex do
			umsg.Short( Get( i ).RefEnt:EntIndex() )
		end

	umsg.End()

end

hook.Add("InvUniqueItem", "CheckInRoom", function( ply, id )

	local Room = ply:GetRoom()

	if Room then
		Room:UpdateRoomSaveData()
	end

	if ply._RoomSaveData then

		for _, v in pairs( ply._RoomSaveData ) do
			if v.InvItem == id then
				return true
			end
		end

	end

end )

/*hook.Add("PlayerCanHearPlayersVoice", "GMTRoomTalk", function(listener, talker)
	local group = talker:GetGroup() --Maybe i should add some check if groups module turned on?
	if group then return end

	local Room = Get(ClosestRoom( listener:GetPos() ))

	if !Room then
		return
	end

	if Location.Find(listener:GetPos()) == nil or Location.Find(talker:GetPos()) == nil or Room.Owner == nil then return end
	if Location.Find(listener:GetPos()) == Location.Find(talker:GetPos()) and Location.IsSuite(Location.Find(listener:GetPos())) and Room.Owner:GetSetting( 20 ) then
		return true
	end
end)*/

// 0.25 seconds for room precision, PlayerThink's 1 second is too slow for protecting suites
timer.Create( "GTowerRoomThink", 1, 0, function()
	for _, v in ipairs( player.GetAll() ) do
		if IsValid( v ) then
			hook.Call( "RoomThink", GAMEMODE, v )
		end
	end
end)

timer.Create( "AchiSuiteParty", 60.0, 0, function()
	for _, v in pairs( player.GetAll() ) do
		if !v:AchievementLoaded() then return end

		local Room = v:GetRoom()

		if Room then
			local Players = Room:GetPlayers()

			if #Players >= 5 then
				v:AddAchievement(  ACHIEVEMENTS.SUITEPARTY, 1 )
			end
		end
	end
end )

hook.Add( "PlayerAFK", "RoomAFK", function( ply, afk )
	if ( not IsValid( ply ) ) then return end
	if ( not afk ) then return end

	local Room = ply:GetRoom() or nil

	if Room then
		Room:Finish()

		ply:MsgT( "RoomAFKAway" )
	end
end )

function GetPanel( id )
	for _, ent in pairs( ents.FindByClass("func_suitepanel") ) do
		if ent.RoomId == id then
			return ent
		end
	end
end

function GetDoor( id )
	local panel = GetPanel( id )
	if panel then
		return panel:GetDoor() or nil
	end
end

concommand.Add( "gmt_useroomdoor", function( ply, cmd, args )
	if !args[1] || !tonumber(args[1]) || !IsValid(ply) || !Location.IsSuite( ply:Location() ) then return end

	// delay
	if ply._LastDoorUse && ply._LastDoorUse > CurTime() then return end

	-- make sure door is valid
	local door = ents.GetByIndex(tonumber(args[1]))

	if !door || !IsValid(door) || door:GetClass() != "func_door_rotating" || !Location.IsSuite( door:Location() ) then return end
	if !door.Id then return end

	-- room check
	local RoomID = door.Id

	local Room = Rooms[RoomID]
	if !Room || !Room.Owner then return end

	-- dist check
	if door:GetPos():Distance( ply:GetPos() ) > 100 then return end

	if door:GetSaveTable().m_toggle_state == 0 then
		door:Fire( "Close" )
	else
		door:Fire( "Open" )
	end

	ply._LastDoorUse = CurTime() + .5
end )

util.AddNetworkString( "SendSuiteName" )
net.Receive( "SendSuiteName", function( len, ply )
	if !IsValid(ply) || !ply:GetNet( "RoomID" ) then return end

	local Panel = GetPanel( ply:GetNet( "RoomID" ) )

	if Panel then
		local name = net.ReadString()

		Panel:SetText( tostring(name) or "oboy" )
	end
end )