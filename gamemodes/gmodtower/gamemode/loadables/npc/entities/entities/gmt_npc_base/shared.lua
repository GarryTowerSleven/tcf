ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

--ENT.AnimMale		= Model( "models/player/gmt_shared.mdl" )
ENT.AnimMale		= Model( "models/Humans/GMTsui1/Male_03.mdl" )
ENT.AnimFemale		= Model( "models/Humans/GMTsui1/Female_01.mdl" )

ENT.StoreId = -1

function ENT:GetAnimationBase()
	local bFemale = string.find( string.lower(self.Model), "female" )
	return bFemale and self.AnimFemale or self.AnimMale
end

function ENT:GetEyePos()

	if CLIENT then
		local attachId = self.Ragdoll:LookupAttachment("eyes")
		if attachId then
			local att = self.Ragdoll:GetAttachment(attachId)
			if att then
				return att.Pos
			end
		end
	end

	return vector_origin
end

function ENT:SetupModel()

	if SERVER then

		self:SetModel(self:GetAnimationBase())

	else

		if IsValid(self.Ragdoll) then
			self.Ragdoll:Remove()
		end

		self.Ragdoll = ClientsideModel(self.Model)
		self.Ragdoll:AddEffects( bit.bor( EF_BONEMERGE, EF_BONEMERGE_FASTCULL, EF_PARENT_ANIMATES ) )
		self.Ragdoll:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self.Ragdoll:DrawShadow(false)
		self.Ragdoll:SetNoDraw(true)
		self.Ragdoll:SetParent(self)
		self.Ragdoll:SetOwner(self)
		self.Ragdoll:Spawn()

		self:SetupRagdoll( self.Ragdoll )

	end

end

function ENT:OnRemove()
	if SERVER then return end

	if IsValid(self.Ragdoll) then
		self.Ragdoll:Remove()
	end
end

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Sale" )
	self:NetworkVar( "Bool", 1, "New" )
end

function ENT:IsOnSale()
	return self:GetSale()
end

function ENT:HasNewItems()
	return self:GetNew()
end

function ENT:GetStoreId()
	return self.StoreId
end

function ENT:GetTitle()

	if ( GTowerStore.Stores and self:GetStoreId() != -1 ) then
		return GTowerStore.Stores[self:GetStoreId()].WindowTitle
	end

	return nil

end

function ENT:CanUse( ply )
	local title = self:GetTitle()
	if title && title != "Suite Lady" then
		return true, "SHOP: " .. string.upper(title)
	else
		return true, "TALK"
	end
end

/* ----------------------------------
	Animations
---------------------------------- */
function ENT:PlaySequence(str)

	if self.bAnimating then return end

	local seq = self:LookupSequence(str)
	self:ResetSequence(seq)

	self.bAnimating = true

end