include("eventbase.lua")

//List of all lua files that should be included on the events folder
local IncludeList = {}

module( "minievent", package.seeall )

EnabledConvar = CreateConVar( "gmt_events_enabled", "1", { FCVAR_REPLICATED }, nil, 0, 1 )

function IsEnabled()
	return EnabledConvar:GetBool() == true
end

DEBUG = false

List = {}
Active = Active or {}

globalnet.Register( "String", "NextEvent" )
globalnet.Register( "Float", "NextEventTime" )

function GetList()
	return List
end

function GetActive()
	return Active
end

function Register( name, tbl )

	if List[ name ] != nil then
		ErrorNoHalt( "Registering a module with name '".. name .. "' twice" )
		return
	end
	
	tbl._Definition = tbl
	
	tbl.Name = name

	if tbl.Base and List[ tbl.Base ] then
		tbl = table.Inherit( tbl, List[ tbl.Base ]._Definition )
	end

	setmetatable( tbl, minievent.base )
	
	List[ tbl.Name ] = tbl
	
	if DEBUG then
		print( "Registering new event: " .. name )
	end

end

function RandomNew()

	if table.Count( List ) == 0 then
		return
	end
	
	local RandomEvent = table.Random( List )
	
	return New( 
		RandomEvent.Name, 
		math.Rand( RandomEvent.MinLength, RandomEvent.MaxLength )
	)
	
end

function RandomName()

	local pool = hook.Run( "EventsPool" ) or List

	if table.Count( pool ) == 0 then
		return
	end

	local temp_tbl = table.Copy( pool )

	if table.Count( pool ) != 1 then
		table.RemoveByValue( temp_tbl, LastEvent )
	end

	local RandomEvent = List[ table.Random( temp_tbl ) ]
	
	LastEvent = RandomEvent.Name
	return RandomEvent.Name
	
end

function Start( name )

	local Event = List[ name ]

	if !Event then
		return
	end

	return New( name, 
		math.Rand( Event.MinLength, Event.MaxLength )
	)

end

function New( name, time )

	if !List[ name ] then
		ErrorNoHalt( "Invalid minievent with name '".. name .. "'" )
	end
	
	local o = {}
	
	setmetatable( o, {
		__index = List[ name ]
	} )
	
	o.__Length = time
	o.__EndTime = CurTime() + time
	
	table.insert( Active, o )
	
	if o.Start then
		o:Start()
	end
	
	hook.Run( "NewEvent", name, o )
	
	if DEBUG then
		print( "Starting new event: " .. name )
	end
	
	return o

end

function EndAll()

	if SERVER then
		net.Start("minievent")
			net.WriteUInt( 1, 4 )
		net.Broadcast()
	end
	
	for _, v in ipairs( Active ) do
		if v.Destroy then
			v:Destroy()
		end
	end
	
end

hook.Add( "Think", "MiniEventsThink", function()
	
	for _, v in ipairs( Active ) do
		
		if v.Think then
			v:Think()
		end
		
		if CurTime() > v.__EndTime then
			if v.Destroy then
				v:Destroy()
			end
		end
	
	end

end )

for _, v in pairs( IncludeList ) do
	include( "events/" .. v )
	
	if SERVER then
		AddCSLuaFile( "events/" .. v )
	end
end