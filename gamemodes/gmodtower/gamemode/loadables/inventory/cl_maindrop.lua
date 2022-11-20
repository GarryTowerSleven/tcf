
local PANEL = {}
PANEL.DEBUG = false
local OpenTime = 1 / 0.1

local BorderSize = 3
local SpaceBetweenItems = 2
local MaxColumns = 8

function PANEL:Init()

	self.CurYPos = 0
	self.Changing = true
	
end

function PANEL:Think()

	/*if self.TimerClose && CurTime() > self.TimerClose then
		self:Close()
	end*/
	
	if self.Changing then
		self:ChangingThink()
	end

end

function PANEL:Paint( w, h )

	-- Background
	local color = Color( 70, 100, 150, 255 )
	draw.RoundedBox( 3, 0, 0, w-2, h-2, colorutil.Brighten(color, .75) )

	-- Background Box while dragging
	for k, v in pairs( GTowerItems.ClientItems[1] ) do
	
		if !v._VGUI or v._VGUI:Equippable() then continue end
		if v._VGUI:IsDragging() then
			surface.SetDrawColor( 0, 0, 0, 50 )
			surface.DrawRect( v._VGUI.OriginX+1, v._VGUI.OriginY+1, v._VGUI:GetWide()-1, v._VGUI:GetTall()-1 )
		end
	
	end

end

function PANEL:ChangingThink()

	local TargetPos = self:GetTargetYPos()
	local NewYPos = math.Approach( self.CurYPos, TargetPos, math.max( FrameTime(), 0.01 ) * self:GetTall() * OpenTime )
	
	if NewYPos == TargetPos then
		self.Changing = false
		
		if NewYPos < 0 then
			self:SetVisible( false )
		end
	end
	
	self:SetPos( self.x, NewYPos )
	self.CurYPos = NewYPos 

end

function PANEL:StopDragging()
	for _, v in pairs( GTowerItems.ClientItems[1] ) do
		if IsValid( v._VGUI ) && v._VGUI:IsDragging() then
			v._VGUI:StopDrag()
		end	
	end
end

function PANEL:PerformLayout()
	
	local CurX, CurY = BorderSize+1, BorderSize
	local MaxHeight, MaxWidth = 1, 0
	local Col = 0
	local HasItemsOnRow = false
	
	for k, v in pairs( GTowerItems.ClientItems[1] ) do
	
		if !v._VGUI then
			GTowerItems:CreateItemOfID( k )
		end
		
		if !v._VGUI:Equippable() then
			HasItemsOnRow = true
			
			v._VGUI:OriginalPos( CurX, CurY )

			CurX = CurX + v._VGUI:GetWide() + SpaceBetweenItems

			Col = Col + 1
			
			if v._VGUI:GetTall() > MaxHeight then
				MaxHeight = v._VGUI:GetTall()
			end
			
			if Col >= MaxColumns then
				MaxWidth = CurX
				Col = 0
				CurX = BorderSize+1
				CurY = CurY + v._VGUI:GetTall() + SpaceBetweenItems
				HasItemsOnRow = false
			end
			
			v._VGUI:UpdateParent()
			v._VGUI:InvalidateLayout()
			
		end
	
	end
	
	local Tall = CurY + BorderSize + SpaceBetweenItems
	
	if HasItemsOnRow == true then
		Tall = Tall + MaxHeight
	end
	
	self:SetSize( MaxWidth + (BorderSize *2), Tall )

	local pwide = GTowerItems.MainInvPanel.x + (GTowerItems.MainInvPanel.EquipWidth/2)
	self:SetPos( pwide - self:GetWide()/2, self.CurYPos )
	
end

function PANEL:OnCursorEntered()

end

function PANEL:OnCursorExited()
	self:CheckClose()
end


/*===========================
 == External functions
=============================*/

function PANEL:Open()

	self.IsOpen = true
	self:UpdateChanging()
	self.GetTargetYPos = self.GetTargetYPosOpen
	
	self:SetVisible( true )

end

function PANEL:Close()

	self.IsOpen = false
	self:UpdateChanging()
	self:StopDragging()
	self.GetTargetYPos = self.GetTargetYPosClosed
	
end


function PANEL:ForceClose()
	self.CurYPos = self:GetTall() * -1 
	self:SetPos( self.x, self.CurYPos )
	self:SetVisible( false )
end


function PANEL:CheckClose()

	if self.DEBUG then Msg2("InvMainDrop: Checking for closing") end

	if self.IsOpen == false then
		return
	end
	
	if self:IsMouseInWindow() then
		return
	end
	
	if GTowerItems.MainInvPanel:IsMouseInWindow() then
		return
	end
	
	if IsValid( GTowerItems.EntGrab.VGUI ) then -- Make sure one of the outside entites are not being grabbed
		return
	end
	
	for _, v in pairs( GTowerItems.ClientItems[1] ) do
		if v._VGUI && v._VGUI:IsDragging() then
			if self.DEBUG then Msg2("InvMainDrop: Found item being dragged, ignoring.") end
			return
		end
	end
	
	if hook.Call("InvDropCheckClose", GAMEMODE ) == false then
		return
	end
	
end


/*===========================
 == Internal functions
=============================*/

function PANEL:GetTargetYPosOpen()
	if GTowerItems.MainInvPanel then
		return GTowerItems.MainInvPanel.y + GTowerItems.MainInvPanel:GetTall()
	end
	
	return 0
end

function PANEL:UpdateChanging()
	self.Changing = true
end

function PANEL:GetTargetYPosClosed()
	if GTowerItems.MainInvPanel then
		return GTowerItems.MainInvPanel.y - self:GetTall()
	end
	
	return -self:GetTall()
end
PANEL.GetTargetYPos = PANEL.GetTargetYPosClosed


function PANEL:IsMouseInWindow()
    local x,y = self:CursorPos()
    return x >= 0 && y >= 0 && x <= self:GetWide() && y <= self:GetTall()
end


vgui.Register("GTowerInvDrop",PANEL, "Panel")