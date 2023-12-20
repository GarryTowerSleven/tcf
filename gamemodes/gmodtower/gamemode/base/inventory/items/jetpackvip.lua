ITEM.Name = "Jetpack Unlimited"
ITEM.Base = "jetpack1"
ITEM.Description = "Fly over your friends with style... forever!"
ITEM.Model = "models/gmod_tower/jetpack.mdl"
ITEM.DrawModel = true

ITEM.Equippable = true
ITEM.UniqueEquippable = true
ITEM.EquipType = "Jetpack"

ITEM.IsJetpack = true
ITEM.JetpackPower = 2
ITEM.JetpackFuel = -1
ITEM.JetpackRecharge = 0.01
ITEM.JetpackHideFuel = true
ITEM.JetpackStartRecharge = 0.01
ITEM.ExtraOnFloor = 25 //Amount of force the player has extra when jumping from the floor

ITEM.StoreId = GTowerStore.VIP
ITEM.StorePrice = 40000

ITEM.Tradable = false
ITEM.VIP = true
ITEM.ModelSkinId = 2 // To make this different from the other jetpack
ITEM.UniqueInventory = true

ITEM.ExtraMenuItems = function ( item, menu ) 
	
	table.insert( menu, {
		[ "Name" ] = "Set Power",
		[ "function" ] = function()
		
			local curText = LocalPlayer():GetInfo( "gmt_vip_jetpackpower" ) or 1.0
			
			Derma_StringRequest(
				"Jetpack Power",
				"Please enter the power of your jetpack (1.0 - 2.0)",
				curText,
				function ( text ) RunConsoleCommand( "gmt_vip_jetpackpower", tonumber(text) )  end
			)
			
		end
	} )
		
end