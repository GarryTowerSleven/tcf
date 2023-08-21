hook.Add("LoadInventory","LoadSizeChangingPotion", function()
	
	local Potions = {
		{ "Tiny Potion", 				0.1, 0, nil, Color( 0, 255, 255 ) },
		{ "Smaller Potion", 			0.25, 0, 1000, Color( 0, 0, 255 ) },
		{ "Small Potion", 				0.5,  1, 600, Color( 255, 0, 255 ) },
		{ "Medium Potion", 				0.75, 1, 350, Color( 0, 255, 0 ) },
		{ "Normal Potion", 				1,  2, 150, Color( 255, 255, 0 ) },
		{ "Slightly Bigger Potion", 	1.2,  2, 500, Color( 10, 140, 255 ) },
		{ "Large Potion", 				1.6, 3, nil, Color( 255, 0, 0 ) }
	}
	
	local ITEM = {}
	
	if SERVER then

		local function ApplyScale( potion, temp, defaultsize )

			if not IsLobby then return end

			local size = defaultsize or potion.PlayerChangeSize

			if potion.Ply:Alive() && not potion.Ply:InVehicle() then

				-- No need to apply this
				if GTowerModels.Get( potion.Ply ) == size then
					return false
				end

				-- Forbid usage in theater
				/*if Location and Location.IsEquippablesNotAllowed( potion.Ply:Location() ) then
					if not potion._TraceFailedNotified then
						potion.Ply:MsgI( "exclamation", "InventoryEquipNotAllowed", potion.Name, potion.Ply:LocationName() )
					end
					potion._TraceFailedNotified = true
					return false
				end*/

				local tr = GTowerModels.TestSize( potion.Ply, size )
				if ( tr.HitWorld or IsValid( tr.Entity ) ) then
					if defaultsize then
						potion.Ply:MsgI( "exclamation", "InventoryWallTraceFailedDefaultSize" )
					else
						potion.Ply:MsgI( "exclamation", "InventoryWallTraceFailed", potion.Name )
					end

					return false
				end

				if temp then
					GTowerModels.SetTemp( potion.Ply, size )
				else
					GTowerModels.Set( potion.Ply, size )
				end

				potion.Ply:EmitSound( "GModTower/inventory/use_potion.wav", 80, math.Clamp( 80, 150, 100 / size ) )

			end

		end

		function ITEM:OnEquip()
			return ApplyScale( self, true ) -- temp
		end

		function ITEM:OnUnEquip()
			return ApplyScale( self, false, 1 )
		end

		function ITEM:OnUse()
			ApplyScale( self, true ) -- temp
			return true
		end

		function ITEM:OnSecondaryUse()
			ApplyScale( self )
			return true
		end

	end	
	
	ITEM.Model = "models/gmod_tower/aigik/bottle1.mdl"
	ITEM.DrawModel = true
	ITEM.CanUse = true
	ITEM.CanSecondaryUse = true
	ITEM.UseDesc = "Drink"
	ITEM.SecondaryUseDesc = "Set As Default Size"
	ITEM.CanEntCreate = true
	ITEM.DrawName = true
	ITEM.InvCategory = "potions"
	ITEM.MoveSound = "glass"
	ITEM.Equippable = true
	ITEM.EquipType = "Potion"
	ITEM.UniqueEquippable = true
	
	for _, potion in pairs( Potions ) do
		local NEWITEM = table.Copy( ITEM )
		
		NEWITEM.Name = potion[1]
		NEWITEM.PlayerChangeSize = potion[2]
		NEWITEM.ModelSkinId = potion[3]
		NEWITEM.ModelColor = potion[5] or Color( 255, 255, 255 )

		if potion[2] == 1 then
			NEWITEM.Description = "Change your size back to normal."
		else
			NEWITEM.Description = "Change your size to " .. potion[2] * 100 .. "% of normal."
		end

		NEWITEM.Description = NEWITEM.Description .. " Potions are unlimited use."
		
		if potion[4] then
			NEWITEM.StoreId = GTowerStore.VENDING
			NEWITEM.StorePrice = potion[4]
		else
			NEWITEM.StoreId = GTowerStore.VIP
			NEWITEM.StorePrice = 4000 * potion[2]
			NEWITEM.Tradable = false
			NEWITEM.VIP = true
			NEWITEM.UniqueInventory = true
		end
		
		GTowerItems.RegisterItem("potion" .. potion[2], NEWITEM )
	end

end )