AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_player.lua")
include("sh_player.lua")

net.Receive( "gmt_serverfriends", function( len )
	local friends = net.ReadTable()
	local ply = net.ReadEntity()
	
	ply.FriendsList = friends
end )

util.AddNetworkString( "gmt_serverfriends" )