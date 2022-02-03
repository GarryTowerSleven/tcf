include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local noice_icons = {
	Material("icon16/contrast.png"),
	Material("icon16/application_osx_terminal.png"),
	Material("icon16/box.png"),
	Material("icon16/brick.png"),
	Material("icon16/car.png"),
	Material("icon16/eye.png"),
	Material("icon16/drink.png"),
	Material("icon16/sport_soccer.png"),
	Material("icon16/cart.png"),
	Material("icon16/sport_football.png"), -- if the world made any sense this would be "handegg.png"
	Material("icon16/wand.png"),
	Material("icon16/weather_rain.png"),
	Material("icon16/weather_sun.png"),
	Material("icon16/world.png"),
	Material("flags16/fi.png"),
	Material("icon16/ipod.png"),
	Material("icon16/monkey.png"),
	nil -- cuz Material returns 2 values WTFFFFFFFFFFFFFFFFFFFFF
}

local function DrawIcons(y, w, h)
	for i,icon in pairs(noice_icons) do
		local seed = i

		local tick = (CurTime() + seed*40)

		local speed = seed % 4 + 1 + (seed * 0.05)
		local loltick = (CurTime() * 2 + tick * speed * 20) % w

		surface.SetDrawColor(255, 255, 255, 100)
		surface.SetMaterial(icon)

		local iw, ih = 16, 16
		if icon:GetName():match("^flags16") then iw, ih = 20, 12 end
		surface.DrawTexturedRect(loltick, h/2 + math.sin(loltick / 30) * 30, iw, ih)
	end
end

local loadMat
CasinoKit.getRemoteMaterial("http://5.161.54.79/apps/loading/img/gmtdeluxe2.png", function(mat)
	loadMat = mat
end)

local Buttons = {
	{
		text = "Discord",
		onClick = function()
			gui.OpenURL( "https://www.gmtdeluxe.org/chat" )
		end,
	},
	{
		text = "Twitter",
		onClick = function()
			gui.OpenURL( "https://www.twitter.com/gmtdeluxe" )
		end,
	},
	{
		text = "Group",
		onClick = function()
			gui.OpenURL( "https://steamcommunity.com/groups/gmtdeluxe" )
		end,
	},
	{
		text = "Website",
		onClick = function()
			gui.OpenURL( "https://www.gmtdeluxe.org" )
		end,
	},
}

local btn_m = 10
local function DrawButtons(imgui, x, y, w, h)
	local count = #Buttons
	local bw = (w/count) - ((btn_m/count)*(count-1))
	local bx = x
	for k,v in pairs( Buttons ) do
		if k == count then local btn_m = 0 end

		if imgui.xTextButton(v.text, "!Roboto@24", bx, y, bw, h, 1, nil, colorutil.Rainbow(45), color_white) then
			if isfunction(v.onClick) then v.onClick() end
		end
		bx = bx + bw + btn_m
	end

	--draw.RectBorder( x, y, w, h, 1, Color( 255,0,0 ) )
end

function ENT:DrawTranslucent()
	self:DrawModel()

	local imgui = GTowerUI.imgui

	local w, h = 795, 512
	
	if imgui.Entity3D2D(self, Vector(1.5,-73.5,47.5), Angle(0, 90, 90), 0.185, 2048) then

		local mx, my = imgui.CursorPos()

		surface.SetDrawColor( 51, 18, 82 )
		surface.DrawRect( 0, 0, w, h )

		draw.GradientBox( 0, 0, w, h, Color( 11, 100, 110 ), DOWN )

		DrawIcons(y, w, h)

		surface.SetDrawColor( 0, 0, 0, 80 )
		surface.DrawRect( 0, 0, w, h )

		surface.SetDrawColor( 255,255,255 )
		surface.SetMaterial( loadMat or Material("icon16/monkey.png") )
		local imgS = 1
		local imgW, imgH = 604*imgS, 110*imgS
		surface.DrawTexturedRect( w/2-(imgW/2), h/2-(imgH/2), imgW, imgH )

		local btn_w, btn_h = 500, 50
		DrawButtons( imgui, w/2-(btn_w/2), 380, btn_w, btn_h )
		draw.SimpleShadowText( "Will open in steam browser.", imgui.xFont("!Roboto@14"), w/2, 450, color_white, Color(0,0,0,50), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2 )

		--DrawCursor( mx, my, w, h, imgui.IsPressing() )

		imgui.ExpandRenderBoundsFromRect(0, 0, w, h)
		imgui.End3D2D()
	end
end