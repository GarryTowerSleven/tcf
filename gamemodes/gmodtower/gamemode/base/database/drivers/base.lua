local DRIVER = {}

DRIVER.Name = "Base"
DRIVER.Identifier = "base"

DRIVER.Config = {}

function DRIVER:onerror( err, callback )
    ErrorNoHaltWithStack( "SQL Error! (", err, ")" )

    AdminNotif.SendStaff( "AN SQL ERROR HAS OCCURED! SEE CONSOLE FOR DETAILS!", 20, "RED", 0 )
    AdminLog.PrintStaff( "SQL ERROR: " .. tostring( err ), "RED", 0 )

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