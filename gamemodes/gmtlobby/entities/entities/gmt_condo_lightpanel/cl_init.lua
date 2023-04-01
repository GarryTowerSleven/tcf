include('shared.lua')

local IsGameUIVisible = gui.IsGameUIVisible
local IsConsoleVisible = gui.IsConsoleVisible
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.LightValues = { 1, .8, .6, .4, .2, 0 }
ENT.CurrentLightValue = 1
ENT.CurrentLightColor = Color( 255, 255, 255 )

ENT.LightOffsets = {
	[1] = Vector(136, 140, 0),
	[2] = Vector(-27, 187, -0),
	--1563.637451 107.941208 -48.313026
}

function ENT:Initialize()

	self.mx = 0
	self.my = 0
	self.visible = false
	self.mousePress = false

end

function ENT:SetupScreen()

	local pos = self:GetPos() - ( self:GetRight() * .75 )
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), -180)
	ang:RotateAroundAxis(ang:Up(), -90)

	self.screen = screen.New()		--create 3D2D screen
	self.screen:SetPos(pos)			--center of screen
	self.screen:SetAngles(ang)		--forward angle
	self.screen:SetSize(5.5,9.1)	--screen size
	self.screen:SetRes(256,400) 	--document size
	self.screen:AddToScene(false)	--for callback support (false means don't automatically draw)
	self.screen:SetMaxDist(128)		--max distance a player can use
	self.screen:SetCull(true)		--only use/draw from front
	self.screen:SetBorder(0)		--slight border to fill gap between screen and model
	self.screen:SetFade(300,400)	--panel facade startFade, endFade
	self.screen:SetDrawFunc(		--2D draw function
		function(scr,w,h)
			self:DrawPanel( w, h )
			self:DrawCursor( w, h )
		end
	)
end


function ENT:Draw()
	self:DrawModel()
end

function ENT:SetLightColor( color )
	self:SetLightColorR( color.r )
	self:SetLightColorG( color.g )
	self:SetLightColorB( color.b )
end

function ENT:GetLightColor()
	return Color( self:GetLightColorR() or 255, self:GetLightColorG() or 255, self:GetLightColorB() or 255 )
end

function ENT:SendLightParams( val, color )
	net.Start( "CondoLightUpdate" )
		net.WriteEntity( self )

		val = val or self:GetLightValue() or 1
		net.WriteUInt( math.Round(val * 255), 8 )

		color = color or self:GetLightColor()
		net.WriteUInt( color.r, 8 )
		net.WriteUInt( color.g, 8 )
		net.WriteUInt( color.b, 8 )
	net.SendToServer()
end

function ENT:Think()
	self:DrawLight()
end

function ENT:GetLightPos()
	return self:GetPos() + self.LightOffsets[self:GetLightID() or 1]
end

function ENT:DrawLight()

	if not self:GetLightValue() or self:GetLightValue() == 0 then return end

	local trace = util.TraceLine({start=self:GetLightPos(), endpos=LocalPlayer():EyePos()})
	if trace.HitWorld or ( IsValid( trace.Entity ) and trace.Entity:GetClass() == "func_door" ) then return end

	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.pos = self:GetLightPos()
		dlight.r = self:GetLightColor().r
		dlight.g = self:GetLightColor().g
		dlight.b = self:GetLightColor().b
		dlight.brightness = 2 * (self:GetLightValue() or 1)
		dlight.Decay = 1024 * (self:GetLightValue() or 1)
		dlight.size = 1750  * (self:GetLightValue() or 1)
		dlight.DieTime = CurTime() + 1
	end

end

local iconSize = 64
local iconLargeSize = 128
local barw, barh = 40, 40
local iconY = 64 + 50
local colorMat = Material( "gmod_tower/panelos/rainbow.png", "unlitsmooth" )

function ENT:GetCondo()
	local condoid = self:GetNWInt("condoID")
	return condoid--GtowerRooms:Get( condoid )
end

function ENT:DrawPanel( scrw, scrh )

	surface.SetDrawColor( 24, 25, 26 )
	surface.DrawRect( 0, 0, scrw, scrh )

	local canuse, adminoverride = GtowerRooms:CanManagePanel( self:GetCondo(), LocalPlayer() )

	if not canuse then

		surface.SetDrawColor( self:GetLightColor() )
		surface.SetMaterial( GTowerIcons2.GetIcon("light") )
		surface.DrawTexturedRect( scrw/2 - iconLargeSize/2, scrh/2 - iconLargeSize/2, iconLargeSize, iconLargeSize )

		surface.SetTextColor( 255, 255, 255 )
		draw.DrawText( "CONTROLLED BY\nCONDO OWNER ONLY", "GTowerHUDMainLarge", scrw/2, scrh-80, Color( 255, 255, 255, 15 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		return
	end

	self:DrawButtons()

	local vip = LocalPlayer():IsVIP()

	if vip then
		self:DrawVIPPanel( scrw, scrh )
	else

		-- Light toggle
		self:CreateButton( "light_toggle", scrw/2 - iconLargeSize/2, scrh/2 - iconLargeSize/2, iconLargeSize, iconLargeSize,
			function( btn, x, y, w, h, isover ) -- draw
				if isover then
					surface.SetDrawColor( Color( 0, 162, 236, 255 ) )
				else
					--local white = math.Clamp( self:GetLightValue() * 255, 100, 255 )
					local color = self:GetLightColor()
					surface.SetDrawColor( color.r, color.g, color.b, math.Clamp( 255 * (self:GetLightValue() or 1), 50, 255 ) )
				end

				surface.SetMaterial( GTowerIcons2.GetIcon("light") )
				surface.DrawTexturedRect( x, y, w, h )
			end,
			function( btn ) -- onclick
				if self:GetLightValue() <= .5 then
					self:SendLightParams( 1 )
				else
					self:SendLightParams( 0 )
				end
			end
		)

		surface.SetTextColor( 255, 255, 255 )
		draw.DrawText( "DONATE FOR\nMORE CONTROL", "GTowerHUDMainLarge", scrw/2, scrh-80, Color( 255, 255, 255, 15 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	end

end

function ENT:DrawVIPPanel( scrw, scrh )

	local x = (scrw/2) - (iconSize/2)
	local y = 32

	-- Light toggle
	self:CreateButton( "light_toggle_vip", x, y, iconSize, iconSize,
		function( btn, x, y, w, h, isover ) -- draw
			if isover then
				surface.SetDrawColor( Color( 0, 162, 236, 255 ) )
			else
				--local white = math.Clamp( self:GetLightValue() * 255, 100, 255 )
				local color = self:GetLightColor()
				surface.SetDrawColor( color.r, color.g, color.b, math.Clamp( 255 * (self:GetLightValue() or 1), 50, 255 ) )
			end

			surface.SetMaterial( GTowerIcons2.GetIcon("light") )
			surface.DrawTexturedRect( x, y, w, h )
		end,
		function( btn ) -- onclick
			if (self:GetLightValue() or 1) <= .5 then
				self:SendLightParams( 1 )
			else
				self:SendLightParams( 0 )
			end
		end
	)

	barw = scrw/2 - 4
	x, y = 0, iconY
	local white = 255
	for id, value in pairs( self.LightValues ) do

		self:CreateButton( "light_style_"..value, x, y, barw, barh,
			function( btn, x, y, w, h, isover ) -- draw
				if isover then
					surface.SetDrawColor( Color( 0, 162, 236, 255 ) )
				else
					if (self:GetLightValue() or 1) >= value then
						local white = math.Clamp(  (self:GetLightValue() or 1) * 255, 100, 255 )
						surface.SetDrawColor( Color( white, white, white ) )
					else
						local white = 50
						surface.SetDrawColor( Color( white, white, white ) )
					end
				end
				surface.DrawRect( x, y, w, h )
			end,
			function( btn ) -- onclick
				self:SendLightParams( value )
			end
		)
		y = y + barh + 10
		white = white - 25

	end

	x, y = barw+8, iconY

	-- Light color
	self:CreateButton( "light_color", x, y, barw, scrh-y,
		function( btn, x, y, w, h, isover ) -- draw
			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.DrawRect( x, y, w, h )

			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.SetMaterial( colorMat )
			surface.DrawTexturedRect( x, y+15, w, h )
		end,
		function( btn ) -- onclick
			color = Color( 255, 255, 255 )
			if (self.my - y) >= 15 then
				local colorPerc = math.Clamp( math.Fit( self.my, y+15, y+255, 0, 255 ), 0, 255 )
				color = HSVToColor( colorPerc, 1, 1 )
			end
			self:SendLightParams( nil, color )
		end
	)

end

function ENT:DrawCursor( scrw, scrh )

	local canuse, adminoverride = true, false --GTowerRooms.CanManagePanel( self:GetCondo(), LocalPlayer() )
	if not canuse then return end
	if not self.visible then return end

	local invokeMouseEvents = true--not ( IsGameUIVisible() or IsConsoleVisible() )

	local cursorSize = 64

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( Cursor2D )

	-- Mouse press
	if invokeMouseEvents and input.IsMouseDown( MOUSE_LEFT ) and canuse then
		cursorSize = 58
		self:MouseEvent( self.mx, self.my )
	end

	local offset = cursorSize / 2
	local cursorX, cursorY = self.mx - offset + 10, self.my - offset + 15
	surface.DrawTexturedRect( cursorX, cursorY, cursorSize, cursorSize )

end

function ENT:CreateButton( name, x, y, w, h, paint, pressed )

	if not self.buttons then
		self.buttons = {}
	end

	if self.buttons[name] then return end

	local btn = {
		x = x or 0, y = y or 0,
		w = w or 1, h = h or 1,
		DoPaint = paint, OnPressed = pressed
	}

	self.buttons[name] = btn

end

function ENT:IsMouseOver( x, y, w, h )
	return ( self.mx >= x && self.my >= y && self.mx <= x+w && self.my <= y+h ) && self.visible
end

function ENT:DrawButtons()
	if not self.buttons then return end
	for _, btn in pairs( self.buttons ) do
		local isover = self:IsMouseOver( btn.x, btn.y, btn.w, btn.h )
		btn:DoPaint( btn.x, btn.y, btn.w, btn.h, isover )
	end
end

function ENT:MouseEvent( x, y )

	if not self.buttons then return end

	-- Buttons
	for _, btn in pairs( self.buttons ) do
		local isover = self:IsMouseOver( btn.x, btn.y, btn.w, btn.h )
		if isover then
			if not btn.NextPress or btn.NextPress < CurTime() then
				btn.NextPress = CurTime() + .25
				btn:OnPressed()
			end
		end
	end

end
