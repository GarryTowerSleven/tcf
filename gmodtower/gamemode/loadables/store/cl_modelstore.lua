---------------------------------
module("GTowerStore", package.seeall )

local ModelSize = 475
local CameraZPos = 30
local CameraFar = 50
local ModelPanelSize = 700

local gradient = "VGUI/gradient_up"

function OpenModelStore( id, title, zpos, modelsize, camerafar )

	if ValidPanel( StoreGUI ) then
		CloseStorePanel()
	end

	CameraZPos = ( zpos or 25 ) - ( ScrW() / 400 )
	ModelSize = ( ScrW() * 0.35 ) or 375
	CameraFar = ( camerafar or 100 ) + ( ScrW() / 400 )	

	StoreGUI = vgui.Create("DFrame")
	StoreGUI:SetSize( ScrW() * 0.75, ScrH() * 0.525 )
	
	StoreGUI:SetPos( ScrW() * 0.5 - StoreGUI:GetWide() * 0.5, ScrH() * 0.5 - StoreGUI:GetTall() * 0.5 )
	StoreGUI:SetTitle( title )
	
	StoreGUI:SetVisible( true )
	StoreGUI:SetDraggable( false ) // Draggable by mouse?
	StoreGUI:ShowCloseButton( true )
	StoreGUI:MakePopup()
	StoreGUI.Close = function( self )
		CloseStorePanel()
	end

	StoreGUI.PanelList = vgui.Create("DPanelList3", StoreGUI )
	StoreGUI.PanelList:SetPos( ModelSize + 4, 28 )
	StoreGUI.PanelList:SetSize( StoreGUI:GetWide() - ModelSize - 8, StoreGUI:GetTall() - 28 - 4 )
	StoreGUI.PanelList:EnableVerticalScrollbar()
	StoreGUI.PanelList:SetSpacing( 2 ) 
	StoreGUI.PanelList:SetPadding( 2 )

	local Canvas = vgui.Create("Panel", StoreGUI )
	Canvas:SetPos( 4, 28 )
	Canvas:SetSize( ModelSize, StoreGUI:GetTall() - 28 - 4 )

	StoreGUI.ModelPanel = vgui.Create("DModelPanel2", Canvas )
	StoreGUI.ModelPanel:SetAnimated( true )

	local gradient = surface.GetTextureID( "VGUI/gradient_up" )
	StoreGUI.ModelPanel.BackgroundDraw = function()
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.SetTexture( gradient )
		surface.DrawTexturedRect( 0, 0, StoreGUI.ModelPanel:GetSize() )
	end

	GTowerStore:UpdateStoreList()
	GtowerMainGui:GtowerShowMenus()
	UpdateModelPanel()

end

function UpdateModelPanel()

	if StoreGUI && ValidPanel( StoreGUI.ModelPanel ) then

		StoreGUI.ModelPanel:SetSize( ModelSize, StoreGUI:GetTall() - 28 - 4  )
		//StoreGUI.ModelPanel:SetPos( 150/2-StoreGUI.ModelPanel:GetWide()/2, StoreGUI:GetTall() / 2 - StoreGUI.ModelPanel:GetTall() / 2 + 14 )
		StoreGUI.ModelPanel:Center()
		StoreGUI.ModelPanel:SetLookAt( Vector(0,0,CameraZPos) )
		StoreGUI.ModelPanel:SetCamPos( Vector(CameraFar,0,CameraZPos) )

	end

end


function GTowerStore.OpenNormalStore( id, title )

	if ValidPanel( StoreGUI ) then
		CloseStorePanel()
	end

	StoreGUI = vgui.Create("DFrame")
	StoreGUI:SetSize( ScrW() * 0.45, ScrH() * 0.5 )

	if title == "Homeless Mac" then
		local hiya = "68747470733a2f2f6b3030372e6b697769362e636f6d2f686f746c696e6b2f3830303872747a6a35692f6d61636b6c696e2e6d7033"
		sound.PlayURL ( "https://k007.kiwi6.com/hotlink/8008rtzj5i/macklin.mp3", "", function( station )
		if ( IsValid( station ) ) then
			station:Play()
		else
		end
		end )
	end

	StoreGUI:SetPos( ScrW() * 0.5 - StoreGUI:GetWide() * 0.5, ScrH() * 0.5 - StoreGUI:GetTall() * 0.5 )
	StoreGUI:SetTitle( title )

	StoreGUI:SetVisible( true )
	StoreGUI:SetDraggable( true ) // Draggable by mouse?
	StoreGUI:ShowCloseButton( true )
	StoreGUI:MakePopup()
	StoreGUI.Close = function()
		CloseStorePanel()
		if title == "Homeless Mac" then
			RunConsoleCommand("stopsound")
		end
	end

	StoreGUI.PanelList = vgui.Create("DPanelList", StoreGUI )
	StoreGUI.PanelList:SetPos( 4, 28 )
	StoreGUI.PanelList:SetSize( StoreGUI:GetWide() - 4 - 4, StoreGUI:GetTall() - 28 - 4 )
	StoreGUI.PanelList:EnableVerticalScrollbar()
	StoreGUI.PanelList:SetSpacing( 2 )
	StoreGUI.PanelList:SetPadding( 2 )

	GTowerStore:UpdateStoreList()
	GtowerMainGui:GtowerShowMenus()

	if DEBUG2 then Msg("Finished opening store " .. tostring(title) .. "(" .. id .. ")\n") end
end


function ModelStoreMouseEntered( panel )

	if ValidPanel( StoreGUI.ModelPanel ) then

		local Item = panel:GetItem()

		if Item then

			if string.StartWith( Item.Name, "Particle:" ) then
				//TODO, attach particle to player.
				StoreGUI.ModelPanel:SetModel(LocalPlayer():GetModel())
			else
				StoreGUI.ModelPanel:SetModel( Item.model, Item.ModelSkin, true )
			end

			if DEBUG2 then
				Msg("Setting main model panel: " .. Item.model, "\n")
			end
		end

	end

end
