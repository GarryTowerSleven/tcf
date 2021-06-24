
ENT.RenderGroup = RENDERGROUP_OPAQUE

ENT.Base		= "base_entity"
ENT.Type 		= "anim"
ENT.PrintName	= "Palm Tree"

ENT.Model = Model("models/map_detail/foliage/coconut_tree_01.mdl")
ENT.LODModel = Model("models/map_detail/foliage/coconut_tree_01_lod.mdl")

ENT.PalmSeq = "wind_light"

function ENT:Initialize()
    if math.random(1,2) == 1 then self.PalmSeq = "wind_light_b" end
end

function ENT:Think()
	if ( SERVER ) then
		self:NextThink( CurTime() )
    if self:GetModel() == self.Model then
      self:ResetSequence( self.PalmSeq )
    end
		return true
  end

  if CLIENT then
    if ( !LocalPlayer():GetPos():WithinDistance( self:GetPos(), 2048 ) ) then
      if self:GetModel() == self.LODModel then return end
      self:SetModel( self.LODModel )
    else
      if self:GetModel() == self.Model then return end
      self:SetModel( self.Model )
    end
  end

end
