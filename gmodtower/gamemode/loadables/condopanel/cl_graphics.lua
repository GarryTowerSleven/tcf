module( "panelos", package.seeall )

surface.CreateFont( "AppBarLarge", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 80
} )
surface.CreateFont( "AppBarSmall", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size = 40
} )
surface.CreateFont( "AppBarLabel", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 600,
	size = 32
} )
surface.CreateFont( "AppBarLabelSmall", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 600,
	size = 24
} )

GradientDown = surface.GetTextureID( "VGUI/gradient_down" )
GradientUp = surface.GetTextureID( "VGUI/gradient_up" )
Cursor2D = surface.GetTextureID( "cursor/cursor_default" )

Backgrounds = {
	Material( "gmod_tower/panelos/backgrounds/background1.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background2.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background3.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background4.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background5.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background6.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background7.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background8.png", "unlitsmooth" ),
	Material( "gmod_tower/panelos/backgrounds/background9.png", "unlitsmooth" ),
}

Icons = GTowerIcons2.Icons

Sounds = {
	["accept"] = "GModTower/ui/panel_accept.wav",
	["back"] = "GModTower/ui/panel_back.wav",
	["error"] = "GModTower/ui/panel_error.wav",
	["save"] = "GModTower/ui/panel_save.wav",
}

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

	cost = stringmod.FormatNumber(cost)

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