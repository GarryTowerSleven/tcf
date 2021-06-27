GTowerItems.ToolTip = nil
GTowerItems.ToolTipPanel = nil

local ShouldDraw = false

function GTowerItems:ShowTooltip( title, description, panel )
	
	if !GTowerItems.ToolTip then
		GTowerItems.ToolTip = vgui.Create("InvToolTip")
	else
		GTowerItems.ToolTip:SetHidding( false )
	end
	
	GTowerItems.ToolTipPanel = panel
	
	GTowerItems.ToolTip:SetText( title, description )

end

function GTowerItems:HideTooltip()
	
	if GTowerItems.ToolTip then
		GTowerItems.ToolTip:SetHidding( true )
	end

end

function GTowerItems:RemoveTooltip()
	
	if GTowerItems.ToolTip then
		GTowerItems.ToolTip:Remove()
	end
	
	GTowerItems.ToolTip = nil

end

hook.Add("GtowerHideMenus", "HideInvToolTip", function()
	ShouldDraw = false
	GTowerItems:HideTooltip()
end )


hook.Add("GtowerShowMenus", "HideInvToolTip", function()
	ShouldDraw = true
end )

hook.Add("Think", "HideInvToolTip", function()
	if !ShouldDraw then
		GTowerItems:HideTooltip()
	end
end)