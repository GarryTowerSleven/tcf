table.uinsert( HudToHide, "CHudCrosshair" )
table.uinsert( HudToHide, "CHudHealth" )
table.uinsert( HudToHide, "CHudAmmo" )
table.uinsert( HudToHide, "CHudSecondaryAmmo" )
table.uinsert( HudToHide, "CHudBattery" )
table.uinsert( HudToHide, "CHudZoom" )

module( "GTowerHUD", package.seeall )

EnabledConvar = CreateClientConVar( "gmt_hud", "1", true, false, nil, 0, 1 )

StyleConvar = CreateClientConVar( "gmt_hud_style", "1", true, false, nil, 1, 6 )
ScaleConvar = CreateClientConVar( "gmt_hud_scale", "1", true, false, nil, 0, 4 )

SafeZoneConvar = CreateClientConVar( "gmt_hud_safezone", "0 0", true, false, nil )

AmmoConvar = CreateClientConVar( "gmt_hud_ammo", "1", true, false, nil, 0, 1 )
EventConvar = CreateClientConVar( "gmt_hud_events", "1", true, false, nil, 0, 1 )

CrosshairConvar         = CreateClientConVar( "gmt_hud_crosshair", "1", true, false, nil, 0, 1 )
CrosshairAlwaysConvar   = CreateClientConVar( "gmt_hud_crosshair_always", "1", true, false, nil, 0, 1 )
CrosshairActionConvar   = CreateClientConVar( "gmt_hud_crosshair_action", "1", true, false, nil, 0, 1 )

STYLE_DEFAULT = 1
STYLE_LOBBY2 = 2

STYLE_2009 = 3
STYLE_2010 = 4

STYLE_GMTC = 5
STYLE_DELUXE = 6

MaterialDir = "gmod_tower/lobby/hud/"
MaterialParams = "noclamp smooth"
Materials = {
    mainhud             = Material( MaterialDir .. "mainhud.png", MaterialParams ),
    mainhud_gmtc        = Material( MaterialDir .. "mainhud_gmtc.png", MaterialParams ),
    mainhud_halloween   = Material( MaterialDir .. "mainhud_halloween.png", MaterialParams ),
    mainhud_christmas   = Material( MaterialDir .. "mainhud_christmas.png", MaterialParams ),

    mainhud_2009            = Material( MaterialDir .. "mainhud_2009.png", MaterialParams ),
    mainhud_2010            = Material( MaterialDir .. "mainhud_2010.png", MaterialParams ),
    mainhud_2010_halloween  = Material( MaterialDir .. "mainhud_2010_halloween.png", MaterialParams ),
    mainhud_2010_christmas  = Material( MaterialDir .. "mainhud_2010_christmas.png", MaterialParams ),

    healthbar           = Material( MaterialDir .. "healthbar.png", MaterialParams ),
    healthbar_halloween = Material( MaterialDir .. "healthbar_halloween.png", MaterialParams ),
    healthbar_christmas = Material( MaterialDir .. "healthbar_christmas.png", MaterialParams ),

    ammo        = Material( MaterialDir .. "ammo.png", MaterialParams ),
    ammo_bar    = Material( MaterialDir .. "ammobar.png", MaterialParams ),

    crosshair   = Material( "sprites/powerup_effects" ),
    crosshair2   = Material( MaterialDir .. "crosshair.png", MaterialParams ),

    logo_128 = Material( MaterialDir .. "logo_128.png", MaterialParams ),
    logo_256 = Material( MaterialDir .. "logo_256.png", MaterialParams ),
    logo_512 = Material( MaterialDir .. "logo_512.png", MaterialParams ),

    logo_flat   = Material( MaterialDir .. "logo_flat.png", MaterialParams ),
    logo_deluxe = Material( MaterialDir .. "logo_flat_deluxe.png", MaterialParams ),

    gradient        = Material( MaterialDir .. "bg_gradient.png", MaterialParams ),
    gradient_deluxe = Material( MaterialDir .. "bg_gradient_deluxe.png", MaterialParams ),
}

