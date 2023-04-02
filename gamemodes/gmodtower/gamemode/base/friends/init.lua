AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

net.Receive( "FriendStatus", function( len, ply )
	local friends = net.ReadTable()

	ply._Friends = friends
end )

util.AddNetworkString( "FriendStatus" )