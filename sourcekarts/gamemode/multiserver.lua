
function GM:EndServer()
	//I guess it it good bye
	GTowerServers:EmptyServer()

	--timer.Simple( 2.5, ChangeLevel, GTowerServers:GetRandomMap() or GAMEMODE:RandomMap( "gmt_ballracer" ) )
	timer.Simple(10,function()
		for k,v in pairs(player.GetAll()) do
			v:Kick("Not redirected!")
		end

		local map = (GTowerServers:GetRandomMap() or GAMEMODE:RandomMap( "gmt_sk" ))
		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("Changing map to ]]..map..[[...", Color(225, 20, 20, 255))]])
		end
		hook.Call("LastChanceMapChange", GAMEMODE, map)
		RunConsoleCommand("changelevel", map)

	end)

	Msg( " !! You are all dead !!\n" )

end

function GM:EnterPlayingState()
	if self.CurrentLevel == 0 then
		self:AdvanceLevelStatus()
	end

	self:SetState( 2 )
end
