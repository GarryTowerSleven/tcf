module( "analytics", package.seeall )

function postDiscord( Type, text )
	LogPrint( Format( "(%s) %s", Type, text ), nil, "Analytics" )
	/*text = "["..(Type or "Logs").."] " .. text

	local authKey = "PaLy5TCoJ5RZjqWZtVccQpRVFgXkzwwm"
	local AnalyticsURL = "http://ruch.site.nfoservers.com/deluxeanalytics.php"

	http.Post( AnalyticsURL, { key = authKey, message = text, user = "SERVER @ " .. tostring(game.GetIPAddress()) }, function( result )
	end,
	function( failed )
		MsgC( Color( 255, 0, 0 ), "/!\\---Deluxe Analytics Error---/!\\\n")
		MsgC( Color( 255, 0, 0 ), failed )
	end )*/
end

hook.Add( "InitPostEntity", "InitAnalytics", function()
    timer.Simple( 25, function()
      analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server went up at " .. tostring( game.GetIPAddress() ) )
    end)
end )

hook.Add( "ShutDown", "ShutdownAnalytics", function()
    analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server shutting down..." )
end )
