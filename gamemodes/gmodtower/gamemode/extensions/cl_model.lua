function SetModelScaleVector( ent, scale )

	if !IsValid( ent ) then return end

	local scalefix = Matrix()
	scalefix:Scale( scale )

	ent:EnableMatrix( "RenderMultiply", scalefix )

end

function DrawModelMaterial( ent, scale, material )

	// start stencil
	render.SetStencilEnable( true )
	
	// render the model normally, and into the stencil buffer
	render.ClearStencil()
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilReferenceValue( 1 )
	
		// render model
		/*ent:SetModelScale( 1, 0 )
		ent:SetupBones()
		ent:DrawModel()*/
	
	// render the outline everywhere the model isn't
	render.SetStencilReferenceValue( 0 )
	render.SetStencilTestMask( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_ZERO )
	
	// render black model
	render.SuppressEngineLighting( true )
	render.MaterialOverride( material )
	
		// render model
		ent:SetModelScale( scale, 0 )
		ent:SetupBones()
		ent:DrawModel()
		
	// clear
	render.MaterialOverride()
	render.SuppressEngineLighting( false )
	
	// end stencil buffer
	render.SetStencilEnable( false )

end

local meta = FindMetaTable("Entity")

function meta:SetPlayerProperties( ply )

	if !IsValid( ply ) then return end

	if !self.GetPlayerColor then
		self.GetPlayerColor = function() return ply:GetPlayerColor() end
	end

	self:SetBodygroup( ply:GetBodygroup(1), 1 )
	self:SetMaterial( ply:GetMaterial() )
	self:SetSkin( ply:GetSkin() or 1 )

	if self.MinecraftMat then
		self:SetMaterial( self.MinecraftMat )
	end

end