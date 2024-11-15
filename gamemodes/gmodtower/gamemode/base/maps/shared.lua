module( "Maps", package.seeall )

List = {}
Debug = false

CooldownLimit = 2 // Max amount of times you can play a map

GamemodePrefixes =
{
	["ballracer_"] 	= "ballrace",
	["pvp_"] 		= "pvpbattle",
	["virus_"] 		= "virus",
	["uch_"] 		= "ultimatechimerahunt",
	["zm_"] 		= "zombiemassacre",
	["mono_"] 		= "monotone",
	["minigolf_"] 	= "minigolf",
	["sk_"] 		= "sourcekarts",
	["gr_"]			= "gourmetrace",
}

function RegisterMaps()

	include("ballrace.lua")
	include("gmtlobby.lua")
	include("pvpbattle.lua")
	include("ultimatechimerahunt.lua")
	include("virus.lua")
	include("zombiemassacre.lua")
	include("minigolf.lua")
	include("sourcekarts.lua")
	// include("gourmetrace.lua")

	if SERVER then
		AddCSLuaFile("ballrace.lua")
		AddCSLuaFile("gmtlobby.lua")
		AddCSLuaFile("pvpbattle.lua")
		AddCSLuaFile("ultimatechimerahunt.lua")
		AddCSLuaFile("virus.lua")
		AddCSLuaFile("zombiemassacre.lua")
		AddCSLuaFile("minigolf.lua")
		AddCSLuaFile("sourcekarts.lua")
		// AddCSLuaFile("gourmetrace.lua")
	end

end

function Register( map, mapData )

	// Gather data
	mapData.Gamemode = mapData.Gamemode or GetGamemode( map )

	mapData.Name = mapData.Name or "Unknown"
	mapData.Desc = mapData.Desc or "N/A"
	mapData.Author = mapData.Author or "Unknown"

	if mapData.DateAdded == 0 then
		mapData.DateAdded = os.time()
	end

	if mapData.DateModified == 0 then
		mapData.DateModified = os.time()
	end

	mapData.LastPlayed = 0
	mapData.PlayCount = 0
	mapData.Cooldown = 0

	// Update/insert into list
	Maps.List[map] = mapData

	//Msg( map, "\n" )

	// Update MySQL
	/*if SERVER && Database.IsConnected() then
		UpdateSQL( map, mapData )
	end*/

end

function GetMapData( map )
	return Maps.List[map]
end

function GetName( map )

	local mapData = GetMapData( map )
	if !mapData then
		return "Unknown"
	end

	return mapData.Name

end

function GetMapsInGamemode( gm )

	local maps = {}

	for map, mapData in pairs( Maps.List ) do

		if mapData.Gamemode == gm then
			table.insert( maps, map )
		end

	end

	return maps

end

function GetIcon( map )

	return "gmod_tower/maps/" .. string.sub( map, 0, -3 )

end

MapsWithNoVersion = {
	["gmt_ballracer_metalworld"] = true,
	["gmt_ballracer_nightball"] = true,

	["gmt_pvp_aether"] = true,
	["gmt_pvp_mars"] = true,
	["gmt_pvp_neo"] = true,
}

function GetPreviewIcon( map )

	if MapsWithNoVersion[ map ] then
		return "gmod_tower/maps/preview/" .. map
	else
		return "gmod_tower/maps/preview/" .. string.sub( map, 0, -3 )
	end

end

function GetCurrentMap()

	if MapsWithNoVersion[ map ] then
		return game.GetMap()
	end

	return string.sub( game.GetMap(), 0, -3 )

end

function IsMap( map )

	--return map == GetCurrentMap()
	return string.StartWith( game.GetMap(), map )

end

function GetGamemode( map )

	// Get gamemode name based on prefix
	for prefix, gamemodename in pairs( GamemodePrefixes ) do
		if string.find( map, prefix ) then
			return gamemodename

		end
	end

	return "gmtlobby"

end

