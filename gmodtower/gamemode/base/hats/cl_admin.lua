module("HatAdmin", package.seeall )

DEBUG = false
LoadingItem = {}
CanUpdate = false
ValuesChanged = false
CopyData = GTowerHats.DefaultValue

MainPanel = nil
HatsNodes = nil
ModelNodes = nil
ModelPanel = nil
ValuesList = {}

CurrentTranslations = GTowerHats.DefaultValue

usermessage.Hook("HatAdm", function( um )

	local Id = um:ReadChar()
	
	if Id == 1 then
		
		local HatId = um:ReadLong()
		local ModelName = um:ReadString()
		local x = um:ReadFloat()
		local y = um:ReadFloat()
		local z = um:ReadFloat() 
		local ap = um:ReadFloat() 
		local ay = um:ReadFloat() 
		local ar = um:ReadFloat() 
		local sc = um:ReadFloat()
		local at = um:ReadChar()
		
		if HatId == LoadingItem.Hat && ModelName == LoadingItem.Model then
			
			CanUpdate = false
			
			CurrentTranslations = {
				x,
				y,
				z,
				ap,
				ay,
				ar,
				sc,
				at
			}
			
			for k, v in pairs( CurrentTranslations ) do
				if IsValid( ValuesList[k] ) then
					ValuesList[ k ]:SetValue( v )
				end
			end
			
			CanUpdate = true
			
		end
		
	end

	
end )


hook.Add("CanCloseMenu", "GTowerHatAdmin", function()
	if IsValid( MainPanel ) then
		return false
	end
end )

hook.Add("GTowerAdminMenus", "AdminHatOffsets", function()
	return {
		["Name"] = "Hat Offsets",
		["function"] = Open
	}
end )

/*hook.Add("ExtraMenuPlayer", "AdminHatOffsets", function(ply)

	if GTowerHats:Admin( LocalPlayer() ) then
		return {
	        ["Name"] = "Hat Offsets",
			["function"] = Open
		}
	end

	return nil

end )*/

function RequestUpdate()

	if CanUpdate == false or !IsValid( MainPanel ) then
		return
	end
	
	if GTowerHats:Admin( LocalPlayer() ) then
		//ForceUpdate(GetCurrentItem(), GetCurrentTranslations())
		timer.Create("Hat" .. Item.Model .. "|" .. Item.Hat, 
			0.1,
			1, 
			ForceUpdate, 
			Item, 
			CurrentTranslations )
	end
	
end

function OnValuesChanged()
	ValuesChanged = CanUpdate and true or false
end

function ForceUpdate( Item, Translations )

	print(Item)
	PrintTable(Translations)
	
	//RunConsoleCommand("gmt_admsethatpos",
	//	Item.Hat,
	//	Item.Model,
	//	Translations[1],
	//	Translations[2],
	//	Translations[3],
	//	Translations[4],
	//	Translations[5],
	//	Translations[6],
	//	Translations[7],
	//	Translations[8]
	//)

end

