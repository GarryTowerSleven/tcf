local DRIVER = {}

DRIVER.Name = "Base"
DRIVER.Identifier = "base"

DRIVER.Config = {}

function DRIVER:onerror( err, callback )
    ErrorNoHaltWithStack( "SQL Error! (", err, ")" )

    if callback then
        callback( nil, false, err )
    end

    hook.Run( "DatabaseError", err )
end

function DRIVER:setconfig() end
function DRIVER:getconfig() return self.Config end

function DRIVER:constructor() end
function DRIVER:destructor() end

function DRIVER:isconnected() end

function DRIVER:connect() end

function DRIVER:disconnect() end

function DRIVER:query( str, callback ) end

function DRIVER:escape( str ) end

Database.RegisterDriver( DRIVER )