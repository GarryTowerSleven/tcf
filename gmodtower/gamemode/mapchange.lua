
module("GTowerMapChange", package.seeall )

DefaultTime = 10

SetGlobalInt( "NewTime", 0 )
SetGlobalBool( "ShowChangelevel", false )

GMT_IS_PREPARING_TO_RESTART = false

if string.StartWith(game.GetMap(),"gmt_lobby") then

timer.Create("gmt_autorestart",10,0,function()
	if GMT_IS_PREPARING_TO_RESTART then return end
	local CurSysTime = os.date( '%H:%M' , os.time() )
	if CurSysTime == "07:00" then

		GMT_CHANGE_MAP = "gmt_lobby2_r7"

		if time.IsHalloween() then
			GMT_CHANGE_MAP = GMT_CHANGE_MAP .. "h"
		elseif time.IsChristmas() then
			GMT_CHANGE_MAP = GMT_CHANGE_MAP .. "c"
		end

		GMT_IS_PREPARING_TO_RESTART = true

		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("GMod Tower will be restarted in 5 minutes. Your items and stats will be saved.", Color(225, 20, 20, 255))]])
			analytics.postDiscord( "Logs", "Performing midnight restart in 5 minutes..." )
		end

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
						RunConsoleCommand("gmt_changelevel",GMT_CHANGE_MAP)
					end
				end)

			else
				RunConsoleCommand("gmt_changelevel",GMT_CHANGE_MAP)
			end

		end)

	end
end)

end

concommand.Add( "gmt_changelevel", function( ply, command, args )

	if ply == NULL or ply:IsAdmin() then

		local str = args[1] or ""

		if timer.Exists("ChangeLevelTimer") then

			timer.Destroy("ChangeLevelTimer")

			for k,v in pairs(player.GetAll()) do
				v:SendLua([[GTowerChat.Chat:AddText("Halting map restart...", Color(225, 20, 20, 255))]])
			end
			return
		end

		local DuelGoingOn = false

		for k,v in pairs( player.GetAll() ) do
			if v.ActiveDuel then
				DuelGoingOn = true
			end
		end

		if DuelGoingOn then
			if ply:IsValid() then
				ply:MsgT("FailedMapChange")
			else
				print("You cannot change levels while there is poker or duel going. Use forcechangelevel to override this.")
			end
			return
		end

		if str == '' then
			ChangeLevel( game.GetMap(), ply )
		else
			ChangeLevel( str, ply )
		end
	else
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, command, args )
		end
	end

end )

concommand.Add( "gmt_forcelevel", function( ply, command, args )

	if ply == NULL or ply:IsAdmin() then

		local str = args[1] or ""

		if str == '' then
			ForceLevel( game.GetMap(), ply )
		else
			ForceLevel( str, ply )
		end

	else
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, command, args )
		end
	end

end )

concommand.Add( "forcechangelevel", function( ply, command, args )

	local str = args[1]

	if ply == NULL or ply:IsAdmin() then
		RunConsoleCommand("changelevel", str)
	end

end )

local function FinalChangeHook(MapName)
	hook.Call("LastChanceMapChange", GAMEMODE, MapName)

	RunConsoleCommand("changelevel", MapName)
end

function ChangeLevel( map, ply )

	local FilePlace = "maps/"..map..".bsp"
	local MapName = map

	if file.Exists(FilePlace,"GAME") then
		for k,v in pairs(player.GetAll()) do
			v:SendLua([[GTowerChat.Chat:AddText("Changing map to ]]..map..[[ in ]]..DefaultTime..[[ seconds...", Color(225, 20, 20, 255))]])
			v:SendLua([[surface.PlaySound( "gmodtower/misc/changelevel.wav" )]])
		end

		local ChangeName

		if IsValid(ply) then
			ChangeName = string.SafeChatName(ply:Nick())
		else
			ChangeName = "CONSOLE"
		end

		analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server changing level to " .. map .. "... [".. ChangeName .."]" )

		timer.Create("ChangeLevelTimer", (DefaultTime - 0.5), 1, function()
			for k,v in pairs(player.GetAll()) do
				v:SendLua([[GTowerChat.Chat:AddText("Changing map to ]]..map..[[...", Color(225, 20, 20, 255))]])
			end

			analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server shutting down..." )

			timer.Simple(0.5,function()
				FinalChangeHook(MapName)
			end)
		end)

	else
		ply:Msg2("'"..map.."' not found on server! Use forcechangelevel to force a level change.")
	end
end

function ForceLevel( map, ply )
	local FilePlace = "maps/"..map..".bsp"
	local MapName = map

	if file.Exists(FilePlace,"GAME") then

		local ChangeName

		if IsValid(ply) then
			ChangeName = string.SafeChatName(ply:Nick())
		else
			ChangeName = "CONSOLE"
		end

		analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server changing level to " .. map .. "... [".. ChangeName .."]" )
		analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server shutting down..." )

		FinalChangeHook(MapName)

	else
		ply:Msg2("'"..map.."' not found on server! Use forcechangelevel to force a level change.")
	end
end