function Open()

	if !GTowerHats:Admin( LocalPlayer() ) then return end

	Close()
	//GTowerMainGui:ShowMenus()
	gui.EnableScreenClicker( true )

	MainPanel = vgui.Create("DFrame")
	MainPanel:SetSize( 1000, ScrH() - 200 )
	MainPanel:SetPos( ( ScrW() / 2 ) - ( MainPanel:GetWide() / 2 ), ( ScrH() / 2 ) - ( MainPanel:GetTall() / 2 ) )
	MainPanel:SetTitle("HAT OFFSET EDITOR")
	MainPanel:SetDeleteOnClose( true )
	MainPanel.Close = Close

	//=======================================
	// == Panel list of models
	//=======================================
	ModelNodes = vgui.Create( "DTree", MainPanel )
	ModelNodes:SetPos( 5, 25 )
	ModelNodes:SetSize( 225, MainPanel:GetTall() - 500 )
	ModelNodes.DoClick = function( self, node )
		if DEBUG then Msg("Select model: ", node.ModelName, "\n" ) end
		UpdateModelPanels()
	end

	ModelNodes.Paint = function()
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawRect( 0, 0, ModelNodes:GetSize() )
	end
	
	HatsNodes = vgui.Create( "DTree", MainPanel )
	HatsNodes:SetPos( 5, 25 + ModelNodes:GetTall() + 3 )
	HatsNodes:SetSize( 225, MainPanel:GetTall() - 25 - ModelNodes:GetTall() - 5 )
	HatsNodes.DoClick = function( self, node )
		if DEBUG then Msg("Select hat: ", node.HatId, "\n" ) end
		UpdateModelPanels()
	end

	HatsNodes.Paint = function()
		surface.SetDrawColor( 255, 255, 255 )
		surface.DrawRect( 0, 0, HatsNodes:GetSize() )
	end

	// Create dummy table to sort it	
	local ModelsSorted = {}
	for k, v in pairs( GTowerHats:GetModelPlayerList() ) do
		local sort = {}
		sort.ModelName = k
		sort.ModelPath = v
		table.insert( ModelsSorted, sort )
	end

	// Sort by ABC
	table.sort( ModelsSorted, function( a, b )
		return a.ModelName < b.ModelName
	end )

	// Actually insert the nodes
	local FirstNode = nil
	for id, sort in pairs( ModelsSorted ) do

		local node = ModelNodes:AddNode( sort.ModelName )
		node.ModelName = sort.ModelName
		node.ModelPath = sort.ModelPath
		
		if !FirstNode then

			if LocalPlayer():GetModel() == sort.ModelPath then
				FirstNode = node
			end

		end
	end
	ModelNodes:SetSelectedItem( FirstNode )
	ModelsSorted = nil
	
	
	
	FirstNode = nil

	local HatsSorted = table.Copy( GTowerHats.Hats )
	for k, v in pairs( HatsSorted ) do
		v.UnsortedHatId = k
	end

	table.sort( HatsSorted, function( a, b )
		return a.Name < b.Name
	end )

	for k, v in pairs( HatsSorted ) do
		if k != 0 then
			local name = v.Name
			--if time.IsNew( v.dateadded or 0 ) then name = name .. " [NEW!]" end
			name = "[" .. v.UnsortedHatId .. "] " .. name
			if GTowerHats.FixScales[v.unique_Name] then name = name .. " [SCALE FIX!]" end

			local node = HatsNodes:AddNode( name )
			node.HatId = v.UnsortedHatId
			
			if !FirstNode then

				if GTowerHats:IsWearing( LocalPlayer(), v.UnsortedHatId ) then
					FirstNode = node
				end

			end
		end
	end
	HatsNodes:SetSelectedItem( FirstNode )
	
	
	//=======================================
	// == MODEL PANEL
	//=======================================
	
	ModelPanel = vgui.Create("DModelPanelAdminHat", MainPanel )
	ModelPanel:SetPos( 225+10, 25 )
	ModelPanel:SetSize( MainPanel:GetWide() - 150 - 225 - 10, MainPanel:GetTall() - 90 )
	
	if GTowerHats:Admin( LocalPlayer() ) then

		//=======================================
		// == SLIDERS
		//=======================================
		
		local TextValues = {"ZPos", "YPos", "XPos", "PAng", "YAng", "RAng", "Scale" }
		
		for i=1, 7 do
		
			local panel = vgui.Create("DNumSlider", MainPanel )
			panel:SetWide( 130 )
			panel:SetPos( MainPanel:GetWide() - 150, 50 * i )
			panel:SetText( TextValues[ i ] )

			panel.Scratch:SetImageVisible( true )
			panel.Label:SetSize( 115 )
			panel.Label:SetTextColor( Color( 255, 255, 255 ) )
			panel.TextArea:SetTextColor( Color( 255, 255, 255 ) )
			panel.PerformLayout = function() end

			panel.Paint = function( w, h )
				draw.RoundedBox( 6, 0, 0, panel:GetWide(), panel:GetTall(), Color( 0,0,0,50 ) )
			end

			panel.OnValueChanged = OnValuesChanged
			
			if i <= 3 then
				panel:SetMin( -150 )
				panel:SetMax( 150 )
				panel:SetDecimals( 1 )
			elseif i == 7 then
				panel:SetMin( 0 )
				panel:SetMax( 8 )
				panel:SetDecimals( 2 )
			else
				panel:SetMin( -180 )
				panel:SetMax( 180 )
				panel:SetDecimals( 0 )
			end
			
			ValuesList[i] = panel
			
		end	
		
		local ComboBox = vgui.Create("DComboBox", MainPanel )
		local ItemList = {}
		//ComboBox:SetMultiple( false )
		ComboBox:SetPos( MainPanel:GetWide() - 50, MainPanel:GetTall() - 25 - 10 )
		ComboBox:SetSize( 130, 25 )
		ComboBox:SetVisible( false ) // disable for now
		
		ComboBox.GetValue = function( self )
			return ComboBox.SelectedId
		end
		ComboBox.SetValue = function( self, key )
			key = (!key or key == 0) and 1 or key -- quickfix
			self:ChooseOptionID( key )
			self.SelectedId = key
		end
		
		for k, v in pairs( GTowerHats.AttachmentsList ) do
			ComboBox:AddChoice( v.Name, nil, function()
				ComboBox.SelectedId = k
			end )

			if v.Name == "Eyes" then
				ComboBox.DefaultID = k
			end

			//Item.AttachmentId = k
			
			//ItemList[ k ] = Item
		end
		
		ValuesList[8] = ComboBox

		ComboBox:SetValue( ComboBox.DefaultID )
		
		//=======================================
		// == COPY PASTE SAVE
		//=======================================
		
		local Copy = vgui.Create("DButton", MainPanel )
		Copy:SetText("COPY")
		Copy:SetSize( 100, 50 )
		Copy:SetPos( 225+20, MainPanel:GetTall() - 60 )
		Copy.DoClick = function()
			CopyData = table.Copy( GetCurrentTranslations() )
		end
		
		local Paste = vgui.Create("DButton", MainPanel )
		Paste:SetText("PASTE")
		Paste:SetSize( 100, 50 )
		Paste:SetPos( Copy.x + Copy:GetWide() + 10, MainPanel:GetTall() - 60 )
		Paste.DoClick = function()	
			for k, v in pairs( 	HatAdmin.CopyData ) do
				HatAdmin.ValuesList[ k ]:SetValue( v )
			end
		end
		
		local Save = vgui.Create("DButton", MainPanel )
		Save:SetText("SAVE")
		Save:SetSize( 100, 50 )
		Save:SetPos( Paste.x + Paste:GetWide() + 10, MainPanel:GetTall() - 60 )
		Save.DoClick = RequestUpdate

	end
	
	
	CanUpdate = GTowerHats:Admin( LocalPlayer() )
	UpdateModelPanels()

