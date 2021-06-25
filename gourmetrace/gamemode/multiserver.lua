function GM:EndServer()
	//I guess it it good bye
	GTowerServers:EmptyServer()

	timer.Simple(10,function()
		for k,v in pairs(player.GetAll()) do
			v:Kick("Not redirected!")
		end

		local map = (GTowerServers:GetRandomMap() or GAMEMODE:RandomMap( "gmt_gr" ))
		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("Changing map to ]]..map..[[...", Color(225, 20, 20, 255))]])
		end
		hook.Call("LastChanceMapChange", GAMEMODE, map)
		RunConsoleCommand("changelevel", map)

	end)

end

hook.Add("PlayerDisconnected", "StopServerEmpty", function(ply)

	if ply:IsBot() || #player.GetBots() > 0 then return end

	//No need to play an empty server, or by yourself
	timer.Simple( 5.0, function()

		local clients = player.GetAll() --gatekeeper.GetNumClients()
		local total = player.GetCount()

		if #player.GetBots() == 0 && total < 1 && GTowerServers:GetState() != 1 then
			GTowerServers:EmptyServer()
			RunConsoleCommand("changelevel", ( GTowerServers:GetRandomMap() or GAMEMODE:RandomMap( "gmt_gr" ) ) )
		end

	end )

end )

hook.Add("GTowerMsg", "GamemodeMessage", function()
	if player.GetCount() < 1 then
		return "#nogame"
	else
		return tostring(math.Clamp( GetGlobalInt("Round"), 1, GAMEMODE.NumRounds )) .. "/" .. GAMEMODE.NumRounds
	end
end )
