GM.Name 	= "GMod Tower"
GM.Author	= "Deluxe Team & PixelTail Games"
GM.AllowSpecialModels = true
GM.AllowEquippables = true

GM.UsesHands = true

IsLobby = true

DeriveGamemode( "gmodtower" )

team.SetUp(1, "Tower Fans", team.GetColor(TEAM_UNASSIGNED), true)

include("player_class/player_lobby.lua")

function IsHalloweenMap( map )
	local map = map or game.GetMap()

	if IsLobby then
		return map[11] == "h"
	end

	return false
end

function IsChristmasMap( map )
	local map = map or game.GetMap()

	if IsLobby then
		return map[11] == "c"
	end

	return false
end

function IsHolidayMap()
	return ( IsHalloweenMap() || IsChristmasMap() )
end

Loadables.Load( {

	-- Lobby
	---------------------------------------------------------
	"soundbrowser",			-- Sound browser
	--"bassemitstream",		-- Emit stream (radios)
	--"ragdollcontroller",	-- Player ragdolling
	"npc_chat",				-- Chatting NPCs (suite and PVP Battle)
	"animation",			-- Force animation system
	--"ambiance",			-- Old Ambient music
	--"enchant",			-- Player enchantments
	"trivia",				-- Trivia
	--"funmeter",			-- Fun Meter (experimental minigame)
	--"spawner",			-- Special spawner (presents and candy)

	-- WIP/Unfinished
	---------------------------------------------------------
	--"advertisement",		-- Advertisement system (WIP)
	--"lscontrol",			-- for live.gmtower.org
	--"autorestart" 		-- Manages restarting the server every so often (WIP)
	--"websocket",			-- WebSocket connection for cross-server/web chat
	--"racing",				-- Silly little minigame (WIP)
	--"boss",				-- Boss battle (WIP)

	-- Mediaplayer
	---------------------------------------------------------
	"mediaplayer",			-- Media player

	-- Base Modules
	---------------------------------------------------------
	"inventory",			-- Inventory and items
	"clientsettings",		-- Client systems (GMC networking, etc.)
	"clsound",				-- Clientside emitsound sent by serverside actions
	"group",				-- Group
	"achievement",			-- Achievements
	"hacker",				-- Hacker logging
	"npc",					-- Store NPCs
	"room",					-- Suite/condo system
	"scoreboard",			-- Scoreboard
	"store",				-- Stores
	"multiserver",			-- Multiserver
	"location",				-- Location system
	"seats",				-- Seat manager
	--"gibsystem",			-- Gibs
	"thirdperson",			-- Thirdperson
	"commands",				-- Chat commands (required for emotes)
	"afk",					-- AFK kicker
	"drunk", 				-- Drunk system
	--"events",				-- Random events (sales, minigames)
	"emote",				-- Player emote system (ie. /dance)
	"duel",					-- Player dueling
	"legs",					-- First person legs
	--"arcade",				-- Arcade API
	"contentmanager",		-- Alerts players when they're missing a required game or addon
	"fakeclientmodel",		-- Less-specific version of fakeself for drastic clientmodel modifications
	"ping",					-- Pings the clients to detect for server crashes
	"soundscape",			-- Soundscape system
	"theater", 				-- Theater built with the media player
	"mapdata",				-- Map specific fixes and additions
	"painsounds",			-- Player Voicelines
	//"emotion",			-- I'm hurting, Gordon!

	-- Items Depend On These
	---------------------------------------------------------
	"jetpack",				-- Jetpacks
	"bonemod",				-- Bone modifications
	"pet",					-- Pets
	"cards",				-- Poker module
	"minecraftskins",		-- Minecraft Steve model skins
	"auction",				-- Auction tables

	-- Debugging/Tools
	---------------------------------------------------------
	"weaponfix",			-- Fixes weapon viewmodels
	"errortrace",			-- Error debugging tracing

	-- UI/Misc
	---------------------------------------------------------
	"question",				-- Global voting
	-- "multicore",			-- Possible Performance Booster

	-- Weapons
	---------------------------------------------------------
	--"weaponmanager",		-- Manages minigame weapons and such
	"pvp",					-- PVP weapons
	"virus",				-- Virus weapons

	-- EXPERIMENTAL
	---------------------------------------------------------
	-- "models",			-- Outfits
	-- "miku",				-- Ghost of Miku

} )

