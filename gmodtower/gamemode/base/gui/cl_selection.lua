module( "SelectionMenuManager", package.seeall )

-- Example Menu Structure
--[[ menu = {
		-- Item
		{
			title = "Check in", 
			icon = "house", -- Optional, default nil, uses panelos.Icons
			func = function() end, 
			toggle = false, -- Optional, default true. Toggles between large and small on click
			desc = "Check into your condo", -- Optional, default nil
			cost = 500, -- Optional, default nil
			large = true -- Optional, default false
		}
	}
]]

local ModelSize = 775
local CameraZPos = 30
local ModelPanelSize = 700

------------------------
-- Selection functions
------------------------

function Create( logo, menu, desc )

	StoreModel = "models/barney_animations.mdl"

	Remove()

	GUI = vgui.Create("SelectionMenu")
	GUI:SetLogo( logo )
	if desc then
		GUI:SetDescription( desc )
	end

	GUI:SetMenu( menu )
	
	RestoreCursorPosition()

end

function SetMenu( menu, back )

	if IsValid( GUI ) then 
		GUI:SetMenu( menu, back )
	end

end

function Remove()

	if GUI and IsValid( GUI ) then
		RememberCursorPosition()
		GUI:Remove()
		GUI = nil
		menu = {}
	end

end

function CreateConfirmation( text, onaccept, ondeny )

	if GUIConfirmation and IsValid( GUIConfirmation ) then
		GUIConfirmation:Remove()
		GUIConfirmation = nil
	end

	GUIConfirmation = vgui.Create("SelectionMenuConfirmation")
	GUIConfirmation:SetText( text )
	GUIConfirmation:SetFunctions( onaccept, ondeny )

end

concommand.Add( "storeopen", function( ply, cmd, args )

	StoreID = tonumber(args[1])
	local isDiscount = true
	local discount = tonumber(args[2])

	soundscape.StopChannel("music", 0.5, true)

	if !Location.IsGroup( ply:Location(), "nightclub" ) then

		if StoreID == GTowerStore.MERCHANT then
			soundscape.Play("music_store_merchant", "music", true)
		else
			soundscape.Play("music_store", "music", true)
		end

	end

	if !discount or discount == 0 then
		discount = 0
		isDiscount = false
	end

	for k, v in pairs( GTowerStore.Items ) do
		if v.storeid == StoreID then

			// Top Hat
			if v.Name == "Really Hat Top Hat" then continue end

			// Horseless Headless Horsemann
			if v.Name == "Horseless Headless Horsemann" then continue end

			local cost = math.Round((v.price or v.prices[1]) - ((v.price or v.prices[1]) * discount))

			local tbl = {
					title = v.Name,

					toggle = true,

					desc = v.description,

					mdl = v.model,
					cost = cost,
					ogPrice = v.price or v.prices[1],
					NewItem = v.IsNew,
					ItemLevels = v.prices,
					ItemLevel = v.level,
					ItemMaxLevel = v.maxlevel,
					hasDiscount = isDiscount,
					ModelSkin = v.ModelSkin or 1,
					PreviewURL = v.PreviewURL or "",

					func = function()
						local ItemID = v.Id
						// TODO: Make this look nicer and appear for high price items.
						/*CreateConfirmation(
							"Are you sure you want to buy '"..v.Name.."' for "..cost.." gmc?",
							function() GTowerStore:PromptToBuy( ItemID, 1 ) end,
							function() end
						)*/
						GTowerStore:PromptToBuy( ItemID, 1 )
					end
				}

			table.insert(menu,tbl)

		end
	end

	local desc = "UNKNOWN STORE"
	local logo = ""
	for k,v in pairs(GTowerStore.Stores) do
		if k == StoreID then
			desc = v.WindowTitle
			ModelSize = v.ModelSize or ModelSize
			CameraZPos = v.CameraZPos or CameraZPos
			if v.Logo then logo = v.Logo end
		end
	end

	table.sort( menu, function( a, b ) return a.cost < b.cost end )

	Create( logo, menu, desc )

end )

local ScrollBarWidth = 8
local LogoPath = "gmod_tower/ui/stores/"
local function CreateLogo( png, path )
	path = path or LogoPath
	return Material( path .. png .. ".png", "unlitsmooth" )
end

