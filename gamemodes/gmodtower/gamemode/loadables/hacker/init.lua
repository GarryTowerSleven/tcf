//include('shared.lua')

AddCSLuaFile('cl_init.lua')
//AddCSLuaFile('shared.lua')
//AddCSLuaFile('vocab.lua')

/*local function InsertHackerStatus(result, status, error)
	if status != 1 then
		SQL.SqlError( error )
	end
end*/

GTowerHackers = {}

local function fakeUnknownCommand(ply, cmd)
	net.Start("ConsolePrint")
		net.WriteString("Unknown command: " .. cmd)
		net.WriteColor(Color(255,255,255))
	net.Send(ply)
end

function GTowerHackers:Init()
	// if !tmysql then return end
	// SQL.getDB():Query("CREATE TABLE IF NOT EXISTS gm_hackers(steamid TINYTEXT, name TINYTEXT, hackid TINYINT, cmd TINYTEXT, args TINYTEXT, extra TINYTEXT)")
end

timer.Simple( 1, function()
	GTowerHackers:Init()
end )

function GTowerHackers:NewAttemp( ply, id, cmd, args, extra )

	if !ply || !cmd then return end
	if !cmd then return end

	if !id then id = 0 end
	if !extra then extra = "" end

	local cmd = tostring(cmd)

	local cmdRaw = cmd
	local argsRaw = args

	if !args then
		args = ""
	else
		for _,v in pairs(args) do
			cmd = cmd .. " " .. v
		end
	end

	AdminNotif.SendStaff( "[Hacker Attempt] " .. ply:NickID() .. " attempted to run \"" .. cmd .. "\"", nil, "RED" )
	fakeUnknownCommand(ply, cmdRaw)

	/*if !tmysql then return end

	if type( argsRaw ) == "table" then
		argsRaw = string.Implode( " ", argsRaw )
	else
		argsRaw = tostring( argsRaw )
	end

	local InsertString = "INSERT INTO `gm_hackers`(`steamid`,`name`,`hackid`,`cmd`,`args`,`extra`) VALUES ('"..SQL.getDB():Escape(ply:SteamID()).."','" .. SQL.getDB():Escape(ply:Nick()) .. "',"..id..",'".. SQL.getDB():Escape(cmdRaw).."','".. SQL.getDB():Escape(argsRaw).."', '".. SQL.getDB():Escape(extra).."');"

	SQL.getDB():Query( InsertString, SQLLogResult )*/
	
end