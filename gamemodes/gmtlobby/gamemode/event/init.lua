
local EventSound = "gmodtower/misc/notifyevent.wav"
if time.IsChristmas() then EventSound = "gmodtower/music/christmas/eventnotify.mp3" end

local eventlist = { minigames.balloonpop.MinigameName, minigames.chainsaw.MinigameName, minigames.obamasmash.MinigameName,  "storesale", "storesale" }

local shopslist = {
    GTowerStore.SUITE,
	GTowerStore.HAT, 
	GTowerStore.PVPBATTLE, 
	GTowerStore.BAR,
	GTowerStore.BALLRACE, 
	GTowerStore.SOUVENIR, 
	GTowerStore.ELECTRONIC, 
	GTowerStore.MERCHANT, 
	GTowerStore.BUILDING, 
	GTowerStore.VENDING,
	GTowerStore.PLAYERMODEL, 
	GTowerStore.POSTERS,
	GTowerStore.FOOD,
	--GTowerStore.DUEL,
	GTowerStore.TOY,
	GTowerStore.PET,
	GTowerStore.MUSIC,
}

local enabled = true
local curevent = "Unknown"
local nextevent = "Unknown"
local nexttype = "Unknown"
local endtime = 0

local lastevent = 0

// Min/max Time Interval
local mininterval = 25
local maxinterval = 35

local nexttime = 0

// Percentage
local minsale = 10
local maxsale = 50

local cursale = nil
local curmini = nil

// Lengths
local minitime = 120 -- 2 minutes
local saletime = 120 -- 2 minutes

function SendMessageToPlayers(msgtype, ...)
	for _, v in ipairs(player.GetAll()) do
		v:MsgT( msgtype, select( 1, ... ) )
	end
end

function getEventType()
    return table.Random( eventlist )
end

local function updateGlobals( time, event )
    SetGlobalInt( "NextEventTime", time )
    SetGlobalString( "NextEvent", event )
end

