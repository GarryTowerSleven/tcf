local CurTime = CurTime
local RealTime = RealTime
local FrameTime = FrameTime
local Material = Material
local pairs = pairs
local ipairs = ipairs
local tonumber = tonumber
local table = table
local string = string
local type = type
local surface = surface
local HSVToColor = HSVToColor
local Lerp = Lerp
local Msg = Msg
local math = math
local draw = draw
local cam = cam
local Matrix = Matrix
local Angle = Angle
local Vector = Vector
local setmetatable = setmetatable
local ScrW = ScrW
local ScrH = ScrH
local ValidPanel = ValidPanel
local Color = Color
local color_white = color_white
local color_black = color_black
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT
local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM
local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER

UP = 4
DOWN = 5
local UP = UP
local DOWN = DOWN
local LEFT = LEFT
local RIGHT = RIGHT

-- Fix for iterating through UTF-8 strings character by character
-- for char in text:gmatch(utf8pattern) do
local utf8pattern = "[%z\1-\127\194-\244][\128-\191]*"

-- Used for pushing cam matrices
local vecTranslate = Vector()
local vecScale = Vector(1,1,1)
local angRotate = Angle()

-- Used for non-mipmapped corners
local Tex_Corner8 	= surface.GetTextureID( "gui/corner8" )
local Tex_Corner16 	= surface.GetTextureID( "gui/corner16" )

module( "draw" )

function HTMLPanel( panel, w, h )

	if not ValidPanel( panel ) then return end
	if not (w and h) then return end
	
	panel:UpdateHTMLTexture()

	local pw, ph = panel:GetSize()

	-- Convert to scalar
	w = w / pw
	h = h / ph

	-- Fix for non-power-of-two html panel size
	pw = math.CeilPower2(pw)
	ph = math.CeilPower2(ph)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( panel:GetHTMLMaterial() )
	surface.DrawTexturedRect( 0, 0, w * pw, h * ph )

end

HTMLTexture = HTMLPanel

function HTMLMaterial( mat, w, h )

	if not (w and h) then return end

	local pw, ph = w, h

	-- Convert to scalar
	w = w / pw
	h = h / ph

	-- Fix for non-power-of-two html panel size
	pw = math.CeilPower2(pw)
	ph = math.CeilPower2(ph)

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( mat )
	surface.DrawTexturedRect( 0, 0, w * pw, h * ph )

end

/*---------------------------------------------------------
	draw.Rectangle
---------------------------------------------------------*/
function Rectangle( x, y, w, h, col, tex, ismat )

	surface.SetDrawColor( col )
	
	if tex then

		if !ismat then 
			surface.SetTexture( tex )
		else
			surface.SetMaterial( tex )
		end

		surface.DrawTexturedRect( x, y, w, h )

	else
		surface.DrawRect( x, y, w, h )
	end

end

--[[---------------------------------------------------------
    Name: RectBorder( x, y, w, h, thickness, col )
    Desc: Draws a rectangle that will always be in the center of x and y
-----------------------------------------------------------]]
function RectCenter( x, y, w, h, col )

	if col then
		surface.SetDrawColor( col )
	end

	surface.DrawRect( x - ( w / 2 ), y - ( h / 2 ), w, h )

end

--[[---------------------------------------------------------
    Name: RectBorder( x, y, w, h, thickness, col )
    Desc: Draws an outlined rectangle, no fill
-----------------------------------------------------------]]
function RectBorder( x, y, w, h, thickness, col )

	if col then
		surface.SetDrawColor( col )
	end

	// Top
	surface.DrawRect( x, y, w, thickness )

	// Bottom
	surface.DrawRect( x, y + h - thickness, w, thickness )

	// Left
	surface.DrawRect( x, y + thickness, thickness, h - (thickness*2) )

	// Right
	surface.DrawRect( x + w - thickness, y + thickness, thickness, h - (thickness*2) )

end

