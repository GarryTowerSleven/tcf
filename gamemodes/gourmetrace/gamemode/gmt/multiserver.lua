function GAMEMODE:EndServer()

	//I guess it it good bye
	GTowerServers:EmptyServer()
	GTowerServers:ResetServer()

end

hook.Add("PlayerDisconnected", "StopServerEmpty", function(ply)

	if ply:IsBot() || #player.GetBots() > 0 then return end

	//No need to play an empty server, or by yourself
	timer.Simple( 5.0, function()

		local clients = player.GetAll() --gatekeeper.GetNumClients()
		local total = player.GetCount()

		if #player.GetBots() == 0 && total < 1 && GTowerServers:GetState() != 1 then
			GTowerServers:EmptyServer()
			RunConsoleCommand("gmt_forcelevel", ( GTowerServers:GetRandomMap() or GAMEMODE:RandomMap( "gmt_gr" ) ) )
		end

	end )

end )

hook.Add("GTowerMsg", "GamemodeMessage", function()
	if player.GetCount() < 1 then
		return "#nogame"
	else
		return tostring(math.Clamp( GAMEMODE:GetRoundCount(), 1, GAMEMODE.NumRounds )) .. "/" .. GAMEMODE.NumRounds
	end
end )
