---------------------------------
ITEM.Name = "Akimibo"
ITEM.ClassName = "weapon_akimbo"
ITEM.Description = "Akimibo"
ITEM.Model = "models/weapons/w_pvp_ire.mdl"
ITEM.UniqueInventory = true
ITEM.DrawModel = false
ITEM.Tradable = false
ITEM.DrawName = true
ITEM.EquipType = "Weapon"
ITEM.Equippable = true

util.PrecacheModel( ITEM.Model )

function ITEM:IsWeapon()
	return true
end
