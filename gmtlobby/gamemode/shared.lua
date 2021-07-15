
GM.Name     = "GMTower"
GM.Author   = "GMT: Deluxe Team"
GM.Website  = "http://www.gmtdeluxe.org/"
GM.AllowSpecialModels = true
GM.AllowEquippables = true
GM.AllowJetpack = true

DeriveGamemode("gmodtower")

Loadables.Load( {

	-- Old/Unused
	--------------------------------------------------------
	--"soundbrowser",					-- Soundbrowser (broken)
	--"bassemitstream",				-- Sound streams (unused)
	--"npc_chat",							-- Lobby 1 NPC talk module (no longer used in Deluxe)

	-- Base Modules
	---------------------------------------------------------
	"commands",							-- Chat commands
	"achivement",						-- Achievements
	//"boss",									-- WIP boss battle
	"soundscape",						-- Soundscapes and background music
	"condopanel",						-- Condo OS
	"condoupgrades",						-- Condo Upgrades
	//"multicore",						-- Forces multicore, improves FPS
	"friends",							-- Friend and blocking system
	"group",								-- Player group system
	"clsound",							-- Clientside sounds
	"hacker",								-- Hacker logs
	--"racing",								-- Silly little minigame
	"inventory",						-- Inventory module
	"clientsettings",						-- Client systems (GMC networking, etc.)
	"duel",									-- Dueling
	"room",									-- Condo module
	"ping",									-- Lost connection prompt
	"emote",								-- Emotes!
	"scoreboard3",					-- Scoreboard
	"store",								-- Stores and items
	"multiserver",					-- Join panels and gamemode definitions
	"location",							-- Location system
	"mapdata",							-- Map Specific Fixes
	--"gibsystem",					-- Bloody gibs for Chainsaw battle
	"afk2",									-- AFK system
	"ragdollcontroller",		-- Ragdoll controller
	"thirdperson",					-- Manages going thirdperson and exclusions
	"animation",						-- Player animation
	"legs",									-- First person legs
	"fakeclientmodel",			-- Fake player models for use such as the monorail
	"question",					    -- Global voting
	"contentmanager",			  -- Missing Content Notification
	"vipglow", 						  -- Glow for players

	-- Items Depend On These
	---------------------------------------------------------
	"minecraftskins",				-- Minecraft Steve model skins
	"jetpack",							-- Jetpacks
	"seats",								-- Seats module
	"bonemod",							-- Bone modifications
	"cards",								-- Poker module
	"pet",									-- Pets

	-- Debugging/Tools
	---------------------------------------------------------
	"weaponfix",						-- Fixes weapon viewmodels
	"errortrace",						-- Error debugging tracing

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
	if ChairOffsets[ ent:GetModel() ] then return "SIT" end

	-- Support custom prop sounds
	if class == "prop_physics_multiplayer" and ( (ply._NextUse or 0) < CurTime() ) then
		local Item = GTowerItems:GetTableByEntity( ent )
		if Item and Item.UseSound then
			return "TOUCH"
		end
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

function GM:ShouldCollide(ent1, ent2)
	if ent1.ActiveDuel and ent2.ActiveDuel then return true end
	return !(ent1:IsPlayer() and ent2:IsPlayer())
end

function GM:OnPlayerHitGround( ply, inWater, onFloater, speed )
	return true
end

hook.Add( "KeyPress", "SuiteDoorE", function( ply, key )
	if CLIENT then return end
	if ( key == IN_USE ) then
		local ent = ply:GetEyeTrace().Entity
		if !IsValid(ent) then return end
		if (ent and ent:GetClass() == "prop_physics_multiplayer") then
		for k,v in pairs(GTowerItems.Items) do
			if (ent:GetModel() == v.Model && v.UseSound) then
				if ent.SoundDelay then return end
				ent:EmitSound("GModTower/inventory/" .. v.UseSound, 60)
				ent.SoundDelay = true
				if v.UseSound == "move_plush.wav" then
					ent:SetModelScale(0.75,0.25)
					timer.Simple(0.25, function() ent:SetModelScale(1,0.25) end)
				end
				ply._NextUse = CurTime() + 2
				timer.Simple(2,function() ent.SoundDelay = false end)
			end
		end
	end
end
end )
