---------------------------------
hook.Add("Initialize", "GTowerStoreBegin", function()
	hook.Call("GTowerStoreLoad", GAMEMODE )
end )

function GTowerStore:SQLInsert( NewItem )

	if type( NewItem.price ) == "number" then
		NewItem.prices = { NewItem.price }
	end

	if NewItem.name then
		NewItem.Name = NewItem.name
	end

	if !NewItem or !NewItem.unique_name or !NewItem.Name or !NewItem.prices then
		return nil
	end	
	
	if table.Count( NewItem.prices ) > 16 then
		Msg("ATTETION! Item " .. NewItem.Name .. " has more than 16 levels and it will not be saved on the database correctly!")
	end
	
	NewItem.upgradable = NewItem.upgradable or false
	NewItem.FromFile = true
	
	local Item = NewItem
	/*{
		["storeid"] = tonumber( NewItem.storeid ),
		["ClientSide"] = NewItem.ClientSide,
		["Name"] = NewItem.Name,
		["unique_name"] = NewItem.unique_name,
		["description"] = NewItem.description or "",
		["prices"] = NewItem.prices,
		["upgradable"] = NewItem.upgradable or false,
		["onbuy"] = NewItem.onbuy,
		["canbuy"] = NewItem.canbuy,
		["FromFile"] = true
	} */
	
	if string.len( Item.description ) > 256 then
		Msg("ATTETETION: " .. Item.Name .. " description is too long! Cropping it!")
		Item.description = string.sub( Item.description, 1, 256 ) 
	end
	
	local Id =  simplehash(Item.unique_name) //self:GetItemByName( Item.unique_name )
	
	if GTowerStore.Items[ Id ] then
		SQLLog('error', "FOUND DUPLICATE ITEM ID!\n" .. Item.unique_name .. " - " .. GTowerStore.Items[ Id ].unique_name )
	end
	
	GTowerStore.Items[ Id ] = Item

	return Id

end