
QUERY_FAILIURE = false
QUERY_SUCCESS = true

module( "Database", package.seeall )

DEBUG = true
Object = Object or nil

function GetObject()
    return Object
end

function SetDriver( identifier )

    local driver = CreateDriver( identifier )

    if not driver then
        LogPrint( Format( "Failed to set driver to \"%s\"! Not found in registry!", identifier ), color_red, "Database" )
        return
    end

    Object = driver

end

function SetConfig( tbl )

    local driver = GetObject()

    return driver:setconfig( tbl )

end

function IsConnected()

    local driver = GetObject()

    return driver:isconnected()

end

function Connect( callback )

    local driver = GetObject()

    return driver:connect( callback )

end

function Disconnect()

    local driver = GetObject()

    return driver:disconnect()

end

function Query( str, callback )

    if not IsConnected() then
        ErrorNoHaltWithStack( "Attempt to query with a disconnected database!" )
        return
    end

    local driver = GetObject()

    return driver:query( str, callback )

end

function Escape( str )

    if not IsConnected() then
        ErrorNoHaltWithStack( "Attempt to escape with a disconnected database!" )
        return
    end

    local driver = GetObject()

    return driver:escape( str )

end