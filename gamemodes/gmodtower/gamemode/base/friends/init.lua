AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

module( "Friends", package.seeall )

function GetFriends( ply )

	local tbl = {}

	for _, v in ipairs( player.GetAll() ) do
		
		if not IsValid( v ) then continue end

		if IsFriend( ply, v ) then
			table.insert( tbl, v )
		end

	end

	return tbl

end

// could have a better name?
function GetFriended( ply )

	local tbl = {}

	for _, v in ipairs( player.GetAll() ) do
		
		if not IsValid( v ) then continue end

		if IsFriend( v, ply ) then
			table.insert( tbl, v )
		end

	end

	return tbl

end

function NotifyJoin( ply )

	for _, v in ipairs( Friends.GetFriended( ply ) ) do
		if v:GetInfoNum( "gmt_notify_friendjoin", 1 ) <= 0 then continue end

		v:MsgI( "heart", "Friends_Joined", ply:GetName() )
	end

	ply._FriendsNotified = true

end

hook.Add( "PlayerCanHearPlayersVoice", "BlockedVoices", function( listener, talker )
	if ( Friends.IsBlocked( listener, talker ) ) then return false end
end )
/*
net.Receive( "FriendStatus", function( len, ply )

	local friends = net.ReadTable()
	ply._Friends = friends

	if not ply._FriendsNotified then
		NotifyJoin( ply )
	end

end )
/*
//util.AddNetworkString( "FriendStatus" )