function CanPlayerUse( arg1, arg2 )

	local ply, ent
	if CLIENT and !IsValid( arg2 ) then

		-- one argument can only be done clientside
		ply = LocalPlayer()
		ent = arg1

	else

		-- two args: ply and ent
		ply = arg1
		ent = arg2

	end
	if !IsValid( ply ) or !IsValid( ent ) then return nil end

	if ply:InVehicle() then return nil end
	if ent.HideTooltip then return nil end

	local class = ent:GetClass()

	-- Seats
	if seats.ChairOffsets[ ent:GetModel() ] then return "SIT" end

	-- Support custom prop sounds
	if class == "prop_physics_multiplayer" and ( (ply._NextUse or 0) < CurTime() ) then
		local Item = GTowerItems:GetTableByEntity( ent )
		if Item and Item.UseSound then
			return "TOUCH"
		end
	end

	// multiserver leave/join/offline
	if class == "gmt_multiserver" then
		if ent.ServerName && ent.ServerName == "Loading..." then
			return "GAMEMODE UNAVAILABLE, CHECK BACK LATER", true
		end

		if ent.ServerGamemode && LocalPlayer():GetNWString("QueuedGamemode") == ent.ServerGamemode then
			return "LEAVE"
		end

		return "JOIN"
	end

	-- Support custom entities
	if ent.CanUse then
		local enter, message = ent:CanUse( ply )
		return message, not enter
	end

	-- Doors
	if string.match(class, "func_door*") then return "OPEN/CLOSE" end

	-- Any props should be ignored
	if class == "prop_physics" or class == "prop_dynamic" or class == "prop_dynamic_override" then
		return nil
	end

	-- Just in case
	if ent.OnUse then
		return "USE"
	end

	return nil

end

function GM:PlayerUseTrace( ply, filter )

	if !filter then
		filter = ply
	end

	local pos = ply:EyePos()
	local trace = util.TraceLine({
		["start"] = pos,
		["endpos"] = pos + ( ply:GetAimVector() * 96 ),
		["filter"] = filter
	})

	return trace.Entity

end

function GM:FindUseEntity( ply, ent )

	local usable = self:PlayerUseTrace( ply, player.GetAll() ) -- getting players in location doesn't work with bots
	if IsValid( usable ) and CanPlayerUse( ply, usable ) then

		return usable

	end

	return ent

end

function GM:OnPlayerHitGround() return true end -- Disable fall damage sound

hook.Add("GTowerPhysgunPickup", "NoFuncForFun", function( ply, ent )
	local phys = ent:GetPhysicsObject()
	if IsValid( phys ) then
		phys:EnableMotion( true )
		phys:Wake()
	end

	local Class = ent:GetClass()
	if string.sub( Class, 1, 5 ) == "func_" or string.sub( Class, 1, 10 ) == "prop_door_" then
		return false
	end

	if ent:GetModel() == "models/gmod_tower/suite_bath.mdl" then
		return false
	end

	// No picking up of chairs
	if ent:GetClass() == "prop_vehicle_prisoner_pod" then
		return false
	end

	// Forbid anyone to pickup the live camera.
	if ent:IsPlayer() && ent:IsLiveStream() then
		return false
	end
end )

function GM:ShouldCollide( ent1, ent2 )
	if IsValid( ent1:GetNWEntity("DuelOpponent") ) && IsValid( ent2:GetNWEntity("DuelOpponent") ) then return true end
	return true // !(ent1:IsPlayer() and ent2:IsPlayer())
end