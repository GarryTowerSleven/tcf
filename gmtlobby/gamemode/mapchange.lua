GMT_IS_PREPARING_TO_RESTART = false
ADMIN_RESTART = false

concommand.Add("gmt_updateserver", function( ply, cmd, args )
	if !ply:IsAdmin() then return end
	ADMIN_RESTART = true
end)

if string.StartWith(game.GetMap(),"gmt_lobby") then

timer.Create("gmt_autorestart",10,0,function()
	if GMT_IS_PREPARING_TO_RESTART then return end
	local CurSysTime = os.date( '%H:%M' , os.time() )
	if CurSysTime == "07:00" || ADMIN_RESTART then

		GMT_CHANGE_MAP = "gmt_lobby2_r3"
		RESTART_TIME = 30

		GMT_IS_PREPARING_TO_RESTART = true

		GAMEMODE:ColorNotifyAll( T( "AutoRestartMap", 5 ), Color(225, 20, 20, 255) )
		analytics.postDiscord( "Logs", "Performing midnight restart in 5 minutes..." )

		timer.Simple(5*60,function()

			local DuelGoingOn = false

			for k,v in pairs( player.GetAll() ) do
				if v.ActiveDuel then
					DuelGoingOn = true
				end
			end

			if DuelGoingOn then

				timer.Create("gmt_is_ready_yet",1,0,function()
					local DuelGoingOn = false

					for k,v in pairs( player.GetAll() ) do
						if v.ActiveDuel then
							DuelGoingOn = true
						end
					end

					if !DuelGoingOn then
						RunConsoleCommand("gmt_changelevel",GMT_CHANGE_MAP,RESTART_TIME)
					end
				end)

			else
				RunConsoleCommand("gmt_changelevel",GMT_CHANGE_MAP,RESTART_TIME)
			end

		end)

	end
end)

end