Logos = {
	-- Condos
	["towercondos"] = {
		mat = CreateLogo( "towercondos" ),
		width = 340,
		height = 227,
	},
	-- Entertainment
	["towercasino"] = {
		mat = CreateLogo( "towercasino" ),
		width = 340,
		height = 253,
	},
	-- Stores
	["sweetsuite"] = {
		mat = CreateLogo( "sweetsuite" ),
		width = 340,
		height = 81,
	},
	["songbirds"] = {
		mat = CreateLogo( "songbirds" ),
		width = 340,
		height = 229,
	},
	["basicalsgoods"] = {
		mat = CreateLogo( "basical" ),
		width = 340,
		height = 229,
	},
	["centralcircuit"] = {
		mat = CreateLogo( "centralcircuit" ),
		width = 340,
		height = 192,
	},
	["thetoystop"] = {
		mat = CreateLogo( "thetoystop2" ),
		width = 340,
		height = 112,
	},
	["toweroutfitters"] = {
		mat = CreateLogo( "toweroutfitters" ),
		width = 340,
		height = 62,
	},
	["pvpbattle"] = {
		mat = CreateLogo( "pvpbattle", "gmod_tower/ui/gamemodes/" ),
		width = 340,
		height = 247,
	},
	["ballrace"] = {
		mat = CreateLogo( "ballrace", "gmod_tower/ui/gamemodes/" ),
		width = 340,
		height = 192,
	}
}

------------------------
-- Main panel
------------------------

local PANEL = {}
PANEL.HeightPadding = 75
PANEL.WidthPadding = 20
PANEL.Width = 400
PANEL.Height = 720

function PANEL:Init()

	GIFUrl = "about:blank"

	-- Don't break for lower resolutions
	if self.Height > ScrH() then
		self.Height = ScrH()
	end

	self:MakePopup()
	self:SetSize( ScrW(), ScrH() )
	self:SetZPos( 0 )

	-- Side
	local x = (ScrW()/2) - self.Width - self.WidthPadding
	local y = (ScrH()/2)-(self.Height/2) --self.HeightPadding
	local w = self.Width + ScrollBarWidth + 4
	local h = self.Height -- - (self.HeightPadding * 2)

	self.Side = vgui.Create( "SelectionMenuSide", self )
	self.Side:SetPos( x, y )
	self.Side:SetSize( w, h - 32 )

	self.ModelPanel = vgui.Create("DModelPanel2", self.Side )
	self.ModelPanel:SetAnimated( true )

	self.ModelPanel:SetModel("")

	local NewSize = ModelSize

	if ScrW() < 1920 then
		// People still use these resolutions?
		local devideFactor = 2

		if ScrH() == 720 then devideFactor = 1.5 end
		if ScrH() == 768 then devideFactor = 1.5 end
		if ScrH() == 900 then devideFactor = 1.25 end
		if ScrH() == 992 then devideFactor = 1.15 end

		NewSize = ModelSize/devideFactor
	end

	self.ModelPanel:SetSize( NewSize, NewSize)
	//self.ModelPanel:SetPos( ScrW() / 3.75, ScrH() / 4 )
	self.ModelPanel:Center()
	self.ModelPanel:SetLookAt( Vector(0,0,CameraZPos) )
	self.ModelPanel:SetCamPos( Vector(100,0,CameraZPos) )

	function self.ModelPanel:LayoutEntity( ent )
		ent:SetAngles( ent:GetAngles() + Angle(0,FrameTime() * 25,0) )

		if string.StartWith(ent:GetModel(),"models/player") then
			ent:SetSequence( "idle_all_01" )
			self:RunAnimation()
		end

		if StoreModel then ent:SetModel(StoreModel) end
		ent:SetSkin(ModelSkin or 1)

	end

end

function PANEL:OnMouseWheeled( dlta )
	self.ItemList.ScrollBar:AddVelocity( dlta )
end

function PANEL:SetLogo( logo )
	self.Logo = Logos[logo]
	self.Side:SetBackgrounds( logo )
end

function PANEL:SetDescription( desc )

	self.Description = vgui.Create( "DLabel", self )
	self.Description:SetFont( "GTowerSelectionMenuTitle" )

	self.Description:SetText( desc )
	self.Description:SizeToContents()

end

