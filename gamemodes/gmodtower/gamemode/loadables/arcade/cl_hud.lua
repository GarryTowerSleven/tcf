local DEBUG = CreateClientConVar( "gmt_arcade_debug", 0, true )
local ticketsMat = Material( "gmod_tower/icons/ticket.png" )
hook.Add( "GTowerHUDPaint", "DrawTickets", function()

	if !Location.IsArcade( LocalPlayer():Location() ) and !DEBUG:GetBool() then return end
	local tickets = LocalPlayer():GetTickets()
	if not tickets then return end

	tickets = string.FormatNumber( tickets )

	surface.SetFont( "GTowerHUDMain" )
	local tw, th = surface.GetTextSize( tickets )
	local x = GTowerHUD.Info.X + 125
	local y = GTowerHUD.Info.Y + 40

	surface.SetMaterial( ticketsMat )
	surface.SetDrawColor( 255, 255, 255 )
	surface.DrawTexturedRect( x, y, 24, 24 )

	draw.SimpleShadowText( tickets, "GTowerHUDMain", x + 24 + 6, y + 10, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
	draw.SimpleShadowText( "TICKET" .. ( ( tickets != "1" or tickets != "-1" ) and "S" or "" ), "GTowerHUDMainSmall", x + 24 + 4 + tw + 4, y + 12, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

end )
