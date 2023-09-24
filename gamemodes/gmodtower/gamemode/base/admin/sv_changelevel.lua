
module( "MapChange", package.seeall )

Active = false
Changing = false
Force = false

ChangeMap = nil
ChangeTime = nil
ChangeTimeStart = nil

NotifiedTenSeconds = false

local chat_color = Color( 255, 50, 50, 255 )

function CanChangeLevel()

    local duel_ongoing = false 

    for _, v in ipairs( player.GetAll() ) do
        
        if Dueling.IsDueling( v ) then
            duel_ongoing = true
            break
        end

    end

    if duel_ongoing then
        return false
    end

    return true

end

concommand.Add( "gmt_changelevel", function( ply, command, args )
	
    if ply == NULL or ply:IsAdmin() then

        if Active then
            StopChangeLevel( ply )
            return
        end

        local canChange = CanChangeLevel()

        if not canChange then
            if IsValid( ply ) then
                ply:MsgT( "FailedMapChange" )
            end

            LogPrint( T( "FailedMapChange" ), color_red, "MapChange" )
            
            return
        end

        local isNum = tonumber( args[1] ) != nil

        local map = isNum and game.GetMap() or (args[1] or game.GetMap())
        local time = isNum and tonumber( args[1] ) or tonumber( args[2] ) or 30

		if IsLobby and GMT_IS_RESTARTING then
			if not Database.IsConnected() then return end
			Database.Query( "UPDATE `gm_casino` SET `jackpot` = 0;" )
		end
        ChangeLevel( map, time, ply )    
        
    end
	
end )

concommand.Add( "gmt_forcelevel", function( ply, command, args )
	
    if ply == NULL or ply:IsAdmin() then

        if Active then
            StopChangeLevel( ply )
            return
        end

        local map = args[1] or game.GetMap()
        local time = 0
    
        ChangeLevel( map, time, ply )
        Force = true
        
    end
	
end )

function TimeLeft()
    return (ChangeTimeStart + ChangeTime) - CurTime()
end

local function ChatNotify( notime )

    if Force then return end
    if not Active then return end

    local map = ChangeMap
    local time = math.floor( TimeLeft() )

    if map == game.GetMap() then
        GTowerChat.AddChat( notime and T( "AdminRestartMap" ) or T( "AdminRestartMapSec", time ), chat_color )
    else
        GTowerChat.AddChat( notime and T( "AdminChangeMap", map ) or T( "AdminChangeMapSec", map, time ), chat_color )
    end

end

function StopChangeLevel( caller )

    if not Active then return end

    Active = false
    Changing = false
    Force = false

	GMT_IS_RESTARTING = false
	GMT_IS_PREPARING_TO_RESTART = false
	
    ChangeMap = nil
    ChangeTime = nil
    ChangeTimeStart = nil

    NotifiedTenSeconds = false

    AdminNotif.SendStaff( Format( "%s has stopped a changelevel.", IsValid( caller ) and caller:Nick() or "CONSOLE" ), nil, "RED", 1 )
    
    GTowerChat.AddChat( "Map restart stopped...", chat_color )

end

function ChangeLevel( map, time, caller )

    map = map or game.GetMap()

    local map_path = "maps/" .. map .. ".bsp"

    if not file.Exists( map_path, "GAME" ) then

        local msg = Format( "Map \"%s\" not found on server!", map )
        
        if IsValid( caller ) then
            caller:Msg2( msg )
        end

        LogPrint( msg, color_red, "MapChange" )

        return

    end

    Active = true
    ChangeMap = map
    ChangeTime = time
    ChangeTimeStart = CurTime()

    NotifiedTenSeconds = false

    AdminNotif.SendStaff( Format( "%s has started a changelevel. (%s, %s secs)", IsValid( caller ) and caller:Nick() or "CONSOLE", ChangeMap, ChangeTime ), nil, "RED", 1 )

    ChatNotify()

    for _, v in ipairs( player.GetAll() ) do
        v:SendLua( [[surface.PlaySound( "gmodtower/misc/changelevel.wav" )]] )
    end

end

function Think()

    if Active then

        local timeleft = TimeLeft()
        
        if timeleft <= 0 then
            
            ChatNotify( true )
            Active = false

            if not Force then
                Database.SaveAll()
            end

            pcall( SQLLog, "server", "Map changed to: " .. tostring( ChangeMap ) )

            Changing = true

        end

        if ChangeTime > 20 and timeleft <= 10 and not NotifiedTenSeconds then
            ChatNotify()
            
            NotifiedTenSeconds = true
        end

    end
    
    if Changing then

        local db_queue = 0

        if not Force and Database.GetObject() and Database.GetObject().Identifier == "mysqloo" then
            db_queue = Database.GetObject().Object:queueSize()
        end

        if db_queue == 0 then
            Changing = false
            hook.Run( "LastChanceMapChange", ChangeMap )

            RunConsoleCommand( "changelevel", ChangeMap or game.GetMap() )
        end

    end

end

hook.Add( "Think", "MapChange", Think )