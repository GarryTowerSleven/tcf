AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

module( "Friends", package.seeall )

MaxFriends = 2048

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

net.Receive( "FriendStatus", function( len, ply )

	if not ply._Friends then ply._Friends = {} end
	
	-- Add a one second delay so people with lots of friends can't hang the server.
	if ply._FriendsLastUpdate and ply._FriendsLastUpdate > CurTime() then return end
	ply._FriendsLastUpdate = CurTime() + 1

	-- No data, so no need to read any of the client's input.
	if len == 0 then return end

	repeat
		local strippedSteamID = net.ReadString()

		-- If the steamid is empty, too long, or doesn't have 2 colons, then it's invalid.
		-- The length of 15 is arbitrary. SteamID's are currently shorter, but we want this to work in 2140 too.
		local _, colons = strippedSteamID:gsub(":","")
		if strippedSteamID == "" or string.len( strippedSteamID ) > 15 or colons != 2 or #ply._Friends >= MaxFriends then
			break -- Just stop bothering with this client.
		end

		ply._Friends["STEAM_" .. strippedSteamID] = 1

	until strippedSteamID == ""

	if not ply._FriendsNotified then
		NotifyJoin( ply )
	end

end )

util.AddNetworkString( "FriendStatus" )