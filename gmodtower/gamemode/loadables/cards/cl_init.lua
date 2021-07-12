
-----------------------------------------------------
include( "cl_dcardlist.lua" )

include( "cl_dmodel_card.lua" )

include( "cl_dnumsliderbet.lua" )

include( "cl_panel_help.lua" )

include( "shared.lua" )

include( "sh_player.lua" )



module( "Cards", package.seeall )

local chipsMat = Material( "gmod_tower/icons/chip.png" )

hook.Add( "HUDPaint", "DrawChips", function()


	if !GTowerHUD.Enabled:GetBool() then return end
	if (LocalPlayer().GLocation != 25) then return end

	local chips = LocalPlayer():PokerChips()

	if not chips then return end



	if GTowerHUD.Style:GetInt() == 2 then
		chips = "CHIPS: " .. string.FormatNumber( chips )

		local off = 10

		surface.SetMaterial( chipsMat )
		surface.SetDrawColor( 50, 50, 50 )
		surface.DrawTexturedRect( 100, ScrH() - 115 + off, 32, 32 )
		surface.SetDrawColor( 100, 100, 100 )
		surface.DrawTexturedRect( 80, ScrH() - 120 + off, 32, 32 )
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawTexturedRect( 90, ScrH() - 125 + off, 32, 32 )

		draw.SimpleShadowText( chips, "GTowerHUDMain", 125, ScrH() - 113 + off, Color( 255, 255, 255, 255 ), color_black, TEXT_ALIGN_LEFT )
	else
		GTowerHUD.DrawExtraInfo( GTowerIcons2.GetIcon("chips"), " " .. tostring(chips), 16 )
	end



end )