include( "sh_events.lua" )

module("minievent", package.seeall )

local DrawTimer = CreateClientConVar( "gmt_draweventtimer", 1, true, false )

local endtime = GetGlobalInt( "NextEventTime" )
local eventname = GetGlobalString( "NextEvent" )

function UpdateEventTimer()
	endtime = GetGlobalInt( "NextEventTime" )
	eventname = GetGlobalString( "NextEvent" )
end

local timeSinceUpdate = 0

local function displayTimer()
	if Location.IsCasino( LocalPlayer():Location() ) then return false end
	local locid = LocalPlayer():GetNet( "RoomID" )
	if locid && locid != 0 then return false end

	return true
end

DisplayNames = {
	["storesale"] = "Store Sale",
	["balloonpop"] = "Balloon Pop",
	["obamasmash"] = "Obama Smash",
	["chainsaw"] = "Chainsaw Massacre",
	["pvpnarnia"] = "PVP Narnia",
	["barfight"] = "Bar Fight",
}