function PANEL:SetMenu( menu, back )

	-- Item list
	local x = (ScrW()/2) + self.WidthPadding
	local y = (ScrH()/2)-(self.Height/2) --self.HeightPadding
	local w = self.Width + ScrollBarWidth + 4
	local h = self.Height -- - (self.HeightPadding * 2)

	-- Move down for logo
	if self.Logo then
		y = y + self.Logo.height + 16
		h = h - self.Logo.height - 16 - self.HeightPadding + 8
	end
	self.LogoX = x
	self.LogoY = y

	-- Move down for desc
	if self.Description then
		self.Description:SetPos( x + (((w-4)/2)-(self.Description:GetWide()/2)), y )
		y = y + self.Description:GetTall() + 8
		h = h - self.Description:GetTall() - 8
	end

	-- Setup item list
	if self.ItemList then self.ItemList:Remove() end
	self.ItemList = vgui.Create( "SelectionMenuItemList", self )
	self.ItemList:SetPos( x, y )
	self.ItemList:SetSize( w, h - 32 )

	-- Add items to item list
	for id, item in ipairs( menu ) do
		self.ItemList:AddItem( item )
	end

	if not back then self.LastMenu = menu end

	-- Close/Back button
	if not self.Close then

		self.Close = vgui.Create( "SelectionMenuItem", self )
		self.Close:SetPos( x, y+h )
		self.Close:SetLarge( false )
		self.Close.BackgroundColor = Color( 200, 20, 20 )
		self.Close:SetTextColor( Color( 200, 200, 200 ) )

	end

	-- Back button
	if back then
		self.Close:SetTitle( "Back" )
		self.Close:SetIcon( "back" )

		self.Close:SetFunction( function()
			self:SetMenu( self.LastMenu, false )
			surface.PlaySound( panelos.Sounds["back"] )
		end )

	-- Normal close button
	else
		self.Close:SetTitle( "Close" )
		self.Close:SetIcon( "cancel" )

		self.Close:SetFunction( function()
			soundscape.StopChannel("music", 0.5, true)

			if LocalPlayer():GetInfo("gmt_bgmusic_enable") == "1" then
				if !Location.IsGroup( LocalPlayer():Location(), "nightclub" ) then
					soundscape.Play("music_global_ambient", "music", true)
				end
			end

			Remove()
			surface.PlaySound( panelos.Sounds["back"] )
		end )
	end

end

local matBlurScreen = Material( "pp/blurscreen" )
function PANEL:Paint( w, h )

	-- Darken
	surface.SetDrawColor( 0, 0, 0, 225 )
	surface.DrawRect( 0, 0, w, h )

	-- Background
	surface.SetMaterial( panelos.Backgrounds[3] )
	surface.SetDrawColor( 255, 255, 255, 15 )
	for i=1, 4 do
		local scroll0 = (1 + math.cos(RealTime() / 2 + i)) * ScrW()
		local scroll1 = (1 + math.sin(RealTime() / 2 + i)) * ScrH()
		surface.DrawTexturedRect( -scroll0, -scroll1, ScrW() * 4, ScrH() * 4 )
	end

	-- Blur
	--[[surface.SetMaterial( matBlurScreen )   
	surface.SetDrawColor( 255, 255, 255, 150 )

	local blurAmount = 1 / math.Clamp( 16, 1, 10)
	local x, y = self:LocalToScreen( 0, 0 )

	for i = blurAmount, 1, blurAmount do

		matBlurScreen:SetFloat( "$blur", 5 * i )
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, w, h )

	end]]

	-- Draw logo
	if self.Logo then
		surface.SetMaterial( self.Logo.mat )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( self.LogoX, self.LogoY-self.Logo.height-4, self.Logo.width, self.Logo.height )
	end

end

derma.DefineControl( "SelectionMenu", "", PANEL, "DPanel" )


------------------------
-- Selection Item List
------------------------
local PANEL = {}
PANEL.ItemPadding = 8

function PANEL:Init()

	self.Container = vgui.Create( "DPanel", self )

	self.Container:SetDrawBackground(false)
	self.ScrollBar = vgui.Create( "SlideBar2", self )
	self.ScrollBar:SetZPos( 0 )

	self.Items = {}

	self:SetMouseInputEnabled( true )
	self.Container:SetMouseInputEnabled( true )

end

function PANEL:AddItem( item )

	-- Create the panel and process the data of the menu
	local panel = vgui.Create( "SelectionMenuItem", self.Container )
	panel:ProgessData( item )

	table.insert( self.Items, panel )

end

function PANEL:GetTotalHeight()

	local height = 0

	for id, panel in pairs(self.Items) do
		height = height + panel:GetTall()

		-- Padding
		if id < #self.Items then
			height = height + self.ItemPadding
		end
	end

	return height

end

function PANEL:SetScroll( scroll )

	if scroll < 0 then scroll = 0 end
	if self:GetTotalHeight() < self:GetTall() then scroll = 0 end

	self.Container:SetPos( 0, -scroll )

end


