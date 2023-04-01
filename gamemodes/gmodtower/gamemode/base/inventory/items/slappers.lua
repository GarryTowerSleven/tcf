ITEM.Name = "Slappers"
ITEM.ClassName = "slappers"
ITEM.Description = "Slap around your friends and foes!"
ITEM.Model = ""
ITEM.UniqueInventory = true
ITEM.DrawName = true
ITEM.DrawModel = false
ITEM.Tradable = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

function ITEM:IsWeapon()
	return true
end