
-----------------------------------------------------
local PANEL = {}
local OpenTime = 1 / 0.5 -- 0.5 seconds
local gradient = surface.GetTextureID("vgui/gradient_up")

local ItemWidth = 64 - 10
local SlotBarHeight = 15

local EquipSlotsOnly = GTowerItems.EquippableSlots
local CosmeticPadding = 15

local GradColor1 = Color( 21, 100, 110, 250 )
local GradColor2 = Color( 84, 44, 97, 225 )

if IsHalloweenMap() then
	GradColor1 = Color( 35, 35, 35, 250 )
	GradColor2 = Color( 45, 45, 45, 250 )
end

function PANEL:Init()

	self:SetTall( 60 + SlotBarHeight - 4 )

end

function PANEL:Paint( w, h )

	local ew = self.EquipWidth or w

	-- Draw background
	surface.SetDrawColor( 33, 100, 110, 255 )
	surface.DrawRect( 0, 0, ew, 3 )
	draw.RoundedBox( 3, 0, 0, ew, h, GradColor1 )
--84, 44, 97
	surface.SetDrawColor( GradColor2 )
	surface.SetTexture( gradient )
	--surface.DrawTexturedRect( 0, SlotBarHeight, w, h )

	-- Draw slotbars
	local posX = 2
	for i=1, EquipSlotsOnly do

		-- Show selected
		if i == GTowerItems.CurWeapon then
			surface.SetDrawColor( 105, 78, 120, 200 )
			surface.SetTexture( gradient )
			surface.DrawTexturedRect( posX, 0, ItemWidth-1, h )

			surface.SetDrawColor( 255, 0, 0, 150 )
			surface.DrawRect( posX, 0, ItemWidth, SlotBarHeight )
		end

		-- Background
		surface.SetDrawColor( GradColor1 )
		surface.SetTexture( gradient )
		surface.DrawTexturedRect( posX, 0, ItemWidth, SlotBarHeight )

		-- Number
		draw.SimpleText( tostring(i), "DermaDefault", posX + ItemWidth/2, 6, color_white, TEXT_ALIGN_CENTER, 1 )

		posX = posX + ItemWidth + 2

	end

	-- Draw cosmetic
	surface.SetDrawColor( GradColor1 )
	surface.DrawRect( ew+CosmeticPadding-4, 0, ew/2+CosmeticPadding-8, 3 )
	draw.RoundedBox( 3, ew+CosmeticPadding-4, 0, ew/2+CosmeticPadding-8, h, GradColor1 )
	surface.SetFont("DermaDefault")
	local size = surface.GetTextSize("W E A R A B L E S")
	draw.SimpleText( "W E A R A B L E S", "DermaDefault", ew/2+CosmeticPadding-4 + (w-ew)/2 + (size/2), 6, color_white, TEXT_ALIGN_CENTER, 1 )


	-- Background Box while dragging
	for k, v in pairs( GTowerItems.ClientItems[1] ) do

		if not v._VGUI or not v._VGUI:Equippable() then continue end
		if v._VGUI:IsDragging() then
			surface.SetDrawColor( 0, 0, 0, 75 )
			surface.DrawRect( v._VGUI.OriginX+1, v._VGUI.OriginY+1, v._VGUI:GetWide()-1, v._VGUI:GetTall()-1 )
		end

	end

end

function PANEL:PerformLayout()

	local width, posX, posY, gap = 0, 2, SlotBarHeight, 0

	for k, v in pairs( GTowerItems.ClientItems[1] ) do

		if !v._VGUI then
			GTowerItems:CreateItemOfID( k )
		end

		if v._VGUI:Equippable() then

			v._VGUI:OriginalPos( posX, posY )

			posX = posX + ItemWidth + 2

			if k == EquipSlotsOnly-4 then
				self.EquipWidth = posX
				posX = posX + CosmeticPadding
			end

			width = posX

			v._VGUI:UpdateParent()
			v._VGUI:InvalidateLayout()

		end

	end

	posX = posX + ItemWidth + 2

	width = posX

	self:SetWide( width + 300 )
	self:SetPos( ScrW() / 2 - self:GetWide() / 2, 0 )
	self:SetZPos( 1 )

end

function PANEL:OnCursorEntered()
	GTowerItems:OpenDropInventory()
end

function PANEL:OnCursorExited()
	GTowerItems:CheckSubClose()
end


/*===========================
 == External functions
=============================*/

function PANEL:Open()

	self.IsOpen = true
	self:SetVisible( true )

	GTowerItems:HideTooltip()

end

function PANEL:Close()

	self.IsOpen = false
	self:SetVisible( false )

	GTowerItems:HideTooltip()

end

function PANEL:ForceClose()
	self:SetVisible( false )

	GTowerItems:HideTooltip()
end


/*===========================
 == Internal functions
=============================*/

function PANEL:UpdateChangingThink()
	self.Think = self.ChangingThink
end

function PANEL:IsMouseInWindow()
    local x,y = self:CursorPos()
    return x >= 0 && y >= 0 && x <= self:GetWide() && y <= self:GetTall()
end


vgui.Register("GTowerInvMain",PANEL, "Panel")

--vgui.Create("GTowerInvMain")