function PANEL:Think()

	if self.ScrollBar:Changed() then
		self:SetScroll( self.ScrollBar:Value() * ( self:GetTotalHeight() - self:GetTall() ) )
	end

end

function PANEL:PerformLayout()

	local w, h = self:GetWide(), self:GetTall()

	--------------
	-- Items
	--------------

	local totalh = 3
	for id, panel in pairs( self.Items ) do

		panel:SetPos( 0, totalh )
		totalh = totalh + panel:GetTall()

		-- Padding
		if id < #self.Items then
			totalh = totalh + self.ItemPadding
		else
			totalh = totalh + 3
		end

	end

	--------------
	-- Container
	--------------

	-- Set the container size
	self.Container:SetSize( w, h )

	-- Set the container to that size
	if totalh > h then
		self.Container:SetTall( totalh )
	end

	--------------
	-- Scroll Bar
	--------------

	-- Set the scroll bar position to the right
	self.ScrollBar:SetPos( w - ScrollBarWidth, 0 )
	self.ScrollBar:SetSize( ScrollBarWidth, h )

	-- Setup the scroll bar scaling
	self.ScrollBar:SetBarScale( (totalh / h) )

	-- Set the scroll position of the container to match the scroll bar
	self:SetScroll( self.ScrollBar:Value() * ( totalh - h ) )

end

function PANEL:Paint( w, h )

	-- Debug
	--surface.SetDrawColor( 255,0,0, 150 )
	--surface.DrawRect( 0, 0, w, h )

	if self.ScrollBar:Value() > 0 and self:GetTotalHeight() > self:GetTall() then

		surface.SetDrawColor( 255, 255, 255, 150 )
		surface.DrawRect( 0, 0, w-ScrollBarWidth-4, 2 )

		surface.SetDrawColor( 255, 255, 255, 150 )
		surface.DrawRect( 0, h-2, w-ScrollBarWidth-4, 2 )

	end

end

vgui.Register( "SelectionMenuItemList", PANEL, "DPanel" )


------------------------
-- Selection Item
------------------------
local font = "Clear Sans"
surface.CreateFont( "GTowerSelectionMenuTitle", { font = font, size = 22, weight = 1000, antialias = true } )
surface.CreateFont( "GTowerSelectionMenuTitleLarge", { font = font, size = 38, weight = 600, antialias = true } )
surface.CreateFont( "GTowerSelectionMenuDesc", { font = font, size = 14, weight = 600, antialias = true } )

local PANEL = {}
PANEL.Width = 350
PANEL.Height = 33
PANEL.Padding = 6
PANEL.LargeHeight = 84
PANEL.IconSize = 64
PANEL.IconSpacing = 55
PANEL.DescPadding = 10
PANEL.BackgroundColor = Color( 0, 0, 0 )
PANEL.NormalColor = Color( 240, 240, 240 )
PANEL.LargeColor = Color( 124, 77, 144 )

PANEL.PreviewPrefix = "https://gmodtower.org/game/previews/"

function PANEL:Init()

	self:SetPos( 0, 0 )
	self:SetSize( self.Width, self.Height )
	self:SetZPos( 0 )
	self:SetMouseInputEnabled( true )

	self.Title = vgui.Create( "DLabel", self )
	self.Title:SetText( "Item" )
	self.Title:SetFont( "GTowerSelectionMenuTitle" )
	self.Title:SetTextColor( Color( 50, 50, 50 ) )

end

function PANEL:ProgessData( data )

	-- Set title
	self:SetTitle( data.title )

	-- Set icon
	if data.icon then self:SetIcon( data.icon ) end

	-- Set cost
	if data.cost then self:SetCost( data.cost, data.hasDiscount, data.ogPrice ) end

	if data.NewItem then self:SetNew() end

	if data.ItemLevels then

		for k,v in pairs( data.ItemLevels ) do
			if k <= data.ItemMaxLevel then
				self.HasBought = true
			end
		end

	end

	-- Create description
	if data.desc then
		self:SetDescription( data.desc )
	end

	-- Create Preview URL
	if data.PreviewURL then
		self:SetPreviewURL( data.PreviewURL )
	end

	-- Create Preview Model
	if data.mdl then
		self:SetModel( data.mdl )
	end

	-- Skin
	if data.ModelSkin then
		self:SetModelSkin( data.ModelSkin )
	end

	self.Toggles = data.toggle or false
	if data.func then self:SetFunction( data.func ) end

	-- Set size
	self:SetLarge( data.large or false )

end

