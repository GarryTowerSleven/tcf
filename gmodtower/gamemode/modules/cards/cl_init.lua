
-----------------------------------------------------
include( "cl_dcardlist.lua" )
include( "cl_dmodel_card.lua" )
include( "cl_dnumsliderbet.lua" )
include( "cl_panel_help.lua" )
include( "shared.lua" )
include( "sh_player.lua" )

module( "Cards", package.seeall )

hook.Add( "HUDPaint", "DrawChips", function()


	if !GTowerHUD.Enabled:GetBool() then return end
	if (LocalPlayer().GLocation != 25) then return end

	local chips = LocalPlayer():PokerChips()

	if not chips then return end



	GTowerHUD.DrawExtraInfo( GTowerIcoons.GetIcoon("chips"), " " .. tostring(chips), 16 )



end )