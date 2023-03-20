GTowerMessages = {
	MsgObjs = {},
	Type = 1,
	IsOpen = false,

	ClosedAlpha = 230,
	ButtonAlpha = 150,
	ButtonOffAlpha = 0,
	OpenedAlpha = 230,
	FullAlpha = 255,
}

function Msg2( ... )

	if select('#', ... ) > 0 then
		return GTowerMessages:AddNewItem( ... )
	end

end

function MsgI( icon, text, time, autoclose )
	return GTowerMessages:AddNewItem( text, time, autoclose, icon )
end

function GetMessageYPosition()
	return ScrH() - 70
end

function GTowerMessages:CloseMe()

	GTowerMessages.IsOpen = false

	for _, v in pairs( GTowerMessages.MsgObjs ) do
		
		v:SetTargetAlpha( GTowerMessages:GetCurAlpha( v ) )
		v:ResumeTimer()
	
	end

end
hook.Add("GTowerHideMenus", "ResumeTimers", GTowerMessages.CloseMe )

function GTowerMessages:AddNewItem( text, time, autoclose, icon )

	local NewItem = vgui.Create( "GTowerNewMessage" )
	
	NewItem:SetText( text )
	NewItem:SetTargetAlpha( self:GetCurAlpha( NewItem ) )
	
	if time != nil then
		NewItem:SetDuration( time, true )
	end

	if icon then
		NewItem:SetIcon( icon )
	end
	
	NewItem:SetAutoClose( autoclose != false )
	
	if self.IsOpen == true && NewItem:GetAutoClose() == true then
		NewItem:StopTimer()
	end
	
	table.insert( self.MsgObjs, NewItem )
	
	self:Invalidate()
	
	Msg( text .. "\n" )
	
	return NewItem

end

function GTowerMessages:GetCurAlpha( panel )

	if panel != nil && panel.Hovered then 
		return self.FullAlpha
	end

	return self.IsOpen && self.OpenedAlpha || self.ClosedAlpha

end

function GTowerMessages:OpenMe()

	GTowerMessages.IsOpen = true

	for _, v in pairs( self.MsgObjs ) do
		
		v:SetTargetAlpha( self:GetCurAlpha( v ) )
		
		if v:GetAutoClose() == true then
			v:StopTimer()
		end
		
	end

end

function GTowerMessages:RemovePanel( panel )

	local id = nil
	
	for k, v in pairs( self.MsgObjs ) do
		if v != nil && v == panel then        
 
			table.remove( self.MsgObjs, k ):Remove() // remove the object, and delete the panel
			
			break
		end    
	end    

	self:Invalidate()

end

function GTowerMessages:Invalidate()

	local TempTable = table.Copy( self.MsgObjs )
	
	table.sort( TempTable,
		function(a,b)   
			return a.DieTime < b.DieTime
		end
	)

	local CurY = ( self.Type == 1 && GetMessageYPosition ) && ( GetMessageYPosition() - 50 ) or 50

	off = -5

	for _, v in pairs ( TempTable ) do

		v:SetTargetY( CurY )

		if self.Type == 1 then
			CurY = CurY - v:GetTall() - off
		else
			CurY = CurY + v:GetTall() + off
		end

	end

end


local PANEL = {}
PANEL.ProgressHeight = 2
PANEL.ShadowHeight = 8

AccessorFunc( PANEL, "bAutoClose", "AutoClose" )

function PANEL:Init()

	self.ReadyToDraw = true
	self.TargetX = 0
	self.TargetY = 0
	
	self:SetDuration( 10 )
	self:SetAutoClose( true )
	
	self.TextStartY = 0
	
	self.TargetAlpha = 230
	self.Alpha = 255
	
	self.Text = {}
	
	self.Timeleft = nil
	self.Question = nil
	self.QuestionAnswered = false
	
	self.Extra = nil

	self.TextXPos = 8

end

function PANEL:SetDuration( time , reset )

	self.Duration = time
	
	if self.DieTime != nil && reset != true then
		self.DieTime = RealTime() - ( self.DieTime - RealTime() ) + time
	else
		self.DieTime = RealTime() + time
	end
	
end

function PANEL:HasQuestion()
	return self.Question != nil
end

function PANEL:SetTargetY( GoY )
	self.TargetY = GoY
end

function PANEL:SetIcon( iconname )
	return
end

