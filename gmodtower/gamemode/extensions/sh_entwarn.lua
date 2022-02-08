local netName = "ENT_COUNT"
ENT_LIMIT = 8064
ENT_WARN = .85

if SERVER then

    local lastCount = 0
    hook.Add( "Think", "EntCheck", function()
        local count = ents.GetEdictCount()

        if lastCount == count then return end
        lastCount = count

        SetGlobalInt( netName, count )
    end )
    
elseif CLIENT then

    local EntBarEnabled = CreateClientConVar( "gmt_admin_entbar", 1, true )
    local EntBarAlways =  CreateClientConVar( "gmt_admin_entbar_always", 0, true )
    local EntBarLabels =  CreateClientConVar( "gmt_admin_entbar_labels", 0, true )

    local style = {
        h = 500,
        w = 20,
    }

    local function DrawEntHud()
        if !LocalPlayer():IsStaff() || !EntBarEnabled:GetBool() then return end

        local ENT_COUNT = GetGlobalInt( netName, 0 )

        local scrw, scrh = ScrW(), ScrH()

        local per = ENT_COUNT/ENT_LIMIT
        local isbad = per >= ENT_WARN

        if !isbad && !EntBarAlways:GetBool() then return end
        
        local fill = accent
        local border = Color( 255,255,255,50 )
        local bg = Color( 0,0,0,120 )

        if !isbad then
            fill = Color( 255,255,255 )
        else
            fill = HSVToColor( 360, 1*per, 1 )
        end

        local x, y = 15, (scrh/2)-(style.h/2)

        local txt = ENT_COUNT --math.Round(per, 2)*100 .. "%"

        // bg
        draw.Rectangle( x, y, style.w+1, style.h+1, bg )
        // bar
        draw.RectFillBorder( x+1, y+1, style.w-1, style.h-1, 1, per or 0, border, fill, true )
        // text
        draw.SimpleShadowText( txt, nil, x+(style.w/2)+1, y+style.h+8, nil, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )

        if EntBarLabels:GetBool() then
            local d = 5
            for i=0, d do
                local h = style.h - 2
                draw.SimpleShadowText( "- " .. math.floor(ENT_LIMIT*(i/d)), nil, x+style.w+8, y + h - ((h)*(i/d)), nil, nil, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1 )
            end 
        end
    end

    hook.Add( "HUDPaint", "EntityLimitHud", DrawEntHud )

end