end

function Close()

	SafeRemove( MainPanel )
	SafeRemove( HatsNodes )
	SafeRemove( ModelNodes )
	SafeRemove( ModelPanel )
	SafeRemove( ValuesList )
	
	ValuesList = {}
	MainPanel = nil
	HatsNodes = nil
	ModelNodes = nil
	ModelPanel = nil
	CanUpdate = false
	
	//GTowerMainGui:HideMenus()
	gui.EnableScreenClicker( false )

end

function GetPlayerModel()
	return ModelNodes:GetSelectedItem().ModelPath
end

function GetHatModel()
	return GTowerHats.Hats[ GetHatId() ].model
end

function GetPlayerName()
	return ModelNodes:GetSelectedItem().ModelName
end

function GetHatId()
	if HatsNodes:GetSelectedItem() then
		return HatsNodes:GetSelectedItem().HatId
	end
	return 1
end

function GetHatName()
	return GTowerHats.Hats[ GetHatId() ].unique_name
end

function GetCurrentItem()
	return {
		Model = GetPlayerName(),
		Hat = GetHatId()
	}
end

function GetCurrentTranslations()
	return {
		ValuesList[1]:GetValue(),
		ValuesList[2]:GetValue(),
		ValuesList[3]:GetValue(),
		ValuesList[4]:GetValue(),
		ValuesList[5]:GetValue(),
		ValuesList[6]:GetValue(),
		ValuesList[7]:GetValue(),
		ValuesList[8]:GetValue(),
	}
