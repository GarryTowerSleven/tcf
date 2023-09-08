local DRIVER = {}

DRIVER.Name = "SQLite"
DRIVER.Identifier = "sqlite"

DRIVER.Config = {}

function DRIVER:setconfig() end

function DRIVER:constructor() end
function DRIVER:destructor() end

function DRIVER:isconnected()
    return true
end

function DRIVER:connect()
    hook.Run( "DatabaseConnected", true, nil )

    return true
end

function DRIVER:disconnect()
    return true
end

function DRIVER:query( str, callback )

    local res = sql.Query( str )

    if res == false then
        self:onerror( sql.LastError(), callback )

        return
    end

    callback( res, true, nil )

end

function DRIVER:escape( str )
    return sql.SQLStr( str, true )
end

// HAS ISSUES, DISABLED FOR NOW
// Database.RegisterDriver( DRIVER )