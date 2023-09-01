---------------------------------
GTowerStore.StoreGUI = nil
GTowerStore.StoreId = 0
GTowerStore.StoreDiscount = 0
GTowerStore.ShowModelIcon = false

function GTowerStore:OpenStore( id, title, message, discount )

	self.StoreId = id
	self.StoreDiscount = discount or 0

	local StoreTbl = GTowerStore.Stores[ id ]

	if StoreTbl then

		local StoreTitle = title or StoreTbl.WindowTitle or ""

		GTowerStore.ShowModelIcon = !StoreTbl.ModelStore

		if StoreTbl.ModelStore then
			GTowerStore.OpenModelStore( id, StoreTitle, StoreTbl.CameraZPos, StoreTbl.ModelSize, StoreTbl.CameraFar )
		else
			GTowerStore.OpenNormalStore( id, StoreTitle )
		end

		hook.Call( "GTowerOpenStore", GAMEMODE )

	end

end

function GTowerStore:UpdateStoreList()

	if !IsValid( self.StoreGUI ) then
		return
	end

	local function HasPanelWithId( id )
		for _, v in pairs( self.StoreGUI.PanelList.Items ) do
			if v.Id == id then
				return true
			end
		end

		return false
	end

	local function ItemCostNil( Item )
		return #Item.prices == 1 && Item.prices[1] == 0
	end

	for k, v in pairs( self.Items ) do
		if v.storeid == self.StoreId && HasPanelWithId( k ) == false && !ItemCostNil( v ) then

			local NewItem = vgui.Create("GTowerStoreItem")
			NewItem:SetId( k )

			self.StoreGUI.PanelList:AddItem( NewItem )

			if GTowerStore.ShowModelIcon then
				NewItem:EnableModelPanel()
			end

		end
	end

	table.sort( self.StoreGUI.PanelList.Items, function( a,b )
    local APrice = a:GetFirstPrice()
    local BPrice = b:GetFirstPrice()    
    
    if APrice == BPrice then
        return a.Id < b.Id
    end
    
    return APrice < BPrice
end )

	self.StoreGUI.PanelList:InvalidateLayout()
end

function GTowerStore:CheckAndUpdate(storeid, discount)
	if !IsValid( self.StoreGUI ) || GTowerStore.StoreId != storeid then
		return
	end

	GTowerStore.StoreDiscount = discount
	GTowerStore:UpdateStoreList()
end

hook.Add("PlayerLevel", "GTowerStoreUpdate", function()
	GTowerStore:UpdateStoreList()
end )

function GTowerStore.CloseStorePanel()

	hook.Call("GTowerCloseStore", GAMEMODE )

	if IsValid( GTowerStore.StoreGUI ) then
		GTowerMainGui.HideMenus()
		GTowerStore.StoreGUI:Remove()
	end

	GTowerStore.StoreGUI = nil

end