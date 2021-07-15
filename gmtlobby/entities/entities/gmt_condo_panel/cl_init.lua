include('shared.lua')

local cam = cam
local draw = draw
local render = render
local surface = surface
local LocalPlayer = LocalPlayer
local IsGameUIVisible = gui.IsGameUIVisible
local IsConsoleVisible = gui.IsConsoleVisible

module("panelos", package.seeall )
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Initialize()

	self.mouseX = 0
	self.mouseY = 0
	self.mousePress = false
	self.interact = false
	self.homePress = false
		
	self:OSInit()
	self:SetupScreen()

end


function ENT:SetupScreen()
	local pos = self:GetPos() - ( self:GetRight() * -.2 ) + self:GetUp() * 1.15
	local ang = self:GetAngles()

	ang:RotateAroundAxis(ang:Up(), -90)

	self.panelAngle = ang
	self.panelPos = pos

	self.screen = screen.New()		--create 3D2D screen
	self.screen:SetPos(pos)			--center of screen
	self.screen:SetAngles(ang)		--forward angle
	self.screen:SetSize(37,21.2)	--screen size
	self.screen:SetRes(1387,800) 	--document size
	self.screen:AddToScene(false)	--for callback support (false means don't automatically draw)
	self.screen:SetMaxDist(128)		--max distance a player can use
	self.screen:SetCull(true)		--only use/draw from front
	self.screen:SetBorder(1)		--slight border to fill gap between screen and model
	self.screen:SetFade(300,400)	--panel facade startFade, endFade
	self.screen:SetFacadeMaterial(panelos.Backgrounds[1]) --use this material for facade
	self.screen:SetFacadeColor(Color(255,255,255)) --draw facade with this color
	self.screen:EnableInput(true)	--enable input hooking
	self.screen:SetDrawFunc(		--2D draw function
		function(scr,w,h)
			scrw = w
			scrh = h
			self:DrawPanel()
			self:DrawCursor()
		end
	)
end

function ENT:SetScreenFacade(mat)
	self.screen:SetFacadeMaterial(mat)
end

function ENT:Draw()

	mx, my, visible = self.screen:GetMouse()
	LocalPlayer().UsingPanel = ( visible and self or nil )
	self.screen:Draw()
	self:DrawModel()

end

function ENT:DrawPanel()

	surface.SetDrawColor( 50, 58, 69, 255 )
	surface.DrawRect( 0, 0, scrw, scrh )

	if self.instance then
		local transitionTime = math.min(self.instance:GetTime() * 2, 1)

		if transitionTime ~= 1 then
			local af = (self.panelAngle:Up() + self.panelAngle:Right()):GetNormal()
			local df = self.panelPos:Dot(af)
			local theta = transitionTime * math.pi/2
			local transition = self.HalfWidth - math.pow(math.sin(theta), 3) * self.Width

			transition = transition * self.ui_scale

			--render.PushCustomClipPlane(-af, -df)
			render.PushCustomClipPlane(-af, -df - transition)
			if LocalPlayer() then
				self.instance:DrawGUI(true)
			else
				self.instance:DrawPreviewGUI(true)
			end
			render.PopCustomClipPlane()

			render.PushCustomClipPlane(af, df + transition)
			if LocalPlayer() then
				self.instance:DrawGUI()
			else
				self.instance:DrawPreviewGUI()
			end
			render.PopCustomClipPlane()
		else
			if LocalPlayer() then
				self.instance:DrawGUI()
			else
				self.instance:DrawPreviewGUI()
			end
		end
	end

	self:DrawMainGUI( w, h )

end

function ENT:DrawMainGUI()

	-- Top Bar
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.SetTexture( GradientDown )
	surface.DrawTexturedRect( 0, 0, scrw, 64 )

	-- Time
	draw.DrawText(os.date("%I:%M"), "AppBarSmall", scrw-64-110, 10, Color(255, 255, 255, 200))
	draw.DrawText(os.date("%p"), "AppBarSmall", scrw-64-10, 10, Color(255, 255, 255, 200))
	if self.AlarmSet then
		surface.SetMaterial( Icons["alarm"] )
		surface.SetDrawColor( 255,255,255 )
		surface.DrawTexturedRect( scrw - 64 - 110 - 64, 0, 64, 64 )
	end

	-- Home Bar
	surface.SetDrawColor( 0, 0, 0, 200 )
	surface.SetTexture( GradientUp )
	surface.DrawTexturedRect( 0, scrh-64, scrw, 64 )

	-- Back
	local iconSize = 96
	local padding = 12
	local back = false
	if self.instance:Current() ~= "homescreen" then

		if Icons[self.instance:CurrentIcon()] then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetMaterial( Icons[self.instance:CurrentIcon()] )
			surface.DrawTexturedRect( 16, 0, 64, 64 )
		end

		draw.DrawText(self.instance:Current(true), "AppBarSmall", 16+2+64, 10, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)

		local over = DrawButton( Icons.home, (scrw/2)-iconSize/2, scrh-iconSize+padding, iconSize )
		local room = self:GetNWInt("condoID")
		local canuse = GtowerRooms.CanManagePanel( room, LocalPlayer() )

		if over and self.mousePress and !self.homePress and canuse then
			self:EmitSound(Sounds["back"])
			--self.instance:Launch("homescreen", false, true)
			self.instance:App():Launch("homescreen")
			self.homePress = true
		end
	else
		self.homePress = false

		-- Condo ID
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( Icons["about"] )
		surface.DrawTexturedRect( 16, 0, 64, 64 )

		local info = "Condo #"..tostring(LocalPlayer().GLocation - 1)
		local condo = self:GetCondo()
		if condo then
			info = info .. " | Welcome, " .. GtowerRooms:RoomOwnerName(LocalPlayer().GLocation - 1)
		end
		draw.DrawText(info, "AppBarSmall", 16+2+64, 10, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
	end

end

function ENT:DrawCursor()

	if self.interact and not visible then
		self.instance:MouseEvent(MOUSE_LEAVE, mx, my)
		self.interact = false
		return
	end

	if not self.interact and visible then
		self.instance:MouseEvent(MOUSE_ENTER, mx, my)
		self.interact = true
	end

	if not visible then return end

	local room = self:GetCondo()
	local canuse, adminoverride = GtowerRooms.CanManagePanel( room, LocalPlayer() )
	local invokeMouseEvents = not ( IsGameUIVisible() or IsConsoleVisible() )

	local cursorSize = 64

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( Cursor2D )

	if self.mouseX ~= mx or self.mouseY ~= my then
		self.mouseX = mx
		self.mouseY = my
		self.instance:MouseEvent(MOUSE_MOVE, mx, my)
	end

	-- Mouse press
	if invokeMouseEvents and input.IsMouseDown( MOUSE_LEFT ) and canuse then
		cursorSize = 58

		if not self.mousePress then
			if my < scrh - 96 then self.instance:MouseEvent(MOUSE_PRESS, mx, my) end
			self.mousePress = true
		end
	else
		if self.mousePress then
			if my < scrh - 96 then self.instance:MouseEvent(MOUSE_RELEASE, mx, my) end
			self.mousePress = false
		end
	end

	if not self.screen:IsEditingText() then -- Don't draw cursor while editing text

		local offset = cursorSize / 2
		local cursorX, cursorY = mx - offset + 10, my - offset + 15
		surface.DrawTexturedRect( cursorX, cursorY, cursorSize, cursorSize )

		if not canuse then
			surface.SetTexture( CursorLock2D )
			surface.DrawTexturedRect( cursorX + 30, cursorY + 10, cursorSize, cursorSize )
		end

		if adminoverride then
			draw.DrawText("ADMIN OVERRIDE", "AppBarLabelSmall", cursorX + 45, cursorY + 30, Color(255, 255, 255, 200), TEXT_ALIGN_LEFT)
		end

	end

end

hook.Add( "PlayerBindPress", "PlayerPanelUse", function( ply, bind, pressed )

	local ent = GAMEMODE:PlayerUseTrace( ply )
	ent = GAMEMODE:FindUseEntity( ply, ent )

	if IsValid( ent ) and ent:GetClass() == "gmt_condo_panel" then

		local room = ent:GetCondo()
		local canuse, adminoverride = GtowerRooms.CanManagePanel( room, LocalPlayer() )
		local invokeMouseEvents = not ( IsGameUIVisible() or IsConsoleVisible() )

		if bind == "+use" && pressed then

			-- Mouse press
			if invokeMouseEvents and canuse then
				if not ent.mousePress then
					if my < scrh - 96 then ent.instance:MouseEvent(MOUSE_PRESS, mx, my) end
					ent.mousePress = true
				end
			else
				if ent.mousePress then
					if my < scrh - 96 then ent.instance:MouseEvent(MOUSE_RELEASE, mx, my) end
					ent.mousePress = false
				end
			end

		end

	end

end )
