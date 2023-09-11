---------------------------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_command.lua")
AddCSLuaFile("cl_mapchooser.lua")
AddCSLuaFile("mapselection/DMapSelector.lua")
AddCSLuaFile("mapselection/DMapList.lua")

include("shared.lua")
//include("join.lua")
//include("servers.lua")
include("network.lua")
include("waiting.lua")
include("player.lua")
//include("Nametable.lua")
include("server/server.lua")
//include("mapchooser.lua")

GTowerServers.Servers = {}

function GTowerServers:GetServersResponse( res, status, err )

	if status != QUERY_SUCCESS then -- TODO
		ErrorNoHalt( "GetServers error " .. err )
		--Msg( status .. "\n")
		return
	end

	for k, v in pairs( res ) do
		local Id = tonumber( v.id )

		if !Id then
			GTowerServers:CreateServer( Id )
		end

		local Server = self:Get( Id )

		if Server == nil then
			GTowerServers:CreateServer( Id )
			Server = self:Get( Id )
		end

		Server:LoadSQL( v )
	end

	hook.Call("GTowerServerUpdate")
end

function GTowerServers:GetServers()

	if not Database.IsConnected() then
		return
	end

	//No use sending queries if the server is empty.
	if player.GetCount() == 0 then
		return
	end

	local Query = "SELECT `id`,`ip`,`port`,`players`,HEX(`playerlist`) as `playerlist`,`msg`,`maxplayers`,`map`,`password`,`gamemode`,`status`,`lastupdate`,HEX(`lastplayers`) as `lastplayers`"
	.. "FROM `gm_servers` WHERE `id`!=" .. self:GetServerId() .. " AND `lastupdate`>" .. (os.time() - self.UpdateTolerance)


	Database.Query( Query, function( res, status, err )
		
		GTowerServers:GetServersResponse( res, status, err )

	end )

end



timer.Create("GTowerRequestData", GTowerServers.UpdateRate, 0, function()  GTowerServers:GetServers()
end)

hook.Add("InitPostEntity", "GTowerServers1Request", function() GTowerServers:GetServers() end )

function GTowerServers:Get( Id )
	return self.Servers[ Id ]
end

concommand.Add("gmt_multisetid", function( ply, cmd, args )

	if !ply:IsAdmin() then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, cmd, args )
		end
		return
	end

	if #args != 2 then
		return
	end

	local Ent = ents.GetByIndex( tonumber( args[1] ) or 0  )
	local Id = tonumber( args[2] )

	if !Id then
		return
	end

	if !IsValid( Ent ) || Ent:GetClass() != "gmt_multiserver" then
		return
	end

	Ent:SetId( Id )

end )


concommand.Add("gmt_multijoin", function( ply, cmd, args )

	if !ply:IsStaff() then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, cmd, args )
		end
		return
	end

	if #args != 1 then
		return
	end

	local ServerId = tonumber( args[1] )
	local Server = GTowerServers:Get( ServerId )

	if !Server || !Server:Online() then return end

	if Server.PlayerCount >= Server.ServerMaxPlayers then
		ply:Msg2( T("GamemodeFull", Server.gamemode) )
		return
	end

	timer.Simple(1.5, function()
		GTowerServers:RedirectPlayers( Server.Ip, Server.Port, Server.Password, {ply} )
	end)
end )

concommand.Add("gmt_multiminplay", function( ply, cmd, args )
	if !ply:IsAdmin() then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, cmd, args )
		end
		return
	end

	if #args != 2 then return end

	local ServerId = tonumber( args[1] )
	local Server = GTowerServers:Get( ServerId )
	local GamemodeName = Server:GetGamemodeName()
	local Gamemode = GTowerServers:GetGamemode( GamemodeName )
	local MinPlay = tonumber( args[2] )

	if !Server || !Server:Online() then return end

	Gamemode.MinPlayers = MinPlay
end )

concommand.Add("gmt_multiforcevote", function( ply, cmd, args )
	if !ply:IsAdmin() then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, cmd, args )
		end
		return
	end

	if #args != 1 then return end

	local ServerId = tonumber( args[1] )
	local Server = GTowerServers:Get( ServerId )
	local GamemodeName = Server:GetGamemodeName()
	local Gamemode = GTowerServers:GetGamemode( GamemodeName )

	if !Server || !Server:Online() then return end

	local MinPlay = Gamemode.MinPlayers
	Gamemode.MinPlayers = 1
	timer.Simple(60, function() Gamemode.MinPlayers = MinPlay end)
end )