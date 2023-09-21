
module( "Bans", package.seeall )

DEBUG = false

List = List or {}

FetchDelay = 60
LastFetch = LastFetch or 0

DefaultReason = "Your current action(s) are against our rules."

function Get( steamid )

    return List[ steamid ] or nil

end

function Add( ban )

    if not ban.steamid then return end

    List[ ban.steamid ] = ban

end

function AddBan( steamid, invoker, reason, name, ip, duration )

    local ban = New()

    ban:SetData( steamid, name, ip )
    ban:SetBanner( invoker )
    ban:SetReason( reason )
    ban:SetLength( duration )

    Add( ban )

    SaveToSQL( ban, invoker )
    
end

function Remove( steamid )

    local ban = List[ steamid ]

    if not ban then
        if IsValid( alert ) then
            alert:PrintMessage( HUD_PRINTCONSOLE, "Ban not found." )
        end

        return nil
    end

    List[ steamid ] = nil

    return ban

end

function BanPlayer( ply, invoker, reason, duration )

    if not IsValid( ply ) then
        return
    end

    local ban = New()

    ban:SetPlayer( ply )
    ban:SetBanner( invoker )
    ban:SetReason( reason )
    ban:SetLength( tonumber( duration ) )

    Add( ban )

    SaveToSQL( ban, invoker )

    local message = ban:BanNotice()

    ply:Kick( message )

end

concommand.StaffAdd( "gmt_addban", function( ply, _, args )

    if table.Count( args ) <= 0 then
        local usage_string = "Usage: gmt_addban <steamid (STEAM_0:0:0000000)> <name> <reason> <duration (in seconds)>"

        if IsValid( ply ) then
            ply:PrintMessage( HUD_PRINTCONSOLE, usage_string )
        else
            print( usage_string )
        end

        return
    end

    local steamid = args[1] or nil
    local reason = args[2] or nil
    local name = args[3] or nil
    local duration = args[4] or nil

    AddBan( steamid, ply, name, reason, nil, duration )

end )

concommand.StaffAdd( "gmt_removeban", function( ply, _, args )

    local steamid = args[1] or nil
    if not steamid then return end

    local ban = Remove( steamid )

    if not ban then
        ply:PrintMessage( HUD_PRINTCONSOLE, "Ban not found!" )

        return
    end

    local query = ban:GetRemoveQuery()

    Database.Query( query, function( res, status, err )
    
        if status != QUERY_SUCCESS then
            if IsValid( ply ) then
                ply:PrintMessage( HUD_PRINTCONSOLE, "Failed to unban! (" .. err .. ")" )
            end

            return
        end

        if IsValid( ply ) then
            ply:PrintMessage( HUD_PRINTCONSOLE, "Successfully unbanned " .. steamid .. "." )
        end

    end )


end )

concommand.StaffAdd( "gmt_ban", function( ply, _, args )

    local target = player.GetByID( tonumber( args[1] ) )
    if not IsValid( target ) then return end

    BanPlayer( target, ply, args[2] or nil, args[3] or nil )

end )

function KickPlayer( ply, invoker, reason )

    local invoker_name = IsValid( invoker ) and invoker:Nick() or "staff"
    local message = Format( "Kicked by %s | Reason: %s", invoker_name, reason or DefaultReason )   

    ply:Kick( message )

end

concommand.StaffAdd( "gmt_kick", function( ply, _, args )

    local target = player.GetByID( tonumber( args[1] ) )
    if not IsValid( target ) then return end

    KickPlayer( target, ply, args[2] or nil )

end )

hook.Add( "CheckPassword", "CheckBanned", function( steamID64, ip, _, _, name )

    local steamid = util.SteamIDFrom64( steamID64 )

    local ban = Get( steamid )
    if ban then
        
        if not ban:IsExpired() then
            return false, ban:BanNotice()
        else
            Remove( steamid )
        end

    end

end )

function Fetch()

    Database.Query( "SELECT * FROM `gm_bans` ORDER BY `bannedOn` DESC;", function( res, status, err )
    
        if status != QUERY_SUCCESS then return end

        for _, v in ipairs( res ) do

            // dont overwrite current bans with previous ones
            if List[ v.steamid ] then continue end
            
            local ban = New()

            ban:SetFromSQL( v )

            if ban:IsExpired() then
                continue
            end

            Add( ban )

        end

        if DEBUG then
            LogPrint( Format( "Fetched %s ban(s) from SQL.", string.FormatNumber( table.Count( res ) ) ), nil, "Bans" )
        end
    
    end )

    LastFetch = CurTime()

end

hook.Add( "DatabaseConnected", "FetchBans", Fetch )

hook.Add( "Think", "BanFetch", function()

    if not Database.IsConnected() then return end

    if LastFetch + FetchDelay < CurTime() then
        Fetch()
    end

end )

function SaveToSQL( ban, alert )

    if not ban or not ban.steamid then return end
    if not Database.IsConnected() then return end

    local query = ban:GetInsert()

    Database.Query( query, function( res, status, err )

        if status != QUERY_SUCCESS then
            if IsValid( alert ) then
                alert:PrintMessage( HUD_PRINTCONSOLE, "Failed to insert ban! (" .. tostring( err or "Unknown" ) .. ")" )
            end

            return
        end

        if IsValid( alert ) then
            alert:PrintMessage( HUD_PRINTCONSOLE, "Successfully banned " .. ban:GetSteamID() .. "." )
        end
        
    end )

end