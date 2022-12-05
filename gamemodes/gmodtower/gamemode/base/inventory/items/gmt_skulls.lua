---------------------------------
ITEM.Name = "Flamin' Skulls"
ITEM.ClassName = "gmt_skulls"
ITEM.Description = "Shoot some spooky flaming skulls with this Deluxe technology."
ITEM.Model = "models/weapons/w_rocket_launcher.mdl"
ITEM.UniqueInventory = false
ITEM.DrawModel = true
ITEM.Tradable = false

ITEM.StorePrice = 200

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

function ITEM:IsWeapon()
	return true
end
