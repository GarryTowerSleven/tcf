---------------------------------
ITEM.Name = "Internet Globe"
ITEM.Description = "Der Strato Homepage Baukasten. (Wearable!)"
ITEM.Model = "models/gmod_tower/internet_globe.mdl"
ITEM.DrawModel = true

ITEM.CanEntCreate = false

ITEM.Equippable = true
ITEM.UniqueEquippable = false

ITEM.RemoveOnNarnia = true

ITEM.EquippableEntity = true // Should an entity be created from CreateEquipEntity ?

ITEM.CanRemove = false
ITEM.Tradable = false

//ITEM.StoreId = GTowerStore.BASICAL
//ITEM.StorePrice = 5000

if SERVER then

	ITEM.AllowEntBackup = true

	function ITEM:OnCreate( data )
	end

	function ITEM:OnEquip()
	end

	function ITEM:CreateEquipEntity()

		local GlobeEnt = ents.Create("gmt_wearable_globe")

		if IsValid( GlobeEnt ) then
			GlobeEnt:SetOwner( self.Ply )
			GlobeEnt:SetParent( self.Ply )
			GlobeEnt.Owner = self.Ply
			GlobeEnt._GTInvSQLId = false

			GlobeEnt:SetPos( self.Ply:GetPos() + Vector(0,0,32) )
			GlobeEnt:Spawn()
		end

		return GlobeEnt

	end


	function ITEM:CustomNW()
	end

end