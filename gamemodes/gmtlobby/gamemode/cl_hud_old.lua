
module( "GTowerHUD", package.seeall )

local location_background = Color( 0, 140, 240, 100 )
local function PaintLocation( scale )

    surface.SetFont( "GTowerHUD_Old_Location" )
    local location_name = GetLocation()

	local tW, tH = surface.GetTextSize( location_name )

    local tX, tY = ScrW() / 2, ScrH()
    local padding = 12 * scale

    draw.RoundedBox( 6, tX - ( tW / 2 ) - padding, tY - tH, tW + (padding * 2), tH + (20 * scale), location_background )
    draw.SimpleText( location_name, "GTowerHUD_Old_Location", tX, tY, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

end

local function PaintInfo( scale, sx, sy, scrw, scrh )

    local main_width, main_height = 256, 128
    local main_x, main_y = sx, scrh - (main_height * scale) + (3 * scale)

    local mat = Style() == STYLE_2009 and Materials.mainhud_2009 or Materials.mainhud_2010
    
    if IsHalloweenMap() then
        mat = Materials.mainhud_2010_halloween
    elseif IsChristmasMap() then
        mat = Materials.mainhud_2010_christmas
    end

    // Background
    surface.SetDrawColor( color_white )
    surface.SetMaterial( mat )
    surface.DrawTexturedRect( main_x, main_y, main_width * scale, main_height * scale )   
    
    
    // Events
    if ShouldDrawEvents() then
        local event_x, event_y = main_x + (15 * scale), main_y + (111 * scale)

        if Style() == STYLE_2009 then
            event_x = event_x + (25 * scale)
        end

        local event_name, event_time = GetEventInfo()
        local timeleft = event_time - CurTime()

        local event_string = "Next Event (" .. event_name .. ") in " .. string.FormattedTime( timeleft, "%02i:%02i" )

        draw.SimpleText( event_string, "GTowerHUD_Old_EventTimer", event_x + (1 * scale), event_y + (1 * scale), color_black )
        draw.SimpleText( event_string, "GTowerHUD_Old_EventTimer", event_x, event_y, color_white )

    end


    // Health
    PaintHealth( main_x + (69 * scale), main_y + (81 * scale), 150 * scale, 20 * scale, scale, true )

    // Money
    draw.SimpleText( GetMoney(), "GTowerHUD_Old_Money", main_x + (93 * scale), main_y + (53 * scale), color_white )

end

function PaintOld( scale, sx, sy, scrw, scrh )

    PaintInfo( scale, sx, sy, scrw, scrh )
    PaintLocation( scale )
    
end