function PANEL:SetupQuestion( YesFunction, NoFunction, TimeoutFunction, extra, YesColor, NoColor ) //YesText, NoText

	local YesPanel = vgui.Create( "GTowerMessageQuestion", self )
	local NoPanel = vgui.Create( "GTowerMessageQuestion", self )
	
	YesPanel:SetFunc( YesFunction, NoPanel, Material("icons/accept.vtf"), true, Color( 0, 255, 0 ) )
	NoPanel:SetFunc( NoFunction, YesPanel, Material("icons/decline.vtf"), false, Color( 255, 0, 0 ) )
	
	if YesColor != nil then
		YesPanel:SetColor( YesColor[1], YesColor[2], YesColor[3] )
	end

	if NoColor != nil then
		NoPanel:SetColor( NoColor[1], NoColor[2], NoColor[3] )
	end

	self.Question = { YesPanel, NoPanel, TimeoutFunction }

	self.Extra = extra
	
	self.TextXPos = 59
	
	YesPanel:SetVisible( true )
	NoPanel:SetVisible( true )
	
	self:InvalidateLayout()

end

function PANEL:GetExtra()
	return self.Extra
end

function PANEL:SetTargetAlpha( alpha )
	self.TargetAlpha = alpha
end

function PANEL:Show()

	if GTowerMessages.Type == 1 then
		self.TargetX = ScrW() - self:GetWide()
	else
		self.TargetX = 0
	end

end

function PANEL:GetHidingPos()

	if GTowerMessages.Type == 1 then
		return ScrW()
	else
		return -self:GetWide()
	end

end

function PANEL:Hide( NoTimout, force )

	self.TargetX = self:GetHidingPos()
	self.Removing = true
	
	if NoTimout != true && self:HasQuestion() then

		if self.Question[3] != nil then
			self.Question[3]( self:GetExtra() )
		end

	end
	
	if force == true then 
		self.DieTime = 0.0
	end

end

function PANEL:IsHiding()
	return self.TargetX == self:GetHidingPos()
end

function PANEL:SetText( text )

	self.Text = string.Explode( "\n", text )
	self:InvalidateLayout()

end


function PANEL:StopTimer()
	self.Timeleft = self.DieTime - RealTime()
end

function PANEL:ResumeTimer()

	if self.Timeleft == nil then return end
	
	self.DieTime = RealTime() + self.Timeleft
	self.Timeleft = nil

end

function PANEL:Answered( accepted )
	self.QuestionAnswered = true
	self.Accepted = accepted
end

function PANEL:GetIconColors( icon )
	return
end

local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )
local gradientDown = surface.GetTextureID( "VGUI/gradient_down" )
local dGradient = Material( "gmod_tower/hud/bg_gradient_deluxe2.png", "unlightsmooth" )
function PANEL:Paint( w, h )

	if !self.ReadyToDraw then return end

	local shadowH = self.ShadowHeight

	local Wide, Tall = self:GetWide(), self:GetTall()
	local color

	-- BG
	color = Color( 7, 51, 76 )
	surface.SetDrawColor( color.r, color.g, color.b, self.Alpha )
	surface.DrawRect( 0,0, w, h - shadowH )

	-- Color BG
	/*local bgcolor, bgflash, textcolor = self:GetIconColors( self.IconName )
	if bgcolor then
		local alpha = self.Alpha
		if bgflash then alpha = alpha * SinBetween(.5,1,RealTime() * 5) end

		surface.SetDrawColor( bgcolor.r, bgcolor.g, bgcolor.b, alpha )
		surface.DrawRect( 0,0, w, h - shadowH )
	end*/

	color = Color( 255, 255, 255 )

	if bgcolor then
		if not textcolor then
			textcolor = Color( 0, 0, 0, math.Clamp( self.Alpha * 2.5, 128, 255 ) )
		else
			textcolor = Color( textcolor.r, textcolor.g, textcolor.b, self.Alpha )
		end
		surface.SetTextColor( textcolor )
		color = textcolor
	end

	-- Text
	surface.SetFont( "GTowerMessage" )
	surface.SetTextColor( color.r, color.g, color.b, math.Clamp( self.Alpha * 2.5 , 128, 255 ) )
	
	local Height = 0
	
	-- Draw text
	for k, v in pairs( self.Text ) do

		local w, h = surface.GetTextSize( v )
		
		surface.SetTextPos( self.TextXPos, Height + self.TextStartY )
		surface.DrawText( v )
		
		Height = Height + h + 2

	end

	-- Progress bar
	color = Color(111, 237, 29)
	surface.SetDrawColor( color.r, color.g, color.b, self.Alpha )
	
	if self.Timeleft == nil then
		surface.DrawRect( 0, h - self.ProgressHeight - shadowH, w * ( ( self.DieTime - RealTime()) / self.Duration ), self.ProgressHeight )
	else
		surface.DrawRect( 0, h - self.ProgressHeight - shadowH, w * ( self.Timeleft / self.Duration ), self.ProgressHeight )
	end


	-- Draw colors when they accept/deny
	if !self.QuestionAnswered then return end
	   
	surface.DrawRect( 0, 0, w, h - shadowH )
