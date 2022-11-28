local logname = "MapData"

module( "MapData", package.seeall )

BaseDir = "gmodtower/gamemode/loadables/mapdata/maps/"

function Load( map )
	local map = map or game.GetMap()
    LogPrint( "Loading data for " .. map .. "...", co_color, logname )

    local server_file = BaseDir .. map .. ".lua"
    local client_file = BaseDir .. map .. "_client.lua"

    if ( SERVER && file.Exists( server_file, "LUA" ) ) then
        LogPrint( "Loading serverside...", co_color, logname )
        include( server_file )
    end

    if ( file.Exists( client_file, "LUA" ) ) then
        if SERVER then
            LogPrint( "Sending clientside...", co_color, logname )
            AddCSLuaFile( client_file )
        else
            LogPrint( "Loading clientside...", co_color, logname )
            include( client_file )
        end
    end
end

Load()