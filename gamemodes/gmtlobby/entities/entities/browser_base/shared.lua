AddCSLuaFile("shared.lua")

if SERVER then
	AddCSLuaFile("cl_html.lua")
else
	include("cl_html.lua")
end

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.RenderGroup = RENDERGROUP_BOTH

local activebrowser = nil
local DEBUG = false
//MatInUse = {}

function SetupBrowser( ENT, width, height, scale )

	if SERVER then return end
	
	ENT.Width = width
	ENT.Height = height
	ENT.Scale = scale

end

local function RayQuadIntersect(vOrigin, vDirection, vPlane, vX, vY)

	local vp = vDirection:Cross(vY)

	local d = vX:DotProduct(vp)

	if (d <= 0.0) then return end

	local vt = vOrigin - vPlane
	local u = vt:DotProduct(vp)
	if (u < 0.0 or u > d) then return end

	local v = vDirection:DotProduct(vt:Cross(vX))
	if (v < 0.0 or v > d) then return end

	return Vector(u / d, v / d, 0)

end

local function BuildFace(vMins, vMaxs)

	local p3 = Vector(0, vMaxs.y, vMins.z)
	local p4 = Vector(0, vMins.y, vMins.z)
	local p7 = Vector(0, vMaxs.y, vMaxs.z)
	local p8 = Vector(0, vMins.y, vMaxs.z)

	return
	{
		Vertex( p8, 0, 0 ),
		Vertex( p7, 1, 0 ),
		Vertex( p4, 0, 1 ),
		Vertex( p7, 1, 0 ),
		Vertex( p3, 1, 1 ),
		Vertex( p4, 0, 1 ),
	}

end

function ENT:SetLargeBounds()

	if !self.Scale then
		self.Scale = .1
	end

	local w = self.Width / 2
	local min = Vector(-w * self.Scale, -w * self.Scale, 0)
	local max = Vector(w * self.Scale, w * self.Scale, self.Height*self.Scale)

	if self.SetRenderBounds then
		self:SetRenderBounds(min, max)
	end

end

function ENT:InitBrowser()

	self.Browser = vgui.Create("GMTBrowserHTML")
	self.Browser:SetSize( self.Width, self.Height )
	self.Browser:SetEntity( self )
	self.Browser:SetPaintedManually( true )
	self.Browser:SetAllowLua( true )
	self.Browser:AddFunction( "gmt", "SendData", function( data ) self:ParseData( data ) end )
	self.Browser:AddFunction( "gmt", "ExtraData", function( data ) MsgN( data ) if self.ParseExtraData then self:ParseExtraData( data ) end end )
	self.Browser:SetMouseInputEnabled( false )

	self.mX, self.mY = 0, 0
	self.mActive = false

	LocalPlayer().ActiveBrowser = self.Browser

end

function ENT:RemoveBrowser()

	if self.Browser then
		self.Browser:Free()
		self.Browser = false

		self:CloseInputPanel()
		LocalPlayer().ActiveBrowser = nil
	end

end

function ENT:OnRemove()
	self:RemoveBrowser()
end

function ENT:GetPosBrowser()
	return self:GetPos()
end

function BrowserScroll(ply, bind, pressed)

	if !IsValid(activebrowser) || !activebrowser.Browser || !activebrowser.mActive then return end

	if bind == "invnext" then
		activebrowser.Browser:MouseScroll(-3)
		return true
	elseif bind == "invprev" then
		activebrowser.Browser:MouseScroll(3)
		return true
	end

	// Disable shooting
	if bind == "+attack" || bind == "+attack2" then
		return true
	end

end

hook.Add("PlayerBindPress", "BrowserScroll", BrowserScroll)

function ENT:MouseRayInteresct()

	local up, right = self:GetUp(), self:GetRight()
	local plane = self:GetPosBrowser() + ( (up * self.Height * self.Scale) + ( right * (-self.Width/2) * self.Scale ) )

	local x = (right * (self.Width/2) * self.Scale) - (right * (-self.Width/2) * self.Scale)
	local y = (up * -self.Height * self.Scale)

	return RayQuadIntersect( LocalPlayer():EyePos(), GetMouseAimVector(), plane, x, y )

end

local mousedownlast = false
local guienabled = false

function ENT:MouseThink()

	local uv = self:MouseRayInteresct()

	if uv then
		if !self.mActive then
			if self.Focus then
				self:BringUpInputPanel()
			end
			if self.OnEnterBrowser then
				self:OnEnterBrowser()
			end
		end

		// there can only be one active browser, this is for scrolling
		activebrowser = self

		self.mActive = true
		self.mX, self.mY = (1-uv.x) * self.Width, uv.y * self.Height

		//self.Browser:MouseMove(self.mX, self.mY)

		local down = input.IsMouseDown(MOUSE_LEFT)

		if down && !mousedownlast then

			self.Browser:MouseUpDown(true, 0)

		elseif !down && mousedownlast then
			self.Browser:MouseUpDown(false, 0)
		end

		mousedownlast = down

		self.mX = math.Clamp(self.mX, 1, self.Width - 1)
		self.mY = math.Clamp(self.mY, 1, self.Height - 1)

	elseif self.mActive then

		self.mActive = false
		self:CloseInputPanel()

	end

end

function ENT:DrawBrowser()
	if !self.Browser then return end
	draw.HTMLTexture( self.Browser, self.Width, self.Height )
end

function ENT:DrawCursor()

	if !self.mActive then return end

	if !self.InputPanel && ( self:GetClass() == "gmt_room_tv" || self:GetClass() == "gmt_room_tv_large" ) then return end

	local cursorSize = 32
	
	surface.SetTexture( Cursor2D )

	if input.IsMouseDown( MOUSE_LEFT ) then
		cursorSize = 28
		surface.SetDrawColor( 255, 150, 150, 255 )
	else
		surface.SetDrawColor( 255, 255, 255, 255 )
	end

	local offset = cursorSize / 2
	surface.DrawTexturedRect( self.mX - offset + 5, self.mY - offset + 5, cursorSize, cursorSize )