--[[---------------------------------------------------------
    Name: RectFillBorder( x, y, w, h, thickness, percent, col1, col2 )
    Desc: Draws a rectangle with an inner rect for percentage boxes
-----------------------------------------------------------]]
function RectFillBorder( x, y, w, h, thickness, percent, col1, col2, up )

	// Border
	draw.RectBorder( x, y, w, h, thickness, col1 )

	if col2 then
		surface.SetDrawColor( col2 )
	end

	// Fill
	if !up then
		surface.DrawRect( x + thickness, y + thickness, ( w - ( thickness * 2 ) ) * percent, h - ( thickness * 2 ) )
	else
		surface.DrawRect( x + thickness, y - ( h * percent ) + thickness + h, ( w - ( thickness * 2 ) ), h * percent - ( thickness * 2 ) )
	end

end

--[[---------------------------------------------------------
    Name: RoundedBox( bordersize, x, y, w, h, color, a, b, c, d )
    Desc: Draws a rounded box without mipmapping issues
-----------------------------------------------------------]]

function RoundedBoxEx( bordersize, x, y, w, h, color, a, b, c, d )
	x = math.Round( x )
	y = math.Round( y )
	w = math.Round( w )
	h = math.Round( h )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	
	-- Draw as much of the rect as we can without textures
	surface.DrawRect( x+bordersize, y, w-bordersize*2, h )
	surface.DrawRect( x, y+bordersize, bordersize, h-bordersize*2 )
	surface.DrawRect( x+w-bordersize, y+bordersize, bordersize, h-bordersize*2 )
	
	local tex = Tex_Corner8
	if ( bordersize > 8 ) then tex = Tex_Corner16 end
	
	surface.SetTexture( tex )
	
	if ( a ) then
		surface.DrawTexturedRectUV( x, y, bordersize, bordersize, 0, 0, 1, 1 )
	else
		surface.DrawRect( x, y, bordersize, bordersize )
	end
	
	if ( b ) then
		surface.DrawTexturedRectUV( x +w -bordersize, y, bordersize, bordersize, 1, 0, 0, 1 )
	else
		surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
	end
 
	if ( c ) then
		surface.DrawTexturedRectUV( x, y +h -bordersize, bordersize, bordersize, 0, 1, 1, 0 )
	else
		surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
	end
 
	if ( d ) then
		surface.DrawTexturedRectUV( x +w -bordersize, y +h -bordersize, bordersize, bordersize, 1, 1, 0, 0 )
	else
		surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
	end
end

--[[---------------------------------------------------------
    Name: DropOutlineText( panel, x, y, w, h )
    Desc: Draws text with a clean outline below the text
-----------------------------------------------------------]]
local color_drop = Color(0,0,0,255)
function DropOutlineText( text, font, x, y, color, xalign, yalign )

	-- Clean drop outline behind real text
	color_drop.a = color.a
	draw.SimpleText(text, font, x, y + 4, color_drop, xalign, yalign)
	draw.SimpleText(text, font, x + 1, y + 2, color_drop, xalign, yalign)
	draw.SimpleText(text, font, x - 1, y + 2, color_drop, xalign, yalign)

	-- Actual text
	draw.SimpleText(text, font, x, y, color, xalign, yalign)

end

--[[---------------------------------------------------------
    Name: Shape( x, y, sides, radius, percent, color )
    Desc: 
-----------------------------------------------------------]]
//local circle
function Shape( x, y, sides, radius, percent, color )

	if ( percent <= 0 ) then return end
	
	local angle = math.Round( percent * 360 )
	if ( angle <= 0 ) then return end

	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )

	//local sides_render = math.ceil( sides * percent )
	for i = 0, sides do
		//local a = math.rad( (( i / sides - 1 ) * -360) - 180 )
		local a = math.rad( (( i / sides - 1 ) * -angle) - 180 )

		//if ( i > sides_render ) then
		//	break
		//end
		
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	
	surface.SetDrawColor( color )
	draw.NoTexture()
	surface.DrawPoly( cir )

	/*draw.SimpleText( "draw.Circle( " .. x .. ", " .. y .. ", " .. sides .. ", " .. radius .. ", " .. percent .. " )", nil, x, y - radius - 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	for k, v in pairs( cir ) do
		draw.Rectangle( v.x - 1, v.y - 1, 2, 2, color_white )
		draw.SimpleText( k .. ", x" .. math.Round( v.x ) .. " y" .. math.Round( v.y ), nil, v.x, v.y - 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end*/

end

