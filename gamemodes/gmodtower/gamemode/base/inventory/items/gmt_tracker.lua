ITEM.Name = "Paranormal Detector"
ITEM.ClassName = "gmt_tracker"
ITEM.Description = "Track ghosts, reveal the truth."
ITEM.Model = "models/weapons/w_pvp_ragingb.mdl"
ITEM.UniqueInventory = false
ITEM.DrawModel = true
ITEM.Tradable = false

ITEM.StorePrice = 500
// ITEM.StoreId = GTowerStore.HALLOWEEN

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

function ITEM:IsWeapon()
	return true
end
