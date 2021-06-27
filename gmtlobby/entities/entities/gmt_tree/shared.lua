
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Base		= "base_entity"

ENT.Type 		= "anim"

ENT.PrintName	= "Palm Tree"


ENT.Model = Model("models/map_detail/foliage/coconut_tree_01.mdl")
ENT.LODModel = Model("models/map_detail/foliage/coconut_tree_01_lod.mdl")

ENT.PalmSeq = "wind_light"
ENT.AnimStarted = false

function ENT:Initialize()
	if ( CLIENT ) then
		if math.random(1,2) == 1 then self.PalmSeq = "wind_light_b" end
	end
end

function ENT:Think()

	if ( SERVER && !self.AnimStarted ) then
		self.AnimStarted = true
		if self:GetModel() == self.Model then
			self:ResetSequence( self.PalmSeq )
		end
	end

	if ( CLIENT ) then
		if ( LocalPlayer():GetPos():Distance( self:GetPos() ) <= 2048 ) then
			self:SetSequence( self.PalmSeq )
		else
			self:SetSequence( 0 )
		end
	end

	self:NextThink( CurTime() )
	return true

end