-- I didn't want to use textures to do this effect, so I made this nice gradient function =P
-- Thanks to all people at FacePunch forums that helped me to optimize it!
/*local g_grds, g_wgrd, g_sz
function GradientBox(x, y, w, h, al, ...)

	g_grds = {...}

	al = math.Clamp(math.floor(al), 0, 1)

	local n
	if al == 1 then
		n = w
		w, h = h, n
	end

	g_wgrd = w / (#g_grds - 1)

	for i = 1, w do

		for c = 1, #g_grds do
			n = c
			if(i <= g_wgrd * c) then break end
		end

		g_sz = i - (g_wgrd * (n - 1))

		local color = Color( Lerp(g_sz/g_wgrd, g_grds[n].r, g_grds[n + 1].r) or 0,
							 Lerp(g_sz/g_wgrd, g_grds[n].g, g_grds[n + 1].g) or 0,
							 Lerp(g_sz/g_wgrd, g_grds[n].b, g_grds[n + 1].b) or 0,
							 Lerp(g_sz/g_wgrd, g_grds[n].a, g_grds[n + 1].a) or 0 )

		color = nil

		if color then
			surface.SetDrawColor( color )
		else
			surface.SetDrawColor( 0, 0, 0, 230 )
		end

		if(al == 1) then
			surface.DrawRect(x, y + i, h, 1)
		else
			surface.DrawRect(x + i, y, 1, h)
		end

	end
end*/

local verts = {{},{},{},{}}
local otw, oth, tw, th, uoffset, voffset, umax, vmax
function OffsetTexture( x, y, w, h, xoffset, yoffset, tw, th, texture, color )

	otw, oth = surface.GetTextureSize(texture)
	uoffset, voffset = xoffset/otw, yoffset/oth
	umax, vmax = uoffset + (tw/otw), voffset + (th/oth)

	verts[1].x = x
	verts[1].y = y
	verts[1].u = uoffset
	verts[1].v = voffset

	verts[2].x = x + w
	verts[2].y = y
	verts[2].u = umax
	verts[2].v = voffset

	verts[3].x = x + w
	verts[3].y = y + h
	verts[3].u = umax
	verts[3].v = vmax

	verts[4].x = x
	verts[4].y = y + h
	verts[4].u = uoffset
	verts[4].v = vmax

	surface.SetDrawColor(color)
	surface.SetTexture(texture)
	surface.DrawPoly(verts)

end


--[[---------------------------------------------------------
    Name: SimpleShadowText( text, font, x, y, color, colorshadow, alignx, aligny, offset )
    Desc: Draws text with a very simple flat shadow
-----------------------------------------------------------]]
function SimpleShadowText( text, font, x, y, color, colorshadow, alignx, aligny, offset, offsetx, offsety )

	local offx = ( offset or 2 ) + ( offsetx or 0 )
	local offy = ( offset or 2 ) + ( offsety or 0 )

	if ( alignx == TEXT_ALIGN_CENTER ) then
		x = x - offx
	end
	if ( aligny == TEXT_ALIGN_CENTER ) then
		y = y - offy
	end

	draw.SimpleText( text, font, x + offx, y + offy, colorshadow or color_black, alignx or TEXT_ALIGN_CENTER, aligny or TEXT_ALIGN_CENTER )
	draw.SimpleText( text, font, x, y, color or color_white, alignx or TEXT_ALIGN_CENTER, aligny or TEXT_ALIGN_CENTER )

end

--[[---------------------------------------------------------
    Name: NiceText( txt, font, x, y, clr, alignx, aligny, dis, alpha )
    Desc: Draws text with a shadow
-----------------------------------------------------------]]
function NiceText( txt, font, x, y, clr, alignx, aligny, dis, alpha )
	
	local tbl = {
		pos = {
			[1] = x,
			[2] = y
		},
		color = clr,
		text = txt,
		font = font,
		xalign = alignx,
		yalign = aligny
	}

	draw.TextShadow( tbl, dis, alpha )
	
end

--[[---------------------------------------------------------
    Name: TextBackground( text, font, x, y, padding )
    Desc: Draws a background that will fit text
-----------------------------------------------------------]]
function TextBackground( text, font, x, y, padding, height, color )

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	surface.SetDrawColor( color or Color(0, 0, 0, 245) )
	surface.DrawRect( x - ( w / 2 + ( padding / 2 ) ), y, w + padding, height or 40 )

end

