
module( "GTowerHUD", package.seeall )

local function PaintCrosshair( ent )

    if not ShouldDrawCrosshair() then return end
    if not CrosshairAlwaysConvar:GetBool() and ( not IsValid( ent ) or not true ) then return end

    local x, y = ScrW() / 2, ScrH() / 2
	local color = color_white
    local size = 4

    surface.SetMaterial( Materials.crosshair2 )
    surface.SetDrawColor( color.r, color.g, color.b, 100 )
    surface.DrawTexturedRect( x - size/2, y - size/2, size, size )

end

local function PaintUseMessage( ent, scale )

    if not ShouldDrawCrosshair() then return end
    if not CrosshairActionConvar:GetBool() then return end

    if not IsValid( ent ) or not true then return end

	local use, nokey = CanPlayerUse( ent )
	if not use then return end

    local x, y = ScrW() / 2, ScrH() / 2

    if use then

		surface.SetFont( "GTowerHUD_Use" )
		local tw, th = surface.GetTextSize( use )
		local offset = -(tw / 2)

		if not nokey then

			local usekey = string.upper( input.LookupBinding( 'use' ) or "e" )

			surface.SetFont( "GTowerHUD_UseKey" )
			tw, th = surface.GetTextSize(usekey)
			tw = math.max(tw+(8*scale),th)
			offset = tw/2

			surface.SetDrawColor( 0, 0, 0, 200 )
			surface.DrawRect( x - tw/2, y - th/2 + (2*scale), tw, th )

			draw.SimpleText( usekey, "GTowerHUD_UseKey", x, y - th/2, color_white, 1 )

		end

		draw.SimpleShadowText( use, "GTowerHUD_Use", x + (4*scale) + offset, y, color_white, Color( 0, 0, 0, 230 ), TEXT_ALIGN_LEFT, 1, 1 )

	end

end

local info_width = 250
local info_height = 68
local info_alpha = 200

local function PaintGradient( x, y, w, h )

    local IsDeluxe = Style() == STYLE_DELUXE

    local gradient = IsDeluxe and Materials.gradient_deluxe or Materials.gradient
    local gradient_col = IsDeluxe and color_white or color_black
    local gradient_alpha = IsDeluxe and 150 or info_alpha

    surface.SetDrawColor( gradient_col.r, gradient_col.g, gradient_col.b, gradient_alpha )
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( x, y, w, h )

end

