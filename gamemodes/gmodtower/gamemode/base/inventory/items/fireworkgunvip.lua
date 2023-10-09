
ITEM.Name = "Firework RPG Unlimited!"
ITEM.ClassName = "gmt_firework_gun"
ITEM.Description = "Shoot fireworks.. Forever!"
ITEM.Model = "models/weapons/w_rocket_launcher.mdl"
ITEM.DrawModel = true
ITEM.CanEntCreate = false
ITEM.UniqueInventory = true

ITEM.Tradable = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

ITEM.StoreId = GTowerStore.VIP
ITEM.StorePrice = 15000

function ITEM:IsWeapon()
	return true
end

if SERVER then

	function ITEM:PaintOver()
		surface.SetFont("Default")
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( 2, 2 )
	end

end
