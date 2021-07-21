

GTowerItems.BankMainGui = nil

function GTowerItems:GetBankTable()
	return GTowerItems.ClientItems[2]
end

function GTowerItems:GetBankItem( id )
	if GTowerItems.ClientItems[2] && GTowerItems.ClientItems[2][id] then
		return GTowerItems.ClientItems[2][id].Item
	end
end

function GTowerItems:UpdateBankTitle()

	local count = 0

	for k, v in pairs( GTowerItems:GetBankTable() ) do

		if !v._VGUI then
			v._VGUI = vgui.Create("GTowerInvItem")
			GTowerItems:UpdateBankGuiItem( v._VGUI )
			v._VGUI:SetId( k )
			v._VGUI:UpdateParent()
			v._VGUI.CheckParentLimit = self.BankMainGui.ItemList

			self.BankMainGui.ItemList:AddItem( v._VGUI )
			if v.Item then
				count = count + 1
			end
		else
			if v.Item then
				count = count + 1
			end
		end

	end

	local title = "Vault | " .. count .. " items"

	local max = #GTowerItems:GetBankTable()
	title = title .. " | " .. ( max - count ) .. "/" .. max .. " slots"

	if self.BankMainGui then
		self.BankMainGui:SetTitle( title )
	end

end

function GTowerItems:OpenBank()

	--surface.PlaySound('gmodtower/lobby/misc/trunk_open.wav')

	--self:CloseBank()
	GtowerMainGui:GtowerShowMenus()

	if IsValid(self.BankMainGui) then return end

	self.BankMainGui = vgui.Create("DFrame")
	self.BankMainGui:SetSize( 560, 400 )
	self.BankMainGui:SetPos( ScrW() - self.BankMainGui:GetWide() * 1.1, 100 )
	self.BankMainGui:SetVisible( true )
	self.BankMainGui.Close = function()
		GTowerItems:CloseBank()
	end

	self.BankMainGui.ItemList = vgui.Create("DPanelList2", self.BankMainGui)
	self.BankMainGui.ItemList:SetPos( 4, 25 )
	self.BankMainGui.ItemList:SetSize( self.BankMainGui:GetWide() - 8, self.BankMainGui:GetTall() - 28 )
	self.BankMainGui.ItemList:EnableHorizontal( true )
	self.BankMainGui.ItemList:SetSpacing( 2 )
	self.BankMainGui.ItemList:EnableVerticalScrollbar()

	self:ReloadMaxItems()

	self:UpdateBankTitle()

end

function GTowerItems:InvalidateBankLayout()
	if self.BankMainGui then
		if self.BankMainGui.ItemList then
			self.BankMainGui.ItemList:InvalidateLayout()
		end
	end
end

function GTowerItems:MouseInBank()
	local x,y = self.BankMainGui:CursorPos()
    return x >= 0 && y >= 0 && x <= self.BankMainGui:GetWide() && y <= self.BankMainGui:GetTall()
end

function GTowerItems:CloseBank()

	if IsValid( self.BankMainGui ) then self.BankMainGui:Remove() end

	for k, v in pairs( GTowerItems:GetBankTable() ) do
		if v._VGUI then
			v._VGUI:Remove()
		end

		v._VGUI = nil
	end

	self.BankMainGui = nil

	--surface.PlaySound('gmodtower/lobby/misc/trunk_close.wav')

	net.Start("gmt_closevault")
	net.SendToServer()

	GtowerMainGui:GtowerHideMenus()
end

hook.Add( "InvGuiDrop", "GTowerBankDrop", function( panel )
	for k, v in pairs( GTowerItems:GetBankTable() ) do
		if v._VGUI && panel != v._VGUI && v._VGUI:IsMouseInWindow() then
			return v._VGUI
		end
	end
end )

hook.Add("CanCloseMenu", "GTowerInvBank", function()
	if GTowerItems.BankMainGui then
		return false
	end
end )

hook.Add("InvDropCheckClose", "GTowerBank", function()

	if GTowerItems.BankMainGui then
		for k, v in pairs( GTowerItems:GetBankTable() ) do
			if v._VGUI && v._VGUI:IsDragging() then
				return false
			end
			GTowerItems:UpdateBankTitle()
		end
	end

end )

hook.Add("GTowerInvHover", "GTowerBank", function( panel )
	if GTowerItems.BankMainGui && GTowerItems:MouseInBank() then
		return GTowerItems.BankMainGui
	end
	GTowerItems:UpdateBankTitle()
end )
