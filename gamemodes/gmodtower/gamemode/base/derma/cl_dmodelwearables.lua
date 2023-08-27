local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed", 	"AnimSpeed" )
AccessorFunc( PANEL, "Entity", 			"Entity" )
AccessorFunc( PANEL, "vCamPos", 		"CamPos" )
AccessorFunc( PANEL, "fFOV", 			"FOV" )
AccessorFunc( PANEL, "vLookatPos", 		"LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor", 		"Color" )
AccessorFunc( PANEL, "bAnimated", 		"Animated" )

function PANEL:Init()

	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	
	self:SetCamPos( Vector( 0, 0, 0 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 15 )
	
	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )
	
	self:SetAmbientLight( Color( 50, 50, 50 ) )
	
	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
	
	self:SetColor( Color( 255, 255, 255, 255 ) )
	self.HeadPos = Vector()

end

function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[iDirection] = color
end

function PANEL:SetModel( strModelName, skin )

	// Invalid model
	if !strModelName then return end
	
	if !util.IsValidModel( strModelName ) then
		strModelName = "models/error.mdl"
	end

	// Same model found
	if self.ModelName == strModelName then
		self.Entity:SetSkin( skin or 1 )
		return
	end

	// Note - there's no real need to delete the old 
	// entity, it will get garbage collected, but this is nicer.
	if IsValid( self.Entity ) then
		self.Entity:Remove()
		self.Entity = nil		
	end
	
	// Note: Not in menu dll
	if !ClientsideModel then return end

	self.ModelName = strModelName

	self.Entity = ClientsideModel( self.ModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if !IsValid(self.Entity) then return end

	self.Entity:SetNoDraw( true )
	self.Entity:SetIK( false )
	self.Entity:SetModelScale( GTowerModels.GetScale( strModelName ) or 1 )
	self.Entity:SetSkin( skin or 1 )

	self.Entity:SetPos( Vector( -185, 0, 0 ) )

	local pos, ang = self:GetHeadPos()
	self.HeadPos = pos
	
	-- Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end
	
end

PANEL._lastmodel = nil
PANEL._lasthats = { 0, 0 }
function PANEL:SetModelWearables( ply )

	local slot1, slot2 = Hats.GetWearables( ply )
	if (self._lastmodel or nil) == self.Entity:GetModel() and (self._lasthats[1] or 0) == slot1 and (self._lasthats[2] or 0) == slot2 then return end

	self._lasthats[1] = slot1
	self._lasthats[2] = slot2
	self._lastmodel = self.Entity:GetModel()

	if IsValid( self.EntityWear1 ) then
		self.EntityWear1:Remove()
		self.EntityWear1 = nil		
	end

	if IsValid( self.EntityWear2 ) then
		self.EntityWear2:Remove()
		self.EntityWear2 = nil
	end

	if !ClientsideModel then return end
	
	local wear1, wear2 = Hats.GetItem( slot1 ), Hats.GetItem( slot2 )

	if wear1.model != Hats.GetNoHat() then
		self.EntityWear1 = ClientsideModel( wear1.model, RENDER_GROUP_OPAQUE_ENTITY )
	end

	if wear2.model != Hats.GetNoHat() then
		self.EntityWear2 = ClientsideModel( wear2.model, RENDER_GROUP_OPAQUE_ENTITY )
	end

	local req = {}

	if IsValid( self.EntityWear1 ) then
		self.EntityWear1:SetNoDraw( true )
		self.EntityWear2:SetLegacyTransform( true )
		table.insert( req, wear1.unique_Name )
	end
	if IsValid( self.EntityWear2 ) then
		self.EntityWear2:SetNoDraw( true )
		self.EntityWear2:SetLegacyTransform( true )
		table.insert( req, wear2.unique_Name )
	end

	Hats.RequestData( Hats.FindPlayerModelByName( self.Entity:GetModel() ), req )
	
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

function PANEL:GetTranslations( ent, wear )

	local data = Hats.GetData( ent:GetModel(), wear:GetModel() )

	local Pos, Ang, PlyScale = Hats.ApplyTranslation( ent, data )
	local Scale = data[7] * PlyScale

	return Pos, Ang, Scale

end

function PANEL:DrawWearable( wear )

	local pos, ang, scale = self:GetTranslations( self.Entity, wear )

	wear:SetPos( pos )
	wear:SetAngles( ang )
	wear:SetModelScale( scale, 0 )
	wear:DrawModel()

end

function PANEL:PrePaint( ent )
end

function PANEL:DrawModels( w, h )
	local curparent = self
	local leftx, topy = self:LocalToScreen( 0, 0 )
	local rightx, bottomy = self:LocalToScreen( self:GetWide(), self:GetTall() )
	while ( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()

		local x1, y1 = curparent:LocalToScreen( 0, 0 )
		local x2, y2 = curparent:LocalToScreen( curparent:GetWide(), curparent:GetTall() )

		leftx = math.max( leftx, x1 )
		topy = math.max( topy, y1 )
		rightx = math.min( rightx, x2 )
		bottomy = math.min( bottomy, y2 )
		previous = curparent
	end

	-- Causes issues with stencils, but only for some people?
	-- render.ClearDepth()

	render.SetScissorRect( leftx, topy, rightx, bottomy, true )
	
	self.Entity:DrawModel()

	// Draw Wearables
	if IsValid( self.EntityWear1 ) then
		self:DrawWearable( self.EntityWear1 )
	end
	if IsValid( self.EntityWear2 ) then
		self:DrawWearable( self.EntityWear2 )
	end

	render.SetScissorRect( 0, 0, 0, 0, false )
end

function PANEL:Paint( w, h )
	
	if !IsValid( self.Entity ) then return end

	local x, y = self:LocalToScreen( 0, 0 )
	local pos, ang = self:GetHeadPos()

	self:PrePaint( w, h )

	self:LayoutEntity( self.Entity )
	
	cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
	//cam.IgnoreZ( true )
	
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
		
		// draw models
		self:DrawModels( w, h )
	
	render.SuppressEngineLighting( false )
	cam.End3D()
	
	self.LastPaint = RealTime()
	
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( (RealTime()-self.LastPaint) * self.m_fAnimSpeed )	
end

function PANEL:LayoutEntity( Entity )

	if self.bAnimated then
		self:RunAnimation()
	end
	
	if !self.Dragging then
		Entity:SetAngles( Entity:GetAngles() + Angle( 0, RealTime() / 100000,  0) )
	else

		if self.RightDrag then

			local diffX = gui.MouseX() - self.Dragging.x
			Entity:SetAngles( Entity:GetAngles() + Angle( 0, diffX / 100, 0 ) )

		end

	end

end

function PANEL:OnMousePressed( mousecode )

	self.Dragging = { x = gui.MouseX(), y = gui.MouseY() }

	self:MouseCapture( true )
	self.RightDrag = mousecode == MOUSE_LEFT

	MouseDrag.Enable( true, gui.MouseX(), gui.MouseY() )

end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	self:MouseCapture( false )
	MouseDrag.Enable( false )

end

derma.DefineControl( "DModelPanelWearables", "A panel containing a model", PANEL, "DButton" )