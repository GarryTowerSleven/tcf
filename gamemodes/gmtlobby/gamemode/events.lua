hook.Add( "EventsDelayTime", "MiniGames", function()
	return math.random( 60 * 15, 60 * 25 )
end )

local event_pool = { "StoreSale", "ChainsawBattle", "FistFight", "BalloonPop", "ObamaSmash" }
hook.Add( "EventsPool", "MiniGames", function()
	return event_pool
end )


local events = { "sale", "chainsaw", "fistfight", "balloonpop", "obamasmash" }

for _, v in ipairs( events ) do
	
	local path = "events/" .. v .. ".lua"

	if SERVER then
		AddCSLuaFile( path )
	end

	include( path )

end