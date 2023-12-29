---------------------------------
local NetworkPlySend = {}
local NetworkRoomSend = {}

local SizePerMessage = 40


util.AddNetworkString( "GRoom_Update" )

local function SendUpdate( ply )

	local rooms = {}

	for i, r in ipairs( GTowerRooms.Rooms ) do
		
		rooms[i] = {}
		rooms[i].Owner = r.Owner
		
	end

	// FIXME: Use compressed data for speed!
	net.Start( "GRoom_Update" )
	net.WriteTable( rooms )

	if ply then

		net.Send( ply )

	else

		net.Broadcast()

	end

end

hook.Add("RoomLoaded", "SendRoomInfo", function( ply, RoomId )
	SendUpdate()
end )

hook.Add("RoomUnLoaded", "SendRoomInfo", function( RoomId )
	SendUpdate()
end )

hook.Add("PostPlayerDataLoaded", "SendRoomData", function( ply )

	SendUpdate( ply )

end )

concommand.Add("gmt_roomnetwork", function( ply, cmd, args )

	if ply == NULL then
		
		PrintTable( NetworkPlySend )
		PrintTable( NetworkRoomSend )
		
	end

end )