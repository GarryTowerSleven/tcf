
module( "Database", package.seeall )

LastSave = LastSave or 0
SaveFrequency = 60 * ( IsLobby and 2 or 5 )

function ValidPlayer( ply )

    if not IsValid( ply ) then
        return false, "Player Invalid"
    end

    if ply:IsBot() then
        return false, "Bot"
    end

    return true, nil

end

function InsertPlayer( ply, callback )

    local valid, err = ValidPlayer( ply )
    if valid != true then
        callback( false, nil, err or "Unknown" )
        return
    end

    // hardcoding this for now, sorry
    local insert_query = "INSERT INTO `gm_users` (id, steamid, name, ip) VALUES (" .. ply:DatabaseID() .. ", '" .. ply:SteamID() .. "', '" .. Database.Escape( ply:Nick() ) .. "', '" .. ply:DatabaseIP() .. "') ON DUPLICATE KEY UPDATE name = '" .. Database.Escape( ply:Nick() ) .. "', ip = '" .. ply:DatabaseIP() .. "';"

    // store these since the player could go invalid before the query is done
    local id = ply:DatabaseID()
    local steamid = ply:SteamID()
    local name = ply:Nick() .. " [" .. steamid .. "]"

    Query( insert_query, function( res, status, err )
        
        if status != QUERY_SUCCESS then
            LogPrint( Format( "FAILED TO INSERT %s!", name ), color_red, "Database" )
            if callback then
                callback( false, ply, "Failed to insert! (" .. tostring( err ) .. ")" )
            end
            return
        end

        if DEBUG then
            LogPrint( Format( "Successfully inserted %s.", name ), nil, "Database" )
        end

        if callback then
            callback( true, ply, nil )
        end

    end )

end

function SavePlayer( ply, columns, callback )

    callback = callback or EmptyFunction

    local valid, err = ValidPlayer( ply )
    if valid != true then
        callback( false, nil, err or "Unknown" )
        return
    end
    
    if not ply:ProfileLoaded() then
        LogPrint( "Tried to save data before it was loaded! " .. tostring( ply ), color_red, "Database" )

        callback( false, ply, "Player data hasn't been loaded yet." )
        return
    end
    
    if ply._IsSaving then
        LogPrint( "Tried to save data while already saving! " .. tostring( ply ), color_red, "Database" )

        callback( false, ply, "Player data is already saving." )
        return
    end

    local data = Columns.GetPlayer( ply, columns )
    if not data then
        callback( false, ply, "Failed to get player columns. (" .. table.concat( columns or {"all"}, "," ) .. ")" )
        return
    end

    // store these since the player could go invalid before the query is done
    local id = ply:DatabaseID()
    local steamid = ply:SteamID()
    local name = ply:Nick() .. " [" .. steamid .. "]"

    local query_string = "UPDATE `gm_users` SET " .. Columns.CreateQuery( data ) .. " WHERE id = '" .. id .. "';"

    ply._IsSaving = true

    if DEBUG then
        print( query_string )
    end

    Query( query_string, function( res, status, err )

        if IsValid( ply ) then
            ply._IsSaving = false
        end
        
        if status != QUERY_SUCCESS then
            LogPrint( Format( "FAILED TO SAVE %s's DATA!", name ), color_red, "Database" )
            if callback then
                callback( false, ply, "Failed to save data! (" .. tostring( err ) .. ")" )
            end
            return
        end

        if DEBUG then
            LogPrint( Format( "Successfully saved %s's data.", name ), nil, "Database" )
        end

        if callback then
            callback( true, ply, nil )
        end

    end )

end

hook.Add( "PlayerDisconnected", "DatabaseSave", function( ply )

    SavePlayer( ply )

    hook.Run( "DatabasePostPlayerDisconnect", ply )

end )

function SaveAll( columns )

    for _, ply in ipairs( player.GetHumans() ) do

        if not ply:ProfileLoaded() then continue end
        
        SavePlayer( ply, columns )

    end

    if DEBUG then
        LogPrint( "Saved all player data.", nil, "Database" )
    end

end

function FetchPlayerByID( id, columns, callback )
    
    local query = "SELECT " .. Columns.SelectQuery(columns) .. " FROM `gm_users` WHERE id = " .. id .. ";"

    Query( query, function( res, status, err )

        if not callback then return end
        
        if status != QUERY_SUCCESS then
            callback( false, id, "Failed to execute select query. (" .. tostring( err ) .. ")" )
            return
        end

        if table.Count( res ) <= 0 or not res[1] then
            callback( false, id, "Not found in database." )
            return
        end

        callback( true, id, res[1] )

    end )

end

function FetchPlayer( ply, columns, callback )

    local valid, err = ValidPlayer( ply )
    if valid != true then
        callback( false, nil, err or "Unknown" )
        return
    end

    FetchPlayerByID( ply:DatabaseID(), columns, function( status, id, data )

        if not IsValid( ply ) then callback( false, nil, "Player Invalid" ) return end

        callback( status, ply, data )

    end )

end

local function LoadPlayerData( ply )

    Columns.SetPlayerDefaults( ply )

    InsertPlayer( ply, function( status, ply, err )
    
        if status != true then
            return
        end

        if not IsValid( ply ) then return end

        FetchPlayer( ply, nil, function( status, ply, data )

            if status != true then
                return
            end
    
            // can never have enough isvalid checks
            if not IsValid( ply ) then return end

            // could have something better for this, but whateva
            if not tonumber( data.time ) then
                ply._NewPlayer = true
            end
    
            local success = Columns.ApplytoPlayer( ply, data )
            if success != true then
                LogPrint( "Failed to apply data to player " .. tostring( ply ) .. "! (" .. table.concat( table.GetKeys(data) or {}, "," ) .. ")", color_red, "Database" )
                return
            end
    
            ply._DataLoaded = true
        
            hook.Run( "PostPlayerDataLoaded", ply )

            if DEBUG then
                LogPrint( Format( "Successfully loaded %s's data.", ply:GetName() ), nil, "Database" )
            end
    
        end )
    

    end )

end

hook.Add( "PlayerAuthed", "FetchData", LoadPlayerData )

local function SaveThink()

    if player.GetCount() < 1 then return end
    if LastSave + SaveFrequency >= CurTime() then return end

    LastSave = CurTime()

    LogPrint( "Saving all players.", nil, "Database" )
    SaveAll()

end

hook.Add( "Think", "DatabaseSave", SaveThink )

/*hook.Add( "DatabaseOnPlayerFetched", "ApplyData", function( status, id, data )

    if status != true then
        print( "faillll....", id )
        return
    end

    local ply = player.GetByAccountID( id )
    if not IsValid( ply ) then print( "fail!!!", id ) return end

    print( ply )
    PrintTable( data )

end )*/