function GetMapPrefix()

	local gamemodename = engine.ActiveGamemode()
	local prefix = table.KeyFromValue( GamemodePrefixes, gamemodename )

	if prefix then
		return "gmt_" .. prefix
	end

end

RegisterMaps()



// SERVER SIDE ONLY

if CLIENT then return end

function SQLCallback( res, status, err )

	if status != QUERY_SUCCESS then
		SQLLog( "maps", "Maps sql updated failed: " .. err )
		return
	end
	
end

// === LUA TO MYSQL

function UpdateAllToSQL()

	/*for map, mapData in pairs( Maps.List ) do
		UpdateSQL( map, mapData )
	end*/
	
	local UpdateStrs = {}
	
	for map, mapData in pairs( Maps.List ) do
		
		table.insert( UpdateStrs, 
			string.format( "('%s','%s','%s','%s','%s','%i','%i')", 
				map, 
				Database.Escape( mapData.Name or "Unknown" ), 
				Database.Escape( mapData.Desc or "" ), 
				Database.Escape( mapData.Author or "" ), 
				mapData.Gamemode or "", 
				mapData.DateAdded or os.time(),
				mapData.DateModified or os.time()
			)
		)
		
	end

	local EndRequest = string.format( "REPLACE INTO `gm_maps`(`map`,`mapname`,`desc`,`author`,`gamemode`,`dateAdded`,`dateModified`) " ..
		"VALUES %s", table.concat( UpdateStrs,",") )

	//Msg( EndRequest, "\n" )
	
	local Start = SysTime()
	
	Database.Query( EndRequest, function( res, status, error )
		if status != QUERY_SUCCESS then
			Error( error )
		end
		
		LogPrint( "Update Query took: " .. math.Round( SysTime() - Start, 3 ) .. " seconds.", nil, "Maps" )
	end	)

end

function CanPlayMap( map )

	local mapData = List[map]
	return mapData.Cooldown < CooldownLimit

end

function TestCooldown()

	if !Debug then return end

	MsgN( "Testing alternations" )
	PlayedMap( "gmt_minigolf_garden03" )
	PlayedMap( "gmt_minigolf_waterhole04" )
	PlayedMap( "gmt_minigolf_garden03" )
	PlayedMap( "gmt_minigolf_waterhole04" )
	PlayedMap( "gmt_minigolf_sandbar06" )
	PlayedMap( "gmt_minigolf_moon01" )
	PlayedMap( "gmt_minigolf_sandbar06" )
	PlayedMap( "gmt_minigolf_moon01" )

	MsgN( "Testing repeating" )
	PlayedMap( "gmt_minigolf_garden03" )
	PlayedMap( "gmt_minigolf_garden03" )

	PlayedMap( "gmt_minigolf_waterhole04" )
	PlayedMap( "gmt_minigolf_waterhole04" )

	PlayedMap( "gmt_minigolf_sandbar06" )
	PlayedMap( "gmt_minigolf_sandbar06" )

	PlayedMap( "gmt_minigolf_moon01" )
	PlayedMap( "gmt_minigolf_moon01" )

end

function GetPlayableMaps( gamemode )

	local maps = {}

	for map, mapData in pairs( Maps.List ) do

		if mapData.Gamemode == gm && mapData.Cooldown < CooldownLimit then
			table.insert( maps, map )
		end

	end

	return maps

end

function GetNonPlayableMaps( gamemode )

	local maps = {}

	for map, mapData in pairs( List ) do

		if GetGamemode( map ) != gamemode then continue end
		
		if mapData.Cooldown >= CooldownLimit then

			if Debug then MsgC( Color( 255, 0, 0 ), "You can't play " .. map .. "\n" ) end
			table.insert( maps, map )

		else
			//if Debug then MsgC( Color( 0, 255, 0 ), "You can play " .. map .. "\n" ) end
		end

	end

	return maps

end

function ClearPlayedMaps()

	for mapcool, mapDataCool in pairs( List ) do
		mapDataCool.Cooldown = 0
	end

end