--[[---------------------------------------------------------
    Name: draw.TextInBox
-----------------------------------------------------------]]
function TextInBox( text, font, x, y, w, h, color, shadowoffset, shadowcolor )
    local str = string.RestrictStringWidth( text, font, w )
	
    surface.SetFont( font )
    local tW, tH = surface.GetTextSize( str )

    local tX, tY = x + (w / 2) - tW / 2, y + (h / 2) - tH / 2

    if ( shadowoffset ) then
        surface.SetTextColor( shadowcolor or Color( 0, 0, 0, 150 ) )
        surface.SetTextPos( tX + shadowoffset, tY + shadowoffset )
        surface.DrawText( str )
    end

    surface.SetTextColor( color or color_white )
    surface.SetTextPos( tX, tY )
    surface.DrawText( str )
end

--[[---------------------------------------------------------
    Name: draw.WordWrapped
	Desc: Function to draw word-wrapped text
-----------------------------------------------------------]]
function WordWrapped(text, font, x, y, maxwidth, color, shadowoffset, shadowcolor)
    -- Split the text into words
    local words = string.Explode(" ", text)
  
    -- Table to store lines of text
    local lines = {}
    -- Current line of text being built
    local line = ""
  
    -- Set the font for text height calculations
    surface.SetFont(font)
    -- Get the height of the text
    local _, textHeight = surface.GetTextSize(" ")

    -- Loop through each word
    for i, word in ipairs(words) do
        -- Calculate the size of the text if the current word is added to the current line
        local width = surface.GetTextSize(line .. word .. " ")

        -- If the width of the text exceeds maxwidth, add the current line to the table of lines
        -- and start a new line with the current word
        if width > maxwidth then
            table.insert(lines, line)
            line = word .. " "
        else
            -- Otherwise, add the current word to the current line
            line = line .. word .. " "
        end
    end
  
    -- Add the last line to the table of lines
    table.insert(lines, line)
  
    -- Set the font for each line
    surface.SetFont(font)
  
    -- Loop through each line and draw it on the screen
    local totalHeight = textHeight * table.Count( lines )
    for i, line in ipairs(lines) do
        -- Set the position of the line based on the Y coordinate and the height of the text
        //surface.SetTextPos(x, y + (i - 1) * textHeight)
        //surface.DrawText(line)

        local tx, ty = x, (y + (i - 1) * textHeight) - ( totalHeight*.5 ) + (textHeight*.5)
        if ( shadowoffset ) then
            draw.SimpleText( line, font, tx + shadowoffset, ty + shadowoffset, shadowcolor or Color( 0, 0, 0, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        end

        draw.SimpleText( line, font, tx, ty, color or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    //return totalHeight
end

--[[---------------------------------------------------------
    Name: draw.NewTicker( x, y, delay )
    Desc: Creates a new ticker element. Draw using draw.TickerText
    Warning! Do not call this every frame! This is for draw.TickerText management.
-----------------------------------------------------------]]
function NewTicker( x, y, delay )
	return { 
		dir = 1,
		delay = CurTime() + ( delay or 0 ),
		origin = x or 4,
		x = x or 4,
		y = y or 2
	}
end

--[[---------------------------------------------------------
    Name: draw.TickerText( text, font, color, ticker, width, speed, delay )
    Desc: Draws a marquee like text in a specified width.
    Usage: local ticker = draw.NewTicker( 10, 10 )
    		draw.TickerText( "ticker!", "font", color_white, ticker, 150, 10, 2 )
-----------------------------------------------------------]]
function TickerText( text, font, color, ticker, width, speed, delay )

	color = color or Color( 255, 255, 255, 255 )

	local w, h = 0, 0
	local isString = ( type( text ) == "string" )

	if isString then

		surface.SetFont( font )
		surface.SetTextColor( color.r, color.g, color.b, color.a )

		w, h = surface.GetTextSize( text )

	else // So we can use this to get a ticker position without drawing it
		w = tonumber( text )
	end

	if w > width or ticker.x < ticker.origin then

		if ticker.delay < CurTime() then

			// Right
			if ticker.dir == 1 then

				local pos = width - w - 2

				if ticker.x != pos then
					ticker.x = math.Approach( ticker.x, pos, FrameTime() * ( speed or 10 ) )
				else
					ticker.dir = 0
					ticker.delay = CurTime() + ( delay or math.random( 2, 3 ) )
				end

			// Left
			else

				local pos = ticker.origin

				if ticker.x != pos then
					ticker.x = math.Approach( ticker.x, pos, FrameTime() * ( speed or 10 ) )
				else
					ticker.dir = 1
					ticker.delay = CurTime() + ( delay or math.random( 2, 3 ) )
				end

			end

		end

	end

	if isString then
		surface.SetTextPos( ticker.x, ticker.y )
		surface.DrawText( text )
	end

	return ticker

end

--[[---------------------------------------------------------
    Name: draw.RainbowText( text, font, x, y, alpha, xalign, yalign, speed )
    Desc: Draws animated rainbow text
-----------------------------------------------------------]]
function RainbowText(text, font, x, y, alpha, xalign, yalign, speed, shiftamt)

	font 	= font 		or "DermaDefault"
	x 		= x 		or 0
	y 		= y 		or 0
	alpha	= alpha 	or 255
	xalign 	= xalign 	or TEXT_ALIGN_LEFT
	yalign 	= yalign 	or TEXT_ALIGN_TOP
	speed 	= speed 	or 200
	local w, h = 0, 0
	surface.SetFont(font)
	
	if (xalign == TEXT_ALIGN_CENTER) then
		w, h = surface.GetTextSize( text )
		x = x - w/2
	elseif (xalign == TEXT_ALIGN_RIGHT) then
		w, h = surface.GetTextSize( text )
		x = x - w
	end
	
	if (yalign == TEXT_ALIGN_CENTER) then
		w, h = surface.GetTextSize( text )
		y = y - h/2
		
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
	
		w, h = surface.GetTextSize( text );
		y = y - h;
	
	end
	
	local charoffset = 0
	local hue = 330

	shiftamt = shiftamt or 10 --math.max(math.ceil(360 / nchars), 10)

	for char in text:gmatch(utf8pattern) do

		local colour = HSVToColor( ( hue - RealTime() * speed ) % 360, 1, 1 )

		surface.SetTextPos( math.ceil( x + charoffset ), math.ceil( y ) );
		
		surface.SetTextColor( colour.r, colour.g, colour.b, alpha )
		surface.DrawText(char)
	
		charoffset = charoffset + surface.GetTextSize(char)

		hue = hue + shiftamt

	end

	return w, h
	
end

--[[---------------------------------------------------------
    Name: SimpleText(text, font, x, y, colour)
    Desc: Simple "draw text at position function"
          color is a table with r/g/b/a elements
   Usage: 
-----------------------------------------------------------]]
function WaveyText(text, font, x, y, colour, xalign, yalign, amplitude, wavelength, frequency)

	font 	= font 		or "DermaDefault"
	x 		= x 		or 0
	y 		= y 		or 0
	xalign 	= xalign 	or TEXT_ALIGN_LEFT
	yalign 	= yalign 	or TEXT_ALIGN_TOP
	amplitude = amplitude or 20
	wavelength = wavelength or 40
	frequency = frequency or 1
	local w, h = 0, 0
	surface.SetFont(font)
	
	if (xalign == TEXT_ALIGN_CENTER) then
		w, h = surface.GetTextSize( text )
		x = x - w/2
	elseif (xalign == TEXT_ALIGN_RIGHT) then
		w, h = surface.GetTextSize( text )
		x = x - w
	end
	
	if (yalign == TEXT_ALIGN_CENTER) then
		w, h = surface.GetTextSize( text )
		y = y - h/2
		
	elseif ( yalign == TEXT_ALIGN_BOTTOM ) then
	
		w, h = surface.GetTextSize( text );
		y = y - h;
	
	end
	
	surface.SetTextPos( math.ceil( x ), math.ceil( y ) );
	
	local angfreq = 2*math.pi*frequency
	local k = 2*math.pi / wavelength

	local alpha = colour and (colour.a or 255) or 255
	local charoffset = 0

	shiftamt = shiftamt or 10 --math.max(math.ceil(360 / nchars), 10)

	local charidx = 1

	for char in text:gmatch(utf8pattern) do

		-- y(x,t) = A * sin(wt - kx + phi)
		local yoffset = amplitude * math.sin(angfreq * RealTime() - k*charidx)
		surface.SetTextPos( math.ceil( x + charoffset ), math.ceil( y + yoffset ) );
		
		surface.SetTextColor( colour.r, colour.g, colour.b, alpha )
		surface.DrawText(char)

		charoffset = charoffset + surface.GetTextSize(char)

		charidx = charidx + 1

	end
	
	return w, h
	
end

function TheaterText(text, font, x, y, colour, xalign, yalign)
	draw.SimpleText(text, font, x, y + 4, Color(0,0,0,colour.a), xalign, yalign)
	draw.SimpleText(text, font, x + 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
	draw.SimpleText(text, font, x - 1, y + 2, Color(0,0,0,colour.a), xalign, yalign)
	draw.SimpleText(text, font, x, y, colour, xalign, yalign)
end

local GradientDirTextures = {
	[UP] = Material( "vgui/gradient-u" ),
	[DOWN] = Material( "vgui/gradient-d" ),
	[LEFT] = Material( "vgui/gradient-l" ),
	[RIGHT] = Material( "vgui/gradient-r" )
}

function GradientBox( x, y, w, h, color, dir )
	surface.SetDrawColor( color )
	surface.SetMaterial( GradientDirTextures[dir] )
	surface.DrawTexturedRect( x, y, w, h )
end

function GradientVignette( x, y, w, h, color )
    draw.GradientBox( x, y, w*.5, h, color or color_black, LEFT )
    draw.GradientBox( x + w*.5, y, w*.5, h, color or color_black, RIGHT )
    draw.GradientBox( x, y, w, h*.5, color or color_black, UP )
    draw.GradientBox( x, y + h*.5, w, h*.5, color or color_black, DOWN )
end

--[[---------------------------------------------------------
    Name: RotatedText(text, font, x, y, degrees, color, xalign, yalign)
    Desc: Draws rotated text at the given coordinates and degrees.
-----------------------------------------------------------]]
function RotatedText( text, font, x, y, degrees, color, xalign, yalign )

	vecTranslate.x = x
	vecTranslate.y = y
	angRotate.y = degrees

	local mat = Matrix()
	mat:Translate( vecTranslate )
	mat:Rotate( angRotate )
	mat:Translate( -vecTranslate )

	local w, h

	cam.PushModelMatrix(mat)
		w, h = draw.SimpleText( text, font, x, y, color, xalign, yalign )
	cam.PopModelMatrix()

	return w, h

end

--[[---------------------------------------------------------
    Name: ScaledText(text, font, x, y, scale, color, xalign, yalign)
    Desc: Draws scaled text; negative scale flips text.
-----------------------------------------------------------]]
function ScaledText( text, font, x, y, xscale, yscale, color, xalign, yalign )

	vecTranslate.x = x
	vecTranslate.y = y
	vecScale.x = xscale
	vecScale.y = yscale

	local mat = Matrix()
	mat:Translate( vecTranslate )
	mat:Scale( vecScale )
	mat:Translate( -vecTranslate )

	local w, h

	cam.PushModelMatrix(mat)
		w, h = draw.SimpleText( text, font, x, y, color, xalign, yalign )
	cam.PopModelMatrix()

	return w, h

end

function CircleComplex( id, perc, InBound, OutBound, amt, spread, offsetX, offsetY )

	local angbegin = math.rad( id * (360/amt) )
	local angend = angbegin + math.rad( (360/amt) - spread ) * perc

	if !offsetX then offsetX = 0 end
	if !offsetY then offsetY = 0 end

	return {
		{
			["x"] = offsetX + math.cos( angbegin ) * OutBound,
			["y"] = offsetY + math.sin( angbegin ) * OutBound,
			["u"] = 0,
			["v"] = 0
		},
		{
			["x"] = offsetX + math.cos( angend ) * OutBound,
			["y"] = offsetY + math.sin( angend ) * OutBound,
			["u"] = 1,
			["v"] = 1
		},
		{
			["x"] = offsetX + math.cos( angend ) * InBound,
			["y"] = offsetY + math.sin( angend ) * InBound,
			["u"] = 0,
			["v"] = 1
		},
		{
			["x"] = offsetX + math.cos( angbegin ) * InBound,
			["y"] = offsetY + math.sin( angbegin ) * InBound,
			["u"] = 1,
			["v"] = 0
		}
	}

end

function GetTextSize( text, font )

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	return { w = w, h = h }

end