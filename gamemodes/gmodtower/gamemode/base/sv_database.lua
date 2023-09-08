require( "dotenv" )
env.load( ".env" )

// Setup Database Connection

local function SetupDatabase()

    local driver = env.getString( "DATABASE_DRIVER", "mysqloo" )
    local config = {
        host = env.getString( "DATABASE_HOST", "localhost" ),

        user = env.getString( "DATABASE_USER", "root" ),
        password = env.getString( "DATABASE_PASSWORD", "password" ),

        db = env.getString( "DATABASE_DB", "gmt" ),

        port = env.getNumber( "DATABASE_PORT", 3306 ),
        socket = env.getString( "DATABASE_SOCKET", nil ),
    }
    
    Database.SetDriver( driver )
    Database.SetConfig( config )

    Database.Connect()

end

hook.Add( "DatabaseModuleInitialized", "SetupDatabase", SetupDatabase )
hook.Add( "DatabaseConnected", "SetupDatabase", function()

    LogPrint( "Successfully connected to database.", nil, "Database" )

    // Database.Migrate()

end )