concommand.Add( "gmt_changelevel", function( ply, command, args )

	if ply == NULL or ply:IsAdmin() then

		local str = args[1] or ""

		if timer.Exists("ChangeLevelTimer") then
			timer.Destroy("ChangeLevelTimer")
			GAMEMODE:ColorNotifyAll( "Halting map restart...", Color(225, 20, 20, 255) )
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
				MsgC( co_color2, "You cannot change levels while there is poker or duel going. Use gmt_forcelevel to override this." )
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

local function FinalChangeHook(MapName)
	hook.Call("LastChanceMapChange", GAMEMODE, MapName)

	RunConsoleCommand("changelevel", MapName)
end

function ChangeLevel( map, ply )

	local FilePlace = "maps/"..map..".bsp"
	local MapName = map

	if file.Exists(FilePlace,"GAME") then

		if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMapSec", DefaultTime ), Color(225, 20, 20, 255) )
		else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMapSec", map, DefaultTime ), Color(225, 20, 20, 255) )
		end

		for k,v in pairs(player.GetAll()) do
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
			if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMap" ), Color(225, 20, 20, 255) )
			else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMap", map ), Color(225, 20, 20, 255) )
			end

			analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server shutting down..." )

			timer.Simple(0.5,function()
				FinalChangeHook(MapName)
			end)
		end)

	else
		ply:Msg2("'"..map.."' not found on server!")
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
		ply:Msg2("'"..map.."' not found on server!")
	end
end