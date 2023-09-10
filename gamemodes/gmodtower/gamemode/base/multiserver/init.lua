---------------------------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
include("game.lua")
include("password.lua")
include("gamemode.lua")
include("hex.lua")
include("gatekeeper.lua")

/*
	STATE LIST

	1 = Ready to get players
	2 = Server is busy
	3 = Has a list of players and ready to receive them
*/
GTowerServers.CurState = 0

local UpdateInProgress = false

function GTowerServers:GetState()
	return GTowerServers.CurState
end

function GTowerServers:SetState( state )
	GTowerServers.CurState = state

	SQLLog( "multiserver", "State changed to: " .. tostring( state ) )
end

function GM:SetStatus( state )
	GTowerServers:SetState( state )
end
GM.SetState = GM.SetStatus

function GTowerServers:GetServerId()
	return GetConVarNumber("gmt_srvid")
end

function GTowerServers:GetMessage()
	local HookMessages = hook.GetTable().GTowerMsg

	if HookMessages then
		for _, v in pairs( HookMessages ) do
			if type( v ) == "function" then
				return v()
			end
		end
	end

	return ""
end

function DecodePlayersFromSQLId(hex)
	local players = {}
	local data = Hex( hex )

	while data:CanRead( 8 ) do
		table.insert(players, data:Read(8))
	end

	return players
end

local function GetPlayerSQLIdHex()

	local Data = Hex()
	local PlayerList = player.GetAll()

	for _, ply in pairs( PlayerList ) do
		if ply.SQL && ply.SQL.Connected == true then
			Data:Write( ply:DatabaseID(), 8 )
		end
	end

	return Data:Get(), #PlayerList

end

local function GTowerServerDatabaseResult( res, status, err )
	UpdateInProgress = false

	if status != QUERY_SUCCESS then
		return
	end

	hook.Call("GTowerServersDatabaseUpdated", GAMEMODE)
end

//The playerstack will be the list of players that will be allowed to join the main server
function GTowerServers:UpdateDatabase( playerstack )

	if not Database.IsConnected() then
		return
	end

	local ServerID = self:GetServerId()
	
	if ServerID == 0 then
		Msg("No Server id found")
		return
	end

	local serverAddress = string.Explode( ":", game.GetIPAddress() )
	local PlayerData, PlayerCount = GetPlayerSQLIdHex()
	local gamemsg = GTowerServers:GetMessage()

	local data = {
		port = serverAddress[2],
		players = PlayerCount,
		maxplayers = game.MaxPlayers(),
		map = Database.Escape( string.lower( game.GetMap() ), true ),
		gamemode = Database.Escape( self:Gamemode(), true ),
		password = Database.Escape( GetConVarString( "sv_password" ) or "", true ),
		status = Database.Escape( self:GetState(), true ),
		playerlist = PlayerData,
		lastupdate = os.time(),

		msg = gamemsg and Database.Escape( gamemsg, true ) or nil,
		lastplayers = playerstack and Database.Escape( playerstack, true ) or nil,
	}

	local query = "UPDATE `gm_servers` SET " .. Database.CreateUpdateQuery( data ) .. " WHERE `id` = " .. ServerID .. ";"
	
	UpdateInProgress = true

	Database.Query( query, GTowerServerDatabaseResult )

end

function UpdateMultiServer()
	GTowerServers:UpdateDatabase()
	timer.Start("GTowerServersRepeat")
end

hook.Add("MapChange", "GTowerMultiServersMap", function()
	//GTowerServers:SetState( 0 )
	UpdateMultiServer()
end )
hook.Add("InitPostEntity", "GTowerMultiServerInit", function()
	if GTowerServers:GetState() <= 1 then
		GTowerServers:SetState( 1 )
	end
	GTowerServers:UpdateDatabase()
end )
hook.Add("CanChangeLevel", "UpdatingMultiServer", function()
	if UpdateInProgress == true then
		return false
	end
end )


hook.Add( "DatabaseConnected", "GTowerServersConnect", UpdateMultiServer )
hook.Add( "PlayerDisconnected", "GTowerServersDisConnect", UpdateMultiServer )
timer.Create( "GTowerServersRepeat", GTowerServers.UpdateRate, 0, function()
	UpdateMultiServer()
end )
