if not util.IsBinaryModuleInstalled( "mysqloo" ) then return end
require( "mysqloo" )

local DRIVER = {}

DRIVER.Name = "MySQLOO"
DRIVER.Identifier = "mysqloo"

function DRIVER:constructor()
    self.Config = {
        host        = "localhost",
        db          = "gmtower",
        username    = "root",
        password    = "password",
        port        = 3306,
        socket      = nil,
    }

    self.Object = nil
end

function DRIVER:destructor() end

function DRIVER:setconfig( tbl )
    table.Merge( self.Config, tbl )
end

function DRIVER:isconnected()
    return self.Object and self.Object:status() == mysqloo.DATABASE_CONNECTED
end

function DRIVER:connect( callback )
    self.Object = mysqloo.connect(
        self.Config.host,
        self.Config.username,
        self.Config.password,
        self.Config.db,
        self.Config.port,
        self.Config.socket
    )

    self.Object.onConnected = function( db )
        if callback then
            callback( true )
        end

        hook.Run( "DatabaseConnected" )
    end

    self.Object.onConnectionFailed = function( db, err )
        LogPrint( "FAILED TO CONNECT! (" .. err .. ")", color_red, "Database" )

        if callback then
            callback( false, err )
        end
    end

    self.Object:connect()

    return true
end

function DRIVER:disconnect()
    if self:isconnected() then
        self.Object:disconnect()
    end
end

function DRIVER:query( str, callback )

    if not self:isconnected() then return end
    
    local db = self.Object

    local qu = db:query( str )

    qu.onSuccess = function( q, data )
        if callback then
            callback( data, true, nil )
        end
    end

    qu.onError = function( q, err, sql )
        self:onerror( err, callback )
    end

    qu.onAborted = function( q )
        self:onerror( "Query aborted.", callback )
    end 

    qu:start()

end

function DRIVER:escape( str )
    return self.Object:escape( str )
end

Database.RegisterDriver( DRIVER )