function GM:EndServer()

	GTowerServers:EmptyServer()

	timer.Simple(10,function()
		for k,v in pairs(player.GetAll()) do
			v:Kick("Not redirected!")
		end

		local map = (GTowerServers:GetRandomMap() or GAMEMODE:RandomMap( "gmt_minigolf" ))
		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("Changing map to ]]..map..[[...", Color(225, 20, 20, 255))]])
		end
		hook.Call("LastChanceMapChange", GAMEMODE, map)
		RunConsoleCommand("changelevel", map)

	end)

end
