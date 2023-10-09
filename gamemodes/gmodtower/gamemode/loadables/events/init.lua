AddCSLuaFile("eventbase.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

module("minievent", package.seeall )

cvars.AddChangeCallback( "gmt_events_enabled", function( _, old, new )

	if tobool( new ) == false then
		
		if timer.Exists( "MiniEventsCaller" ) then
			timer.Remove( "MiniEventsCaller" )
		end

	else
	
		if not timer.Exists( "MiniEventsCaller" ) then
			CreateNewTimer( 180 )
		end

	end

end, "EventCallback" )

MinDelay = 20
MaxDelay = 30

NextEvent = nil
NextTime = nil

local function RandomTime()
	return math.Round( hook.Call( "EventsDelayTime", GAMEMODE ) or math.Rand( MinDelay, MaxDelay ) )
end

function CreateNewTimer( ExtraTime )

	if not IsEnabled() then return end

	local time = ( ExtraTime or 0 ) + RandomTime()
	NextTime = CurTime() + time
	
	if DEBUG then
		print("Starting next event in: " .. time .. " seconds.")
	end

	NextEvent = RandomName()

	globalnet.SetNet( "NextEvent", NextEvent or "Unknown" )
	globalnet.SetNet( "NextEventTime", NextTime )

	MsgT( "MiniNext", math.floor( time / 60 ) )

end

function NewTimer()

	local event = Start( NextEvent or RandomName() )
	if not event then return end

	// Create a new timer for the next event!
	CreateNewTimer( event:GetLength() )

end

function Start( name, length )

	local event = List[ name ]
	if not event then return end
	
	local NewEvent = New( event.Name, length or math.Rand( event.MinLength, event.MaxLength ) )
	if not NewEvent then return end
		
	NewEvent:__SendToClient()

	return NewEvent

end

hook.Add( "Think", "MiniEventsCaller", function()
	
	if not IsEnabled() then return end

	if NextTime and NextTime <= CurTime() then

		NewTimer()

	end

end )

hook.Add( "PlayerInitialSpawn", "MiniEventsStartTimer", function()
	
	// This just needs to be called once, when the first player is spawn
	hook.Remove( "PlayerInitialSpawn", "MiniEventsStartTimer" )
	
	// Start the timer to call events!
	if not timer.Exists( "MiniEventsCaller" ) then
		CreateNewTimer( 180 )
	end
	
end )

hook.Add( "PlayerInitialSpawn", "MiniEventsSendAllEvents", function( ply )

	local Active = GetActive()
	
	// Hope there is not too many minivenets and we pass 255-bytes
	
	net.Start( "minievent" )
		net.WriteUInt( 0, 4 )

		net.WriteUInt( table.Count( Active ), 8 )

		for k, v in pairs( Active ) do
	
			v:__SendToClientMessage()
		
		end
	net.Send( ply )

end )

concommand.AdminAdd( "gmt_event_start", function( ply, _, args )

	if table.Count( args ) < 1 then return end

	local event = Start( args[1], tonumber( args[2] ) )

	if not event then
		ply:PrintMessage( HUD_PRINTCONSOLE, "Invalid event \"" .. args[1] or "nil" .. "\"." )
	end

end )

concommand.AdminAdd( "gmt_event_endall", function( ply )

	EndAll()

end )

concommand.AdminAdd( "gmt_event_next", function( ply )

	NewTimer()

end )

concommand.AdminAdd( "gmt_event_setnext", function( ply, _, args )

	local event = args[1] or RandomName()

	if not List[ event ] then
		ply:PrintMessage( HUD_PRINTCONSOLE, "Invalid event \"" .. args[1] or "nil" .. "\"." )

		return
	end

	NextEvent = event
	globalnet.SetNet( "NextEvent", NextEvent or "Unknown" )

end )

util.AddNetworkString( "minievent" )