---------------------------------
/* ================================================
 * THIS FILE WILL BE DEDICATED TO MANAGE THE PLAYERS WITHIN THE SERVER
 * - Throw all players back into the main server
 * - Store what players are allowed to join the main server unconditually
 * - Throw players into a server
  ================================================  */

GTowerServers.EmptyingServer = false

function MakeSureGoneA( uniqueid, ip, port, password )

	for _, ply in pairs( player.GetAll() ) do
		if ply:SteamID() == uniqueid then

			//Player still exists in the server?
			ply:SendLua("RunConsoleCommand(\"password\", \"" .. password .. "\")")
			ply:SendLua("LocalPlayer():ConCommand(\"connect " .. ip .. ":" .. port .. "\")")

			timer.Simple( 5.0,  function() MakeSureGoneB( ply:SteamID() ) end)
		end
	end

end

function MakeSureGoneB( uniqueid )

	for _, v in pairs( player.GetAll() ) do
		if v:SteamID() == uniqueid then
			v:Kick( "Not redirected." )
		end
	end

end

function GTowerServers:StopRedirecting()
	for _, v in ipairs( player.GetAll() ) do
		if IsValid( v ) then
			v.HideRedir = false
		end
	end
end

//BRUTE COMMAND TO REMOVE PLAYERS
function GTowerServers:RedirectPlayers( ip, port, password, players, NoCheckGone, gameMode )

	local rp = RecipientFilter()

	if !players then
		players = player.GetAll()
	end

	if gameMode then
		local gameName = gameMode.Name or "unspecified gamemode"
		local numPlayers = #players or "an unknown number of"

		for _, v in ipairs( player.GetAll() ) do
			if IsValid( v ) then
				v.HideRedir = true
			end
		end

		GAMEMODE:ColorNotifyAll( T("GamemodeStartingChat", gameName, tostring( numPlayers )), Color(154, 218, 235, 255) )
	end

	local ips = {}

	for _, ply in pairs( players ) do
		if IsValid(ply) then
			table.insert(ips, ply:Name() .. "@" .. ply:IPAddress())
			local gameName
			if gameMode != nil then gameName = gameMode.Name else gameName = "unspecified gamemode" end
			rp:AddPlayer( ply )
			ply:Msg2("Sending you to " .. gameName)

			if NoCheckGone != true then
				timer.Simple( 5.0,  function() MakeSureGoneA( ply:SteamID(), ip, port, password ) end)
			end

			if IsLobby then
				timer.Simple(2, function()
					if IsValid(ply) then
						umsg.Start("GServ", ply)
							umsg.Char( 14 )
							umsg.String(gameName)
						umsg.End()
					end
				end)
			end

			if self.DEBUG then Msg("Setting player " .. tostring( ply ) .. " to serverID#: " .. tostring(serverid) .. "\n") end
		end
	end

	if #ips > 0 then
		SQLLog( "redirectplayers", "Redirecting " .. table.concat(ips, ", ") )
	end

	umsg.Start("MServ", rp )
		umsg.Char( 0 )
		umsg.String( ip )
		umsg.String( port )
		umsg.String( password )
	umsg.End()

	if gameMode then
		timer.Simple( 30, function() GTowerServers.StopRedirecting( self ) end)
	end

end

//Returns on the callback the table of the main server table
//If it fails, the calls the callback with nil
local function GetMainServerCallbackResult(callback, res)

	//Unable to execute query
	if res[1].status != true then
		Msg( res[1].status .. "\n")
		callback( nil )
		return
	end

	for _, v in pairs( res[1].data ) do
		//Make sure the server has send a signal in the last 5 minutes and that it is alive.
		if tonumber( v.lastupdate ) > (os.time() - GTowerServers.UpdateTolerance) then
			callback( v )
			return
		end
	end

	callback( nil )
end

function GTowerServers:GetMainServer( callback )

	 /*SQL.getDB():Query( "SELECT `ip`,`port`,`password`,`lastupdate` FROM `gm_servers` WHERE `gamemode`='gmtlobby' AND `id`!=" .. self:GetServerId(), function(res)
	GetMainServerCallbackResult(callback, res) end)*/

	SQL.getDB():Query( "SELECT `ip`,`port`,`password`,`lastupdate` FROM `gm_servers` WHERE `gamemode`='gmtlobby' AND `id`!=" .. self:GetServerId(), GetMainServerCallbackResult, callback)

end

//Function to check what is the main server and send them there
//If if fails, call the failsafe function

concommand.Add('gmt_returntolobby', function( ply )
	GTowerServers:SendMainServer( {ply} )
end)

function GTowerServers:SendMainServer( Players )
	GTowerServers:GetMainServer( function( server )
		if !server then
			GTowerServers:FailSafeRemove( Players )
			return
		end

		GTowerServers:RedirectPlayers( server.ip, server.port, server.password, Players, true )
	end )
end

function GTowerServers:FailSafeRemove( Players )
	//this doesn't get the failsafeb, so just kick them
	for k,v in pairs(Players) do
		if IsValid(v) then
			v:ChatPrint("Could not find the main server")
			v:Kick("Unable to find main server, you aren't meant to be here.")
		end
	end
end


//Command to make sure all players will be redirected to the main server
//And they will be added to the stack allowing them to by-pass the max players
function GTowerServers:AuthorizeJoinedPlayers(golist)
	local PlayersIPs = {}

	for ip, v in pairs( golist ) do
		table.insert( PlayersIPs, ip )
	end

	local HexData = self:ListToHex( PlayersIPs )
	self:UpdateDatabase( HexData )
end

function GTowerServers:EmptyServer()

	// no need to empty again, we've already processed it
	if GTowerServers.EmptyingServer then return end

	SQLLog( "server", "Empty server"  )
	GTowerServers.EmptyingServer = true

	//Make a query to allow all the players that were previsuly accepted here
	//Be accepted in the main server at any cost
	GTowerServers:AuthorizeJoinedPlayers(GetAuthorizedPlayers())

	local Gamemode = self:Self()

	if Gamemode && Gamemode.Private == true then
		//I don't want confusions with people coming back
		GTowerServers:SetRandomPassword()
	end

end

function GTowerServers:ResetServer()
	timer.Simple( 10, function()
		local map = GTowerServers:GetRandomMap()
		GAMEMODE:ColorNotifyAll( T( "AdminChangeMap", map ), Color(255, 50, 50, 255) )
		for k,v in pairs(player.GetAll()) do
			v:Kick("Not redirected.")
		end
		hook.Call("LastChanceMapChange", GAMEMODE, map)
		RunConsoleCommand("changelevel", map)
	end )
end

local function EmptyNow()
	if !GTowerServers.EmptyingServer then return end

	for k,v in pairs(player.GetAll()) do
		v:Kick("The game has ended")
	end
end

hook.Add("MapChange", "EmptyServerForReal", EmptyNow)

local function UpdatedDatabaseEmptyResult(res)
	if res[1].status != true then
		Msg( tostring(res[1].status) .. "\n")
		return
	end
end

hook.Add("GTowerServersDatabaseUpdated", "EmptyServer", function()
	if !GTowerServers.EmptyingServer then return end

	local allplayers = player.GetAll()

	// let's make sure the servers sync
	timer.Simple(1.5, function()
		//Now we send all the players to the main server
		GTowerServers:SendMainServer( allplayers )
	end)
end)

concommand.Add("gmt_emptyserver", function( ply, cmd, args )

	if ply == NULL || ply:IsAdmin() then

		GTowerServers:EmptyServer()

	end


end )
