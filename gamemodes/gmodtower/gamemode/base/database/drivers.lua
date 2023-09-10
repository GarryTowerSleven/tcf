
module( "Database", package.seeall )

BaseDir = "gmodtower/gamemode/base/database/"
DriverDir = BaseDir .. "drivers/"

DriverRegistry = DriverRegistry or {}
DefaultDriver = "sqlite"

function CreateDriver( identifier )

    if not DriverRegistry[ identifier ] then
        LogPrint( Format( "Failed to create driver \"%s\"! Not found in registry!", identifier ), color_red, "Database" )
        return
    end

    LogPrint( Format( "Creating driver \"%s\"...", identifier ), nil, "Database" )

    return DriverRegistry[ identifier ]:init()

end

function RegisterDriver( driver )

    LogPrint( Format( "Initialized \"%s\" driver.", driver.Name ), nil, "Database" )

    local obj = {}
    obj.__index = obj

    if driver.Identifier != "base" then
        obj = table.Copy( DriverRegistry[ "base" ] )
    end

    table.Merge( obj, driver )

    function obj:init()
        local new = {}
        setmetatable( new, obj )

        new:constructor()

	    return new
    end

    DriverRegistry[ driver.Identifier ] = obj

end

function LoadDrivers()

    local files, _ = file.Find( DriverDir .. "*.lua", "LUA" )

    for _, v in ipairs( files ) do
        include( DriverDir .. v )
    end

end
