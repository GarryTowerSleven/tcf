
module( "Database", package.seeall )

function Load()

    // drivers
    LoadDrivers()

    // tables
    hook.Run( "DatabaseTables" )

    // columns
    hook.Run( "DatabaseColumns" )

    // let things know that the module is ready
    hook.Run( "DatabaseModuleInitialized" )

end

hook.Add( "Initialize", "LoadDatabase", Load )