include('shared.lua')
include('cl_admin.lua')

module("Hats", package.seeall )

hook.Add("GTowerStoreLoad", "AddHats", function()
	for _, v in pairs( List ) do
		
		if v.unique_Name then
		
			local NewItem = {}
			
			NewItem.storeid = v.storeid || StoreId
			NewItem.name = v.name
			NewItem.Name = v.name
			NewItem.description = v.description
			NewItem.prices = { v.price }
			NewItem.unique_Name = v.unique_Name
			NewItem.model = v.model
			NewItem.drawmodel = true
			NewItem.ModelSkin = v.ModelSkin
			
			GTowerStore:SQLInsert( NewItem )
			
		end
		
	end
end )
