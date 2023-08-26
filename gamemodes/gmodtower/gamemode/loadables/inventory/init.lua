include("shared.lua")
include("bank.lua")
include("concommand.lua")
include("weapon.lua")
include("trade/init.lua")
include("inventorysaver/init.lua")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_maindrop.lua")
AddCSLuaFile("cl_mainitem.lua")
AddCSLuaFile("cl_maininv.lua")
AddCSLuaFile("cl_admin.lua")
AddCSLuaFile("cl_debug.lua")
AddCSLuaFile("cl_grab.lua")
AddCSLuaFile("cl_weapon.lua")
AddCSLuaFile("cl_bank.lua")
AddCSLuaFile("cl_bankitem.lua")
AddCSLuaFile("cl_tooltip.lua")
AddCSLuaFile("cl_tooltipgui.lua")
AddCSLuaFile("cl_playermodel.lua")

hook.Add("EntityTakeDamage", "InventoryCheckBreak", function( ent, dmginfo  )

	if ent:IsPlayer() then
		return
	end

	local ItemId = GTowerItems:FindByEntity( ent )

	if ItemId then
		local Item = GTowerItems:Get( ItemId )
		local attacker = dmginfo:GetAttacker()

		if Item.AllowEntBreak  == false then
			dmginfo:ScaleDamage( 0.0 )
		else
			if Item.MysqlId == ITEMS.empty_bottle && IsPlayer( attacker ) then
				attacker:SetAchievement( ACHIEVEMENTS.DOMESTICABUSE, 1 )
				attacker:AddAchievement( ACHIEVEMENTS.TRASHCOMPACTOR, 1 )
			end
		end
	end

end )

concommand.Add("gmt_findnonitems", function( ply, cmd, args )

	if ply != NULL then
		return
	end

	local EndStr = ""
	local UsedTable = {}

	for _, ent in pairs( ents.GetAll() ) do
		if ent:GetClass() == "prop_physics" then

			local Item = GTowerItems:FindByEntity( ent )

			if !Item then
				local Model = ent:GetModel()

				if !table.HasValue( UsedTable, Model ) then
					table.insert( UsedTable, Model )
					EndStr = EndStr .. Model .. "\n"
				end
			end

		end
	end

	file.Write("InventoryNonItems.txt", EndStr )

end )

concommand.Add("gmt_scrnsize", function(ply,cmd,args)
	if #args == 2 then
		ply._ScreenMirrorSize = { tonumber(args[1]), tonumber(args[2] ) }
	end
end )

local function GiveAdminSizes( ply )

	umsg.Start("ScrnSize", ply)
		umsg.Bool( false )

		for _, v in pairs( player.GetAll() ) do

			if v._ScreenMirrorSize then
				umsg.Short( v._ScreenMirrorSize[1] )
				umsg.Short( v._ScreenMirrorSize[2] )
			end

		end

	umsg.End()

end

concommand.Add("gmt_getmirrorsize", function(ply,cmd,args)
	if ply:IsAdmin() then

		umsg.Start("ScrnSize")
			umsg.Bool( true )
		umsg.End()

		timer.Create("GMTGiveMirrorSizes", 5.0, 1, function() GiveAdminSizes(ply ) end)

	end
end )

function GTowerItems.CreateMysteryItem(ply)
	if !IsValid(ply) then return end

	local p = math.Rand(0, 1)

	if p <= 0.0005 then
		SQLLog( "game", ply:Nick() .. " found a blockles machine from a cat sack." )

		ply:AddAchievement( ACHIEVEMENTS.LUCKYCAT, 1 )
		GAMEMODE:ColorNotifyAll( string.upper(ply:Name()).." JUST FOUND A BLOCKLES MACHINE FROM THE MYSTERIOUS CAT SACK!", Color(255, 200, 0, 255) )

		return ITEMS.suitetetris
	elseif p <= 0.1 then
		return ITEMS.mysterycatsack
	elseif p <= 0.2 then
		return ITEMS.alcohol_bottle
	elseif p <= 0.225 then
		return ITEMS.beercase
	elseif p <= 0.4 then
		return ITEMS.computer_display
	elseif p <= 0.5 then
		return ITEMS.computer_monitor
	elseif p <= 0.6 then
		return ITEMS.huladoll
	elseif p <= 0.7 then
		return ITEMS.ingredient_bone
	elseif p <= 0.7125 then
		return ITEMS.ingredient_plastic
	elseif p <= 0.7250 then
		return ITEMS.ingredient_glass
	elseif p <= 0.7375 then
		return ITEMS.ingredient_orange
	elseif p <= 0.75 then
		return ITEMS.ingredient_banana
	elseif p <= 0.7625 then
		return ITEMS.ingredient_watermel
	elseif p <= 0.7750 then
		return ITEMS.ingredient_straw
	elseif p <= 0.7875 then
		return ITEMS.ingredient_apple
	elseif p <= 0.8 then
		return ITEMS.clipboard
	elseif p <= 0.9 then
		return ITEMS.microwave
	else
		if ply:HasItemById( ITEMS.wepon_357 ) then
			return ITEMS.mysterycatsack
		else
			return ITEMS.wepon_357
		end
	end
end
