---------------------------------
ITEM.MaxUses = 3
ITEM.Name = "Camera"
ITEM.ClassName = "gmt_camera"
ITEM.Description = "Take screenshots without the HUD - and with zoom!"
ITEM.Model = "models/maxofs2d/camera.mdl"
ITEM.DrawModel = true
ITEM.CanEntCreate = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

ITEM.UniqueInventory = true

ITEM.StoreId = 7
ITEM.StorePrice = 250

function ITEM:IsWeapon()
	return true
end
