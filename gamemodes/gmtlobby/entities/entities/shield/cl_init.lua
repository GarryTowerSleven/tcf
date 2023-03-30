include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

ENT.MatPower = Material( "models/effects/comball_tape" )

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

function ENT:Initialize()

	self:SetPos( self:GetPos() + Vector( 0, 0, 10 ) )
	self.Scale = 0

end

function ENT:Draw()

	self.Scale = math.Approach( self.Scale, 1.3, FrameTime() * 10 )
	self:SetModelScale( self.Scale, 0 )

	self:DrawModel()

	DrawModelMaterial( self, self.Scale + .1, self.MatPower )

end