AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_selectweapon.lua")
AddCSLuaFile("cl_closebutton.lua")

include("shared.lua")


concommand.Add("gmt_pvpselwep", function( ply, cmd, args )

	if #args != 1 then
		return
	end
	
	local ItemId = GTowerStore:GetItemByName( args[1] )
	
	if !ItemId then	return end
	
	local Item = GTowerStore:Get( args[1] )
	
	if !Item then return end
	if ply:GetLevel( ItemId ) != 1 then return end
	
	local WeaponClass = PVPBattle.WeaponsIDs[ ItemId ]
	local Weapon = weapons.Get( WeaponClass )

	if !Weapon then
		ply:Msg2("Unknown weapon " .. tostring(WeaponClass) .. " " .. tostring(ItemId))
		return
	end

	local Slot = Weapon.Slot + 1
	
	ply._PVPLoadout[ Slot ] = ItemId
	
	if PVPBattle.DEBUG then
		Msg("Setting ", ply, " - Slot: " .. Slot .. " - " .. ItemId .. "\n")
	end
	
	PVPBattle.SendToClient( ply )

end )

concommand.Add("gmt_pvpopenstore", function( ply, cmd, args )

	if ply:IsAdmin() then
		PVPBattle.OpenStore( ply )
	end

end )

/*function PvpBattle:OpenStore( ply, ent )

	GTowerStore:SendItemsOfStore( ply, self.StoreId )
	self:SendToClient( ply, true )

end*/
