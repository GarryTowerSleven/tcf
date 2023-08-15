module( "GTowerMainGui", package.seeall )

local function CanClose()

	local tbl = hook.GetTable().CanCloseMenu
	
	if tbl == nil then return true end

	//For not closing when the trade is open
	for _, v in pairs( tbl ) do
		if v() == false then
			return false
		end
	end

	return true

end

function HideMenus()

	if ContextMenuEnabled then return end
	//if hook.Call( "DisableMenu", GAMEMODE ) == true then return end

	if CanClose() == false then return end

	RememberCursorPosition()
	gui.EnableScreenClicker( false )
	MenuEnabled = false

	if GTowerItems and GTowerItems.HideTooltip then GTowerItems:HideTooltip() end
	
	hook.Call( "GTowerHideMenus", GAMEMODE )
end

function HideContextMenus()

	if MenuEnabled then return end

	//if hook.Call( "DisableMenu", GAMEMODE ) == true then return end

	RememberCursorPosition()
	gui.EnableScreenClicker( false )
	ContextMenuEnabled = false

	if GTowerItems and GTowerItems.HideTooltip then GTowerItems:HideTooltip() end
	
	hook.Call( "GTowerHideContextMenus", GAMEMODE )

end
concommand.Add("-menu", HideMenus) 
concommand.Add("-menu_context", HideContextMenus)


function ShowMenus()

	if ContextMenuEnabled then return end
	if not LocalPlayer():Alive() then return end

	if hook.Call( "DisableMenu", GAMEMODE ) == true then return end
	if hook.Call( "CanOpenMenu", GAMEMODE ) == false || ( Dueling && Dueling.IsDueling( LocalPlayer() ) ) then return end
	
	hook.Call("GTowerShowMenusPre", GAMEMODE )

	MenuEnabled = true
	gui.EnableScreenClicker( true )
	RestoreCursorPosition()
	
	hook.Call( "GTowerShowMenus", GAMEMODE )

end

function ShowContextMenus()

	if MenuEnabled then return end

	if hook.Call( "DisableMenu", GAMEMODE ) == true then return end
	if hook.Call( "CanOpenMenu", GAMEMODE ) == false || ( Dueling && Dueling.IsDueling( LocalPlayer() ) ) then return end
	
	hook.Call( "GTowerShowContextMenusPre", GAMEMODE )

	ContextMenuEnabled = true
	gui.EnableScreenClicker( true )
	RestoreCursorPosition()
	
	hook.Call( "GTowerShowContextMenus", GAMEMODE )

end
concommand.Add( "+menu", ShowMenus )
concommand.Add( "+menu_context", ShowContextMenus )


function ToggleCursor( bool )

	if bool then

		if !gui.ScreenClickerEnabled() then
			gui.EnableScreenClicker( true )
			RestoreCursorPosition()
			ClickerForced = true
		end

	else

		if ClickerForced then
			RememberCursorPosition()
			gui.EnableScreenClicker( false )
			ClickerForced = false
		end

	end

end

hook.Add( "ScoreboardHide", "KeepMouseAvaliable", function()

	RememberCursorPosition()

	timer.Simple( 0.0, function()
		if CanClose() == false then
			gui.EnableScreenClicker( true )
			RestoreCursorPosition()
		end
	end )

end )

hook.Add( "Think", "AutoHideMenu", function()

	if ( (MenuEnabled or ContextMenuEnabled) and hook.Call( "DisableMenu", GAMEMODE ) ) then
		HideContextMenus()
		HideMenus()
	end

	if not LocalPlayer():Alive() then
		GTowerMainGui:HideMenus()
	end

end )