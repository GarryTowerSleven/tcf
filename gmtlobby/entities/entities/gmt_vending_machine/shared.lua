ENT.Base		= "base_entity"
ENT.Type 		= "anim"
ENT.PrintName	= "Vending Machine"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= Model("models/map_detail/lobby_vendingmachine.mdl")
ENT.Sound		= Sound( "GModTower/lobby/trainstation/vendingmachineHumm.mp3")
ENT.StoreId 	= GTowerStore.VENDING
ENT.IsStore 	= true

function ENT:GetStoreId()
	return self.StoreId
end

function ENT:GetTitle()

	if self.Title then
		return self.Title
	elseif ( GTowerStore.Stores and self:GetStoreId() != -1 ) then
		return GTowerStore.Stores[self:GetStoreId()].WindowTitle
	end

	return "Unknown Store (ID="..tostring(self:GetStoreId())..")"

end

function ENT:CanUse( ply )
	return true, "BUY ITEMS"
end