-- This requires a special module to be installed before it works correctly
-- Sorry to disappoint you
if file.Find("lua/bin/gmcl_gdiscord_*.dll", "GAME")[1] == nil then return end
require("gdiscord")

if !IsLobby then return end

local rpc_convar = CreateClientConVar( "gmt_rpc", 0, true )
local rpcDisabled = false

cvars.AddChangeCallback("gmt_rpc", function(convar_name, value_old, value_new)

    if rpcDisabled && value_new == "1" then
        if !IsLobby then
            Msg2( "Rich presence will be enabled when you return to the lobby.", nil, nil, "exclamation" )
            return 
        end
        Derma_Query(
            "To enable rich presence you must rejoin. Rejoin now?",
            "Warning",
            "Later", function() end,
            "Rejoin", function() RunConsoleCommand( "retry" ) end
        )
    end

    if !rpcDisabled && value_new == "0" then
        if !IsLobby then
            Msg2( "Rich presence will be disabled when you return to the lobby.", nil, nil, "exclamation" )
            return
        end
        Derma_Query(
            "To disable rich presence you must rejoin. Rejoin now?",
            "Warning",
            "Later", function() end,
            "Rejoin", function() RunConsoleCommand( "retry" ) end
        )
    end
end)

-- Configuration
local discord_id = "925654500084183060"
local refresh_time = 30

local discord_start = discord_start or -1

local function getGamemodeName( gm )
    local niceNames = {}
    niceNames["gmtlobby"] = "Lobby"
    niceNames["ballrace"] = "Ballrace"
    niceNames["pvpbattle"] = "PVP Battle"
    niceNames["ultimatechimerahunt"] = "Ultimate Chimera Hunt"
    niceNames["virus"] = "Virus"
    niceNames["zombiemassacre"] = "Zombie Massacre"
    niceNames["sourcekarts"] = "Source Karts"
    niceNames["gourmetrace"] = "Gourmet Race"
    niceNames["minigolf"] = "Minigolf"

    return niceNames[gm] or gm
end

local function getMapPic( map )
    local mapPics = {}
    mapPics["gmt_lobby2_r6"] = "gmt_lobby2_d"
    mapPics["gmt_lobby2_r7"] = "gmt_lobby2_d"

    return mapPics[map] or "no_icon"
end

local function getLocationPic(loc)
    if Location.IsGroup(loc, "plaza") then
        return "plaza"
    end
    if Location.IsGroup(loc, "games") then
        return "games"
    end 
    if Location.IsGroup(loc, "transit") then
        return "transit"
    end 
    if Location.IsGroup(loc, "boardwalk") then
        return "boardwalk"
    end 
    if Location.IsCasino(loc) then
        return "casino"
    end
    if Location.IsNightclub(loc) then
        return "nightclub"
    end
    if Location.IsTheater(loc) || Location.Is(loc, "theatermain") then
        return "theater"
    end
    if Location.Is(loc, "condolobby") then
        return "condolobby"
    end
    if Location.IsGroup(loc, "lobby") then
        return "towerlobby"
    end
    if Location.IsGroup(loc, "condos") then
        return "condo"
    end
    if Location.IsArcade(loc) then
        return "arcade"
    end

    return "gmt_lobby2_d"
end

local lastUpdate = 0
local needToUpdate = false
local lastData

local gm = engine.ActiveGamemode()
local gmName = getGamemodeName( gm )
local map = game.GetMap()
local mapName = Maps.GetName(map) or map

local location = "Somewhere"

local maxPlys = game.MaxPlayers()

local function DiscordUpdate()
    if rpcDisabled then return end
    if lastUpdate > CurTime() then needToUpdate = true return end
    lastUpdate = CurTime() + 1.5

    local rpc_data = {}

    rpc_data["details"] = getGamemodeName( gm ) .. " (" .. player.GetCount() .. " of " .. maxPlys .. ")"

    rpc_data["largeImageKey"] = getMapPic(map)
    rpc_data["largeImageText"] = mapName
    
    rpc_data["smallImageKey"] = gm
    rpc_data["smallImageText"] = gmName

    rpc_data["startTimestamp"] = discord_start

    if IsLobby then
        rpc_data["state"] = Location.GetFriendlyName(location) or "Somewhere"
        //rpc_data["largeImageText"] = "join.gmtdeluxe.org"
        rpc_data["largeImageText"] = "gmtdeluxe.org/chat"
        rpc_data["largeImageKey"] = getLocationPic(location)

        local duel = Dueling.IsDueling(LocalPlayer())
        if duel then
            rpc_data["state"] = "Dueling " .. duel:Name()
        end
    end

    if rpc_data == lastData then return end
    lastData = rpc_data

    DiscordUpdateRPC(rpc_data)
end

function InitRPC()
    if rpcDisabled then return end
    if !rpc_convar:GetBool() then
        rpcDisabled = true
        return
    end

    discord_start = os.time()
    DiscordRPCInitialize(discord_id)
    DiscordUpdate()

    timer.Create("DiscordRPCTimer", refresh_time, 0, DiscordUpdate)

    if IsLobby then
        hook.Add("Location", "DiscordLoc", function( ply, loc )
            location = loc
            DiscordUpdate()
        end)
    
        hook.Add("Think", "NeedToUpdate", function()
            if lastUpdate > CurTime() && !needToUpdate then return end
            DiscordUpdate()
            needToUpdate = false
        end)
    end
    
    hook.Add("PlayerConnect", "DiscordConnect", DiscordUpdate)
    hook.Add("PlayerSpawn", "DiscordSpawn", DiscordUpdate)
end

hook.Add( "CalcView", "RPCFullyConnected", function()
	hook.Remove( "CalcView", "RPCFullyConnected" )

    InitRPC()
end )