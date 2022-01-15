module("GTowerMapChange", package.seeall )

DefaultTime = 10

SetGlobalInt( "NewTime", 0 )
SetGlobalBool( "ShowChangelevel", false )

concommand.Add( "gmt_changelevel", function( ply, command, args )

	if ply == NULL or ply:IsAdmin() then

		local map = ""
		local time = 30
		if args[1] && tonumber(args[1]) then
			time = tonumber(args[1])
		elseif args[1] then
			map = args[1]
		end

		if tonumber(args[2]) then
			time = tonumber(args[2])
		end

		local name
		if ply == NULL then
			name = "CONSOLE"
		else
			name = ply:Nick()
		end

		if timer.Exists("ChangeLevelTimer") then
			timer.Destroy("ChangeLevelTimer")
			timer.Destroy("ChangeLevelWarning")
			AdminNotif.SendStaff( name .. " has haulted the changelevel.", nil, "RED", 1 )
			GAMEMODE:ColorNotifyAll( "Halting map restart...", Color(255, 50, 50, 255) )
			MsgC( co_color2, "Halting map restart...\n" )
			return
		end

		local DuelGoingOn = false

		for k,v in pairs( player.GetAll() ) do
			if Dueling.IsDueling( v ) then
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
	timer.Simple(0.25,function()
		hook.Call("LastChanceMapChange", GAMEMODE, MapName)

		RunConsoleCommand("changelevel", MapName)

		if GTowerServers.EmptyingServer then
			for _, v in pairs( player.GetAll() ) do
				v:Kick( "Not redirected" )
			end
		end
	end)
end

function ChangeLevel( ply, map, time )

	local FilePlace = "maps/"..map..".bsp"
	local MapName = map

	if file.Exists(FilePlace,"GAME") then

		local name
		if ply == NULL then
			name = "CONSOLE"
		else
			name = ply:Nick()
		end

		AdminNotif.SendStaff( name .. " has initiated a changelevel.", nil, "RED", 1 )

		if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMapSec", time ), Color(255, 50, 50, 255) )
			MsgC( co_color2, T( "AdminRestartMapSec", time ) .. "\n" )
		else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMapSec", map, time ), Color(255, 50, 50, 255) )
			MsgC( co_color2, T( "AdminChangeMapSec", map, time ) .. "\n" )
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

		if time > 10 then
			timer.Create("ChangeLevelWarning", time - 10, 1, function()
				if game.GetMap() == MapName then
					GAMEMODE:ColorNotifyAll( T( "AdminRestartMapSec", 10), Color(255, 50, 50, 255) )
					MsgC( co_color2, T( "AdminRestartMapSec", 10 ) .. "\n" )
				else
					GAMEMODE:ColorNotifyAll( T( "AdminChangeMapSec", map, 10 ), Color(255, 50, 50, 255) )
					MsgC( co_color2, T( "AdminChangeMapSec", map, 10 ) .. "\n" )
				end
			end)
		end

		timer.Create("ChangeLevelTimer", (time), 1, function()
			if game.GetMap() == MapName then
			GAMEMODE:ColorNotifyAll( T( "AdminRestartMap" ), Color(255, 50, 50, 255) )
			MsgC( co_color2, T( "AdminRestartMap" ) .. "\n" )
			else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMap", map ), Color(255, 50, 50, 255) )
			MsgC( co_color2, T( "AdminChangeMap", map ) .. "\n" )
			end

			analytics.postDiscord( "Logs", engine.ActiveGamemode() .. " server shutting down..." )

			FinalChangeHook(MapName)
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
			MsgC( co_color2, T( "AdminRestartMap" ) .. "\n" )
		else
			GAMEMODE:ColorNotifyAll( T( "AdminChangeMap", map ), Color(255, 50, 50, 255) )
			MsgC( co_color2, T( "AdminChangeMap", map ) .. "\n" )
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