function PANEL:SetTextColor( color )
	self.Title:SetTextColor( color )
	self.TextColor = color

	--[[if self.Description then
		self.Description:SetTextColor( Color( color.r, color.g, color.b, 150 ) )
	end]]
end

function PANEL:SetTitle( title, padding )
	self.Title:SetText( string.upper( title or "Invalid Title" ) )
	self.Title:SizeToContents()
	self.Title:CenterVertical()
	self.Title.x = padding or self.Padding
end

function PANEL:SetPreviewURL( url )
	if url == "" then
		url = "about:blank"
		return
	end
	
	self.PreviewURL = self.PreviewPrefix .. url
end

function PANEL:SetModel( mdl )
	self.Model = mdl
end

function PANEL:SetModelSkin( skin )
	self.ModelSkin = skin
end

function PANEL:SetDescription( desc )

	if not self.Description then
		self.Description = vgui.Create( "DPanel", self )
		self.Description:SetWide( self:GetWide() )
	end

	self.Description.Paint = function( self, w, h )
		surface.SetDrawColor( 25, 26, 24, 50 )
		surface.DrawRect( 0, 0, w, h )

		if self.Markup then
			self.Markup:Draw( 6, 2 )
		end
	end

	-- Set width
	self.Description.Markup = markup.Parse( "<font=GTowerSelectionMenuDesc>"..desc.."</font>", self.Description:GetWide()-6 )

end

function PANEL:SetLarge( bool )

	if bool then

		self:SetTall( self.LargeHeight )
		self.BackgroundColor = self.LargeColor

		self:SetTextColor( Color( 255, 255, 255 ) )
		if not self.Toggles then self.Title:SetFont( "GTowerSelectionMenuTitleLarge" ) end

		self.Title:SizeToContents()
		if not self.Toggles then self.Title:CenterVertical() end

		self.IconSize = 64
		--self.Title.x = 12

		if self.Description then
			self.Description:SetVisible(true)
			self.Description:AlignTop(self.Height)
			self.Description:SetTall( self:GetTall() - self.Height )

			if !self.HasBought then
				self.Title.OldText = self.Title:GetText()
				self.Title:SetText("BUY")
			end
		end

	-- Normal
	else

		self:SetTall( self.Height )
		self.BackgroundColor = self.NormalColor

		self:SetTextColor( Color( 80, 80, 80 ) )
		self.Title:SetFont( "GTowerSelectionMenuTitle" )

		self.Title:SizeToContents()
		self.Title:CenterVertical()

		self.IconSize = 40
		--self.Title.x = 6

		if self.Description then
			self.Description:SetVisible(false)
		end

	end

	self.IsLarge = bool

end

function PANEL:SetIcon( icon, size )

	self.IconMaterial = GTowerIcons2.GetIcon(icon)
	self.Title.x = self.IconSpacing

	if size then self.IconSize = size end

end

function PANEL:SetFunction( func )
	self.Function = func
end

function PANEL:GetOtherItems()

	local container = self:GetParent()
	local itemlist = container:GetParent()

	itemlist:InvalidateLayout()

	return itemlist.Items

end

function PANEL:CanAfford()
	if not self.Cost then
		return true
	else
		return Afford( self.Cost )
	end
end

function PANEL:CanHover()
	if self.Toggles then
		return not self.IsLarge
	end
	return true
end

PANEL.MouseEntered = false
function PANEL:Think()

	if self:IsHovered() and self:CanHover() then
		if not self.MouseEntered then
			self.MouseEntered = true

			if self.PreviewURL then
				GIFUrl = self.PreviewURL
			end

			if self.Model then StoreModel = self.Model end
			ModelSkin = tonumber(self.ModelSkin)

			//surface.PlaySound( "GModTower/ui/hover.wav" )
			surface.PlaySound( "GModTower/casino/videopoker/click.wav" )
		end
	else
		self.MouseEntered = false
	end

	if self.AffordError and not self:CanAfford() then
		self.AffordError:SetVisible( self:IsHovered() )
	end

	if self.Bought && self.HasBought then
		self.Bought:SetVisible( true )
	end

end

function PANEL:OnMousePressed( mc )

	if mc == MOUSE_LEFT then

		if self.Toggles then
			if self:CanAfford() && !self.HasBought then
				if self.IsLarge then
					self.Function()
					self.IsLarge = false
				end
				surface.PlaySound("gmodtower/ui/panel_save.wav")
			else
				surface.PlaySound("gmodtower/ui/panel_error.wav")
			end
		elseif self.Function then
			if self:CanAfford() && !self.HasBought then
				self.Function()
				surface.PlaySound("gmodtower/ui/panel_save.wav")
			else
				surface.PlaySound("gmodtower/ui/panel_error.wav")
			end
		end

		if self.Toggles then
			for id, panel in pairs( self:GetOtherItems() ) do
				panel:SetLarge( false )
			end

			self:SetLarge( not self.IsLarge )
		end

	end

