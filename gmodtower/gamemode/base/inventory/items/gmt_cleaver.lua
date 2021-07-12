---------------------------------
ITEM.Name = "Golden Cleaver"
ITEM.ClassName = "gmt_cleaver"
ITEM.Description = "Throw with responsibility."
ITEM.Model = "models/weapons/c_models/c_sd_aussclv/c_sd_cleaver.mdl"
ITEM.UniqueInventory = false
ITEM.DrawModel = true
ITEM.Tradable = false

ITEM.StorePrice = 500

ITEM.DrawName = true

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

function ITEM:IsWeapon()
	return true
end
