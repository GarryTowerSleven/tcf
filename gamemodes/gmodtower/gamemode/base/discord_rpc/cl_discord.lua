if file.Find("lua/bin/gmcl_gdiscord_*.dll", "GAME")[1] == nil then return end
require("gdiscord")

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
local discord_id = "1097587544515936316"
local refresh_time = IsLobby and 30 or 10

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

local function getLocationPic(loc)
    if Location.IsGroup(loc, "trainstation") then
        return "trainstation"
    end
	if Location.IsGroup(loc, "devhq") then
		return "devhq"
	end
	if Location.IsGroup(loc, "teleporters") then
		return "teleporters"
	end
	if Location.IsGroup(loc, "lobbyroof") then
		return "lobbyroof"
	end
	if Location.IsGroup(loc, "theater") or Location.IsGroup(loc, "theaterhallway") then
		return "theater"
	end
	if Location.IsGroup(loc, "vents") then
		return "vents"
	end
	if Location.IsGroup(loc, "moon") then
		return "moon"
	end
	if Location.IsGroup(loc, "eplaza") then
		return "eplaza"
	end
	if Location.IsGroup(loc, "stores") then
		return "stores"
	end
	if Location.IsGroup(loc, "bar") then
		return "bar"
	end
	if Location.IsCasino(loc) then
		return "casino"
	end
	if Location.IsGroup(loc, "arcade") then
		return "arcade"
	end
	if Location.Is("teleporters") then
		return "teleporters"
	end
	if Location.IsGroup(loc, "gamemodeports") or Location.IsGroup( loc, "minigolf" ) or Location.IsGroup( loc, "sourcekarts" ) or Location.IsGroup( loc, "pvpbattle" ) or Location.IsGroup( loc, "ballrace" ) or Location.IsGroup( loc, "ultimatechimerahunt" ) or Location.IsGroup( loc, "zombiemassacre" ) or Location.IsGroup( loc, "virus" ) then
		return "gamemodes"
	end
	if Location.IsGroup(loc, "narnia") then
		return "narnia"
	end
	if Location.IsGroup(loc, "pool") then
		return "pool"
	end
	if Location.IsGroup(loc, "lakeside") then
		return "lakeside"
	end
	if Location.IsGroup(loc, "suites") then
		return "suites"
	end
	if Location.IsGroup(loc, "suite") then
		return "suite"
	end

    return "lobby"
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

    rpc_data["state"] = Format( "%s ( %s of %s )", gmName, player.GetCount(), maxPlys )

    //rpc_data["largeImageKey"] = getMapPic(map)
    //rpc_data["largeImageText"] = mapName
    
    rpc_data["smallImageKey"] = gm
    rpc_data["smallImageText"] = gmName

    rpc_data["startTimestamp"] = discord_start
    
    if IsLobby then
        rpc_data["details"] = Location.GetFriendlyName(location) or "Somewhere"
        rpc_data["largeImageText"] = "chat.gtower.net"
        rpc_data["largeImageKey"] = "location_" .. getLocationPic(location)
        
        local duel = Dueling.IsDueling(LocalPlayer())
        if duel then
			local duelist = LocalPlayer():GetNWEntity("DuelOpponent")
			if IsValid( duelist ) then
				rpc_data["details"] = "Dueling " .. duelist:Name()
			end
        end
        
		rpc_data["joinSecret"] = "steam://connect/"..game.GetIPAddress()
    else
        //rpc_data["largeImageKey"] = map
        /*local timeleft = GAMEMODE:GetTimeLeft()

        rpc_data["startTimestamp"] = os.time() - timeleft
        rpc_data["endTimestamp"] = os.time() + timeleft*/

        // yuck
        local map_icon = "map_" .. string.Replace( Maps.GetPreviewIcon( map ), "gmod_tower/maps/preview/gmt_", "" )

        rpc_data["largeImageKey"] = map_icon
        rpc_data["largeImageText"] = mapName

        if ( GAMEMODE:GetState() == STATE_WAITING ) then
            rpc_data["details"] = "Waiting for Players..."
        else
            rpc_data["details"] = Format( "Round %s of %s", GAMEMODE:GetRound(), GAMEMODE:GetMaxRounds() )
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
    
    else
        hook.Add("Think", "NeedToUpdate", function()
            if lastUpdate > CurTime() && !needToUpdate then return end
            DiscordUpdate()
            needToUpdate = false
        end)

        hook.Add( "GMTRoundChange", "UpdateRound", function( round )
            DiscordUpdate()
        end )
    end
    
    hook.Add("PlayerConnect", "DiscordConnect", DiscordUpdate)
    hook.Add("PlayerSpawn", "DiscordSpawn", DiscordUpdate)
end

hook.Add( "CalcView", "RPCFullyConnected", function()
	hook.Remove( "CalcView", "RPCFullyConnected" )

    InitRPC()
end )