end

function ENT:BaseBrowserDraw()

	local pos, ang = self:GetPosBrowser(), self:GetAngles()
	local up, right = self:GetUp(), self:GetRight()

	pos = pos + (up * self.Height * self.Scale) + (right * (self.Width/2) * self.Scale)

	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos,ang,self.Scale)

		pcall( self.DrawBrowser, self )
		pcall( self.DrawCursor, self )

	cam.End3D2D()

end

function ENT:BringUpInputPanel()

	if self.InputPanel then return end
	
	if DEBUG then
		print("bring up input")
	end

	gui.EnableScreenClicker( true )
	
	self.InputPanel = vgui.Create("DTextEntry")
	self.InputPanel:NoClipping(true)
	self.InputPanel:MakePopup()
	self.InputPanel:SetMouseInputEnabled(true)
	self.InputPanel.DownKey = {}

	self.InputPanel.AllowInput = function(panel, strValue)
		self.Browser:KeyEvent(string.byte(strValue), true)
		return false
	end

	self.InputPanel.Think = function(panel)
		// this is so we can "hold down" a key

		for key, down in pairs(panel.DownKey) do
			if !input.IsKeyDown(key) then
				self.Browser:KeyEvent(key, false, true)
				panel.DownKey[key] = nil
			end
		end
	end

	self.InputPanel.OnKeyCodePressed = function(panel, code)
		if code == KEY_TAB then
			self:CloseInputPanel()
			return
		end

		self.Browser:KeyEvent(code, true, true)
		panel.DownKey[code] = true
		panel.RepeatKey = RealTime()
	end

	self.InputPanel.Paint = function(panel)

		surface.SetDrawColor( 0, 0, 0, 180 )
		surface.DrawRect( 0, 0, ScrW(), 60 )

		draw.SimpleText( "PRESS TAB TO REGAIN CONTROL", "GTowerTabNotice", ScrW() / 2, 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )

	end

end

function ENT:CloseInputPanel()

	if !self.InputPanel then return end
	
	if DEBUG then
		print("close input")
	end

	gui.EnableScreenClicker( false )
	
	self.InputPanel:Remove()
	self.InputPanel = nil

end

function ENT:InitDisplayBrowser()

	self.ControlBrowser = vgui.Create("GMTBrowserHTML")
	self.ControlBrowser:SetSize( 720, 480 )
	self.ControlBrowser:SetEntity( self )
	self.ControlBrowser:SetPaintedManually( true )
	self.ControlBrowser:SetAllowLua( true )
	self.ControlBrowser:AddFunction( "gmt", "SendData", function( data ) self:ParseData( data ) end )
	self.ControlBrowser:AddFunction( "gmt", "ExtraData", function( data ) MsgN( data ) if self.ParseExtraData then self:ParseExtraData( data ) end end )

	LocalPlayer().ActiveBrowser = self.ControlBrowser

end

function ENT:DisplayControls( title, url, onclose )

	if !IsValid( self.ControlBrowser ) then
		self:InitDisplayBrowser()
	end
	
	if !IsValid( self.HTMLFrame ) then
		local w, h = self.ControlBrowser:GetWide() + 10, self.ControlBrowser:GetTall() + 35

		self.HTMLFrame = vgui.Create( "DFrame" )
		self.HTMLFrame:SetSize( w, h )
		self.HTMLFrame:SetTitle( title )
		self.HTMLFrame:SetPos( ( ScrW() / 2 ) - ( w / 2 ), ( ScrH() / 2 ) - ( h / 2 ) )
		self.HTMLFrame:SetDraggable( true )
		self.HTMLFrame:ShowCloseButton( true )
		self.HTMLFrame:SetDeleteOnClose( true )
	end
	
	self.ControlBrowser:SetPaintedManually( false )
	self.ControlBrowser:SetParent( self.HTMLFrame )
	self.ControlBrowser:SetPos( 5, 25 )
	self.ControlBrowser:OpenURL( url )
	
	self.HTMLFrame:SetVisible( true )
	self.HTMLFrame:MakePopup()
	
	local browser = self.ControlBrowser
	local ent = self
	self.HTMLFrame.Close = function( self )

		DFrame.Close( self )

		if IsValid( browser ) then
			browser:Remove()
			ent.ControlBrowser = nil

			if AntiAFK then
				AntiAFK.ForceReset()
			end

			if onclose then
				onclose()
			end
		end

	end

end

function ENT:CloseControls()

	if IsValid( self.HTMLFrame ) then
		self.HTMLFrame:Close()
		self.HTMLFrame:Remove()
		self.HTMLFrame = nil
	end

	if IsValid( self.ControlBrowser ) then
		self.ControlBrowser:Remove()
		self.ControlBrowser = nil
	end

	LocalPlayer().ActiveBrowser = nil

end

function ENT:IsControlsOpen()
	return IsValid( self.HTMLFrame )
end

function ENT:onBeginNavigation(url)

	if self.OpeningURL then
		self:OpeningURL(url)
	end

end

function ENT:onBeginLoading(url, status)

	if self.LoadingURL then
		self:LoadingURL(url)
	end

end

function ENT:onFinishLoading()

	if self.FinishLoading then
		self:FinishLoading()
	end

end

function ENT:onChangeFocus(focus)

	//print("focus", focus, self.InputPanel)
	if focus then
		self:BringUpInputPanel()
	else
		self:CloseInputPanel()
	end
	self.Focus = focus

end