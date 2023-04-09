AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

hook.Add( "PlayerCanHearPlayersVoice", "BlockedVoices", function( listener, talker )
	if ( Friends.IsBlocked( listener, talker ) ) then return false end
end )

net.Receive( "FriendStatus", function( len, ply )
	local friends = net.ReadTable()

	ply._Friends = friends
end )

util.AddNetworkString( "FriendStatus" )