end

function PANEL:SetNew()
	self.NewItem = true
end

function PANEL:SetCost( cost, hasDiscount, ogPrice )

	if not self.CostContainer then

		-- Container
		self.CostContainer = vgui.Create( "DPanel", self )
		self.CostContainer:SetMouseInputEnabled( false )
		self.CostContainer.Paint = function( panel, w, h )
			draw.RoundedBox( 3, 0, 0, w, h, Color( 255, 150, 50 ) )

			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.SetMaterial( GTowerIcons2.GetIcon("money") )
			local iconsize = 24
			surface.DrawTexturedRect( 0, (h/2) - (iconsize/2), iconsize, iconsize )
		end

		-- Text
		self.CostText = vgui.Create( "DLabel", self.CostContainer )
		self.CostText:SetFont( "GTowerSelectionMenuDesc" )
		self.CostText:SetTextColor( Color( 255, 255, 255 ) )

		-- Afford error prompt
		self.AffordError = vgui.Create( "DPanel", self )
		self.AffordError:SetMouseInputEnabled( false )
		self.AffordError.Paint = function( panel, w, h )
			draw.RoundedBox( 3, 0, 0, w, h, Color( 255, 0, 0, 200 ) )
		end
		self.AffordError:SetZPos( 1 )
		self.AffordError:SetVisible( false )

		self.AffordErrorText = vgui.Create( "DLabel", self.AffordError )
		self.AffordErrorText:SetFont( "GTowerSelectionMenuDesc" )
		self.AffordErrorText:SetText( "CAN'T AFFORD" )
		self.AffordErrorText:SetTextColor( Color( 255, 255, 255 ) )
		self.AffordErrorText:SizeToContents()

		self.AffordError:SetWide(125)
		self.AffordErrorText:Center()
		self.AffordError:Center()

		-- Show bought
		self.Bought = vgui.Create( "DPanel", self )
		self.Bought:SetMouseInputEnabled( false )
		self.Bought.Paint = function( panel, w, h )
			draw.RoundedBox( 3, 0, 0, w, h, Color( 15, 200, 15, 200 ) )
		end

		self.Bought:SetZPos( 1 )
		self.Bought:SetVisible( false )

		self.BoughtText = vgui.Create( "DLabel", self.Bought )
		self.BoughtText:SetFont( "GTowerSelectionMenuDesc" )
		self.BoughtText:SetText( "PURCHASED" )
		self.BoughtText:SetTextColor( Color( 255, 255, 255 ) )
		self.BoughtText:SizeToContents()

		self.Bought:SetWide(125)
		self.BoughtText:Center()
		self.Bought:Center()

	end

	-- Set the cost so we can show if they can afford it
	self.Cost = cost

	-- Update the text
	if hasDiscount then
		self.CostText:SetText( string.FormatNumber(cost) )
	else
		self.CostText:SetText( string.FormatNumber(ogPrice) )
	end

	self.CostText:SizeToContents()

	if IsValid(self.DiscountText) then
		self.DiscountText:SetText( string.FormatNumber(ogPrice) )
		self.DiscountText:SizeToContents()
		self.DiscountText:AlignLeft(24)
		self.DiscountText:CenterVertical()
		self.DiscountText:AlignTop(0)
	end

	-- Size up container
	self.CostContainer:SizeToContents()
	self.CostContainer:SetTall( self:GetTall() )
	self.CostContainer:SetWide( self.CostText:GetWide() + 24 + 4 )

	-- Move to the right
	self.CostContainer:AlignRight()

	-- Move to the right
	self.CostText:AlignRight(4)
	self.CostText:CenterVertical()

	if hasDiscount then
		self.CostText:AlignBottom(0)
	end

end

