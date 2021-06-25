AddCSLuaFile("cl_init.lua")
include "functions.lua"

local mapdata = "gamemodes/gmodtower/gamemode/modules/mapdata/maps/" .. game.GetMap() .. ".lua"

if file.Exists( mapdata, "GAME" ) then
	print('\n[MapData] Loading MapData for '.. game.GetMap() ..'\n')
    include( "maps/"..game.GetMap()..".lua" )
else 
	print('\n[MapData] No MapData found for ' .. game.GetMap() .. '!\n')
end