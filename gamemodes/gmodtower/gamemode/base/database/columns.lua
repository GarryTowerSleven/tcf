
module( "Database", package.seeall )

Columns = Columns or {}
Columns.Registry = Columns.Registry or {}

function Columns.Add( name, structure )

    LogPrint( Format( "Registering \"%s\" column...", name ), nil, "Database" )

    Columns.Registry[ name ] = structure

end

function Columns.Get( name )

    return Columns.Registry[ name ] or nil

end

function Columns.CreateQuery( data )

    local queries = {}

    for k, v in pairs( data ) do

        local col = Columns.Get( k )
        if not col then
            ErrorNoHaltWithStack( Format( "Database column \"%s\" not found!", k ) )
            continue 
        end

        local value = v

        if col.escape then
            value = Database.Escape( value )
        end
        
        if col.hex then
            value = value // ??? //"HEX(" .. value .. ")"
        elseif isstring( v ) then
            value = "'" .. value .. "'"
        end

        table.insert( queries, "`" .. k .. "` = " .. value )

    end

    return table.concat( queries, "," )

end

function Columns.SelectQuery( columns )

    columns = columns or table.GetKeys( Columns.Registry )

    local query_string = ""

    for _, v in pairs( columns ) do

        local col = Columns.Get( v )
        if not col then
            ErrorNoHaltWithStack( Format( "Database column \"%s\" not found!", v ) )
            continue 
        end
        
        if query_string != "" then
            query_string = query_string .. ", "
        end

        local key = v
        
        if col.hex then
            key = "HEX(" .. key .. ") as " .. key
        end

        query_string = query_string .. key

    end

    return query_string

end

function Columns.GetSaveColumns()

    local cols = {}

    for k, v in pairs( Columns.Registry ) do

        if v.get and not v.unimportant then
            table.insert( cols, k )
        end
        
    end

    return cols

end

function Columns.GetPlayer( ply, columns )

    if not IsValid( ply ) then return false end

    columns = columns or Columns.GetSaveColumns()
    
    local data = {}

    for _, v in ipairs( columns ) do
        
        local col = Columns.Get( v )
        if not col then
            ErrorNoHaltWithStack( Format( "Database column \"%s\" not found! Can't get!", v ) )
            continue 
        end
        
        if not col.get then continue end

        local val = col.get( ply )

        if not val or val == nil then continue end
        
        data[ v ] = val

    end

    return data

end

function Columns.SetPlayerDefaults( ply )

    if not IsValid( ply ) then return false end

    for k, v in pairs( Columns.Registry ) do
        
        if v.default then
            v.default( ply )
        end

    end

end

function Columns.ApplytoPlayer( ply, data )

    if not IsValid( ply ) then return false end
    if not istable( data ) then ErrorNoHaltWithStack( "DATA ISNT TABLE!!" ) return false end

    for k, v in pairs( data ) do
        
        local col = Columns.Get( k )
        if not col then
            ErrorNoHaltWithStack( Format( "Database column \"%s\" not found! Can't set!", k ) )
            continue 
        end

        if col.set then
            if v == "NULL" then continue end

            col.set( ply, v )
        end

    end

    return true

end
