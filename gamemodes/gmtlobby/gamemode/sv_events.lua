EventPool = EventPool or { "StoreSale", "ChainsawBattle", "FistFight", "BalloonPop", "ObamaSmash" }

if ( IsHalloween ) then
	table.RemoveByValue( EventPool, "BalloonPop" )
	table.uinsert( EventPool, "GhostPop" )
end

if ( IsChristmas ) then
	table.uinsert( EventPool, "SnowballFight" )
end

hook.Add( "EventsDelayTime", "MiniGames", function()
	return math.random( 60 * 15, 60 * 25 )
end )

hook.Add( "EventsPool", "MiniGames", function()
	return EventPool
end )