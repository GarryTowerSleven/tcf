module( "PVPBattle", package.seeall )

StoreID = 3
WeaponList = WeaponList or {}
DefaultWeapons = DefaultWeapons or {}
WeaponsIDs = WeaponsIDs or {}

DEBUG = false

hook.Add("GTowerStoreLoad", "AddPVPBattleWeapons", function()
	
	local wepList = weapons.GetList()
	WeaponList = {}
	DefaultWeapons = {}
	WeaponsIDs = {}
	
	for _, v in pairs( wepList ) do
		
		if v.Base == "weapon_pvpbase" && v.StoreBuyable == true then
			
			local UniqueName = "PVPW" .. string.Replace( v.ClassName, "weapon_", "" )
			
			local NewItemId = GTowerStore:SQLInsert( {
				Name = v.PrintName,
				description = v.Description,
				unique_Name = UniqueName,
				price = v.StorePrice,
				model = v.WorldModel,
				ClientSide = true,
				upgradable = true,
				storeid = StoreID
			} )
			
			if v.Slot && v.SlotPos then
				local Slot = v.Slot + 1
				local SlotId = v.SlotPos + 1
				
				if !WeaponList[ Slot ] then
					WeaponList[ Slot ] = {}
				end
				
				WeaponList[ Slot ][ SlotId ] = UniqueName
				
				if SERVER && v.StorePrice == 0 then
					DefaultWeapons[ Slot ] = NewItemId
				end
				
			else
				Msg("NO SLOT FOUND FOR WEAPON: " , v.ClassName , "\n")
			end
			
			if SERVER then
				v.StoreItemId = NewItemId
				WeaponsIDs[ NewItemId ] = v.ClassName
			end
			
		end
		
	end

end )
