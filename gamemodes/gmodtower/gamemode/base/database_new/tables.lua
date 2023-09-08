
module( "Database", package.seeall )

TablePrefix = "" // "gmt_"
TableRegistry = TableRegistry or {}

function CreateTableQuery( name, structure )
    
    local query_string = "CREATE TABLE IF NOT EXISTS " .. name

    local structure_string = ""

    for _, v in ipairs( structure ) do

        if structure_string != "" then
            structure_string = structure_string .. ","
        end
        
        local str = v.name .. " " .. v.datatype or "text"

        if v.unsigned then
            str = str .. " UNSIGNED"
        end

        if v.notnull then
            str = str .. " NOT NULL"
        end

        if v.default then
            str = str .. " DEFAULT " .. v.default
        end

        if v.autoincrement then
            str = str .. " AUTO_INCREMENT"
        end
        
        if v.primarykey then
            str = str .. " PRIMARY KEY"
        end

        structure_string = structure_string .. str

    end

    query_string = query_string .. " (" .. structure_string .. ");"

    return query_string

end

function RegisterTable( name, structure )

    name = TablePrefix .. name

    LogPrint( Format( "Registering \"%s\" table...", name ), nil, "Database" )

    TableRegistry[ name ] = structure

end

function Migrate()

    LogPrint( "Migrating tables...", nil, "Database" )

    for k, v in pairs( TableRegistry ) do

        local q_str = CreateTableQuery( k, v )

        local callback = function( res, status, err )
            if not status then
                LogPrint( Format( "FAILED TO MIGRATE TABLE \"%s\"! : %s", k, tostring( err ) ), color_red, "Database" )
                return
            end

            LogPrint( Format( "Successfully migrated table \"%s\".", k ), color_green, "Database" )
        end

        Query( q_str, callback )
        
    end

    LogPrint( "Done migrating.", nil, "Database" )

end

hook.Add( "DatabaseTables", "AddTables", function()

    Database.RegisterTable( "gm_users", {
        [1] = {
            name = "id",
            datatype = "varchar(32)",
            primarykey = true,
            notnull = true },
        [2] = {
            name = "name",
            datatype = "text" },
        [3] = {
            name = "steamid",
            datatype = "text",
            notnull = true },
        [4] = {
            name = "betatest",
            datatype = "varchar(45)" },
        [5] = {
            name = "CreatedTime",
            datatype = "varchar(45)" },
        [6] = {
            name = "ip", 
            datatype = "varchar(45)" },
        [7] = {
            name = "levels", 
            datatype = "text" },
        [8] = {
            name = "pvpweapons", 
            datatype = "text" },
        [9] = {
            name = "clisettings", 
            datatype = "text" },
        [10] = {
            name = "MaxItems", 
            datatype = "varchar(45)" },
        [11] = {
            name = "inventory", 
            datatype = "text" },
        [12] = {
            name = "BankLimit", 
            datatype = "text" },
        [13] = {
            name = "bank", 
            datatype = "text" },
        [14] = {
            name = "plysize", 
            datatype = "varchar(45)" },
        [15] = {
            name = "achivement", 
            datatype = "text" },
        [16] = {
            name = "Roomdata", 
            datatype = "text" },
        [17] = {
            name = "money", 
            datatype = "int(10)" },
        [18] = {
            name = "LastOnline", 
            datatype = "varchar(45)" },
        [19] = {
            name = "hat", 
            datatype = "varchar(45)" },
        [20] = {
            name = "tetrisscore", 
            datatype = "varchar(45)" },
        [21] = {
            name = "time", 
            datatype = "varchar(45)" },
        [22] = {
            name = "ramk", 
            datatype = "int(11)" },
        [23] = {
            name = "ball", 
            datatype = "int(11)" },
        [24] = {
            name = "faceHat", 
            datatype = "int(11)" },
        [25] = {
            name = "pendingmoney", 
            datatype = "int(11)" },
        [26] = {
            name = "chips", 
            datatype = "int(11)" },
        [27] = {
            name = "fakename", 
            datatype = "tinytext" },
    } )
    
end )