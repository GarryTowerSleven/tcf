---------------------------------
ITEM.Name = "Confetti Unlimited!"
ITEM.ClassName = "gmt_confetti"
ITEM.Description = "Shoot colorful confetti all around you.. Forever!"
ITEM.Model = "models/gmod_tower/item_confetti.mdl"
ITEM.DrawModel = true
ITEM.CanEntCreate = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

ITEM.StoreId = GTowerStore.VIP
ITEM.StorePrice = 1000

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
