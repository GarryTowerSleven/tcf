module("GTowerMapChange", package.seeall )

DefaultTime = 10

SetGlobalInt( "NewTime", 0 )
SetGlobalBool( "ShowChangelevel", false )

concommand.Add( "gmt_changelevel", function( ply, command, args )

	if ply == NULL or ply:IsAdmin() then

		local map = args[1] or ""
		local time = tonumber(args[2]) or 30

		if timer.Exists("ChangeLevelTimer") then
			timer.Destroy("ChangeLevelTimer")
			timer.Destroy("ChangeLevelWarning")
			GAMEMODE:ColorNotifyAll( "Halting map restart...", Color(255, 50, 50, 255) )
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

		if map == '' then
			ChangeLevel( ply, game.GetMap(), time )
		else
			ChangeLevel( ply, map, time )
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

function ChangeLevel( ply, map, time )

	local FilePlace = "maps/"..map..".bsp"
	local MapName = map

	if file.Exists(FilePlace,"GAME") then

		if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMapSec", time ), Color(255, 50, 50, 255) )
		else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMapSec", map, time ), Color(255, 50, 50, 255) )
		end

		/*for k,v in pairs(player.GetAll()) do
			v:SendLua([[surface.PlaySound( "gmodtower/misc/changelevel.wav" )]])
		end*/

		local ChangeName

		if IsValid(ply) then
			ChangeName = string.SafeChatName(ply:Nick())
		else
			ChangeName = "CONSOLE"
		end

		analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server changing level to " .. map .. "... [".. ChangeName .."]" )

		if time > 10 then
			timer.Create("ChangeLevelWarning", time - 10, 1, function()
				if game.GetMap() == MapName then
					GAMEMODE:ColorNotifyAll( T( "AdminRestartMapSec", 10), Color(255, 50, 50, 255) )
				else
					GAMEMODE:ColorNotifyAll( T( "AdminChangeMapSec", map, 10 ), Color(255, 50, 50, 255) )
				end
			end)
		end

		timer.Create("ChangeLevelTimer", (time), 1, function()
			if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMap" ), Color(255, 50, 50, 255) )
			else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMap", map ), Color(255, 50, 50, 255) )
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

		if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMap" ), Color(255, 50, 50, 255) )
		else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMap", map ), Color(255, 50, 50, 255) )
		end

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