function StartEvent( event )

    curevent = event

    local time = math.Round( math.Rand( mininterval, maxinterval ) )
    nexttime = CurTime()+(time*60)
    nextevent = getEventType()

    updateGlobals( nexttime, nextevent )

    if event == "storesale" then
        local store = table.Random(shopslist)
        local discount = math.Round( math.Rand(minsale,maxsale) )

        cursale = store

        endtime = CurTime() + saletime

        MsgC( color_green, "[EVENTS] Starting " ..  discount .. "% sale at " .. GTowerStore.Stores[ store ].WindowTitle .. "\n" )

        SendMessageToPlayers( "MiniStoreGameStart", discount, GTowerStore.Stores[ store ].WindowTitle )

        GTowerStore:BeginSale(store, discount*.01)
    elseif event == minigames.balloonpop.MinigameName then
        local MiniGame = minigames[ "balloonpop" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "balloonpop"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        MsgC( color_green, "[EVENTS] Starting balloonpop!\n" )

        endtime = CurTime() + minitime

    elseif event == minigames.obamasmash.MinigameName then
        local MiniGame = minigames[ "obamasmash" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "obamasmash"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        MsgC( color_green, "[EVENTS] Starting obama smash!\n" )

        endtime = CurTime() + minitime

    elseif event == minigames.chainsaw.MinigameName then
        local MiniGame = minigames[ "chainsaw" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "chainsaw"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        MsgC( color_green, "[EVENTS] Starting chainsaw!\n" )

        endtime = CurTime() + minitime

    elseif event == "pvpnarnia" then
        local MiniGame = minigames[ "pvpnarnia" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "pvpnarnia"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        MsgC( color_green, "[EVENTS] Starting pvpnarnia!\n" )

        endtime = CurTime() + minitime

    end

end

function EndEvent()

    if curevent == "storesale" then
        GTowerStore:EndSale(cursale)
        MsgC( color_red, "[EVENTS] Sale ended at " .. GTowerStore.Stores[ cursale ].WindowTitle .. "\n" )
    elseif curevent == minigames.balloonpop.MinigameName then
        SafeCall( minigames[ "balloonpop" ].End )
        MsgC( color_red, "[EVENTS] Balloonpop ended\n" )
    elseif curevent == minigames.obamasmash.MinigameName then
        SafeCall( minigames[ "obamasmash" ].End )
        MsgC( color_red, "[EVENTS] Obamasmash ended\n" )
    elseif curevent == minigames.chainsaw.MinigameName then
        SafeCall( minigames[ "chainsaw" ].End )
        MsgC( color_red, "[EVENTS] Chainsaw ended\n" )
    elseif curevent == "pvpnarnia" then
        SafeCall( minigames[ "pvpnarnia" ].End )
        MsgC( color_red, "[EVENTS] PVPNarnia ended\n" )
    end

    curevent = "Unknown"
    cursale = nil
    endtime = 0

end

function StartEventSys()
    if !enabled then return end

    // next event time
    local time = math.Round( math.Rand( mininterval, maxinterval ) )
    
    // next event
    nextevent = getEventType()

    MsgC( color_green, "[EVENTS] Starting next event (" .. nextevent .. ") in " .. time .. " min(s)\n" )
    SendMessageToPlayers( "MiniNext", time )

    nexttime = CurTime()+(time*60)

    updateGlobals( nexttime, nextevent )
end

StartEventSys()

local delay = 0

function MiniCheck()
	if !enabled then return end

    if endtime > 0 && CurTime() > endtime then
        //lastevent = curevent
        EndEvent()
        endtime = 0
    end

    if nexttime > CurTime() then return end

    StartEvent( nextevent )

    local time = math.Round( math.Rand( mininterval, maxinterval ) )
    nexttime = CurTime()+(time*60)
    nextevent = getEventType()

    updateGlobals( nexttime, nextevent )

    MsgC( color_green, "[EVENTS] Starting next event (" .. nextevent .. ") in " .. time .. " min(s)\n" )
    SendMessageToPlayers( "MiniNext", time )
	
end
hook.Add("Think", "GMTEventCheckStart", MiniCheck)

concommand.Add("gmt_event_toggle", function( ply )

	if !ply:IsAdmin() then return end

	if !enabled then
        MsgC( color_green, "[EVENTS] "..ply:Nick().." has enabled the event system.\n" )

        local time = math.Round( math.Rand( mininterval, maxinterval ) )
        nexttime = CurTime()+(time*60)
		enabled = true
        for k,v in pairs( player.GetAll() ) do
            v:Msg2( T( "EventAdminEnabled", ply:Name() ), "admin" )
        end
        MsgC( color_green, "[EVENTS] Starting next event (" .. nextevent .. ") in " .. time .. " min(s)\n" )
        SendMessageToPlayers( "MiniNext", time )
    else

        if endtime > 0 then
            EndEvent()
        end

        MsgC( color_red, "[EVENTS] "..ply:Nick().." has disabled the event system.\n" )

        enabled = false

        nexttime = 0
        endtime = 0
        cursale = nil
        curmini = nil

        updateGlobals( nil, nil )

        for k,v in pairs( player.GetAll() ) do
            v:Msg2( T( "EventAdminDisabled", ply:Name() ), "admin" )
        end
    end

end )

concommand.Add("gmt_event_skip", function( ply )

	if !ply:IsAdmin() then return end

    if enabled && endtime > 0 then
        MsgC( color_red, "[EVENTS] "..ply:Nick().." has forced the event system.\n" )
        EndEvent()
        for k,v in pairs( player.GetAll() ) do
            v:Msg2( T( "EventAdminManual", ply:Name() ), "admin" )
        end
    end

end )

concommand.Add("gmt_event_start", function( ply, cmd, args )

	if !ply:IsAdmin() then return end

    if endtime > 0 then
        EndEvent()
    end

    MsgC( color_red, "[EVENTS] "..ply:Nick().." has forced the event system.\n" )

    for k,v in pairs( player.GetAll() ) do
        //SendMessageToPlayers( "EventAdminManual", ply:Name(), "admin" )
        v:Msg2( T( "EventAdminManual", ply:Name() ), "admin" )
    end
	StartEvent( args[1] )

end )

concommand.Add("gmt_event_rand", function( ply, cmd, args )

	if !ply:IsAdmin() then return end

    MsgC( color_red, "[EVENTS] "..ply:Nick().." has forced the event system.\n" )

    if endtime > 0 then
        EndEvent()
    end

    for k,v in pairs( player.GetAll() ) do
        //SendMessageToPlayers( "EventAdminManual", ply:Name(), "admin" )
        v:Msg2( T( "EventAdminManual", ply:Name() ), "admin" )
    end
	StartEvent( getEventType() )

end )