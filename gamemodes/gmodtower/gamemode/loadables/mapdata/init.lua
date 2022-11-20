AddCSLuaFile("cl_init.lua")
include("functions.lua")

_MapDataLoaded = _MapDataLoaded or false

local mapdata = "gamemodes/gmodtower/gamemode/loadables/mapdata/maps/" .. game.GetMap() .. ".lua"

if ( !_MapDataLoaded ) then
	if file.Exists( mapdata, "GAME" ) then
		MsgC( co_color, "[MapData] Loading MapData for ".. game.GetMap() .."\n")
		include( "maps/"..game.GetMap()..".lua" )
	else
		MsgC( co_color2, "[MapData] No MapData found for " .. game.GetMap() .. "!\n")
	end

	_MapDataLoaded = true
end