end

function UpdateModelPanels()
	
	if ValuesChanged then RequestUpdate() end

	timer.Simple(0.3, function()

		ValuesChanged = false

		CanUpdate = false
		
		LoadingItem = GetCurrentItem()
		
		ModelPanel:SetModel( GetPlayerModel() )
		ModelPanel:SetModelHat( GetHatModel() )

        timer.Create("RequestHatInfo", 0.2, 1, function()
            RunConsoleCommand( "gmt_gethat",  string.lower(GTowerHats.Hats[LoadingItem.Hat].unique_Name), string.lower(LoadingItem.Model) )
        end)

	end)

end

concommand.Add("gmt_openhatmenu", Open )

local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )


/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()

	self.Entity = nil
	self.EntityHat = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	
	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )
	
	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )
	
	self:SetAmbientLight( Color( 50, 50, 50 ) )
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	
	self:SetColor( Color( 255, 255, 255, 255 ) )
	
	self.ViewAngles = Angle(0, 0, 0)
	self.HeadPos = Vector()
	self.ViewDistance = 20
	self.ViewUp = 0
	self.RightDrag = false
end

/*---------------------------------------------------------
   Name: SetDirectionalLight
---------------------------------------------------------*/
function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[iDirection] = color
end

function PANEL:ResetCamera()
	
	self:SetCamPos( self.ViewAngles:Forward() * self.ViewDistance + self.HeadPos + Vector( 0, 0, self.ViewUp ) )
	self:SetLookAt( self.HeadPos + Vector( 0, 0, self.ViewUp ) )
	
end

/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:SetModelHat( strModelName )

	// Note - there's no real need to delete the old 
	// entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.EntityHat ) ) then
		self.EntityHat:Remove()
		self.EntityHat = nil		
	end
	
	// Note: Not in menu dll
	if ( !ClientsideModel ) then return end
	
	self.EntityHat = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid(self.EntityHat) ) then return end
	
	self.EntityHat:SetLegacyTransform( true ) -- Because they suck
	self.EntityHat:SetNoDraw( true )

end

function PANEL:SetModel( strModelName )

	-- Note - there's no real need to delete the old 
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil		
	end
	
	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end
	
	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid(self.Entity) ) then return end
	
	self.Entity:SetNoDraw( true )

	-- Hide model hats
	if strModelName == "models/uch/pigmask.mdl" or strModelName == "models/uch/mghost.mdl" then
		self.Entity:SetBodygroup( 2, 0 ) // UCH crap
	else
		self.Entity:SetBodygroup( 0, 1 ) // Hide Hat bone
	end

	if strModelName == "models/player/hatman.mdl" then
		self.Entity:SetBodygroup(0,0)
	end

	self.Entity:SetPlaybackRate(0)

	local iSeq = self.Entity:LookupSequence( "idle1" )
	if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "idle" ) end
	if (iSeq > 0) then self.Entity:ResetSequence( iSeq ) end
	
	local pos, ang = self:GetHeadPos()
	
	self.HeadPos = pos
	
	self:SetLookAt( pos )
	self:ResetCamera()

