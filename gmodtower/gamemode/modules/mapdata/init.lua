AddCSLuaFile("cl_init.lua")
include "functions.lua"

local mapdata = "gamemodes/gmodtower/gamemode/modules/mapdata/maps/" .. game.GetMap() .. ".lua"

if file.Exists( mapdata, "GAME" ) then
	MsgC( co_color, "\n[MapData] Loading MapData for ".. game.GetMap() .."\n\n")
    include( "maps/"..game.GetMap()..".lua" )
else
	MsgC( co_color2, "\n[MapData] No MapData found for " .. game.GetMap() .. "!\n\n")
end