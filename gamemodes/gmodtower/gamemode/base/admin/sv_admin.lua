
module( "Admins", package.seeall )

List = {

	["STEAM_0:0:1384695"]	= true, -- kity

	["STEAM_0:0:38865393"]	= true, -- boXy
	["STEAM_0:1:124798129"]	= true, -- AmGona
	["STEAM_0:1:39916544"]	= true, -- Anomaladox
	["STEAM_0:0:44458854"]	= true, -- Bumpy
	["STEAM_0:0:35652170"]  = true, -- Lead

}

ListSecret = {

	["STEAM_0:0:618033331"] = true, -- kity alt
	["STEAM_0:0:614075224"] = true, -- tcf

}

ListModerator = {

	["STEAM_0:1:57386100"] 	= true, -- Squibbus
	["STEAM_0:0:156132358"] = true, -- Basical
	["STEAM_0:1:85508734"] 	= true, -- Breezy
	["STEAM_0:0:115320789"] = true, -- Zia
	["STEAM_0:0:41914866"] 	= true, -- Sunni
	["STEAM_0:1:53166133"] 	= true, -- Orlok
	["STEAM_0:1:72402171"] 	= true, -- Umbre
	["STEAM_0:1:97372299"]	= true, -- NotGaylien
	["STEAM_0:0:69447790"]	= true, -- Oliver Ward
	["STEAM_0:0:52342461"]	= true, -- Willy Bonka
	["STEAM_0:0:55259712"]	= true, -- Espy
	["STEAM_0:0:241528576"]	= true, -- Scienti[-]
	["STEAM_0:1:4313984"]	= true, -- Master

}

function IsAdmin( steamid )
	return ( List[ steamid ] or ListSecret[ steamid ] ) or false
end

function IsSecretAdmin( steamid )
	return ListSecret[ steamid ] or false
end

function IsModerator( steamid )
    return ListModerator[ steamid ] or false
end

function IsStaff( steamid )
    return (IsAdmin( steamid ) or IsModerator( steamid )) or false
end

// PlayerNetInitalized since we use plynet here
hook.Add( "PlayerNetInitalized", "GTowerCheckAdmin", function( ply )

	local steamid = ply:SteamID()

	if IsAdmin( steamid ) then
		ply:SetUserGroup( "superadmin" )
	end

	if IsSecretAdmin( steamid ) then
		ply:SetNet( "SecretAdmin", true )
	end

	if IsModerator( steamid ) then
        ply:SetUserGroup( "moderator" )
    end

end )

function GetAll()

	local admins = {}

	for _, ply in ipairs( player.GetAll() ) do
		if ply:IsAdmin() then
			table.insert( admins, ply )
		end
	end

	return admins

end

function GetStaff()

	local staff = {}

	for _, ply in ipairs( player.GetAll() ) do
		if ply:IsStaff() then
			table.insert( staff, ply )
		end
	end

	return staff

end

hook.Add( "PlayerNoClip", "GMTNoclip", function( ply )
	
	if hook.Run( "CanNoClip", ply ) == false then return false end
	
	if ply:IsStaff() or ply:GetSetting( "GTNoClip" ) == true then
		return true
	end

	return false

end )

concommand.AdminAdd( "gmt_runlua", function( ply, _, _, argStr )

	local lua = argStr

	RunString( "function GMTRunLua() end" ) // clear out the last function, incase the new code is invalid
	RunString( "function GMTRunLua() local me = Entity(" .. ply:EntIndex() .. ") " .. lua .. " end" )

	AdminNotif.SendStaff( Format( "%s has ran lua. See console for details.", ply:Nick() ), nil, "YELLOW", 1 )
	AdminLog.PrintStaff( "[RunLua] Running: " .. tostring( lua ), "YELLOW" )

	status, err = pcall( GMTRunLua )

	if !status then
		AdminNotif.SendStaff( "Failed to run lua! See console for details!", nil, "RED", 1 )
		AdminLog.PrintStaff( "[RunLua] Error: " .. tostring( err ), "RED", 1 )
	end
	
end )

concommand.AdminAdd( "gmt_sendlua", function( ply, _, _, argStr )

	local lua = argStr
	local run_lua = "function GMTRunLua() " .. lua .. " end GMTRunLua()"

	if string.len( run_lua ) >= 254 then 
		AdminLog.Print( ply, "[SendLua] String too long! Not Sending.", "RED" )

		return
	end

	AdminNotif.SendStaff( ply:Nick() .. " has sent lua to all players. See console for details.", nil, "YELLOW", 1 )
	AdminLog.PrintStaff( "[SendLua] Broadcasting: " .. tostring( lua ), "YELLOW" )

	BroadcastLua( run_lua )

end )

concommand.AdminAdd( "gmt_rcon", function( ply, _, args )
	
	if #args == 0 then
		AdminLog.Print( ply, "[RCON] No commands specified.", "RED" )

		return
	end
	
	local cmd = table.remove( args, 1 )

	AdminNotif.SendStaff( ply:Nick() .. " has ran RCON. See console for details.", nil, "YELLOW", 1 )
	AdminLog.PrintStaff( "[RCON] Command: " .. tostring( cmd ) .. " " .. table.concat( args, "" ), "YELLOW" )

	RunConsoleCommand( cmd, unpack( args ) )
	
end )

concommand.StaffAdd( "gmt_warn", function( ply, _, args )

	if table.Count( args ) < 2 then return end

	local target = player.GetByID( tonumber( args[1] ) )
	local reason = tostring( args[2] )

	if not IsValid( target ) then return end

	net.Start( "AdminWarn" )
		net.WriteString( reason )
	net.Send( target )

	AdminNotif.SendStaff( ply:Nick() .. " has warned " .. target:NickID() .. " for: " .. reason .. ".", nil, "RED", 2 )

end )

if not IsLobby then
	
	concommand.StaffAdd( "gmt_sendtolobby", function( ply, _, args )

		if table.IsEmpty( args ) then return end
	
		local target = player.GetByID( tonumber( args[1] ) )
	
		if not IsValid( target ) then return end
	
		target:SendLua( "LocalPlayer():ConCommand('connect join.gtower.net')" )
		timer.Simple( 5, function() if IsValid( target ) then target:Kick( "Not redirected." ) end end )
	
		AdminNotif.SendStaff( ply:Nick() .. " has sent " .. target:NickID() .. " back to lobby.", nil, "RED", 3 )
	
	end )

end

util.AddNetworkString("AdminWarn")