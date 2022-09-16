ITEM.Name = ".357"
ITEM.ClassName = "wepon_357"
ITEM.Description = "A gun? Better be careful with this."
ITEM.Model = "models/weapons/w_357.mdl"
ITEM.DrawModel = true

ITEM.EquipType = "Weapon"
ITEM.Equippable = true

util.PrecacheModel( ITEM.Model )

function ITEM:IsWeapon()
	return true
end