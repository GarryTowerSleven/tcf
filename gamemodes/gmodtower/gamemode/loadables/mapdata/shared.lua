local logname = "MapData"

module( "MapData", package.seeall )

BaseDir = "gmodtower/gamemode/loadables/mapdata/maps/"

function Load( map )
	local map = map or game.GetMap()
    LogPrint( "Loading data for " .. map .. "...", color_green, logname )

    local server_file = BaseDir .. map .. ".lua"
    local client_file = BaseDir .. map .. "_client.lua"

    if ( SERVER && file.Exists( server_file, "LUA" ) ) then
        LogPrint( "Loading serverside...", color_green, logname )
        include( server_file )
    end

    if ( file.Exists( client_file, "LUA" ) ) then
        if SERVER then
            LogPrint( "Sending clientside...", color_green, logname )
            AddCSLuaFile( client_file )
        else
            LogPrint( "Loading clientside...", color_green, logname )
            include( client_file )
        end
    end
end

Load()