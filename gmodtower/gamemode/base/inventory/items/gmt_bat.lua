

ITEM.Name = "Batter"
ITEM.ClassName = "gmt_bat"
ITEM.Description = "Hold left click to become a bat and fly!"
ITEM.Model = "models/map_detail/vampbat.mdl"
ITEM.DrawModel = true
ITEM.CanEntCreate = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

function ITEM:IsWeapon()
	return true
end
