local ConVar = CreateClientConVar( "gmt_beta_notice", 1, true, false, nil, 0, 1 )

surface.CreateFont( "GammaFont", {
    font = "Tahoma",
    size = 11,
    antialias = false,
} )

local GammaText = {
    "OPEN DELUXE BUILD",
    "CONTENT SUBJECT TO CHANGE",
    "VISIT US AT GMTDELUXE.ORG",
    //"VERSION 0149.1304",
}

function DrawWatermark()
    if ( !ConVar:GetBool() ) then return end

    local alpha = 120
    local color = colorutil.Alpha( colorutil.Rainbow( 1 ), alpha*1.25 )
    local x, y = ScrW()/2, ScrH() - 80

    for k, v in ipairs( GammaText ) do
        local y = y + (12*(k-1))
        draw.SimpleText( v, "GammaFont", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( v, "GammaFont", x + 1, y + 1, Color( 0, 0, 0, alpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end
end

hook.Add( "HUDPaint", "GMTOpenDeluxe", DrawWatermark )