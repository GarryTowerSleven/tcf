---------------------------------
ITEM.Name = "Paranormal Detector"
ITEM.ClassName = "gmt_tracker"
ITEM.Description = "From Halloween 2019."
ITEM.Model = "models/weapons/w_pvp_ragingb.mdl"
ITEM.UniqueInventory = false
ITEM.DrawModel = true
ITEM.Tradable = false

ITEM.StorePrice = 250
ITEM.StoreId = 19

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

function ITEM:IsWeapon()
	return true
end
