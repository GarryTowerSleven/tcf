function SetupGMTGamemode( name, folder, settings )

	GM.Name = "[GMT] " .. name

	if SERVER then
		game.ConsoleCommand('hostname "' .. GM.Name .. '" \n')
	end

	if Loadables then

		local defaultLoadables = {
			"clientsettings",
            "achievement",
            "commands",
			"afk",
            "scoreboard3",
		}

		if settings.Loadables then
			table.Add( defaultLoadables, settings.Loadables )
		end

		Loadables.Load( defaultLoadables )

	end

	-- Default stuff
	GM.AllowChangeSize = settings.AllowChangeSize or false
	GM.DrawHatsAlways = settings.DrawHatsAlways or false
	GM.UsesHands = settings.UsesHands or false

	-- Force smaller models to default player model
	if settings.DisableSmallModels then
		GM.DisableSmallModels = true
	end

	-- Disable ducking
	if settings.DisableDucking then

		if SERVER then

			hook.Add( "PlayerSpawn", "DisableDucking", function( ply ) 
				ply:SetDuckSpeed( ply:GetWalkSpeed() )
				ply:SetHullDuck( Vector(-16, -16, 0), Vector(16, 16, 72) ) -- Default hull
			end )

		else -- CLIENT

			hook.Add( "CreateMove", "DisableDucking", function( cmd )

				if ( cmd:KeyDown( IN_DUCK ) ) then
					cmd:SetButtons( cmd:GetButtons() - IN_DUCK )
				end

			end )

		end

	end

	-- Disable jumping
	if settings.DisableJumping then

		if SERVER then

			hook.Add( "PlayerSpawn", "DisableJumping", function( ply )
				ply:SetJumpPower( 0 )
			end )

		else -- CLIENT

			hook.Add( "CreateMove", "DisableJumping", function( cmd )

				if not LocalPlayer():Alive() then return end -- Allow jumping to handle respawning

				if ( cmd:KeyDown( IN_JUMP ) ) then
					cmd:SetButtons( cmd:GetButtons() - IN_JUMP )
				end

			end )

		end

	end

	-- Disable running
	if settings.DisableRunning then

		if SERVER then

			hook.Add( "PlayerSpawn", "DisableRunning", function( ply ) 
				ply:SetRunSpeed( ply:GetWalkSpeed() )
			end )

		else -- CLIENT

			hook.Add( "CreateMove", "DisableRunning", function( cmd )

				if ( cmd:KeyDown( IN_SPEED ) ) then
					cmd:SetButtons( cmd:GetButtons() - IN_SPEED )
				end

			end )

		end

	end

	if SERVER then

		-- AFK System
		if AntiAFK then
			AntiAFK.Time = settings.AFKDelay or 60
			AntiAFK.WarningTime = 10
		end

		-- No godmode allowed
		hook.Add( "AllowSpecialAdmin", "DisallowGodmode", function() return false end )

	end

	if CLIENT then
	
		-- Small players
		if settings.AllowSmall then
			hook.Add( "ShouldAutoScalePlayers", "AutoScalePlayers", function() return true end )
		end

		-- GMT menu
		if not settings.AllowMenu && not ( questioner && questioner.CanVote ) then
			hook.Add( "DisableMenu", "DisableGMTMenu", function() return true end )
		end

		-- Clicking on players
		if settings.DisablePlayerClick then
			hook.Add( "CanMousePress", "DisableClientMenu", function() return false end )
		end

		HudToHide = GtowerHudToHide

		-- Hide HUD elements
		table.uinsert( HudToHide, "CHudChat" )
		table.uinsert( HudToHide, "CHudHealth" )
		table.uinsert( HudToHide, "CHudBattery" )
		table.uinsert( HudToHide, "CHudSuitPower" )
		table.uinsert( HudToHide, "CHudAmmo" )
		table.uinsert( HudToHide, "CHudSecondaryAmmo" )

		-- Weapon selection
		if not settings.EnableWeaponSelect then
			table.uinsert( HudToHide, "CHudWeapon" )
			table.uinsert( HudToHide, "CWeaponSelection" )
		end

		-- Crosshair
		if not settings.EnableCrosshair then
			table.uinsert( HudToHide, "CHudCrosshair" )
		end

		-- Damage
		if not settings.EnableDamage then
			table.uinsert( HudToHide, "CHudDamageIndicator" )
		end

		-- Chat box
		if GTowerChat then

			if settings.ChatY then
				GTowerChat.YOffset = settings.ChatY or 400
			end

			if settings.ChatX then
				GTowerChat.XOffset = settings.ChatX or 0
			end

			if settings.ChatBGColor then
				GTowerChat.BGColor = settings.ChatBGColor
			end

			if settings.ChatScrollColor then
				GTowerChat.ScrollColor = settings.ChatScrollColor
			end

		end
	end

	local gmtfolder = "/gamemode/gmt/"

	-- Load the base GMT files
	local srvpayout = folder .. gmtfolder .. "sv_payout.lua"
	local payout = folder .. gmtfolder .. "sh_payout.lua"
	local scoreboard = folder .. gmtfolder .. "cl_scoreboard.lua"
	local multi = folder .. gmtfolder .. "multiserver.lua"

	-- Load the optional GMT files
	local pp = folder .. gmtfolder .. "cl_post_events.lua"
	local camera = folder .. gmtfolder .. "camera/" .. game.GetMap() .. ".lua"
	local particles = folder .. gmtfolder .. "cl_particles.lua"

	AddCSLuaFile( payout )
	AddCSLuaFile( scoreboard )

	-- Camera
	if file.Exists( camera, "LUA" ) then AddCSLuaFile( camera ) end

	timer.Simple( .1, function() -- Delay so we can load the gamemode first

		include( payout )

		if CLIENT then
			include( scoreboard )

			if file.Exists( camera, "LUA" ) then include( camera ) end
			if file.Exists( pp, "LUA" ) then include( pp ) end
			if file.Exists( particles, "LUA" ) then include( particles ) end
		else
			include( multi )
			include( srvpayout )
		end

	end )

	MsgC( Color( 0, 255, 255 ), "Registered and loaded gamemode: " .. name .. "\n" )

