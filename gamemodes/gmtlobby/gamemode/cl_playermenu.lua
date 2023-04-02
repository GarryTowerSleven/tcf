module( "PlayerMenu", package.seeall )

RADIAL = nil
PlayerMenuEnabled = CreateClientConVar( "gmt_playermenu", 1, true, false )

Commands = {
	{
		"Add To Group",
		function( ply )
			RunConsoleCommand( "gmt_groupinvite", ply:EntIndex() )
		end,
		function( ply )
			return !GTowerGroup:IsInGroup( ply ) && !GTowerGroup:IsInGroup( LocalPlayer() )
		end
	},
	{
		"Trade",
		function( ply )
			RunConsoleCommand( "gmt_trade", ply:EntIndex() )
		end,
		function( ply )
			return true
		end
	},
	// TODO
	/*{
		"Mute",
		function( ply )
			RunConsoleCommand( "gmt_mute", ply:EntIndex(), 1 )
		end,
		function( ply )
			return !LocalPlayer():HasMuted( ply )
		end
	},
	{
		"Unmute",
		function( ply )
			RunConsoleCommand( "gmt_mute", ply:EntIndex(), 0 )
		end,
		function( ply )
			return LocalPlayer():HasMuted( ply )
		end
	},*/
	{
		"Friend",
		function( ply )
			Friends.SetFriend( ply, Friends.REL_FRIEND )
		end,
		function( ply )
			return not Friends.IsFriend( LocalPlayer(), ply )
		end
	},
	{
		"Unfriend",
		function( ply )
			Friends.SetFriend( ply, 0 )
		end,
		function( ply )
			return Friends.IsFriend( LocalPlayer(), ply )
		end
	},
	{
		"Block",
		function( ply )
			Friends.SetFriend( ply, Friends.REL_BLOCKED )
		end,
		function( ply )
			return not Friends.IsBlocked( LocalPlayer(), ply )
		end
	},
	{
		"Unblock",
		function( ply )
			Friends.SetFriend( ply, 0 )
		end,
		function( ply )
			return Friends.IsBlocked( LocalPlayer(), ply )
		end
	},
	{
		"Slay",
		function( ply )
			RunConsoleCommand( "gmt_act", "slay", ply:EntIndex() )
		end,
		function( ply )
			return LocalPlayer():IsAdmin() or LocalPlayer():IsModerator()
		end,
		Color( 121, 121, 0, 200 )
	},
	{
		"Cancel",
		nil,
		function( ply )
			return true
		end,
		Color( 121, 0, 0, 200 )
	},
}

function Show( ply )

	Hide()
	GTowerMainGui:ToggleCursor( true )

	RADIAL = vgui.Create( "DRadialMenu" )
	RADIAL:SetSize( ScrH(), ScrH() )
	-- RADIAL:SetPaintDebug( true )
	-- RADIAL:SetRadiusPadding( 50 )
	RADIAL:SetRadiusScale( 0.35 )
	-- RADIAL:SetDegreeOffset( 90 )
	-- RADIAL:SetAlignMode( RADIAL_ALIGN_CENTER )
	RADIAL:Center()
	-- RADIAL:MakePopup()
	/*RADIAL.Paint = function( self, w, h )
		local x, y = self:LocalCursorPos()
		surface.SetDrawColor( Color( 16, 77, 121, 200 ) )
		for i=0, 4 do
			surface.DrawLine( w/2, h/2, x + i, y + i )
		end
	end*/

	-- Add items
	for id, info in ipairs( Commands ) do

		local name = info[1] //string2.Uppercase( info[1] )
		local func = info[2]
		local available = info[3]
		local color = info[4] or Color( 16, 77, 121, 200 )

		if !available || !available( ply ) then continue end

		local p = vgui.Create( "DButton" )
		p:SetSize( 150, 30 )
		p:SetFont( "GTowerHUDMain" )
		p:SetColor( Color( 255, 255, 255 ) )
		p:SetText( name )
		p.DoClick = function( self )
			if func then
				func( ply )
			end
			Hide()
		end

		p.Paint = function( self, w, h )
			draw.RoundedBox( 8, 0, 0, w, h, color )

			if self.Hovered then
				draw.RoundedBox( 8, 0, 0, w, h, Color( color.r + 60, color.g + 60, color.b + 60, 255 ) )
			end
		end

		RADIAL:AddItem( p )
		-- RADIAL:AddItem( p, math.Rand(10,35) )
	end

	local p = vgui.Create( "DLabel" )
	p:SetSize( 100, 30 )
	p:SetText( string.upper( ply:Name() ) )
	p:SetColor( Color( 255, 255, 255 ) )
	p:SetFont( "GTowerHUDMainLarge" )
	p:SetContentAlignment(5)
	p:SizeToContents()
	p:SetWide( p:GetWide() + 10 )
	p.Paint = function( self, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 16 - 30, 77 - 30, 121 - 30, 225 ) )
	end

	RADIAL:SetCenterPanel( p )

end

function Hide()

	if ValidPanel( RADIAL ) then
		RADIAL:Remove()
		GTowerMainGui:ToggleCursor( false )
		gui.EnableScreenClicker( false )
	end

end

function IsVisible()
	return ValidPanel( RADIAL )
end