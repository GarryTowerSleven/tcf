AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

hook.Add( "PlayerCanHearPlayersVoice", "BlockedVoices", function( listener, talker )
    return not Friends.IsBlocked( listener, talker )
end )

net.Receive( "FriendStatus", function( len, ply )
	local friends = net.ReadTable()

	ply._Friends = friends
end )

util.AddNetworkString( "FriendStatus" )