end

function PANEL:OnCursorEntered()
	self:SetTargetAlpha( GTowerMessages.FullAlpha )
end

function PANEL:OnCursorExited( )
	self:SetTargetAlpha( GTowerMessages:GetCurAlpha( self ) )
end

function PANEL:Think()

	if not self.LastInvalidate or self.LastInvalidate > RealTime() then
		self.LastInvalidate = RealTime() + 1
		GTowerMessages:Invalidate()
	end

	if self.x != self.TargetX || self.y != self.TargetY then
	   
		self:SetPos( 
			ApproachSupport( self.x, self.TargetX, 6 ), 
			ApproachSupport2( self.y, self.TargetY, 15 )
		)
		
		if self.x == self.TargetX && self:IsHiding() then
			GTowerMessages:RemovePanel( self )
		end
	end
	
	
	if self.Alpha != self.TargetAlpha then
		self.Alpha = ApproachSupport2( self.Alpha , self.TargetAlpha, 8 )
	end
	
	if self.Timeleft == nil && self.DieTime < RealTime() && !self:IsHiding() then
		self:Hide()
	end

end


function PANEL:PerformLayout()

	local Width, Height = 0,0
	
	surface.SetFont( "GTowerMessage" )
	
	for _, v in pairs( self.Text ) do
		local w, h = surface.GetTextSize( v )
		
		Height = Height + h + self.ProgressHeight + self.ShadowHeight + 2
		
		if w > Width then
			Width = w
		end
		
	end
	
	self:SetSize( Width + 10 + self.TextXPos, Height + 10 )
	self:SetPos( self:GetHidingPos(), self.y )
	
	self.TextStartY = self:GetTall() / 2 - Height / 2
	self:Show()
	
	
	if self:HasQuestion() then

		local YesPanel = self.Question[1]
		local NoPanel =  self.Question[2]

		YesPanel:SetPos( 0, 0 )
		NoPanel:SetPos( 27, 0 )
	
	end
	
end

vgui.Register( "GTowerNewMessage", PANEL, "Panel" )


local PANEL = {}
PANEL.Size = 26

function PANEL:Init()

	self.Function = nil

	self.Color = Color( 255, 255, 255, GTowerMessages.ButtonAlpha )
	self.TargetAlpha = GTowerMessages.ButtonAlpha
	
	self.Brother = nil
	self.BtnTexture = nil

end

function PANEL:SetFunc( Function, brother, texture, accept, color )

	self.Function = Function

	self.Brother = brother	
	self.BtnTexture = texture
	self.BtnColor = color

	self.AcceptButton = accept
	self:InvalidateLayout()

end

function PANEL:OnMouseReleased()

	if self.Function != nil then

		local parent = self:GetParent()
		
		if parent.QuestionAnswered == true then return end
		
		self.Function( parent:GetExtra() )
		parent:Hide( true, true )
		parent:Answered( self.AcceptButton )

	end

end

function PANEL:SetColor( r, g, b )

	self.Color.r = r or 255
	self.Color.b = b or 255
	self.Color.g = g or 255

end

function PANEL:IsMouseOver()

	local x,y = self:CursorPos()
	return x >= 0 and y >= 0 and x <= self.Size and y <= self.Size

end

function PANEL:Paint( w, h )

	local alpha = 255

	if self:GetParent().Removing || self:GetParent().QuestionAnswered then
		alpha = GTowerMessages.ButtonAlpha
	end

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( self.BtnTexture )
	surface.DrawTexturedRect( 0, 0, self:GetWide(), self:GetTall() )
	
	surface.SetDrawColor( 3, 25, 54, self.Color.a )
	surface.DrawRect( 0, 0, 26, 26 )

end

function PANEL:Think()

	if self:IsMouseOver() then
		self.TargetAlpha = GTowerMessages.ButtonAlpha
		self:GetParent():SetTargetAlpha( GTowerMessages.FullAlpha )
		self:SetCursor("hand")
	else
		self.TargetAlpha = GTowerMessages.ButtonOffAlpha
		self:SetCursor("default")
	end

	if self.TargetAlpha != self.Color.a then
		self.Color.a = math.Approach( self.Color.a , self.TargetAlpha, FrameTime() * 5000 )
	end

end

function PANEL:PerformLayout()

	local size = 32

	self:SetSize( size, size )

end

vgui.Register( "GTowerMessageQuestion", PANEL, "Panel" )