function MakeFonts()

    local scale = Scale()
    
    surface.CreateFont( "GTowerHUD_Money", { font = "Oswald", size = 38 * scale, weight = 400 } )
    surface.CreateFont( "GTowerHUD_Location", { font = "Oswald", size = 18 * scale, weight = 400 } )
    
    surface.CreateFont( "GTowerHUD_Use", { font = "Oswald", size = 24 * scale, weight = 400 } )
    surface.CreateFont( "GTowerHUD_UseKey", { font = "Oswald", size = 38 * scale, weight = 400 } )
    surface.CreateFont( "GTowerHUD_Extra", { font = "Clear Sans", size = 18 * scale, weight = 800 } )

    surface.CreateFont( "GTowerHUD_Ammo", { font = "Tahoma", size = 45 * scale, weight = 100 } )
    surface.CreateFont( "GTowerHUD_AmmoSecondary", { font = "Tahoma", size = 20 * scale, weight = 1200 } )
    
    surface.CreateFont( "GTowerHUD_Old_Money", { font = "Tahoma", size = 20 * scale, weight = 800 } )
    surface.CreateFont( "GTowerHUD_Old_EventTimer", { font = "Tahoma", size = 15 * scale, weight = 800 } )
    surface.CreateFont( "GTowerHUD_Old_Location", { font = "Tahoma", size = 28 * scale, weight = 400 } )

end

cvars.AddChangeCallback( "gmt_hud_scale", function( _, old, new )
    MakeFonts()
end )

function IsEnabled()
    return EnabledConvar:GetBool()
end

function Scale()
    return ScaleConvar:GetFloat() or 1
end

MakeFonts()

function Style()
    return StyleConvar:GetInt() or 1
end

function SafeZone()
    local str = SafeZoneConvar:GetString()
    local split = string.Explode( " ", str )

    return tonumber( split[1] or 0 ), tonumber( split[2] or 0 )
end

function IsOldLobby1()
    return Style() == STYLE_2009 or Style() == STYLE_2010
end

function IsLobby1()
    return Style() == STYLE_DEFAULT or Style() == STYLE_GMTC
end

function IsLobby2()
    return Style() == STYLE_LOBBY2 or Style() == STYLE_DELUXE
end

function ShouldDraw()
    if not IsEnabled() then return false end

    if hook.Call( "GTowerHUDShouldDraw", GAMEMODE ) == false then return false end
    
    if IsValid( Weapon ) && Weapon:GetClass() == "gmt_camera" then return false end

    return true
end

/* ---------- helpers --------- */

MoneyAmount = 0
MoneyApproached = 0
MoneyLast = 0

ChipsAmount = 0
ChipsApproached = 0
ChipsLast = 0

Health = 100
HealthMax = 100

HealthRatio = 1
HealthRatioApproach = 1

Weapon = nil

Ammo = 0
AmmoMax = 0
AmmoReserve = 0

AmmoRatio = 1
AmmoRatioApproach = 1

function GetHealth()
    return Health or 0
end
function GetMaxHealth()
    return MaxHealth or 100
end
function GetHealthRatio( approached )
    return approached and HealthRatioApproach or HealthRatio
end

function GetAmmo()
    return Ammo or -1
end
function GetMaxAmmo()
    return Ammo or -1
end
function GetAmmoRatio( approached )
    return approached and AmmoRatioApproach or AmmoRatio
end
function GetAmmoReserve()
    return AmmoReserve or 0
end

function GetLocation()
    return Location.GetFriendlyName( LocalPlayer():Location() )
end

function GetMoney( approached )
    return approached and MoneyApproached or MoneyAmount
end

function GetChips( approached )
    return approached and ChipsApproached or ChipsAmount
end

function ShouldDrawAmmo()
    return AmmoConvar:GetBool() and (IsValid( Weapon ) and ( Ammo >= 0 ))
