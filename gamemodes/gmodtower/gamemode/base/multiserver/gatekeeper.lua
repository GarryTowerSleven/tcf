gateKeep = {}

gateKeep.MaxSlots = 0
gateKeep.AdminBypass = true
gateKeep.AuthorizedPlayers = {}

function GetAuthorizedPlayers()

	return gateKeep.AuthorizedPlayers

end

hook.Add( "DatabaseConnected", "GMTGateKeepInit", function()

	gateKeep:GrabGoList()
	
end )

hook.Add("PlayerPasswordAuth", "OnlyGMTConnections", function(Name, pass, steam, ip)

	local Gamemode = GTowerServers:Self()
	local Pos = string.find(ip, ":")

	if !Gamemode || !Pos then return end

	ip = string.sub(ip, 1, Pos - 1)

	local message = "You are not authorized to join this server"

	--local clients = gatekeeper.GetNumClients()
	local total = gatekeeper.GetNumClients().total

	// allow admins to join regardless, based on steam
	if gateKeep.AdminBypass && Admins.IsAdmin(steam) then return end

	for _, v in ipairs( player.GetAll() ) do
		if v:IsAdmin() then
			total = total - 1
		end
	end

	if Gamemode.CheckForExtraSlots then

		if (total + 1) <= gateKeep.MaxSlots then return end
		message = "The server is full, and you aren't returning from another server."

	elseif total == Gamemode.MaxPlayers then

		// the maxplayers should be +1 so an admin can join, and also handle the bot
		if table.HasValue( Admins.List, steam ) then return end
		message = "This slot is reserved for admins"

	end

	if !gateKeep.AuthorizedPlayers[ip] then
	
		if Gamemode.Private then
			SQLLog( "multiserver", "Dropping connection from " .. tostring(ip) .. " (" .. tostring(Name) .. ") not authorized." )
		end
		
		return {false, message}
		
	end

end)

/*
* Obtains the list of players currently on the server
*/
function gateKeep:GrabStackList(ServerID)

	local Query = "SELECT `id`,HEX(`lastplayers`) FROM `gm_servers` WHERE `id` != " .. ServerID .. " AND `lastupdate` > " .. (os.time() - GTowerServers.UpdateTolerance)

	Database.Query( Query, function( res, status, err )
	
		if status != QUERY_SUCCESS then
			print("Error getting players coming back" .. err)
			return
		end

		gateKeep.AuthorizedPlayers = {}

		if type(res) != "table" then return end

		for _, v in pairs(res) do

			for x, y in pairs(GTowerServers:PlayerListToIDs(v.lastplayers)) do

				gateKeep.AuthorizedPlayers[y] = true

			end

		end


	end )

end

function gateKeep:ResetEmptyReadyServer()

	local Count = player.GetCount()
	if Count == 0 && GTowerServers:GetState() == 3 then

		timer.Simple(60,function()

			local Count = player.GetCount()

			if Count == 0 && GTowerServers:GetState() == 3 then
				SQLLog( "multiserver", "In state 3 too long, changing level" )
				ErrorNoHalt("In state 3 but no players joined, restarting")
				GTowerServers:EmptyServer()
				--ChangeLevel(GTowerServers:GetRandomMap())
				local MapName = GTowerServers:GetRandomMap()
				hook.Call("LastChanceMapChange", GAMEMODE, MapName)
				RunConsoleCommand("gmt_forcelevel", MapName)
			end

		end)

	end

end

// read text file generated to initialize list
function gateKeep:GrabGoingToServer(ServerID)

	// TODO: ??? dont do this
	local txt = "authedusers" .. tostring(GTowerServers:GetServerId()) .. ".txt"

	if file.Exists(txt, "DATA") then
		local contents = file.Read(txt)
		local ips = GTowerServers:PlayerListToIDs(contents)

		SQLLog( "multiserver", "Authorized ips " .. table.concat(ips, ", ") )
		for _, v in pairs(ips) do
			MultiUsers[v] = true
		end

		file.Delete(txt)

		// we can set state 3, ready for players, but this means we need to handle the case when nobody joins
		GTowerServers:SetState(3)
		timer.Simple( 45, function() gateKeep.ResetEmptyReadyServer() end)
	end

end

function gateKeep:GrabGoList()

	gateKeep.MaxSlots = GetMaxSlots()

	if not Database.IsConnected() then return end

	local ServerID = GTowerServers:GetServerId()
	local Gamemode = GTowerServers:Self()

	if !Gamemode then return end

	// this server can overflow, if they're on the stack somewhere
	if Gamemode.CheckForExtraSlots then

		gateKeep:GrabStackList(ServerID)

		timer.Create( "GTowerServersGoList", 1, 0, function() gateKeep.GrabGoList() end)

	// this server can't overflow, but it can only accept connections from players from the list it got from gomap
	elseif Gamemode.Private then

		gateKeep:GrabGoingToServer(ServerID)

	end

end

concommand.Add("listauthorizedids", function(ply, cmd, args)

	if !IsValid(ply) or !ply:IsAdmin() then return end

	for k, _ in pairs(gateKeep.AuthorizedPlayers) do
		if !IsValid(ply) then
			print(k)
		else
			ply:PrintMessage(HUD_PRINTCONSOLE, k)
		end
	end

end)