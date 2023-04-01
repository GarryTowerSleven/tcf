
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Base		= "base_entity"

ENT.Type 		= "anim"

ENT.PrintName	= "Palm Tree"

AddCSLuaFile("shared.lua")

ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName	= "Tree"

if IsChristmas then
	ENT.Model        = Model( "models/wilderness/snowtree.mdl" )
	ENT.ModelLOD     = Model("models/wilderness/snowtree.mdl")
else
	ENT.Model        = Model( "models/map_detail/foliage/coconut_tree_01.mdl" )
	ENT.ModelLOD     = Model("models/map_detail/foliage/coconut_tree_01_lod.mdl")
end


hook.Add( "PhysgunPickup", "TreeGrab", function( ply, ent )

	if ent:GetClass() == "gmt_tree" then return false end
	
end )

if SERVER then

	hook.Add( "OnPhysgunFreeze", "TreeGrab", function( wep, physobj, ent, ply )

		if ent:GetClass() == "gmt_tree" then return false end
		
	end )

	function ENT:Initialize()

		self:SetModel( self.Model )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)

		self:DrawShadow( false )

		self:SetAngles(Angle(0, math.Rand(0, 360), 0))

		local phys = self:GetPhysicsObject()
		if IsValid( phys ) then
			phys:EnableMotion( false )
		end

	end

else -- CLIENT

	local ConVar = ConVar or CreateClientConVar( "gmt_dynamic_trees", "1", true, false, nil, 0, 1 )
	local Budget = true // Budget or !ConVar:GetBool()

	cvars.AddChangeCallback( "gmt_dynamic_trees", function( cmd, old, new ) 

	end )

	ENT.Sequence = "wind_light"
	ENT.AutomaticFrameAdvance = true

	-- Fade distances for prop fading perf stuff
	-- Note we square it so we don't do expensive sqrt operations for each tree
	ENT.StartFadeDistance = 5000^2
	ENT.EndFadeDistance = 5500^2
	ENT.LODSwitchDistance = 2200^2

	function ENT:Initialize()
		self.TreeScale = math.Rand(.65,1)

		self:InitTree()
	end

	function ENT:Draw()
		if ( Budget ) then
			self:DrawModel()
		end 
	end

	function ENT:CreateTree( modelname )
		local mdl = ClientsideModel( modelname, RENDERGROUP_OPAQUE )
		mdl:SetPos( self:GetPos() )
		mdl:SetAngles(self:GetAngles())
		mdl:SetParent(self)

		-- Scale the renderbounds as well
		local min, max = mdl:GetRenderBounds()
		mdl:SetRenderBounds(
			Vector(min.x, min.y, min.z*self.TreeScale), 
			Vector(max.x, max.y, max.z*self.TreeScale))

		return mdl
	end

	function ENT:Think()
		if ( Budget ) then return end

		-- We get the length squared so we save on an expensive sqrt operation
		local d2 = ((LocalPlayer():GetPos() - self:GetPos()):LengthSqr())

		-- Double check our models
		if not IsValid(self.TreeModelLOD) or not IsValid(self.TreeModelAnim) then
			self:InitTree()
		end

		-- Change whether to use the animated or lod tree based on range
		if (d2 < self.LODSwitchDistance) then
			self.TreeModelLOD:SetNoDraw(true)
			self.TreeModel = self.TreeModelAnim
			self:ThinkAnimation()
		else 
			self.TreeModelAnim:SetNoDraw(true)
			self.TreeModel = self.TreeModelLOD
		end

		-- Get the percentage between the start and end fade distances
		local alpha = 1 - (d2 - self.StartFadeDistance) / ( self.EndFadeDistance - self.StartFadeDistance)

		-- Set the tree alpha, preventing it from drawing altogether if it's low enough
		self.TreeModel:SetColor(Color(255,255,255,alpha*255))
		self.TreeModel:SetNoDraw(alpha <= 0)
		self:SetNoDraw(alpha <= 0)
		self.TreeModel:SetRenderMode(alpha >= 1 and RENDERMODE_NORMAL or RENDERMODE_TRANSADD )

	end

	function ENT:ThinkAnimation( )
		if not IsValid( self.TreeModel ) then
			self:InitTree()
		end

		self.TreeModel:FrameAdvance( FrameTime() )
		--[[
		-- Update pos and angles
		if self:GetPos() ~= self.TreeModel:GetPos() then
			self.TreeModel:SetPos( self:GetPos() )
		end
		if self:GetAngles() ~= self.TreeModel:GetAngles() then
			self.TreeModel:SetAngles( self:GetAngles() )
		end
		]]
	end

	function ENT:InitTree()
		// self.TreeModelLOD = IsValid(self.TreeModelLOD ) and self.TreeModelLOD or self:CreateTree(self.ModelLOD)
		self.TreeModelAnim = IsValid(self.TreeModelAnim) and self.TreeModelAnim or self:CreateTree(self:GetModel())

		-- Select a random animation
		local anim = "wind_light"
		if math.random(1,2) == 2 then
			anim = "wind_light_b"
		end
		self.Sequence = anim

		-- Reset animation states
		self.TreeModelAnim:ResetSequenceInfo()

		-- Set sequence
		local seq = self.TreeModelAnim:LookupSequence( self.Sequence )
		self.TreeModelAnim:ResetSequence( seq )
		self.TreeModelAnim:SetCycle( 0.0 )

		-- Create the clientside shadow
		-- self.TreeModelAnim:CreateShadow()
	end

	function ENT:OnRemove()
		if IsValid( self.TreeModelAnim ) then 
			self.TreeModelAnim:Remove()
		end
		if IsValid(self.TreeModelLOD ) then
			self.TreeModelLOD:Remove()
		end
	end

end