end
function ShouldDrawCrosshair()
	if IsValid(Weapon) and !Weapon.DrawCrosshair then return false end -- What
	if LocalPlayer().HideCrosshair then return false end
	if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return false end

	return CrosshairConvar:GetBool()
end
function ShouldDrawHealth()
    return IsOldLobby1() and true or Location.Is( LocalPlayer():Location(), "Narnia" )
end
function ShouldDrawEvents()
    return EventConvar:GetBool() or false
end
function ShouldDrawChips()
    return Location.IsCasino( LocalPlayer():Location() )
end

function GetEventInfo()
    local name = GetGlobalString( "NextEvent" ) or "Unknown"
    local time = GetGlobalInt( "NextEventTime" ) or 0

    return name, time
end

/* ----------------------------- */

function PaintHealth( x, y, w, h, scale, noborder )

    if not ShouldDrawHealth() then return end
    
    local health = GetHealth()
    local ratio = GetHealthRatio() or 1
    local ratio_approached = GetHealthRatio( true ) or 1

    local oppred = 200 - (1-ratio) * math.sin(UnPredictedCurTime() * (1-ratio) * 3) * 55 + (1 - (1-ratio)) * 55

    local mat = Materials.healthbar

    if IsOldLobby1() then
        
        if IsHalloweenMap() then
            mat = Materials.healthbar_halloween
        elseif IsChristmasMap() then
            mat = Materials.healthbar_christmas
        end    

    end

    if noborder then
                
        surface.SetDrawColor( 255, oppred, oppred, 255 )
        surface.SetMaterial( mat )
        surface.DrawTexturedRect( x, y, w * ratio_approached, h )

        local text_sub = 255 - (100 * (1 - ratio))
        local text_color = Color( 255, text_sub, text_sub, 255 )

        draw.SimpleText( health, "GTowerHUD_Old_Location", x + ( w / 2 ), y + ( h / 2 ), text_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

        return

    end

    surface.SetDrawColor( 15, 100, 30, 255 )
    surface.DrawRect( x, y, w, h )

    surface.SetDrawColor( 255, oppred, oppred, 255 )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( x + ( 2 * scale ), y + ( 2 * scale ), (w - ( 4 * scale )) * ratio_approached, h - ( 4 * scale ) )

    draw.SimpleText( health, "GTowerHUD_Location", x + ( w / 2 ), y + ( h / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

function PaintAmmo( scale, sx, sy, scrw, scrh )

    if not ShouldDrawAmmo() then return end

    local ammo_width, ammo_height = 256, 256
    local ammo_bar_width, ammo_bar_height = 126, 126

    local ammo_margin_right = -96 * scale
    local ammo_margin_bottom = -96 * scale

    local ammo_x, ammo_y = scrw - ammo_margin_right - (ammo_height * scale), scrh - (ammo_height * scale) - ammo_margin_bottom

    local ammo_main_x, ammo_main_y = ammo_x + ( 7 * scale ), ammo_y + ( 6 * scale )
    local ammo_main_size = 132 * scale
    
    local ammo_second_x, ammo_second_y = ammo_x + ( 93 * scale ), ammo_y + ( 88 * scale )
    local ammo_second_size = 61 * scale

    local ammo = GetAmmo()
    local reserve = GetAmmoReserve()
    local ratio_approached = GetAmmoRatio( true )

    // Bar
    surface.SetDrawColor( color_white )
    surface.SetMaterial( Materials.ammo_bar )
    surface.DrawTexturedRectRotated(
        ammo_main_x + (ammo_main_size / 2), ammo_main_y + (ammo_main_size / 2),
        ammo_bar_width * scale,
        ammo_bar_height * scale,
        180 * (1 - ratio_approached) )

    // Background
    surface.SetMaterial( Materials.ammo )
    surface.DrawTexturedRect( 
        ammo_x, ammo_y,
        ammo_width * scale,
        ammo_height * scale )

    // Primary Ammo
    draw.SimpleText( ammo, "GTowerHUD_Ammo", ammo_main_x + ( ammo_main_size / 2 ), ammo_main_y + ( ammo_main_size / 2 ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    
    // Secondary Ammo
    draw.SimpleText( reserve, "GTowerHUD_AmmoSecondary", ammo_second_x + ( ammo_second_size / 2 ) - ( 1 * scale ), ammo_second_y + ( ammo_second_size / 2 ) + ( 1 * scale ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

/*local main_color = Color( 84, 167, 222, 255 )
local function PaintInfo2( x, y, scale )

    local rect_width, rect_height = 206 * scale, 70 * scale
    local rect_x, rect_y = x + (50 * scale), y + (48 * scale)

    surface.SetDrawColor( main_color )
    surface.DrawRect( rect_x, rect_y, rect_width, rect_height )

    // two of em
    draw.GradientBox( rect_x, rect_y, rect_width, rect_height, Color( main_color.r - 57, main_color.g - 57, main_color.b - 57 ), DOWN )
    draw.GradientBox( rect_x, rect_y, rect_width, rect_height, Color( main_color.r - 57, main_color.g - 57, main_color.b - 57 ), DOWN )

    local inner_width, inner_height = rect_width - (40 * scale), rect_height - (12 * scale)
    local inner_x, inner_y = rect_x + (34 * scale), rect_y + (6 * scale)

    local hsv = ColorToHSV( main_color )
    local col = HSVToColor( hsv, .95, .55 )
    surface.SetDrawColor( col )
    surface.DrawRect( inner_x, inner_y, inner_width, inner_height )

    local location_width, location_height = inner_width, inner_height - ( 39 * scale )
    local location_x, location_y = inner_x, inner_y + (39*scale)
    
    draw.GradientBox( inner_x, inner_y, inner_width, inner_height, Color( 0, 0, 0, 220 ), DOWN )

    surface.SetDrawColor( 0, 0, 0, 100 )
    surface.DrawRect( location_x, location_y, location_width, location_height )

    surface.SetDrawColor( 0, 0, 0, 50 )
    surface.DrawOutlinedRect( inner_x, inner_y, inner_width, inner_height, 1 * scale )
    surface.DrawOutlinedRect( location_x, location_y, location_width, location_height, 1 * scale )

    local logo_x, logo_y = x - (5 * scale), y + (32 * scale)
    local logo_size = 90 * scale

    local logo_mat = Materials.logo_128

    if logo_size > 256 then
        logo_mat = Materials.logo_512
    elseif logo_size > 128 then
        logo_mat = Materials.logo_256
    end

    surface.SetDrawColor( 255, 255 ,255, 255 )
    surface.SetMaterial( logo_mat )
    surface.DrawTexturedRect( logo_x, logo_y, logo_size, logo_size )

end*/

local chipsMat = Material( "gmod_tower/icons/chip.png" )
local function PaintChips( x, y, scale )

    if not ShouldDrawChips() then return end

    local chips = "CHIPS: " .. string.FormatNumber( GetChips( true ) )

    local icon_size = 32 * scale
    local off = 10 * scale

    surface.SetMaterial( chipsMat )
    surface.SetDrawColor( 50, 50, 50 )
    surface.DrawTexturedRect( x + (20*scale), y - (15*scale) + off, icon_size, icon_size )
    surface.SetDrawColor( 100, 100, 100 )
    surface.DrawTexturedRect( x, y - (20*scale) + off, icon_size, icon_size )
    surface.SetDrawColor( 255, 255, 255 )
    surface.DrawTexturedRect( x + (10*scale), y - (25*scale) + off, icon_size, icon_size )

    draw.SimpleShadowText( chips, "GTowerHUD_Use", x + (45*scale), y - (13*scale) + off, Color( 255, 255, 255, 255 ), color_black, TEXT_ALIGN_LEFT )


end

local jetRatio = 1
local jetLast = 0
local jetlastActive = UnPredictedCurTime()

local function PaintJetpack( x, y, w, h, scale )

	local jetpack_amount = LocalPlayer():GetNet( "JetpackFuelRemaining" ) /*LocalPlayer()._DisplayFuelAmount*/ or 0

    local border = 2 * scale

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

    surface.SetDrawColor( 255, 255, 255, 60 * jetRatio )
    surface.DrawRect( x, y, w, h )

    surface.SetDrawColor( 45, 85, 135, 255 * jetRatio )
    surface.DrawOutlinedRect( x, y, w, h, border )
    
    surface.SetDrawColor( 255, 255, 255, 255 * jetRatio )
    surface.DrawRect( x + border, y + border + ( (h - (border*2)) * ( 1 - jetpack_amount ) ), w - ( border * 2 ), (h - ( border * 2 )) * jetpack_amount )

end

local function PaintInfo( scale, sx, sy, scrw, scrh )

    local main_width, main_height = 256, 128

    local main_margin_left = 8 * scale
    local main_margin_bottom = 12 * scale

    local main_x, main_y = main_margin_left + sx, scrh - (main_height * scale) - main_margin_bottom

    PaintChips( main_x + (72 * scale), main_y + (40 * scale), scale )

    // Jetpack
    local jetpack_x, jetpack_y = main_x + (256 * scale), main_y + (48 * scale)
    local jetpack_width, jetpack_height = 10 * scale, 70 * scale

    PaintJetpack( jetpack_x, jetpack_y, jetpack_width, jetpack_height, scale )

    // Health
    PaintHealth( main_x + (50 * scale), main_y + (33 * scale), 206 * scale, 16 * scale, scale )

    local mat = Style() == STYLE_GMTC and Materials.mainhud_gmtc or Materials.mainhud

    if IsHalloweenMap() then
        mat = Materials.mainhud_halloween
    elseif IsChristmasMap() then
        mat = Materials.mainhud_christmas
    end

    // Background
    surface.SetDrawColor( color_white )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( main_x, main_y, main_width * scale, main_height * scale )

    // PaintInfo2( main_x, main_y, scale )

    // Money
    local money = string.FormatNumber( GetMoney( true ) )
    draw.SimpleText( money, "GTowerHUD_Money", main_x + (110 * scale), main_y + (56 * scale), color_white )

    // Location
    draw.SimpleText( string.upper( GetLocation() ), "GTowerHUD_Location", main_x + (91 * scale), main_y + (94 * scale), color_white )

    // Events
    if ShouldDrawEvents() then

        local event_name, event_time = GetEventInfo()
        local timeleft = event_time - CurTime()
    
        local event_string = "NEXT EVENT (" .. string.upper( event_name ) .. ") IN " .. string.FormattedTime( timeleft, "%02i:%02i" )
    
        draw.SimpleText( event_string, "GTowerHUD_Location", main_x + ((45 + 1) * scale), main_y + ((120 + 1) * scale), color_black )
        draw.SimpleText( event_string, "GTowerHUD_Location", main_x + (45 * scale), main_y + (120 * scale), color_white )    
        
    end

end

local function PaintCrosshair( ent )

    if not ShouldDrawCrosshair() then return end
    if not CrosshairAlwaysConvar:GetBool() and ( not IsValid( ent ) or not CanPlayerUse( ent ) ) and not IsValid(Weapon) then return end

    local x, y = ScrW() / 2, ScrH() / 2
	local color = color_white

    local crosshair_size = ScreenScale( 12 )

    surface.SetDrawColor( color )
    surface.SetMaterial( Materials.crosshair )
    surface.DrawTexturedRect( x - ( crosshair_size / 2 ), y - ( crosshair_size / 2 ), crosshair_size, crosshair_size )    

end

function PaintLobby1()

    local scale = Scale()

    local sx, sy = SafeZone()
    local scrw, scrh = ScrW() - ( sx * 2 ), ScrH() - ( sy * 2 )

    /* Main Info */
    if IsOldLobby1() then
        PaintOld( scale, sx, sy, scrw, scrh )
    else
        PaintInfo( scale, sx, sy, scrw, scrh )
    end

    /* Ammo */
    PaintAmmo( scale, sx, sy, scrw, scrh )

    /* Crosshair */
    local ent = GAMEMODE:PlayerUseTrace( LocalPlayer() )

    PaintCrosshair( ent )

end

function GTowerHUD.DrawNotice( title, message )

    // TODO: hud hook and gradient ver

    if !GTowerHUD.Notice.Enabled:GetBool() then return end

    -- Handle notice
    local w, h = ScrW() / 2, ScrH() / 2
    h = ( h * 2 ) - 150

    -- Draw gradient boxes
    --draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
    --draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
    surface.SetDrawColor( 0, 0, 0, 230 )
    surface.DrawRect( w - 512, h, 1024, 130 )

    -- Draw title
    draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )

    -- Draw text
    draw.DrawText( message or "", "GTowerHudCSubText", w, h + 30, Color( 255, 255, 255, 255 ), 1 )

end

function Paint()

    if not ShouldDraw() then return end

    if IsLobby2() then

        PaintLobby2()

    else

        PaintLobby1()

    end

end

hook.Add( "HUDPaint", "GMTLobbyHUD", Paint )

function Think()

    // Money Approach
    local money = Money()

    MoneyAmount = money

    if MoneyLast != MoneyAmount then
		MoneyLast = MoneyAmount
	end

    if MoneyAmount != MoneyApproached then
		local diffMoney = MoneyApproached - MoneyLast
        local increaseAmount = math.ceil( math.abs( diffMoney * .1 ) )
		MoneyApproached = math.Approach( MoneyApproached, MoneyAmount, increaseAmount )
    end

    // Chips Approach
    local chips = LocalPlayer():PokerChips()

    ChipsAmount = chips

    if ChipsLast != ChipsAmount then
		ChipsLast = ChipsAmount
	end

    if ChipsAmount != ChipsApproached then
		local diffChips = ChipsApproached - ChipsLast
        local increaseAmount = math.ceil( math.abs( diffChips * .1 ) )
		ChipsApproached = math.Approach( ChipsApproached, ChipsAmount, increaseAmount )
    end

    // Health Approach
    local health = LocalPlayer():Health() or 0
    local maxhealth = Dueling.IsDueling( LocalPlayer() ) and 300 or (LocalPlayer():GetMaxHealth() or 100)

    Health = math.Clamp( health, 0, maxhealth )
    HealthMax = maxhealth

    local health_ratio = Health / maxhealth

    HealthRatio = health_ratio

    if HealthRatio != HealthRatioApproach then
        HealthRatioApproach = math.Approach( HealthRatioApproach, HealthRatio, math.abs( HealthRatioApproach - HealthRatio ) * 3 * RealFrameTime() )
    end

    // Ammo Approach
    local weapon = LocalPlayer():GetActiveWeapon()

    if IsValid( weapon ) then

        Weapon = weapon
        
        local cur = weapon:Clip1() or 0
        local max = weapon:GetMaxClip1() or 100

        Ammo = cur
        AmmoMax = max

        local ammo_ratio = Ammo / AmmoMax

        AmmoRatio = ammo_ratio

        if AmmoRatio != AmmoRatioApproach then
            AmmoRatioApproach = math.Approach( AmmoRatioApproach, AmmoRatio, math.abs( AmmoRatioApproach - AmmoRatio ) * 5 * RealFrameTime() )
        end

        local ammo_type = weapon:GetPrimaryAmmoType()
        local reserve = LocalPlayer():GetAmmoCount( ammo_type ) or 0

        AmmoReserve = reserve

    else
        
        Weapon = nil

    end

end

hook.Add( "Think", "GMTLobbyHUD", Think )