local gradient = surface.GetTextureID("vgui/gradient_up")
local newIcon = Material("gmod_tower/icons/new_large.png")
function PANEL:Paint( w, h )

	-- Handle background color and cursor
	local color = self.BackgroundColor
	if self:IsHovered() and self:CanHover() then
		self:SetCursor( "hand" )
		color = colorutil.Brighten( color, .75 )
	else		
		self:SetCursor( "default" )
	end

	if not self:CanAfford() then
		color = Color( 150, 150, 150 )
	end

	-- Draw box
	if self.Title:GetText() == "BUY" then
		draw.RoundedBox( 3, 0, 0, w, h, color )
		draw.RoundedBox( 3, 0, 0, w, h/2.5, Color( 0, 204, 0 ) )
	else
		draw.RoundedBox( 3, 0, 0, w, h, color )
	end

	-- Gradient
	surface.SetDrawColor( 0, 0, 0, 75 )
	surface.SetTexture( gradient )
	surface.DrawTexturedRect( 0, 0, w, h )

	-- Icon
	if self.IconMaterial then
		surface.SetDrawColor( self.TextColor or Color( 255, 255, 255 ) )
		surface.SetMaterial( self.IconMaterial )
		surface.DrawTexturedRect( 28 - (self.IconSize/2), (h/2)-self.IconSize/2, self.IconSize, self.IconSize )
	end

	-- New Item
	if self.NewItem then
		local newText = "NEW!"

		surface.SetFont( "GTowerSelectionMenuTitle" )
		local size = surface.GetTextSize( newText )
		surface.SetTextPos(4,4)
		draw.RoundedBox( 3, 0, 0, size + 8, self.Height, Color( 255, 150, 50 ) )
		surface.SetTextColor( Color( 255, 255, 255, 255 ) )
		surface.DrawText( newText )

		self.Title:AlignLeft(size+8+4)
	end

end

derma.DefineControl( "SelectionMenuItem", "", PANEL, "DPanel" )

local PANEL = {}
PANEL.ButtonWidth = 200
PANEL.ButtonHeight = 32
PANEL.Padding = 8

function PANEL:Init()

	self:MakePopup()

	self:SetSize( ScrW(), ScrH() )
	self:SetZPos( 0 )

	self.Container = vgui.Create( "DPanel", self )
	self.Container.Paint = function( panel, w, h )
		draw.RoundedBox( 3, 0, 0, w, h, Color( 0, 0, 0, 150 ) )
	end

	self.Title = vgui.Create( "DLabel", self.Container )
	self.Title:SetFont( "GTowerSelectionMenuTitle" )
	self.Title:SetText( "CONFIRM ACTION" )
	self.Title:SetTextColor( Color( 255, 255, 255 ) )
	self.Title:SizeToContents()

	self.Text = vgui.Create( "DLabel", self.Container )
	self.Text:SetFont( "GTowerSelectionMenuDesc" )
	self.Text:SetText( "" )
	self.Text:SetTextColor( Color( 255, 255, 255 ) )
	self.Text:SetPos( self.Padding*2, (self.Padding*2) + self.Title:GetTall() )

	self.Yes = vgui.Create( "SelectionMenuItem", self.Container )
	self.Yes:CenterVertical()
	self.Yes:AlignBottom( self.Padding )
	self.Yes:SetLarge( false )
	self.Yes.BackgroundColor = Color( 20, 200, 20 )
	self.Yes:SetTextColor( Color( 255, 255, 255 ) )
	self.Yes:SetTitle( "Okay" )
	self.Yes:SetIcon( "accept" )
	self.Yes:SetSize( self.ButtonWidth, self.ButtonHeight )

	self.No = vgui.Create( "SelectionMenuItem", self.Container )
	self.No:CenterVertical()
	self.No:AlignBottom( self.Padding )
	self.No:SetLarge( false )
	self.No.BackgroundColor = Color( 200, 20, 20 )
	self.No:SetTextColor( Color( 255, 255, 255 ) )
	self.No:SetTitle( "Cancel" )
	self.No:SetIcon( "cancel" )
	self.No:SetSize( self.ButtonWidth, self.ButtonHeight )


	self.Yes.x = self.Padding
	self.No:MoveRightOf(self.Yes, self.Padding)

	self.Yes:MoveBelow(self.Text, self.Padding*4)
	self.No:MoveBelow(self.Text, self.Padding*4)

	self.Container:SetSize( self.ButtonWidth*2 + (self.Padding*3), self.Text:GetTall() + self.Title:GetTall() + self.ButtonHeight + (self.Padding*5) )

	self.Title:CenterHorizontal()
	self.Container:Center()

end

function PANEL:SetText( text )

	self.Text:SetText( text )
	self.Text:SizeToContents()
	self.Text:CenterHorizontal()

	self.Yes:MoveBelow(self.Text, self.Padding*4)
	self.No:MoveBelow(self.Text, self.Padding*4)

	self.Container:SetSize( self.ButtonWidth*2 + (self.Padding*3), self.Text:GetTall() + self.Title:GetTall() + self.ButtonHeight + (self.Padding*6) )
	self.Container:Center()

