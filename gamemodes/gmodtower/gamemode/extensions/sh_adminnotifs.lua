function LogPrint(text, color, mark, markcolor)
    if !color then
        color = Color( 255,255,255)
    end

    if mark then
        if !markcolor then markcolor = color end
        MsgC(markcolor,  "[" .. mark .. "] ") 
    end

    MsgC(color,  text .. "\n")
end

if SERVER then util.AddNetworkString("ConsolePrint") return end

local MsgC = MsgC

local AdminLog = CreateConVar( "gmt_admin_log", 1, { FCVAR_ARCHIVE, FCVAR_USERINFO }, "Enable admin logging." )

module( "AdminNotif", package.seeall )

Notifs = {}
NotifStyle = {
    Font = "GTowerHUDMainMedium",
    Background = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" ),
    PosX = 10,
    PosY = 10,
    PadW = 5,
    PadH = 2,
    Margin = 5,
    Border = 1,
    ShadowOffset = 1,
    ProgressH = 1,
}

local function NotifPaint()

    if table.IsEmpty( Notifs ) then return end

    for k,v in pairs( Notifs ) do

        local timeRemaining = v[2]-CurTime()
        local remainingMult = math.Clamp( timeRemaining/v[3], 0, v[3] )

        surface.SetFont( NotifStyle.Font )
        local w, h = surface.GetTextSize(v[1])

        local x = NotifStyle.PosX

        local y = NotifStyle.PosY + ((k-1)*h) + ((NotifStyle.PadH*2)*(k-1)) + NotifStyle.Margin*(k-1)

        local color = colorutil.Rainbow(25)
        if v[4] && IsColor(v[4]) then
            color = v[4]
        end

        local wid, hei = w + (NotifStyle.PadW*2), h + (NotifStyle.PadH*2)
        surface.SetDrawColor( colorutil.Brighten( color, .5 ) )
        surface.DrawRect( x - NotifStyle.Border, y - NotifStyle.Border, wid + (NotifStyle.Border*2), hei + (NotifStyle.Border*2) )
        surface.SetDrawColor( color )
        surface.DrawRect( x - NotifStyle.Border, y - NotifStyle.Border, (wid + (NotifStyle.Border*2))*remainingMult, hei + (NotifStyle.Border*2) )

        //surface.SetDrawColor( 0, 0, 0 )
        //surface.SetMaterial( NotifStyle.Background )
        //surface.DrawTexturedRectRotated( x + (wid/2), y + (hei/2), hei, wid, 90 )
        surface.SetDrawColor( 0, 0, 0, 250 )
        surface.DrawRect( x, y, wid, hei )

        draw.SimpleText( v[1], NotifStyle.Font, x + NotifStyle.PadW + NotifStyle.ShadowOffset, y + NotifStyle.PadH + NotifStyle.ShadowOffset, Color( 0, 0, 0, 255 ) )
        draw.SimpleText( v[1], NotifStyle.Font, x + NotifStyle.PadW, y + NotifStyle.PadH, color )

    end

end

local function NotifThink()
    if table.IsEmpty( Notifs ) then return end

    for k,v in pairs( Notifs ) do
        if v[2] < CurTime() then
            table.remove( Notifs, k )
        end
    end
end

function Msg( text, time, color, admin )
    if !text then text = "Something's gone wrong!" end
    if !time then time = 10 end
    if !color then color = nil end
    table.insert( Notifs, { text, CurTime()+time, time, color } )
    if admin then
        LogPrint( text, color, "Admin", Color(255,0,0) )
    else
        LogPrint( text, color )
    end
end

net.Receive("AdminNotification", function()
    local text = net.ReadString()
    local time = net.ReadInt(7)
    local color = net.ReadColor()
    local verbose = net.ReadInt(4)

    if verbose && LocalPlayer():GetInfoNum("gmt_admin_log", 1) < verbose then return end

    if color == Color(0,0,0,0) then
        color = nil
    end

    Msg(text, time, color, true)
end)

hook.Add( "HUDPaint", "AdminNotifs", NotifPaint )
hook.Add( "Think", "AdminNotifsThink", NotifThink )

concommand.Add( "notif_test", function()
    Msg( "This is a rainbow notification!", 5 )
    Msg( "This one is gonna last a while.", 15, Color(255,255,255) )
    Msg( "Hey, this one's pink.", 10, Color(255,0,255) )
    Msg( "This is an admin message.", 10, Color(255,0,255), true )
end )

net.Receive("ConsolePrint", function()
    local text = net.ReadString()
    local color = net.ReadColor()

    LogPrint(text, color)
end)