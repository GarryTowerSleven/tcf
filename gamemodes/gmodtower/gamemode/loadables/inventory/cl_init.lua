include("shared.lua")
include("cl_maininv.lua")
include("cl_maindrop.lua")
include("cl_mainitem.lua")
include("cl_grab.lua")
include("cl_admin.lua")
include("cl_bank.lua")
include("cl_bankitem.lua")
include("cl_debug.lua")
include("cl_weapon.lua")
include("cl_tooltip.lua")
include("cl_tooltipgui.lua")
include("trade/cl_init.lua")
include("cl_playermodel.lua")
include("inventorysaver/cl_init.lua")


GTowerItems.MainInvPanel = nil
GTowerItems.DropInvPanel = nil
GTowerItems.InvItemSize = 52
GTowerItems.ClientItems = GTowerItems.ClientItems or {}
GTowerItems.InvDesc = nil

table.uinsert( HudToHide, "CHudWeaponSelection" )

function GTowerItems:MaxItems()
	if not IsValid(LocalPlayer()) or not LocalPlayer().GetNet or not LocalPlayer():GetNet("MaxItems") then
		return GTowerItems.DefaultInvCount
	end
	
	return LocalPlayer():GetNet("MaxItems")
end

function GTowerItems:MaxBank()
	if not IsValid(LocalPlayer()) or not LocalPlayer().GetNet or not LocalPlayer():GetNet("BankMax") then
		return GTowerItems.DefaultBankCount
	end
	
	return LocalPlayer():GetNet("BankMax")
end


hook.Add( "GTowerShowMenus","OpenInventory", function()
	if !LocalPlayer():Alive() then return end
	GTowerItems:OpenMainInventory()
end )


hook.Add( "GTowerHideMenus","CloseInventory", function()

	if GTowerItems.MainInvPanel then
		GTowerItems.MainInvPanel:Close()
	end

	if GTowerItems.DropInvPanel then
		GTowerItems.DropInvPanel:Close()
	end

	timer.Simple(0.1, function()
		if GTowerItems then GTowerItems:HideTooltip() end
	end )

end )

hook.Add( "InvGuiDrop", "GTowerMainDrop", function( panel )
	for k, v in pairs( GTowerItems.ClientItems[1] ) do
		if v._VGUI && panel != v._VGUI && v._VGUI:IsMouseInWindow() then
			return v._VGUI
		end
	end
end )

function GTowerItems:OpenAll()
	self:OpenMainInventory()
	self:OpenDropInventory()
end

function GTowerItems:OpenMainInventory()

	if !self.MainInvPanel then
		self.MainInvPanel = vgui.Create( "GTowerInvMain" )
		self.MainInvPanel:ForceClose()
	end

	self.MainInvPanel:Open()
	self.MainInvPanel:InvalidateLayout()

end

function GTowerItems:OpenDropInventory()

	if !self.DropInvPanel then
		self.DropInvPanel = vgui.Create( "GTowerInvDrop" )
	end

	self.DropInvPanel:Open()
	self.DropInvPanel:InvalidateLayout()

end


function GTowerItems:GetItem( id )
	if self.ClientItems[1][ id ] then
		return self.ClientItems[1][ id ].Item
	end
	return nil
end


function GTowerItems:AllowSwap( slot1, slot2 )

	local Item1 = self:GetItem( slot1 )
	local Item2 = self:GetItem( slot2 )

	if Item1 then
		if !self:AllowPosition( Item1, slot2 ) then
			return false
		end
	end

	if Item2 then
		if !self:AllowPosition( Item2, slot1 ) then
			return false
		end
	end

	if hook.Call("GTowerAllowSwap", GAMEMODE, slot1, slot2, Item1, Item2 ) == false then
		return false
	end

	return true
end


/* ===================================
 == INTERNAL FUNCTIONS
====================================== */

function GTowerItems:CreateItemOfID( id )

	if !self.ClientItems[1][ id ] then
		self.ClientItems[1][ id ] = {}
	end

	if !self.ClientItems[1][ id ]._VGUI then
		local panel = vgui.Create("GTowerInvItem")

		panel:SetId( id )
		panel:UpdateParent()

		self.ClientItems[1][ id ]._VGUI = panel
	end

end

function GTowerItems:GetOriginalParent( id )

	if self:IsEquipSlot( id ) then
		return GTowerItems.MainInvPanel
	end

	return GTowerItems.DropInvPanel

end

function GTowerItems:CheckSubClose()

	if GTowerItems.DropInvPanel then
		GTowerItems.DropInvPanel:CheckClose()
	end

end

