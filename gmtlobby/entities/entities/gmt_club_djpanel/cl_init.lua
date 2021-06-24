
-----------------------------------------------------
include( "shared.lua" )

ENT.RenderGroup = RENDERGROUP_OPAQUE

local VISUALIZER_SIZE_LINEAR  = 0
local VISUALIZER_SIZE_SQRT    = 1
local VISUALIZER_SIZE_DECIBEL = 2

local TextPaddingX = 12
local TextPaddingY = 12

local TextBoxPaddingX = 8
local TextBoxPaddingY = 2

local TextBgColor = Color(0, 0, 0, 200)
local BarBgColor = Color(0, 0, 0, 200)
local BarFgColor = Color(255, 255, 255, 255)

local InfoScale = 1/10

local ListWidth = 0 -- Media queue list

local vis_mountains = surface.GetTextureID( "gmod_tower/nightclub/panel_mountains" )
local vis_glass = surface.GetTextureID( "gmod_tower/nightclub/panel_glass" )
local vis_glassi = surface.GetTextureID( "gmod_tower/nightclub/panel_glass_i" )
local vis_tile = surface.GetTextureID( "gmod_tower/nightclub/panel_tile" )
local gradient = surface.GetTextureID( "VGUI/gradient_up" )

surface.CreateFont( "MediaQueue", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 24
} )
surface.CreateFont( "MediaQueueSmall", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 18
} )
surface.CreateFont( "MediaQueueTitle", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 32
} )
surface.CreateFont( "MediaOwner", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 48
} )

ENT.Resolution = 48
ENT.BarWidth = 3
ENT.BarSensitivity = 25

function ENT:Initialize()
	self:SetRenderBounds( Vector(0, 0, 0),
						  Vector(0, -self.Width, -self.Height))
end

local function GetMedia(controller)
	if not IsValid( controller ) then return end

	local mp = controller:GetMediaPlayer()
	if not IsValid( mp ) then return end

	local media = mp:GetMedia()
	if not IsValid(media) then return end

	return media
end

local function DrawText( text, font, x, y, xalign, yalign, color )
	return draw.SimpleText( text, font, x, y, color or color_white, xalign, yalign )
end

local function DrawTextBox( text, font, x, y, xalign, yalign, color )

	xalign = xalign or TEXT_ALIGN_LEFT
	yalign = yalign or TEXT_ALIGN_TOP

	surface.SetFont( font )
	tw, th = surface.GetTextSize( text )

	if xalign == TEXT_ALIGN_CENTER then
		x = x - tw/2
	elseif xalign == TEXT_ALIGN_RIGHT then
		x = x - tw
	end

	if yalign == TEXT_ALIGN_CENTER then
		y = y - th/2
	elseif yalign == TEXT_ALIGN_BOTTOM then
		y = y - th
	end

	surface.SetDrawColor( color or TextBgColor )
	surface.DrawRect( x, y,
		tw + TextBoxPaddingX * 2,
		th + TextBoxPaddingY * 2 )

end

