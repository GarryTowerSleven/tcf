module("GTowerRooms", package.seeall )

DEBUG = false
StoreId = 1
NPCClassName = "gmt_npc_roomlady"
NPCMaxTalkDistance = 1024

PartyCost = 250

function CanManagePanel( room, ply )

	if not room then return false end

	local canuse = room.RefEnt and ply == room.RefEnt:GetOwner()
	if ply:IsAdmin() then return true, not canuse end -- Admins can always use panels.

	return canuse

end

function PositionInRoom( pos )

	for k, room in pairs( Rooms ) do

		if room.EndPos && room.StartPos then
			if IsVecInRoom( room, pos ) then
				return k
			end
		end

	end

	return nil
end

function IsVecInRoom( roomtable, vec )
	return PosInBox( vec, roomtable.EndPos, roomtable.StartPos )
end

function PosInBox( pos, min, max )
	return pos.x > min.x and pos.y > min.y and pos.z > min.z and
           pos.x < max.x and pos.y < max.y and pos.z < max.z
end

function RecvPlayerRoom(ply, name, old, new)
	if new > 0 then
		ReceiveOwner(ply, new)
	end
end

function GetCondoDoor( condoid )
	for k,v in pairs( ents.FindByClass("gmt_condo_door") ) do
		if v:GetNWInt("CondoID", 0) == condoid then
			return v
		end
	end

	return nil
end

function SetupLocations()
	local data = GTowerRooms.RoomMapData[ game.GetMap() ]
	local objs = ents.FindByClass( data.refobj )

	for _, v in ipairs( objs ) do
		local id = v:GetNWInt( "RoomID", 0 )

		if ( !id or id == 0 ) then return end

		local min = v:LocalToWorld( data.min )
		local max = v:LocalToWorld( data.max )
		OrderVectors( max, min )

		for k, v in ipairs( Location.Locations ) do
			if ( v.IsSuite && v.SuiteID == id ) then
				LogPrint( "Adding location for Suite #" .. id .. "...", color_green, "Rooms" )
				
				Location.Locations[ k ].Min = min
				Location.Locations[ k ].Max = max
			end
		end
	end

	Location.ResortVectors()
end

// hook.Add( "InitPostEntity", "SetupLocations", SetupLocations )

RegisterNWTablePlayer({
	{"GRoomLock", false, NWTYPE_BOOLEAN, REPL_EVERYONE },
	{"GRoomId", 0, NWTYPE_CHAR, REPL_EVERYONE, RecvPlayerRoom },
	{"GRoomEntityCount", 999, NWTYPE_NUMBER, REPL_PLAYERONLY },
})
