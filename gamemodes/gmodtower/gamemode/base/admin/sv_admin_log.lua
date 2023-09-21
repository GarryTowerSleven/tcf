// Admin Notifications //

// this needs a redo D:

AdminNotif = {}
AdminLog = {}

local AdminNotifColors = {
	["RED"] = Color( 255,0,0 ),
	["GREEN"] = Color( 0,255,0 ),
	["BLUE"] = Color( 0,0,255 ),
	["YELLOW"] = Color( 255,255,0 ),
	["PINK"] = Color( 255,0,255 ),
	["RAINBOW"] = Color(0,0,0,0),
	["WHITE"] = Color(255,255,255),
	["GRAY"] = Color( 200,200,200 ),
}

util.AddNetworkString("AdminNotification")
function AdminNotif.Send(ply, text, time, color, verbose)
	if !ply || !IsValid(ply) then return end
    if ply:GetInfoNum("gmt_admin_log", 1) == 0 then return end
	if !text then text = "nil" end
	if !time then time = 10 end
	if !verbose then verbose = 1 end

    if !color then
        color = AdminNotifColors["WHITE"]
    elseif color && !IsColor(color) then
		color = AdminNotifColors[color] or AdminNotifColors["WHITE"]
    end

	net.Start( "AdminNotification" )
		net.WriteString(text)
		net.WriteInt(time, 7)
		net.WriteColor(color)
		net.WriteInt(verbose, 4)
	net.Send( ply )
end

function AdminNotif.SendStaff( text, time, color, verbose ) // send to all staff
	if verbose && verbose <= 3 then
		LogPrint( text, AdminNotifColors[color] or AdminNotifColors["WHITE"], "Staff Log", Color(255,0,0) )
	end
	for k,v in pairs( player.GetStaff() ) do
		//if verbose && v:GetInfoNum("gmt_admin_log", 1) < verbose then return end
		AdminNotif.Send( v, text, time, color, verbose )
	end
end

function AdminNotif.SendAdmins( text, time, color, verbose ) // send to only admins
	LogPrint( text, AdminNotifColors[color] or AdminNotifColors["WHITE"], "Admin Log", Color(255,0,0) )
	for k,v in pairs( player.GetAdmins() ) do
		//if verbose && v:GetInfoNum("gmt_admin_log", 1) < verbose then return end
		AdminNotif.Send( v, text, time, color, verbose )
	end
end

//util.AddNetworkString("AdminConsolePrint")
function AdminLog.Print( ply, str, color )
	if !str then return end
	if !ply || !IsValid(ply) then return end

	if !color then
        color = AdminNotifColors["WHITE"]
    elseif color && !IsColor(color) then
		color = AdminNotifColors[color] or AdminNotifColors["WHITE"]
    end

	net.Start( "ConsolePrint" )
		net.WriteString(str)
		net.WriteColor(color)
	net.Send( ply )
end

function AdminLog.PrintStaff( text, color, verbose ) // send to all staff
	for k,v in pairs( player.GetStaff() ) do
		if verbose && v:GetInfoNum("gmt_admin_log", 1) < verbose then return end
		AdminLog.Print( v, text, color )
	end
end

function AdminLog.PrintAdmins( text, color, verbose ) // send to only admins
	for k,v in pairs( player.GetAdmins() ) do
		if verbose && v:GetInfoNum("gmt_admin_log", 1) < verbose then return end
		AdminLog.Print( v, text, color )
	end
end

/*local adminCompliments = { "sexy", "handsome", "beautiful", "gorgeous", "stud" }
hook.Add( "PlayerSpawnClient", "AdminVerboseWelcome", function( ply )
	if !IsLobby then return end
    if !IsValid(ply) || !ply:IsStaff() then return end
	local str
	if math.random( 0, 100 ) == 1 then
		str = "Dang, nice shoes!"
	else
		str = "Welcome back, " .. table.Random(adminCompliments) .. "."
	end
    AdminNotif.Send( ply, str, nil, "RAINBOW", 5 )
end)*/

hook.Add( "PlayerSpawnClient", "AdminLogConnected", function( ply )
    if !IsValid(ply) then return end
    AdminNotif.SendStaff( ply:NickID() .. " is now in-game.", nil, ply:GetDisplayTextColor(), 3 )
end)

hook.Add( "player_connect", "AdminLogConnecting", function( data )
	local name = data.name
	local steamid = data.networkid

    AdminNotif.SendStaff( name .. " [" .. steamid .. "] is connecting...", nil, nil, 3 )
end )

hook.Add( "player_disconnect", "AdminLogDisconnect", function( data )
	local name = data.name		
	local steamid = data.networkid
	local reason = data.reason

    AdminNotif.SendStaff( name .. " [" .. steamid .. "] has disconnected. (" .. reason .. ")", nil, "GRAY", 3 )
end )