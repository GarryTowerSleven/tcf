// Database Details
local host = ""
local user = ""
local password = ""
local database = ""

local os, arch, mysqlooModulePath, mysqlooExists, sqlType

// prevent doing on lua refreshes
if !dbObject then
	os = string.lower( jit.os )
	arch = jit.arch

	if arch == "x86" then
		if os == "windows" then
			mysqlooModulePath = "bin/gmsv_mysqloo_win32.dll"
		elseif os == "linux" then
			mysqlooModulePath = "bin/gmsv_mysqloo_linux.dll"
		end
	else
		if os == "windows" then
			mysqlooModulePath = "bin/gmsv_mysqloo_win64.dll"
		elseif os == "linux" then
			mysqlooModulePath = "bin/gmsv_mysqloo_linux64.dll"
		end
	end

	mysqlooExists = file.Exists( mysqlooModulePath, "LUA" )

	if mysqlooExists then
		sqlType = "MySQLOO"

		// We're using a translation layer for now until i decide to make everything use native mysqloo functions
		include("mysqloo/tmysql4.lua")
	else
		sqlType = "TMySQL"

		require( "tmysql4" )
	end
end

if !mysqlooExists then
	LogPrint( "Please update to MySQLOO, TMySQL is outdated. (https://github.com/FredyH/MySQLOO/releases/)", Color(255,0,255), "Database" )
end

if !tmysql then
	--LogPrint( "OH GOD. MySQLOO MODULE NOT FOUND!", co_color2, "Database" )
	return 
end

if tmysql && !tmysql.Version then
	tmysql.Version = "4"
end

// lookin' good
LogPrint( sqlType .. " module loaded. [v" .. tmysql.Version .. "]", co_color, "Database" )

module("SQL", package.seeall )

ColumnInfo = ColumnInfo or {}

function connectToDatabase()
	if dbObject then return end
	
	// tmysql.Connect( host, user, pass, db, port, unixsocket, clientflags )
	local db, err = tmysql.Connect( 'host', 'user', 'password', 'database', 3306, nil, 3 )

	if err then
		LogPrint( "DATABASE FAILED TO CONNECT!", co_color2, "Database" )
		LogPrint( tostring(err), co_color2 )
	else
		LogPrint( "Database connected.", co_color, "Database" )
		dbObject = db
	end
end

connectToDatabase()

function getDB()
	return dbObject
end

GTowerSQL = {}

local db = getDB()

include("mysql/colums.lua")
include("mysql/player.lua")

/*
column = COLUMN NAME

//What should be inserted into the UPDATE query
fullupdate = nil or function(ply) returning "columnname = value"

//If fullupdate is not set, this will be called, just return value
update = function(ply) return val end

//What should be put in the sql query
selectquery = nil or columnname

//What column should be selected from the database
selectresult = nil or columname

//Called when the new value has been se
onupdate = nil or function(ply, val) ply:SetVal( val ) end

//Called when the default value need to be set
defaultvalue = nil or function

*/

function GetColumns()
	return Colums
end

function StartColums()

	if Colums then
		return
	end

	Colums = {}

	hook.Call("SQLStartColumns", GAMEMODE )

	//Just some garbage collecting to make sure it won't be added twice
	hook.GetTable().SQLStartColumns = nil

end

function SqlError( error )
	local Match = string.match( error, "Table '([%a_]+)' is marked as crashed and should be repaired" )

	analytics.postDiscord( "SQL ERROR", Match .. " marked as crashed. Repairing it." )

	if Match then

		SQLLog('error', Match .. " marked as crashed. Repairing it." )

		databaseObject:Query( "REPAIR TABLE `".. Match .."`", self.RepairCallback )

	end

end

RepairCallback = function( res, status, error )

	local EndString = ""

	if status != 1 then
		EndString = "Repair callback: " .. error
	else
		for _, v in pairs( res ) do
			EndString = EndString .. table.concat( v, "\t") .. "\n"
		end
	end

	SQLLog('error', "Repair table crashed: " .. EndString )

end

ErrorCheckCallback = function( origin, res, status, error )

	if status != 1 then
		SQLLog('error', 'Origin: ' .. origin .. "\n MySQL Error: " .. error )
	end

end

hook.Add("PlayerAuthed", "GtowerSelectSQL", function(ply, steamid)

	if ply:IsBot() then
		return
	end

	StartColums()

	--ply.SQL = GTowerSQL:NewSQLPlayer( ply )
	ply.SQL = SQLPlayer.Init( ply )
	ply.SQL:ExecuteSelect()

	ply.NextSQLUpdate = CurTime() + 5
end )

hook.Add("PlayerDeath", "GtowerSQLPlayerDeath", function(ply)
	if !ply:IsBot() && ply.SQL then
		ply.SQL:Update( false )
	end
end)

hook.Add("PlayerThink", "GTowerSQLUpdate", function(ply)
	if !ply:IsBot() && ply.SQL && ply.NextSQLUpdate && CurTime() > ply.NextSQLUpdate then
		ply.NextSQLUpdate = CurTime() + 5
		ply.SQL:Update( false )
	end
end)

hook.Add("PlayerDisconnected", "GtowerSQLDisconnect", function(ply)

	if !ply:IsBot() && ply.SQL then
		ply.SQL:Update( true )
	end
end )


hook.Add( "MapChange", "GtowerSQLShutDown", function()

	Msg("Map change, mysql shut down.")

    for k, v in pairs( player.GetAll() ) do
		if !v:IsBot() && v.SQL then
			v.SQL:Update( true )
		end
    end

	//Remove hooks to prevent any confusion
	hook.Remove("PlayerDisconnected", "GtowerSQLDisconnect")
	hook.Remove("PlayerDeath", "GtowerSQLPlayerDeath")
	hook.Remove("PlayerAuthed", "GtowerSelectSQL")
	hook.Remove("PlayerThink", "GTowerSQLUpdate")

end )

hook.Add("CanChangeLevel", "SavingPlayers", function()
	for _, ply in pairs( player.GetAll() ) do
		if ply.SQL && ply.SQL.UpdateInProgress == true then
			return false
		end
	end
end )

concommand.Add("gmt_forceupdate", function( ply, cmd, args )

	if ply == NULL || ply:IsAdmin() then

		for _, v in ipairs( player.GetAll() ) do
			if !v:IsBot() && v.SQL then
				v.SQL:Update( false, true )
			end
	    end

	end

end )

concommand.Add("gmt_dumpsqldata", function( ply, cmd, args )

	file.Write( "SQLDUMP_" .. ply:SQLId() .. ".txt", table.ToNiceString( ply.SQL ) )

end )