end

globalnet.Register( "Int", "State" )
globalnet.Register( "Float", "Time" )
globalnet.Register( "Int", "Round" )

// STATE
STATE_NOPLAY = 0

function GM:SetState( state )
	if not state then return end
	MsgN( "[GMode] Setting state: " .. state )
	globalnet.SetNet( "State", state )
	self.State = state
end

function GM:GetState()
	return self.State or globalnet.GetNet( "State" ) or 0
end

function GM:IsPlaying()
	return self:GetState() == STATE_PLAYING
end


-- TIME
function GM:GetTimeLeft()

	local timeLeft = ( self:GetTime() or 0 ) - CurTime()
	if timeLeft < 0 then timeLeft = 0 end

	return timeLeft

end

function GM:NoTimeLeft()
	return self:GetTimeLeft() <= 0
end

function GM:SetTime( time )
	if not time then return end
	MsgN( "[GMode] Setting time: " .. time )
	globalnet.SetNet( "Time", CurTime() + time )
end

function GM:GetTime()
	return globalnet.GetNet( "Time" )
end


-- ROUNDS
function GM:GetRoundCount()
	return globalnet.GetNet( "Round" ) or 0
end

function GM:GetRound()
	return self:GetRoundCount()
end

function GM:SetRound( round )
	globalnet.SetNet( "Round", round )
end

function GM:IncrementRound()
	self:SetRound( "Round", self:GetRound() + 1 )
end

-- CLEAN UP
local CleanUpPreserveList = { "gmt_global_network", "gmt_cosmeticbase", "gmt_hat" }

function GM:CleanUpMap( noclient, preservegame )
	local preserve = table.Copy( CleanUpPreserveList )
	table.Add( preserve, preservegame )
	game.CleanUpMap( noclient, preserve )
end


if SERVER then
	-- CONCOMMANDS
	concommand.Add( "gmt_setstate", function( ply, cmd, args ) 

		if !ply:IsAdmin() then return end
		ply:PrintMessage( HUD_PRINTCONSOLE, "[GMode] Setting state: " .. args[1] )
		GAMEMODE:SetState( tonumber( args[1] ) )

	end )

	concommand.Add( "gmt_settime", function( ply, cmd, args ) 

		if !ply:IsAdmin() then return end
		ply:PrintMessage( HUD_PRINTCONSOLE, "[GMode] Setting time: " .. args[1] )
		GAMEMODE:SetTime( tonumber( args[1] ) )

	end )
end