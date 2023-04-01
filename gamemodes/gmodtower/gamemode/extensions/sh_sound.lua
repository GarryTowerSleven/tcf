if SERVER then

	util.AddNetworkString( "sound.BroadcastURL" )

	function sound.BroadcastURL( url, options )

		net.Start( "sound.BroadcastURL" )
			net.WriteString( url )
			net.WriteString( options or "" )
		net.Send( player.GetAll() )

	end

else

	local BroadcastChannels = {}

	local playstr = "Playing audio stream for '%s'"
	local failstr = "Failed to play audio stream for '%s'"

	local function ReceiveBroadcastURL(len)

		local url = net.ReadString()
		local options = net.ReadString()

		sound.PlayURL( url, options, function( channel )

			if not channel then
				MsgRainbow( failstr:format(url) )
				return
			end

			channel:Play()

			MsgRainbow( playstr:format(url) )

			table.insert( BroadcastChannels, channel )

		end )

	end
	net.Receive( "sound.BroadcastURL", ReceiveBroadcastURL )

	local function StopAllBroadcastURLs()
		for k, channel in pairs(BroadcastChannels) do
			if channel:IsValid() then
				channel:Stop()
			end
		end
		table.Empty( BroadcastChannels )
	end
	concommand.Add( "gmt_stopbroadcasturls", StopAllBroadcastURLs )

end