local function PaintExtraInfo( icon, text, x, y, scale, icon_size )

	icon_size = icon_size and icon_size or (icon and 32 or 5)
    icon_size = icon_size * scale

    local info_width = 250 * scale
    local info_height = 20 * scale

    PaintGradient( x, y, info_width, info_height )

    if icon then

        surface.SetDrawColor( color_white )
        surface.SetMaterial( icon )
        surface.DrawTexturedRect( x, y + ( (info_height / 2) - (icon_size / 2) ), icon_size, icon_size )
        
    end

    draw.SimpleShadowText( text, "GTowerHUD_Extra", x + icon_size, y + ( info_height / 2 ), color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

end

local function PaintHealth( x, y, w, h, scale )

    local iconSize = 32 * scale

    PaintGradient( x, y, w, h )
    
    // heart
    surface.SetDrawColor( 255, 255, 255 )
    surface.SetMaterial( GTowerIcons2.GetIcon("heart") )
    surface.DrawTexturedRect( x, y + ( (h / 2) - (iconSize / 2) ), iconSize, iconSize )

    -- Draw health bar
    local health_width, health_height = w, 8 * scale
    local health_x, health_y = x + iconSize, y + ( h / 2 ) - ( health_height / 2 )

    // background
    surface.SetDrawColor( 80, 80, 80, 200 )
    surface.DrawRect( health_x, health_y, health_width, health_height )

    local ratio = GetHealthRatio() or 1

    local oppred = 200 - (1-ratio) * math.sin(UnPredictedCurTime() * (1-ratio) * 3) * 55 + (1 - (1-ratio)) * 55

    surface.SetDrawColor( 255, 255, 255, 255 )
    draw.RectFillBorder( health_x, health_y, health_width, health_height, 1 * scale, ratio, Color( 125, 125, 125, 0 ), Color( 255, oppred, oppred ) )


end

local jetRatio = 1
local jetLast = 0
local jetlastActive = UnPredictedCurTime()

local function PaintJetpack( x, y, w, h, scale )

	local jetpack_amount = LocalPlayer():GetNet( "JetpackFuelRemaining" ) /*LocalPlayer()._DisplayFuelAmount*/ or 0

    local border = 1 * scale

    if jetpack_amount != jetLast then
        jetLast = jetpack_amount
        jetlastActive = UnPredictedCurTime()
    end

    if jetlastActive + .5 < UnPredictedCurTime() then
        jetRatio = math.Approach( jetRatio, 0, RealFrameTime() * 5 )
    else
        jetRatio = math.Approach( jetRatio, 1, RealFrameTime() * 5 )
    end

    x = x - ( w * (1-jetRatio) )

    surface.SetDrawColor( 255, 255, 255, 255 * jetRatio )
    surface.DrawOutlinedRect( x, y, w, h, border )
    
    surface.SetDrawColor( 255, 255, 255, 255 * jetRatio )
    surface.DrawRect( x + border, y + border + ( (h - (border*2)) * ( 1 - jetpack_amount ) ), w - ( border * 2 ), math.ceil( (h - ( border * 2 )) * jetpack_amount ) )

end

local function PaintInfo( scale, sx, sy, scrw, scrh )

    local IsDeluxe = Style() == STYLE_DELUXE

    local info_x, info_y = sx, scrh - (92 * scale) - sy
    local info_width, info_height = info_width * scale, info_height * scale

    local logo_mat = IsDeluxe and Materials.logo_deluxe or Materials.logo_flat
    local logo_size = 64 * scale

    // background
    PaintGradient( info_x, info_y, info_width, info_height )

    // logo
    surface.SetDrawColor( color_white )
    surface.SetMaterial( logo_mat )
    surface.DrawTexturedRect( info_x + (10 * scale), info_y + ( info_height / 2 ) - ( logo_size / 2 ), logo_size, logo_size )

    // money
    local money = string.FormatNumber( GetMoney( true ) )
    local money_font = "GTowerHUD_Money"
    local money_x, money_y = info_x + (85 * scale), info_y + (25 * scale)

    surface.SetFont( money_font )
    local tW, _ = surface.GetTextSize( money )
    
	draw.SimpleShadowText( money, money_font, money_x, money_y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
	draw.SimpleShadowText( "GMC", "GTowerHUD_Location", money_x + tW + (4 * scale), money_y + (6 * scale), color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

    // location
    local location = string.upper( GetLocation() )

	draw.SimpleShadowText( location, "GTowerHUD_Location", money_x, money_y + (24 * scale), color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

    // suite
    local suiteid = LocalPlayer():GetNet( "RoomID" ) or 0

    if suiteid > 0 then
        PaintExtraInfo( GTowerIcons2.GetIcon("condo"), "Suite #" .. tostring( suiteid ), info_x, info_y + info_height + (2 * scale), scale )
    end

    if ShouldDrawChips() then
        local chips = string.FormatNumber( GetChips( true ) )

        PaintExtraInfo( GTowerIcons2.GetIcon("chips"), chips, info_x, info_y + info_height + (2 * scale), scale, 16 )
    end

    if ShouldDrawHealth() then
        PaintHealth( info_x, info_y - (20 * scale) - (2 * scale), info_width, 20 * scale, scale )
    end

    // Jetpack
    local jetpack_x, jetpack_y = info_x + info_width, info_y
    local jetpack_width, jetpack_height = 6 * scale, info_height
    
    PaintJetpack( jetpack_x, jetpack_y, jetpack_width, jetpack_height, scale )

    // PaintExtraInfo( nil, "Condo #5", info_x, info_y - (20 * scale) - (2 * scale), scale )
    // PaintExtraInfo( nil, "Condo #5", info_x, info_y - (42 * scale) - (2 * scale), scale )

end

function PaintLobby2()

    local scale = Scale()

    local sx, sy = SafeZone()
    local scrw, scrh = ScrW() - ( sx * 2 ), ScrH() - ( sy * 2 )

    /* Main Info */
    PaintInfo( scale, sx, sy, scrw, scrh )

    /* Ammo */
    PaintAmmo( scale, sx, sy, scrw, scrh )

    /* Crosshair */
    local ent = GAMEMODE:PlayerUseTrace( LocalPlayer() )
    
    PaintCrosshair( ent, scale )
    PaintUseMessage( ent, scale )
    
end