function ENT:DrawMediaQueue( w, h, bg )
	local Controller = self:GetOwner()
	local color = Controller:GetThemeColor()

	-- Background
	local TextBoxColor = colorutil.Brighten( color, .55, 100 )
	surface.SetDrawColor( TextBoxColor )
	surface.DrawRect( 0, 0, w, h )

	-- Gradient
	surface.SetDrawColor( color.r, color.g, color.b, 100 )
	surface.SetTexture( gradient )
	surface.DrawTexturedRect( 0, 0, w, h )

	local titleheight = 32
	local TextBoxColorDark = colorutil.Brighten( color, .35, 150 )

	-- Title
	surface.SetDrawColor( TextBoxColorDark )
	surface.DrawRect( 0, 0, w, titleheight )

	DrawText( "NEXT UP", "MediaQueueTitle", (w/2), (titleheight/2), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, color_white )

	-- Title border
	surface.SetDrawColor( TextBoxColorDark.r, TextBoxColorDark.g, TextBoxColorDark.b, 255 )
	surface.DrawRect( 0, titleheight, w, 3 )

	-- Queue
	local queue = Controller:GetMediaPlayer():GetMediaQueue()
	if not queue then return end

	local padding, spacing, numwidth, nextline = 12, 48, 18, 24
	local maxw, ty = w-padding-numwidth-3, 0

	local arrowh = 32
	local additional = 0

	for i, media in pairs( queue ) do

		ty = (titleheight/2) + (spacing * i)

 		-- Ignore songs if the list goes beyond and draw an arrow
 		local maxheight = (ty + spacing + arrowh)
		if maxheight > h then
			additional = i-1
			break
		end

		-- Container
		surface.SetDrawColor( TextBoxColorDark )
		surface.DrawRect( 0, ty-2, w, spacing ) -- background

		-- Dividers
		surface.SetDrawColor( TextBoxColorDark.r, TextBoxColorDark.g, TextBoxColorDark.b, 255 )
		surface.DrawRect( 0, ty+spacing-2, w, 1 ) -- middle
		if i == 1 then surface.DrawRect( 0, ty-2, w, 1 ) end -- top
		if i == (#queue) then surface.DrawRect( 0, ty+spacing-2, w, 1 ) end -- bottom

		-- Number
		surface.DrawRect( 0, ty-2, padding+numwidth-4, spacing ) -- background
		DrawText( i, "MediaQueue", padding/2, ty+(spacing/2)-2, 0, TEXT_ALIGN_CENTER, Color( 255, 255, 255, 25 ) )

		-- Title
		local alpha = 255
		if i > 1 then alpha = 50 end
		local titleStr = string.RestrictStringWidth( media:Title(), "MediaQueue", maxw )
		DrawText( titleStr, "MediaQueue", padding+numwidth, ty, 0, 0, Color( 255, 255, 255, alpha ) )

		-- Duration
		local durx = 0
		if media:IsTimed() then
			local durStr = string.FormatSeconds(media:Duration())
			surface.SetFont( "MediaQueueSmall" )
			durx = surface.GetTextSize( durStr )
			DrawText( durStr, "MediaQueueSmall", maxw-(durx/2)+2, ty+nextline, 0, 0, Color( 255, 255, 255, alpha ) )
		end

		-- Added by
		if media:OwnerName() then
			local ownerStr = string.RestrictStringWidth( media:OwnerName(), "MediaQueue", maxw-durx )
			DrawText( ownerStr, "MediaQueueSmall", padding+numwidth, ty+nextline, 0, 0, Color( 255, 255, 255, alpha ) )
		end

	end

	-- Arrow (if there's too many songs)
	if additional > 0 then
		surface.SetDrawColor( TextBoxColorDark )
		surface.DrawRect( 0, h-arrowh, w, arrowh ) -- background
		local songs = (#queue-additional)
		DrawText( songs .. " more " .. string.Pluralize( "track", songs ), "MediaQueueTitle", w/2, h-arrowh-2, TEXT_ALIGN_CENTER )
	end

	-- Divider
	local TextBoxBorderColor = colorutil.Brighten( Controller:GetThemeColor(), .25, 255 )
	surface.SetDrawColor( TextBoxBorderColor )
	surface.DrawRect( w-3, 0, 3, h )

end

function ENT:DrawMediaInfo( media, w, h )
	local Controller = self:GetOwner()
	if not IsValid( media ) then return end

	-- Text dimensions
	local tw, th

	-- Box color
	local TextBoxColor = colorutil.Brighten( Controller:GetThemeColor(), .55, 150 )

	-- Title background
	local titleStr = string.RestrictStringWidth( media:Title(), "MediaTitle",
		(w-ListWidth) - (TextPaddingX * 2 + TextBoxPaddingX * 2) )
	local titleY = h - 220

	DrawTextBox( titleStr, "MediaTitle", ListWidth + TextPaddingX, TextPaddingY + titleY, 0, 0, TextBoxColor )

	-- Title
	DrawText( titleStr, "MediaTitle",
		ListWidth + TextPaddingX + TextBoxPaddingX,
		TextPaddingY + TextBoxPaddingY + titleY )

	-- Owner background
	local ownerStr = string.RestrictStringWidth( media:OwnerName() .. " added", "MediaOwner",
		(w-ListWidth) - (TextPaddingX * 2 + TextBoxPaddingX * 2) )
	local titleY = h - 220 - 52

	DrawTextBox( ownerStr, "MediaOwner", ListWidth + TextPaddingX, TextPaddingY + titleY, 0, 0, TextBoxColor )

	-- Owner
	DrawText( ownerStr, "MediaOwner",
		ListWidth + TextPaddingX + TextBoxPaddingX,
		TextPaddingY + TextBoxPaddingY + titleY, 0,0,Color( 255, 255, 255, 50 ) )

	-- Track bar
	if media:IsTimed() then

		local duration = media:Duration()
		local curTime = media:CurrentTime()
		local percent = math.Clamp( curTime / duration, 0, 1 )

		-- Bar height
		local bh = math.Round(h * 1/32)

		-- Bar background
		local BarBgColor = colorutil.Brighten( Controller:GetThemeColor(), .2 )
		surface.SetDrawColor( BarBgColor )
		surface.DrawRect( ListWidth, h - bh, w-ListWidth, bh )

		-- Bar foreground (progress)
		surface.SetDrawColor( Controller:GetThemeColor() or BarFgColor )
		surface.DrawRect( ListWidth, h - bh, (w-ListWidth) * percent, bh )

		local timeY = h - bh - TextPaddingY * 2

		-- Current time
		local curTimeStr = string.FormatSeconds(math.Clamp(math.Round(curTime), 0, duration))

		DrawTextBox( curTimeStr, "MediaTitle", ListWidth + TextPaddingX, timeY,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, TextBoxColor )
		DrawText( curTimeStr, "MediaTitle", ListWidth + TextPaddingX * 2, timeY-70,
			TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		-- Duration
		local durationStr = string.FormatSeconds( duration )

		DrawTextBox( durationStr, "MediaTitle", w - TextPaddingX * 2, timeY,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, TextBoxColor )
		DrawText( durationStr, "MediaTitle", w - TextBoxPaddingX * 2, timeY-70,
			TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP )

	end
end


function ENT:Draw()
	local Controller = self:GetOwner()

	if !IsValid(Controller) then
		for k,v in pairs( ents.FindByClass("gmt_club_dj") ) do
			if IsValid(v) then self:SetOwner(v) end
		end
	end

	if not IsValidController(Controller) or not IsValid(Controller:GetMediaPlayer()) then return end

	local angRef = self:GetAngles() * 1.0
	local angs = self:GetAngles()
	angs:RotateAroundAxis(angRef:Up(), -90)
	angs:RotateAroundAxis(angRef:Right(), 90)

	local off = self:GetForward() * 0.7

	cam.Start3D2D(self:GetPos() + off, angs, InfoScale )
		local media = GetMedia( Controller )
		local iw, ih = self.Width / InfoScale, self.Height / InfoScale

		local succ, err = pcall( self.DrawVisualizer, self, media, iw, ih )
		if not succ then
			print( err )
		end

		local succ, err = pcall( self.DrawMediaInfo, self, media, iw, ih )
		if not succ then
			print( err )
		end

		if not Controller:GetMediaPlayer():IsQueueEmpty() then
			ListWidth = 500 -- I know it's a little slapped in but whatever
			local succ, err = pcall( self.DrawMediaQueue, self, ListWidth, ih )
			if not succ then
				print( err )
			end
		else
			ListWidth = 0
		end
	cam.End3D2D()

	cam.Start3D2D(self:GetPos() + (self:GetForward() * 200) + (self:GetUp() * 235) + (self:GetRight() * -205), angs, InfoScale * 3.2 )
		local media = GetMedia( Controller )
		local iw, ih = self.Width / InfoScale, self.Height / InfoScale

		local succ, err = pcall( self.DrawVisualizer, self, media, iw, ih, true )
		if not succ then
			print( err )
		end

	cam.End3D2D()

end


function ENT:DrawVisualizer( media, iw, ih, bg )

	if bg then ih = ih * 1.5 end

	local Controller = self:GetOwner()
	local multiplier = Controller:GetRange("bass").SmoothedAverage * 20
	local color = Controller:GetThemeColor()
	local x = 0

	--[[if ListWidth > 0 then
		x = ListWidth
	end]]

	-- Mountains
	surface.SetTexture( vis_mountains )
	surface.SetDrawColor( color )
	surface.DrawTexturedRect( x, 0, iw-x, ih )

	-- Grid
	if !bg then
		surface.SetTexture( vis_tile )
		surface.SetDrawColor( color.r, color.g, color.b, math.Fit( multiplier, 0, .2, 0, 100 ) )
		surface.DrawTexturedRect( x, 0, iw-x, ih )
	end

	local eff2 = vis_glass
	if multiplier > .3 then eff2 = vis_glassi end

	-- Glass
	surface.SetTexture( eff2 )
	surface.SetDrawColor( color.r, color.g, color.b, math.Fit( multiplier, 0, .2, 0, 100 ) )
	surface.DrawTexturedRect( x, 0, iw-x, ih )

	-- Bars
    local spacing = (iw - ih) / (self.Resolution-3) + 1/InfoScale

	surface.SetDrawColor( color.r, color.g, color.b, math.Fit( multiplier, 0, .2, 0, 25 ) )

    for i=1, self.Resolution do
        local val = Controller.FFTSmoothed[i]
        val = Controller:GetGraphHeight( val, 90, VISUALIZER_SIZE_SQRT) / 90
        val = math.Clamp( val * self.BarSensitivity / InfoScale, 1, ih/2)

        surface.DrawRect(i *spacing - spacing, -val+(ih/2), self.BarWidth / InfoScale, val * 2 )
    end

  -- Beat border (what is this opus? yes. yes it is.)

	if bg then return end

  local thickness = multiplier*24
	surface.SetDrawColor( color )
	surface.DrawRect( 0, 0, iw, thickness ) -- Top

	if IsValid( media ) and not media:IsTimed() then
		surface.DrawRect( 0, ih - thickness, iw, thickness ) -- Bottom
	end

	surface.DrawRect( 0, thickness, thickness, ih - thickness ) -- Left
	surface.DrawRect( iw - thickness, thickness, thickness, ih - thickness ) -- Right

end

function ENT:Think()
	self:SetRenderBounds( Vector(0, 0, 0),
						  Vector(0, -self.Width, -self.Height))
end
