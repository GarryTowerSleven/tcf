local EntityMeta = FindMetaTable("Entity")
if not EntityMeta then return end

function EntityMeta:CollisionRulesChanged()
	-- HACK!
	local cg = self:GetCollisionGroup()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetCollisionGroup(cg)
end

function EntityMeta:IsBrush()
	return self:GetModel():match( "\\*(%d+)" )
end

-- Replace function as it doesn't always work
function EntityMeta:GetInternalVariable( variableName )
	return self:GetSaveTable().variableName
end

EntityMeta.SetInternalVariable = EntityMeta.SetSaveValue

function EntityMeta:StopFollowingEntity()
	if self:IsFollowingEntity() then
		assert( self:IsEffectActive( EF_BONEMERGE ) == false )
		return
	end

	self:SetParent( NULL )
	self:RemoveEffects( EF_BONEMERGE )
	-- self:RemoveSolidFlags( FSOLID_NOT_SOLID )
	self:SetMoveType( MOVETYPE_NONE )
	self:CollisionRulesChanged()
end

function EntityMeta:IsFollowingEntity()
	return self:IsEffectActive( EF_BONEMERGE )
		and self:GetMoveType() == MOVETYPE_NONE
		and self:GetMoveParent()
end

function EntityMeta:GetFollowedEntity()
	if not self:IsFollowingEntity() then
		return NULL
	end
	return self:GetMoveParent()
end