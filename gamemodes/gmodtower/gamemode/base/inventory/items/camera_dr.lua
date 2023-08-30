---------------------------------
ITEM.MaxUses = 3
ITEM.Name = "Film Camera"
ITEM.ClassName = "gmt_camera_dr"
ITEM.Description = "Take photos and video with this camera! (It's been used in wars, you know.)"
ITEM.Model = "models/maxofs2d/camera.mdl"
ITEM.DrawModel = true
ITEM.CanEntCreate = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

ITEM.UniqueInventory = true

ITEM.StoreId = 7
ITEM.StorePrice = 0

function ITEM:IsWeapon()
	return true
end