function GTowerItems:ReloadMaxItems()

	local function CheckLimits( Place, limit )

		if !self.ClientItems[ Place ] then
			self.ClientItems[ Place ] = {}

		end

		local Tbl = self.ClientItems[ Place ]

		for k, v in pairs( Tbl ) do
			if k < 1 || k > limit then
				Tbl[ k ] = nil
			end
		end

		for i=1, limit do
			if !Tbl[ i ] then
				Tbl[ i ] = {}
			end
		end

	end

	CheckLimits( 1, self:MaxItems() ) -- Main inventory
	CheckLimits( 2, self:MaxBank() ) -- Bank
	-- 22 is admin
	CheckLimits( 4, #self.WearablesList ) -- Wearbles (hotbar)
	CheckLimits( 5, GTowerItems.MaxBankCount ) -- Bank temp (moving boxes)

	self:InvalidateBankLayout()

end
GTowerItems:ReloadMaxItems()

function GTowerItems:GetActiveSlot()

	if self.ActiveSlot then
		local Place = self.ActiveSlot[1]
		local Slot = self.ActiveSlot[2]
		if self.ClientItems[ Place ] then
			return self.ClientItems[ Place ][ Slot ]

		end



	end



end


usermessage.Hook("Inv", function( um )

	local MsgId = um:ReadChar()

	if MsgId == 1 then

		local Place = um:ReadChar()
		local Slot = um:ReadChar() + 128
		local Valid = um:ReadBool()

		if !GTowerItems.ClientItems[ Place ] then
			GTowerItems.ClientItems[ Place ] = {}
		end

		if !GTowerItems.ClientItems[ Place ][ Slot ] then
			GTowerItems.ClientItems[ Place ][ Slot ] = {}
		end

		local ItemObj = GTowerItems.ClientItems[ Place ][ Slot ]

		if ItemObj.Item then
			if ItemObj.Item then
				ItemObj.Item:OnRemove()
				ItemObj.Item.ValidItem = false
			end

			hook.Call("InventoryChanged", GAMEMODE, ItemObj )

			ItemObj.Item = nil
		end

		if Valid then

			local ItemId = um:ReadShort() + 32768
			local Item = GTowerItems:CreateById( ItemId )

			if !Item then
				print("Could not create item of Id: " .. ItemId )
				return
			end

			Item.SlotId = Slot
			Item.PlaceId = Place

			if Item.ReadFromNW then
				Item:ReadFromNW( um )
			end

			ItemObj.Item = Item

			if IsValid( ItemObj._VGUI ) then
				Item._VGUI = ItemObj._VGUI
			end

		end

		if IsValid( ItemObj._VGUI ) then
			ItemObj._VGUI:InvalidateLayout()
		end

		hook.Call("InventoryChanged", GAMEMODE, ItemObj )

		/*
		local IsBank = um:ReadBool()
		local Slot = um:ReadChar() + 127
		local ItemObj = GTowerItems:GetSpecialItem( Slot, IsBank )

		if ItemObj.Item then
			ItemObj.Item:OnRemove()
			ItemObj.Item.ValidItem = false
		end

		hook.Call("InventoryChanged", GAMEMODE, ItemObj )

		ItemObj.Item = nil

		if IsValid( ItemObj._VGUI ) then
			ItemObj._VGUI:InvalidateLayout()
		end

		if IsBank then
			GTowerItems:InvalidateBankLayout()
		end

	elseif MsgId == 2 then

		local IsBank = um:ReadBool()
		local Slot = um:ReadChar() + 128
		local Id = um:ReadShort() + 32768
		local BaseItem = GTowerItems:Get( Id )
		local ItemObj = GTowerItems:GetSpecialItem( Slot, IsBank )

		if ItemObj.Item then
			ItemObj.Item:OnRemove()
			ItemObj.Item.ValidItem = false
			hook.Call("InventoryChanged", GAMEMODE, ItemObj )
		end

		local Item = GTowerItems:CreateById( Id )

		if !Item then
			print("Could not create item of Id: " .. Id )
		end

		ItemObj.Item = Item
		Item.SlotId = Slot
		Item.IsBankSlot = IsBank

		if IsValid( ItemObj._VGUI ) then
			Item._VGUI = ItemObj._VGUI
			ItemObj._VGUI:InvalidateLayout()
		end

		if Item.ReadFromNW then
			Item:ReadFromNW( um )
		end

		if IsBank then
			GTowerItems:InvalidateBankLayout()
		end

		hook.Call("InventoryChanged", GAMEMODE, ItemObj )
		*/

	elseif MsgId == 3 then
		GTowerItems:OpenBank()
	end

end )