end

function PANEL:SetFunctions( onaccept, ondeny )

	self.Yes:SetFunction( function()
		if onaccept then onaccept() end

		RememberCursorPosition()
		self:Remove()
		surface.PlaySound( panelos.Sounds["accept"] )
	end )

	self.No:SetFunction( function()
		if ondeny then ondeny() end

		RememberCursorPosition()
		self:Remove()
		surface.PlaySound( panelos.Sounds["error"] )
	end )

end

local matBlurScreen = Material( "pp/blurscreen" )
function PANEL:Paint( w, h )

	-- Darken
	surface.SetDrawColor( 0, 0, 0, 250 )
	surface.DrawRect( 0, 0, w, h )

	-- Blur
	surface.SetMaterial( matBlurScreen )
	surface.SetDrawColor( 255, 255, 255, 255 )

	local blurAmount = 1 / math.Clamp( 16, 1, 10)
	local x, y = self:LocalToScreen( 0, 0 )

	for i = blurAmount, 1, blurAmount do

		matBlurScreen:SetFloat( "$blur", 5 * i )
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, w, h )

	end

end

derma.DefineControl( "SelectionMenuConfirmation", "", PANEL, "DPanel" )

------------------------
-- Side panel
------------------------
local BGPath = "gmod_tower/ui/images/"
local function CreateBG( png )
	return { mat = Material( BGPath .. png .. ".png", "unlitsmooth" ), alpha = 0, time = 0 }
end

local PANEL = {}
PANEL.Backgrounds = {
	["towercondos"] = {
		CreateBG("condo1"),
		CreateBG("condo2"),
		CreateBG("condo3")
	}	
}
PANEL.ActiveBG = nil
PANEL.ImageDuration = 4
PANEL.ImageWidth = 1280
PANEL.ImageHeight = 720

function PANEL:Paint( w, h )

	self:DrawBackgrounds( w, h )
	draw.RectBorder( 5, 5, w-10, h-10, 2, Color( 255, 255, 255 ) )

	if !self.GifViewer then
		self.GifViewer = vgui.Create( "HTML", self )
		self.GifViewer:SetPos( 0, 0 )
		self.GifViewer:SetSize( w, h )
		self.GifViewer.PaintOver = function()
			surface.SetDrawColor( 255, 0, 255, 255 )
			draw.RectBorder( 5, 5, self:GetWide()-10, self:GetTall()-10, 2, Color( 255, 255, 255 ) )
		end
	end

	if GIFUrl != self._url then
		self.GifViewer:OpenURL( GIFUrl )
		self._url = GIFUrl
	end

end

function PANEL:SetBackgrounds( logo )

	self.logo = logo
	self:SetNewBackground()

end

function PANEL:SetNewBackground( fade )
	local bgs = self.Backgrounds[self.logo]
	if bgs then
		self.ActiveBG = self:FindNewRandomBackground(bgs)
		if not fade then
			self.ActiveBG.alpha = 255
		end
		self.ActiveBG.time = RealTime() + self.ImageDuration
	end
end

function PANEL:FindNewRandomBackground(bgs)
	local rbgs = {}
	for id, bg in ipairs( bgs ) do
		if type(bg) == "number" then continue end -- What the literal fuck seriously??
		table.insert(rbgs, bg)
	end
	return table.Random(rbgs)
end

function PANEL:DrawBackgrounds( w, h )

	surface.SetDrawColor( 24, 25, 26, 200 )
	surface.DrawRect( 0, 0, w, h )

	if not self.logo then return end
	local bgs = self.Backgrounds[self.logo]
	if not bgs then return end

	for id, bg in ipairs( bgs ) do

		if self.ActiveBG and self.ActiveBG.time < RealTime() then self:SetNewBackground(true) end -- New active bg

		if type(bg) == "number" then continue end

		if bg == self.ActiveBG then
			bg.alpha = math.Approach( bg.alpha, 255, 4 )
		else
			bg.alpha = math.Approach( bg.alpha, 0, 4 )
		end

		if bg.alpha > 0 then
			surface.SetDrawColor( 255, 255, 255, bg.alpha )
			surface.SetMaterial( bg.mat )

			local x = self.ImageWidth/2
			surface.DrawTexturedRect( w/2 - SinBetween( x-50, x+50, RealTime() / 2 ), 0, self.ImageWidth, self.ImageHeight )
		end

	end

end

derma.DefineControl( "SelectionMenuSide", "", PANEL, "DPanel" )