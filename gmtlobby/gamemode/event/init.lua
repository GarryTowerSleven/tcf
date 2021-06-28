
local EventSound = "gmodtower/misc/notifyevent.wav"
if time.IsChristmas() then EventSound = "gmodtower/music/christmas/eventnotify.mp3" end

local minigameslist = { "balloonpop", "chainsaw", "snowbattle", "obamasmash" }
local eventlist = { "balloon", "battle", "obama", "storesale", "tronarnia" }
local shopslist = { 1, 2, 3, 4, 5, 6, 7, 8, 11, 13, 15, 16, /*17,*/ 20, 22, 23, 24, 25, 26, 27 }

local enabled = true
local curevent = "Unknown"
local nextevent = "Unknown"
local nexttype = "Unknown"
local endtime = 0

local lastevent = 0

// Min/max Time Interval
local mininterval = 20
local maxinterval = 45

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

function StartEvent( event )

    curevent = event

    local time = math.Round( math.Rand( mininterval, maxinterval ) )
    nexttime = CurTime()+(time*60)
    nextevent = getEventType()

    if event == "storesale" then
        local store = table.Random(shopslist)
        local discount = math.Round( math.Rand(minsale,maxsale) )

        cursale = store

        endtime = CurTime() + saletime

        //for k,v in pairs(player.GetAll()) do v:SendLua([[surface.PlaySound("]]..EventSound..[[")]]) end

        //print( "[EVENTS] " .. T( "MiniNext", time ) )
        print("[EVENTS] Starting " ..  discount .. "% sale at " .. GTowerStore.Stores[ store ].WindowTitle )

        SendMessageToPlayers( "MiniStoreGameStart", discount, GTowerStore.Stores[ store ].WindowTitle )

        GTowerStore:BeginSale(store, discount*.01)
    elseif event == "balloon" then
        local MiniGame = minigames[ "balloonpop" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "balloonpop"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        print("[EVENTS] Starting balloonpop!" )

        endtime = CurTime() + minitime

    elseif event == "obama" then
        local MiniGame = minigames[ "obamasmash" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "balloonpop"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        print("[EVENTS] Starting obama smash!" )

        endtime = CurTime() + minitime

    elseif event == "battle" then
        local MiniGame = minigames[ "chainsaw" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "chainsaw"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        print("[EVENTS] Starting chainsaw!" )

        endtime = CurTime() + minitime

    elseif event == "tronarnia" then
        local MiniGame = minigames[ "tronarnia" ]

        if !MiniGame then
            SendMessageToPlayers( "EventError" )
            enabled = false
            return
        end

        curmini = "tronarnia"
        
        SendMessageToPlayers( MiniGame._M.MinigameMessage, ( MiniGame._M.MinigameArg1 or "" ), ( MiniGame._M.MinigameArg2 or "" ) )
    
        SafeCall( MiniGame.Start, "" )
        print("[EVENTS] Starting tronarnia!" )

        endtime = CurTime() + minitime

    end

end

function EndEvent()

    if curevent == "storesale" then
        GTowerStore:EndSale(cursale)
        print( "[EVENTS] Sale ended at " .. GTowerStore.Stores[ cursale ].WindowTitle )
    elseif curevent == "balloon" then
        SafeCall( minigames[ "balloonpop" ].End )
        print( "[EVENTS] Balloonpop ended" )
    elseif curevent == "obama" then
        SafeCall( minigames[ "obamasmash" ].End )
        print( "[EVENTS] Obamasmash ended" )
    elseif curevent == "battle" then
        SafeCall( minigames[ "chainsaw" ].End )
        print( "[EVENTS] Chainsaw ended" )
    elseif curevent == "tronarnia" then
        SafeCall( minigames[ "tronarnia" ].End )
        print( "[EVENTS] Tronarnia ended" )
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

    print("[EVENTS] Starting next event (" .. nextevent .. ") in " .. time .. " min(s)" )
    SendMessageToPlayers( "MiniNext", time )

    nexttime = CurTime()+(time*60)
end

StartEventSys()

local delay = 0

function MiniCheck()
	if !enabled then return end

    // debug
    //if CurTime() > delay then
    //    print( "NEXTIME " .. math.Round( (nexttime - CurTime())/60, 2 ) )
    //    print( "ENDTIME " .. math.Round( (endtime - CurTime())/60, 2 ) )
    //    delay = CurTime() + 10
    //end

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

    print("[EVENTS] Starting next event (" .. nextevent .. ") in " .. time .. " min(s)" )
    SendMessageToPlayers( "MiniNext", time )
	
end
hook.Add("Think", "GMTEventCheckStart", MiniCheck)

concommand.Add("gmt_event_toggle", function( ply )

	if !ply:IsAdmin() then return end

	if !enabled then
        local time = math.Round( math.Rand( mininterval, maxinterval ) )
        nexttime = CurTime()+(time*60)
		enabled = true
        for k,v in pairs( player.GetAll() ) do
            v:Msg2( T( "EventAdminEnabled", ply:Nick() ), "admin" )
        end
        SendMessageToPlayers( "MiniNext", time )
    else

        if endtime > 0 then
            EndEvent()
        end

        enabled = false

        nexttime = 0
        endtime = 0
        cursale = nil
        curmini = nil

        for k,v in pairs( player.GetAll() ) do
            v:Msg2( T( "EventAdminDisabled", ply:Nick() ), "admin" )
        end
    end

end )

concommand.Add("gmt_event_skip", function( ply )

	if !ply:IsAdmin() then return end

    if enabled && endtime > 0 then
        EndEvent()
        for k,v in pairs( player.GetAll() ) do
            v:Msg2( T( "EventAdminManual", ply:Nick() ), "admin" )
        end
    end

end )

concommand.Add("gmt_event_start", function( ply, cmd, args )

	if !ply:IsAdmin() then return end

    if endtime > 0 then
        EndEvent()
    end

    for k,v in pairs( player.GetAll() ) do
        //SendMessageToPlayers( "EventAdminManual", ply:Nick(), "admin" )
        v:Msg2( T( "EventAdminManual", ply:Nick() ), "admin" )
    end
	StartEvent( args[1] )

end )

concommand.Add("gmt_event_rand", function( ply, cmd, args )

	if !ply:IsAdmin() then return end

    if endtime > 0 then
        EndEvent()
    end

    for k,v in pairs( player.GetAll() ) do
        //SendMessageToPlayers( "EventAdminManual", ply:Nick(), "admin" )
        v:Msg2( T( "EventAdminManual", ply:Nick() ), "admin" )
    end
	StartEvent( getEventType() )

end )