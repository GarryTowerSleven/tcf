
/*   _
    ( )
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)

	DPanelList

	A window.

*/
local PANEL = {}

AccessorFunc( PANEL, "m_bSizeToContents", 		"AutoSize" )
AccessorFunc( PANEL, "m_bStretchHorizontally", 		"StretchHorizontally" )
AccessorFunc( PANEL, "m_bBackground", 			"DrawBackground" )
AccessorFunc( PANEL, "m_bBottomUp", 			"BottomUp" )
AccessorFunc( PANEL, "m_bNoSizing", 			"NoSizing" )

AccessorFunc( PANEL, "Spacing", 	"Spacing" )
AccessorFunc( PANEL, "Padding", 	"Padding" )

/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.pnlCanvas 	= vgui.Create( "Panel", self )
	self.pnlCanvas.OnMousePressed = function( self, code ) self:GetParent():OnMousePressed( code ) end
	self.pnlCanvas:SetMouseInputEnabled( true )
	self.pnlCanvas.InvalidateLayout = function() self:InvalidateLayout() end

	self.Items = {}
	self.YOffset = 0

	self:SetSpacing( 0 )
	self:SetPadding( 0 )
	self:EnableHorizontal( false )
	self:SetAutoSize( false )
	self:SetDrawBackground( true )
	self:SetBottomUp( false )
	self:SetNoSizing( false )

	--self:EnableVerticalScrollbar(true)

	self:SetMouseInputEnabled( true )

	// This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

end

/*---------------------------------------------------------
   Name: SizeToContents
---------------------------------------------------------*/
function PANEL:SizeToContents()

	self:SetSize( self.pnlCanvas:GetSize() )

end

/*---------------------------------------------------------
   Name: GetItems
---------------------------------------------------------*/
function PANEL:GetItems()

	// Should we return a copy of this to stop
	// people messing with it?
	return self.Items

end

/*---------------------------------------------------------
   Name: EnableHorizontal
---------------------------------------------------------*/
function PANEL:EnableHorizontal( bHoriz )

	self.Horizontal = bHoriz

end

/*---------------------------------------------------------
   Name: EnableVerticalScrollbar
---------------------------------------------------------*/
function PANEL:EnableVerticalScrollbar()

	if (self.VBar) then return end

	self.VBar = vgui.Create( "DVScrollBar", self )

end

/*---------------------------------------------------------
   Name: GetCanvas
---------------------------------------------------------*/
function PANEL:GetCanvas()

	return self.pnlCanvas

end

/*---------------------------------------------------------
   Name: GetCanvas
---------------------------------------------------------*/
function PANEL:Clear( bDelete )

	for k, panel in pairs( self.Items ) do

		if ( panel && panel:IsValid() ) then

			panel:SetParent( panel )
			panel:SetVisible( false )

			if ( bDelete ) then
				panel:Remove()
			end

		end

	end

	self.Items = {}

end

/*---------------------------------------------------------
   Name: AddItem
---------------------------------------------------------*/
function PANEL:AddItem( item )

	if (!item || !item:IsValid()) then return end

	item:SetVisible( true )
	item:SetParent( self:GetCanvas() )
	table.insert( self.Items, item )

	self:InvalidateLayout()

end

/*---------------------------------------------------------
   Name: RemoveItem
---------------------------------------------------------*/
function PANEL:RemoveItem( item, bDontDelete )

	for k, panel in pairs( self.Items ) do

		if ( panel == item ) then

			self.Items[ k ] = nil

			if (!bDontDelete) then
				panel:Remove()
			end

			self:InvalidateLayout()

		end

	end

end

/*---------------------------------------------------------
   Name: Rebuild
---------------------------------------------------------*/

surface.CreateFont( "VoteText2", { font = "TodaySHOP-BoldItalic", size = 22, weight = 200, shadow = true, antialias = true,} )

function PANEL:Rebuild()

	local Offset = 0

	for k, panel in pairs( self.Items ) do

		if ( panel:IsVisible() ) then

			local sideOffset = 0
			if k%2==0 then sideOffset = 1 end

			panel:SetSize( 300,75 )
			panel:SetPos( -200,-100 )
			if panel.btnMap then
				panel.btnMap:SetFont("VoteText2")
				panel.btnMap:SetTextInset( 8, 50 )

			end

			panel:MoveTo(self.Padding + 254 + ((254)*sideOffset), self.Padding + Offset,1,0,0.5 * (k/10))

			// Changing the width might ultimately change the height
			// So give the panel a chance to change its height now,
			// so when we call GetTall below the height will be correct.
			// True means layout now.
			--panel:InvalidateLayout( true )

			if k%2==0 then Offset = Offset + panel:GetTall() + self.Spacing end


		end

	end

	Offset = Offset + self.Padding

	self:GetCanvas():SetTall( Offset + (self.Padding) - self.Spacing )

	// This is a quick hack, ideally this setting will position the panels from the bottom upwards
	// This back just aligns the panel to the bottom
	if ( self.m_bBottomUp ) then
		self:GetCanvas():AlignBottom( self.Spacing )
	end

	// Although this behaviour isn't exactly implied, center vertically too
	if ( self.m_bNoSizing && self:GetCanvas():GetTall() < self:GetTall() ) then

		self:GetCanvas():SetPos( 0, (self:GetTall()-self:GetCanvas():GetTall()) * 0.5 )

	end

