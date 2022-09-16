AddCSLuaFile("cl_init.lua")
include("functions.lua")

// server
local mapdata = "gamemodes/gmodtower/gamemode/loadables/mapdata/maps/" .. game.GetMap() .. ".lua"

if file.Exists( mapdata, "GAME" ) then
	MsgC( co_color, "[MapData] Loading MapData for ".. game.GetMap() .."\n")
    include( "maps/"..game.GetMap()..".lua" )
else
	MsgC( co_color2, "[MapData] No MapData found for " .. game.GetMap() .. ".\n")
end