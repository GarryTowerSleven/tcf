module( "SideMenu", package.seeall )

Gui = nil

local gradient = surface.GetTextureID( "VGUI/gradient_down" )

local function FinalUpdatePanelPos( delta )
	Gui:SetPos( Gui:GetWide() * (-1 + delta), ScrH() * 0.35 - Gui:GetTall() * 0.5 )
end

local function UpdatePanelPos( panel, anim, delta )
	FinalUpdatePanelPos( delta )
end

function RunAnim()
	if ValidPanel( Gui ) then 
		Gui.Anim:Run()
	end
end

function Open()
	
	// Gather items
	local HookTbl = hook.GetTable().OpenSideMenu
	local PanelList = {}
	
	if HookTbl then
		for _, v in pairs( HookTbl ) do
			
			local b, err = SafeCall ( v )
			
			if b && type( err ) == "Panel" then
				table.insert( PanelList, err )
			end
		
		end		
	
	end
	
	if #PanelList == 0 then
		return
	end
	
	Close()


	Gui = vgui.Create("DPanel")
	Gui:SetWide( 160 )

	Gui.List = vgui.Create("DPanelList", Gui )
	Gui.List:SetAutoSize( true )
	Gui.List:SetDrawBackground( false )
	Gui.List:SetWide( Gui:GetWide() - 10 )
	Gui.List:SetPos( 5, 5 )
	
	for _, v in ipairs( PanelList ) do
		Gui.List:AddItem( v )		
	end
	
	Gui.List:SortByMember( "SortOrder" )
	Gui.List:InvalidateLayout( true )
	Gui:SetTall( Gui.List:GetTall() + 110 )


	// Handle placement of items
	/*Gui = vgui.Create( "SidebarCategory" )
	Gui:SetLabel( "Sidemenu" )
	Gui:SetPos( 0, 10 )
	
	Gui.List = vgui.Create( "SidebarList", Gui )
	Gui.List:SetAutoSize( true )
	Gui.List:EnableHorizontal( true )
	Gui.List:EnableVerticalScrollbar( true )
	Gui.List:SetSpacing( 2 )
	Gui.List:SetPadding( 2 )
	Gui.List:EnableVerticalScrollbar()
	
	Gui:SetContents( Gui.List )

	for _, v in ipairs( PanelList ) do
		Gui.List:AddItem( v )		
	end

	Gui:InvalidateLayout( true )
	Gui:SizeToContents()
	Gui:SetWide( 160 )*/
	
	Gui.Anim = Derma_Anim( "GTowerSideMenuAnim", Gui, UpdatePanelPos )
	Gui.Think = RunAnim
	Gui.Anim:Start( 0.5 )

	Gui.Paint = function( self, w, h )

		//surface.SetDrawColor( 15, 78, 132, 0 )
		//surface.DrawRect( 0,0, Gui:GetSize() )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 15, 78, 132, 10 ) )

		surface.SetDrawColor( 15, 78, 132, 100 )
		surface.SetTexture( gradient )
		surface.DrawTexturedRect( 0, 0, w, h )

	end
	
end

function Close()

	if ValidPanel( Gui ) then
		hook.Call("CloseSideMenu", GAMEMODE )
		Gui:Remove()
		Gui = nil
	end

end


hook.Add("GTowerShowMenusPre", "GTowerSideMenu", Open )
hook.Add("GTowerHideMenus", "GTowerSideMenu", Close )

hook.Add( "Location", "GTowerSideMenuAutoClose", function( ply )

	if ply != LocalPlayer() then return end
	SideMenu.Close()

end )



local SIDEBARCATEGORY = {}

function SIDEBARCATEGORY:Init()

	self:SetLabel( "Unknown" )
	self:SetLabelFont( Scoreboard.Customization.CollapsablesFont, false )
	self:SetTabCurve( 0 )

	self:SetColors( 
		Scoreboard.Customization.ColorDark, 
		Scoreboard.Customization.ColorBackground, 
		Scoreboard.Customization.ColorBright, 
		Scoreboard.Customization.ColorBright
	)

	self:SetPadding( 2 )
	//self:EnableVerticalScrollbar( false )

end

vgui.Register( "SidebarCategory", SIDEBARCATEGORY, "DCollapsibleCategory2" )




local SIDEBARLIST = {}

function SIDEBARLIST:Paint( w, h )

	surface.SetDrawColor( Scoreboard.Customization.ColorNormal )
	surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )

end

vgui.Register( "SidebarList", SIDEBARLIST, "DPanelList2" )