function PlayedMap( map )

	local mapData = List[map]
	if !mapData then return end

	mapData.LastPlayed = CurTime()
	mapData.PlayCount = mapData.PlayCount + 1
	mapData.Cooldown = mapData.Cooldown + 1

	IncreasePlayCountSQL( map )

	MsgC( Color( 255, 255, 0 ), "Played map " .. map .. "\n" )

	// Clear cooldown maps
	for mapcool, mapDataCool in pairs( List ) do

		if GetGamemode( map ) != GetGamemode( mapcool ) then continue end

		// Clear cool down
		if map != mapcool then
			mapDataCool.Cooldown = 0
		end

	end

	if Debug then
		GetNonPlayableMaps( "minigolf" )
	end

end

function IncreasePlayCountSQL( map )

	local mapData = GetMapData( map )
	if !mapData then
		return
	end

	local Query = "SELECT playedCount FROM `gm_maps` WHERE map='" .. map .. "'"
	Database.Query( Query, function( result, status, err )

		if status != QUERY_SUCCESS then     
			return
		end

		if !result then return end

		// Increase and Update
		local query = "UPDATE gm_maps SET playedCount=" .. ( result[1].playedCount + 1 ) .. " WHERE `map`='" .. map .. "'"
		Database.Query( query, SQLCallback )

	end )

end

concommand.Add( "gmt_updatemaplist", function( ply, cmd, args )

	if ply != NULL && !ply:IsAdmin() then
		return
	end

	Maps.UpdateAllToSQL()

	if ply.Msg2 then
		ply:Msg2( "Updated MySQL map list" )
	end
	
end )

concommand.Add( "gmt_mapcooldown", function( ply, cmd, args )

	if !ply:IsAdmin() then return end

	for map, mapData in pairs( List ) do

		if mapData.Cooldown >= CooldownLimit then
			ply:Msg2( map )
		end

	end

end )

hook.Add( "DatabaseConnected", "UpdateMapList", function() 

	if IsLobby then
		UpdateAllToSQL()
		LogPrint( "Updated map list.", nil, "Maps" )
	end

end )

/*concommand.Add( "gmt_requestmaplist", function( ply, cmd, args )

	if ply != NULL && !ply:IsAdmin() then
		return
	end

	Maps.UpdateAllFromSQL()

	if ply.Msg2 then
		ply:Msg2( "Updated map list from MySQL" )
	end
	
end )*/

/*function UpdateSQL( map, mapData )

	updateData = {
		["map"] = Database.Escape( map ),
		["mapname"] = Database.Escape( mapData.Name or "Unknown" ),
		["desc"] = Database.Escape( mapData.Desc or "" ),
		["gamemode"] = GetGamemode( map ),
		["dateAdded"] = mapData.DateAdded,
		["dateModified"] = mapData.DateModified,
		["author"] = Database.Escape( mapData.Author or "" ),
	}

	local query = "INSERT INTO " .. 
				  MySql.CreateQueryString( "gm_maps", updateData ) .. 
				  " ON DUPLICATE KEY UPDATE map = '" .. map .. "';"

	Database.Query( query, SQLCallback )

end*/


// === MYSQL TO LUA

/*function UpdateAllFromSQL()

	MsgN( "Requesting map list..." )

	local Query = "SELECT * FROM `gm_maps`"
	Database.Query( Query, function( result, status, err )

		if status != QUERY_SUCCESS then     
			ErrorNoHalt( tostring(error) )
			return
		end

		Maps.List = {}
		
		for _, data in pairs( result ) do
			StoreMapData( ProcessSQLMapData( data ) )
		end

	end )

end

function StoreMapData( mapData )

	Maps.List[mapData.Map] = mapData
	MsgN( "Loaded from mysql map: " .. mapData.Map )

end

function ProcessSQLMapData( rawdata )

	local mapData = {
		Map = rawdata[1],
		Name = rawdata[2],
		Desc = rawdata[3],
		Gamemode = rawdata[4],
		PlayCount = rawdata[5],
		DateAdded = rawdata[6],
		DateModified = rawdata[7],
		Author = rawdata[8],
	}

	return mapData

end*/