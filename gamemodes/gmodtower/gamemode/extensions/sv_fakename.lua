
util.AddNetworkString( "FakeName" )

local function SetFakeName(ply, name)
    if name == ply:GetNWString("FakeName") then return end
    if !name then
        print("[FakeName] Removed " .. ply:Nick() .. "'s fakename")
        ply:SetNWString( "FakeName", "" )
        SQL.getDB():Query(
        "UPDATE `gm_users` SET `fakename` = '' WHERE `gm_users`.`steamid` = '" .. ply:SteamID() .. "'", SQLLogResult)
        return 
    end
    print("[FakeName] Set " .. ply:Nick() .. "'s fakename to \"" .. name .. "\"")
    ply:SetNWString( "FakeName", name )
    SQL.getDB():Query(
    "UPDATE `gm_users` SET `fakename` = '" .. name .. "' WHERE `gm_users`.`steamid` = '" .. ply:SteamID() .. "'", SQLLogResult)
end

concommand.Add( "gmt_fakename", function( ply, cmd, args )
    if !ply:IsAdmin() then return end
    local name
    if !args[1] then
        name = nil
    else
        name = args[1]
    end
    SetFakeName( ply, name )
end )

hook.Add( "PlayerInitialSpawn", "FakeNameSpawn", function( ply )
    if !ply:IsValid() || ply:IsBot() || !ply:IsAdmin() then return end
    SQL.getDB():Query("SELECT `fakename` FROM `gm_users` WHERE `steamid` = '" .. ply:SteamID() .. "'", function(res)
        if ( !res || !res[1] || !res[1]["data"] || !res[1]["data"][1] || !res[1]["data"][1]["fakename"] ) then return end

        local name = res[1]["data"][1]["fakename"]
        if name then
            ply:SetNWString( "FakeName", tostring(name) )
        end
    end )
end)