end

/*---------------------------------------------------------
   Name: OnMouseWheeled
---------------------------------------------------------*/
function PANEL:OnMouseWheeled( dlta )

	if ( self.VBar ) then
		return self.VBar:OnMouseWheeled( dlta )
	end

end

/*---------------------------------------------------------
   Name: Paint
---------------------------------------------------------*/

local grad = Material( "gmod_tower/hud/bg_gradient_deluxe.png", "unlightsmooth" )

function PANEL:Paint()

	surface.SetDrawColor( Color( 155, 155, 155, 200 ) )

	for k,v in pairs(self.Items) do

		local x, y = v:GetPos()
		local w, h = v:GetWide(), v:GetTall()

		if v.Map then
			surface.SetDrawColor( Color( 155, 155, 155, 255 ) )
			local mat = MapsGetPreviewIcon(v.Map)
			if mat then
				mat = Material(mat)
				surface.SetMaterial(mat)

				surface.SetDrawColor( Color(255, 255, 255, 255) )

				--render.SetScissorRect(x, y, x+w-50, y+235, true)
				render.SetScissorRect(x, y+160, x+w-50, y+235, true)
					surface.DrawTexturedRect( x - (400/4), y - (200/4), 400, 200 )
				render.SetScissorRect(0, 0, 0, 0, false)

				surface.SetDrawColor( Color( 155, 155, 155, 200 ) )

				surface.SetMaterial(grad)
				surface.DrawTexturedRect(x, y, 250, 75)

				if v.Votes then
					surface.SetTextPos( x+4,y+4 )
					surface.SetTextColor(255,255,255,255)
					surface.SetFont("VoteText2")
					surface.DrawText(v.Votes or "")
				end

				draw.OutlinedBox( x, y, 250, 75, 4, Color( 25, 25, 25, 200 ) )
			end
		end
	end

	derma.SkinHook( "Paint", "PanelList", self )
	return true

end

/*---------------------------------------------------------
   Name: OnVScroll
---------------------------------------------------------*/
function PANEL:OnVScroll( iOffset )

	self.pnlCanvas:SetPos( 0, iOffset )

end

/*---------------------------------------------------------
   Name: PerformLayout
---------------------------------------------------------*/
function PANEL:PerformLayout()

	local Wide = self:GetWide()
	local YPos = 0

	if ( !self.Rebuild ) then
		debug.Trace()
	end

	self:Rebuild()

	if ( self.VBar && !m_bSizeToContents ) then

		self.VBar:SetPos( self:GetWide() - 16, 0 )
		self.VBar:SetSize( 16, self:GetTall() )
		self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() )
		YPos = self.VBar:GetOffset()

		if ( self.VBar.Enabled ) then Wide = Wide - 16 end

	end

	self.pnlCanvas:SetPos( 0, YPos )
	self.pnlCanvas:SetWide( Wide )

	self:Rebuild()

	if ( self:GetAutoSize() ) then

		self:SetTall( self.pnlCanvas:GetTall() )
		self.pnlCanvas:SetPos( 0, 0 )

	end

end

/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:OnMousePressed( mcode )

	// Loop back if no VBar
	if ( !self.VBar && self:GetParent().OnMousePressed ) then
		return self:GetParent():OnMousePressed( mcode )
	end

	if ( mcode == MOUSE_RIGHT && self.VBar ) then
		self.VBar:Grip()
	end

end

/*---------------------------------------------------------
   Name: SortByMember
---------------------------------------------------------*/
function PANEL:SortByMember( key, desc )

	desc = desc or true

	table.sort( self.Items, function( a, b )

								if ( desc ) then

									local ta = a
									local tb = b

									a = tb
									b = ta

								end

								if ( a[ key ] == nil ) then return false end
								if ( b[ key ] == nil ) then return true end

								return a[ key ] > b[ key ]

							end )

end

function PANEL:Shuffle()

	table.shuffle( self.Items )
	self:Rebuild()

end

derma.DefineControl( "DMapList", "A Panel that neatly organises other panels", PANEL, "Panel" )
