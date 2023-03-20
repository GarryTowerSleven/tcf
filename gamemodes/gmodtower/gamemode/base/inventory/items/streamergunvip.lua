
ITEM.Name = "Streamers Unlimited!"
ITEM.ClassName = "gmt_funstreamer"
ITEM.Description = "Shoot streams of color.. Forever!"
ITEM.Model = "models/weapons/w_pistol.mdl"
ITEM.DrawModel = true
ITEM.CanEntCreate = false

ITEM.EquipType = "Weapon"
ITEM.Equippable = true
ITEM.WeaponSafe = true

ITEM.StoreId = GTowerStore.VIP
ITEM.StorePrice = 1500

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
