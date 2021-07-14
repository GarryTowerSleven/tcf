
-----------------------------------------------------
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

Sounds = {

	["accept"] = "GModTower/ui/panel_accept.wav",

	["back"] = "GModTower/ui/panel_back.wav",

	["error"] = "GModTower/ui/panel_error.wav",

	["save"] = "GModTower/ui/panel_save.wav",

}


Cursor2D = surface.GetTextureID( "cursor/cursor_default" )
CursorLock2D = surface.GetTextureID( "cursor/cursor_lock" )

function CreatePlayerSprayMaterial( sprayid )



	return CreateMaterial( "sp_" .. sprayid, "UnlitGeneric",

	{

		["$basetexture"] = "temp/" .. sprayid,

		["$ignorez"] = 1,

		["$vertexcolor"] = 1,

		["$vertexalpha"] = 1,

		["$nolod"] = 1

	} )



end



function IsMouseOver( x, y, w, h )

	return ( mx >= x && my >= y && mx <= x+w && my <= y+h ) && visible

end



function DrawButton( icon, x, y, size, color, color_hovered )



	local color = color or Color( 255, 255, 255, 50 )

	local color_hovered = color_hovered or Color( 255, 255, 255 )

	local over = false



	if IsMouseOver( x, y, size, size ) then

		over = true

		surface.SetDrawColor( color_hovered )

	else

		surface.SetDrawColor( color )

	end



	surface.SetMaterial( icon )

	surface.DrawTexturedRect( x, y, size, size )



	return over



end



function DrawButtonText( text, x, y, color, color_hovered, over )



	surface.SetFont( "AppBarSmall" )

	local w, h = surface.GetTextSize(text)

	local padding = 6



	local color = color or Color( 0, 0, 0, 150 )

	local color_hovered = color_hovered or Color( 255, 255, 255, 50 )



	if over then

		surface.SetDrawColor( color_hovered )

	else

		surface.SetDrawColor( color )

	end



	surface.DrawRect( x+padding, y+padding, w+(padding*2), h+(padding*2) )



	surface.SetTextColor( 255, 255, 255 )

	surface.SetTextPos( x+padding*2, y+padding*2-2 )

	surface.DrawText( text )



end



function DrawButtonTab( text, icon, iconSize, x, y, w, h, isover, highlight, icon2, disabled, color_hovered )



	surface.SetFont( "AppBarSmall" )

	local tw, th = surface.GetTextSize(text)

	local th = 15

	local padding = 6



	local alpha = 1

	local color = Color( 20, 20, 20, 50 )

	local color_hovered = color_hovered or Color( 0, 125, 173, 255 )



	if isover or highlight then

		surface.SetDrawColor( color_hovered )

	else

		surface.SetDrawColor( color )

	end



	if disabled then

		alpha = .25

	end



	-- Background

	surface.DrawRect( x, y, w, h )



	surface.SetDrawColor( 0, 0, 0, alpha*150 )

	surface.SetTexture( GradientUp )

	surface.DrawTexturedRect( x, y, w, h )



	-- Icon

	if icon then

		surface.SetDrawColor( Color( 255, 255, 255, alpha*255 ) )

		surface.SetMaterial( icon )

		surface.DrawTexturedRect( x+padding, y, iconSize, iconSize )

	end



	-- Icon2

	if icon2 then

		surface.SetDrawColor( Color( 255, 255, 255, alpha*255 ) )

		surface.SetMaterial( icon2 )

		surface.DrawTexturedRect( x+w-iconSize-padding, y, iconSize, iconSize )

	end



	-- Text

	if icon then x = x + iconSize end

	surface.SetTextColor( 255, 255, 255, alpha*255 )

	surface.SetTextPos( x + (padding*2), y+(th/2)+4 )

	surface.DrawText( text )



	return over



end



function DrawLabel( text, x, y, w, center, underlinecolor )



	surface.SetFont( "AppBarLabel" )

	local tw, th = surface.GetTextSize(text)



	surface.SetTextColor( 255, 255, 255 )

	if center then

		surface.SetTextPos( x+((w/2)-(tw/2)), y )

	else

		surface.SetTextPos( x+16, y )

	end



	surface.DrawText( text )



	if not nounderline then

		surface.SetDrawColor( 0, 0, 0, 150 )

		if underlinecolor then

			surface.SetDrawColor( underlinecolor )

		end

		surface.DrawRect( x+16, y + 35, x + (w - 16), 3 )

	end



end



function DrawPromptHelp( text, x, y, w )



	surface.SetFont( "AppBarLabel" )

	local tw, th = surface.GetTextSize(text)



	surface.SetTextColor( 255, 255, 255, SinBetween(50,150,RealTime()*5) )

	surface.SetTextPos( x+16, y )



	surface.DrawText( text )



end



function DrawCostLabel( cost, x, y )



	cost = string.FormatNumber(cost)



	surface.SetFont( "AppBarLabel" )

	local tw, th = surface.GetTextSize(cost)

	local iconsize = 24



	tw = tw + 2 + iconsize

	x = x - tw - 8

	y = y - (th/2)



	draw.RoundedBox( 6, x-2, y-2, tw+4, th+4, Color( 255, 150, 50 ) )



	-- Text

	surface.SetTextColor( 255, 255, 255 )

	surface.SetTextPos( x+iconsize, y )

	surface.DrawText( cost )



	-- Icon

	surface.SetDrawColor( Color( 255, 255, 255 ) )

	surface.SetMaterial( GTowerIcons2.GetIcon("money") )

	surface.DrawTexturedRect( x, y+(th/2) - (iconsize/2), iconsize, iconsize )



	-- Test

	--[[surface.SetDrawColor( Color( 255, 255, 255 ) )

	surface.DrawRect( x, y+(th/2), tw, 2 )]]



