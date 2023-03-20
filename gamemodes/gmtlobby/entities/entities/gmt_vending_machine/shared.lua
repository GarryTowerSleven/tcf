ENT.Base		= "base_entity"
ENT.Type 		= "anim"
ENT.PrintName	= "Vending Machine"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= Model("models/props/cs_office/vending_machine.mdl")
ENT.StoreId 	= GTowerStore.VENDING
ENT.IsStore 	= true

function ENT:GetStoreId()
	return self.StoreId
end

function ENT:IsOnSale()
	return self:GetNWBool("Sale")
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

function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
		timer.Simple( 0.0, function()
			GTowerStore:OpenStore( ply, self:GetStoreId() )
			self.Customer = ply
		end)


    end

end