
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
	if !Location.IsCasino( LocalPlayer():Location() ) then return end

	local chips = LocalPlayer():PokerChips()

	if not chips then return end


	GTowerHUD.DrawExtraInfo( GTowerIcons2.GetIcon("chips"), " " .. tostring(chips), 16 )

end )