end



function DrawSimpleLabel( x, y, text, color )



	surface.SetFont( "AppBarLabel" )

	local tw, th = surface.GetTextSize(text)



	x = x - (tw/2)

	y = y - (th/2)



	draw.RoundedBox( 6, x-2, y-2, tw+4, th+4, color or Color( 255, 0, 0, 240 ) )



	-- Text

	surface.SetTextColor( 255, 255, 255 )

	surface.SetTextPos( x, y )

	surface.DrawText( text )



end



function DrawPromptNotice( text, subtext )



	surface.SetDrawColor( 0, 0, 0, 250 )

	surface.DrawRect( 0, 0, scrw, scrh)



	local x, y, w, h = 100, 100, scrw-200, scrh-200



	draw.SimpleText( text, "AppBarLarge", x+w/2, y+h/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	draw.SimpleText( subtext, "AppBarSmall", x+w/2, y+h/2 + 50, Color( 255, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )



end



--local Spray = panelos.CreatePlayerSprayMaterial( "68e555d2" )

local path = "gmod_tower/panelos/icons/"

local function Create( png, filter, path_override )
	return Material( (path_override or path).. png, filter or "unlitsmooth" )
end

local Icons = {
	["gmt"] = Create( "logo_flat.png", "unlitsmooth", "gmod_tower/hud/" ),
	["gmtsmall"] = Create( "gmt.png" ),
	["home"] = Create( "home.png" ),
	["back"] = Create( "back.png" ),
	["camera"] = Create( "video.png" ),
	["music"] = Create( "music.png" ),
	["options"] = Create( "settings.png" ),
	["lock"] = Create( "lock.png" ),
	["unlock"] = Create( "unlock.png" ),
	["alarm"] = Create( "alarms.png" ),
	["time"] = Create( "time.png" ),
	["backspace"] = Create( "backspace.png" ),
	["label"] = Create( "label.png" ),
	["about"] = Create( "about.png" ),
	["storage"] = Create( "storage.png" ),
	["skip"] = Create( "skip.png" ),
	["rewind"] = Create( "rewind.png" ),
	["pause"] = Create( "pause.png" ),
	["play"] = Create( "play.png" ),
	["shuffle"] = Create( "shuffle.png" ),
	["addqueue"] = Create( "addqueue.png" ),
	["images"] = Create( "images.png" ),
	["doorclose"] = Create( "door_closed.png" ),
	["dooropen"] = Create( "door_open.png" ),
	["condo"] = Create( "condo.png" ),
	["players"] = Create( "players.png" ),
	["controller"] = Create( "controller.png" ),
	["movies"] = Create( "movies.png" ),
	["beer"] = Create( "beer.png" ),
	["tv"] = Create( "tv.png" ),
	["party"] = Create( "party.png" ),
	["musicpage"] = Create( "musicpage.png" ),
	["instrument"] = Create( "instrument.png" ),
	["accept"] = Create( "accept.png" ),
	["cancel"] = Create( "cancel.png" ),
	["ban"] = Create( "ban.png" ),
	["heart"] = Create( "heart.png" ),
	["box"] = Create( "box.png" ),
	["broom"] = Create( "broom.png" ),
	["safe"] = Create( "safe.png" ),
	["money"] = Create( "money.png" ),
	["moneylost"] = Create( "money.png" ),
	["trophy"] = Create( "trophy.png" ),
	["present"] = Create( "present.png" ),
	["clipboard"] = Create( "clipboard.png" ),
	["hat"] = Create( "hat.png" ),
	["arcade"] = Create( "arcade.png" ),
	["cards"] = Create( "cards.png" ),
	["slots"] = Create( "slots.png" ),
	["pool"] = Create( "pool.png" ),
	["flag"] = Create( "flag.png" ),
	["admin"] = Create( "admin.png" ),
	["announce"] = Create( "announce.png" ),
	["exclamation"] = Create( "exclamation.png" ),
	["next"] = Create( "next.png" ),
	["light"] = Create( "light.png" ),
	["floor1"] = Create( "floor1.png" ),
	["floor2"] = Create( "floor2.png" ),
	["volume_on"] = Create( "volume_on.png" ),
	["volume_off"] = Create( "volume_off.png" ),
	["volume"] = Create( "volume.png" ),
	["volume16"] = Create( "volume16.png", "unlit" ),
	["chips"] = Create( "chip.png", nil, "gmod_tower/icons/" ),
}

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

	self.screen:SetFacadeMaterial(Material( "gmod_tower/panelos/backgrounds/background1.png", "unlitsmooth" )/*panelos.Backgrounds[1]*/) --use this material for facade

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

	if !self.screen then
		self:SetupScreen()
	end

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


local GradientUp = surface.GetTextureID( "VGUI/gradient_up" )

local GradientDown = surface.GetTextureID( "VGUI/gradient_down" )

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