end

function PANEL:GetHeadPos()

	local pos, ang = self.Entity:GetPos(), self.Entity:GetAngles()
	local head = self.Entity:LookupBone("ValveBiped.Bip01_Head1")

	if !head then head = self.Entity:LookupBone("Head") end
	if !head then head = self.Entity:LookupBone("head") end

	if head then 
		pos, ang = self.Entity:GetBonePosition(head)
	end

	return pos, ang

end

function PANEL:Paint()

	if ( !IsValid( self.Entity ) ) then return end
	if ( !IsValid( self.EntityHat ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )
	//local head = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
	//local pos, ang = self.Entity:GetBonePosition(head)
	local eyes = self.Entity:LookupAttachment( GTowerHats.HatAttachment )
	local EyeTbl = self.Entity:GetAttachment( eyes )
	local pos, ang
	if !EyeTbl then
		pos, ang = Vector(0,0,0), Angle(0,0,0)
	else
		pos, ang = EyeTbl.Pos, EyeTbl.Ang
	end

	local PlyModel = string.lower( self.Entity:GetModel() )
	local HatModel = self.EntityHat:GetModel()

	local PlayerId = GTowerHats:FindPlayerModelByName( PlyModel )
	local HatId = GTowerHats:FindByModel( HatModel ) or ""

	local trans = GTowerHats:GetTranslation( HatId, PlayerId )

	self:LayoutEntity( self.Entity )

	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
	cam.IgnoreZ( true )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( pos + ang:Forward() * 20 )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	render.SetBlend( self.colColor.a/255 )

	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end

	ang:RotateAroundAxis(ang:Right(), trans[2][1])
	ang:RotateAroundAxis(ang:Up(), trans[2][2])
	ang:RotateAroundAxis(ang:Right(), trans[2][3])

	self.Entity:DrawModel()

	self.EntityHat:SetPos( pos +
		(ang:Up() * trans[1][1]) +
		(ang:Forward() * trans[1][2]) +
		(ang:Right() * trans[1][3])
	)
	self.EntityHat:SetAngles( ang )

	local scal = trans[3]
	if GTowerHats.FixScales[HatId] then
		scal = math.sqrt(scal)
	end

	self.EntityHat:SetModelScale( scal )

	self.EntityHat:DrawModel()

	render.SuppressEngineLighting( false )
	cam.IgnoreZ( false )
	cam.End3D()

	self.LastPaint = RealTime()

end

function PANEL:RunAnimation()
end

function PANEL:LayoutEntity( Entity )
end

function PANEL:OnMousePressed( mousecode )
	self.Dragging = { gui.MouseX(), gui.MouseY() }
	self:MouseCapture( true )
	self.RightDrag = ( mousecode == MOUSE_RIGHT )
	self.MiddleDrag = ( mousecode == MOUSE_MIDDLE )
end
function PANEL:OnMouseReleased()
	self.Dragging = nil
	self:MouseCapture( false )
end

function PANEL:Think()

	if !self.Dragging then return end

	if self.RightDrag then

		self.ViewAngles:RotateAroundAxis( self.ViewAngles:Up(), ( gui.MouseX() - self.Dragging[1] ) / 10 )
		self.ViewAngles:RotateAroundAxis( self.ViewAngles:Right(), ( self.Dragging[2] - gui.MouseY() ) / 10 )

	elseif self.MiddleDrag then

		self.ViewUp = self.ViewUp - ( ( self.Dragging[2] - gui.MouseY() ) / 20 )

	else

		self.ViewDistance = self.ViewDistance + (self.Dragging[1] - gui.MouseX()) * 0.1

	end
		
	self.Dragging = { gui.MouseX(), gui.MouseY() }
	self:ResetCamera()

end

derma.DefineControl( "DModelPanelAdminHat", "A panel containing a model", PANEL, "DButton" )