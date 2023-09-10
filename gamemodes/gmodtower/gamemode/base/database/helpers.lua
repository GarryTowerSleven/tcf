
module( "Database", package.seeall )

function CreateInsertQuery( data )

    local keys = {}
    local values = {}

    for k, v in pairs( data ) do
        table.insert( keys, "`" .. k .. "`" )
        table.insert( values, v )
    end

    return "(" .. table.concat( keys, "," ) .. ") VALUES (" .. table.concat( values, "," ) .. ")"

end

function CreateUpdateQuery( data )

    local sets = {}

    for k, v in pairs( data ) do
        table.insert( sets, "`" .. k .. "`=" .. v )
    end

    return table.concat( sets, "," )

end

function CreateWhereQuery( data )

    local sets = {}

    for k, v in pairs( data ) do
        table.insert( sets, "`" .. k .. "`=" .. v )
    end

    return table.concat( sets, " AND " )

end