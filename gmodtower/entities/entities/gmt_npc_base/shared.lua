ENT.Base 			= "base_ai"
ENT.Type 			= "ai"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

--ENT.AnimMale		= Model( "models/player/gmt_shared.mdl" )
ENT.AnimMale		= Model( "models/Humans/GMTsui1/Male_03.mdl" )
ENT.AnimFemale		= Model( "models/Humans/GMTsui1/Female_01.mdl" )
ENT.AutomaticFrameAdvance = false

ENT.StoreId = -1

function ENT:GetAnimationBase()

	local bFemale = string.find( string.lower(self.Model), "female" )
	return bFemale and self.AnimFemale or self.AnimMale

end

function ENT:GetExpression()
	return self:GetNWString( "GMT_NPC_EXPRESSION", "blank" )
end

function ENT:Expression(str)
	self:SetNWString( "GMT_NPC_EXPRESSION", str )
end

function ENT:SetupModel()

	self:SetModel(self:GetAnimationBase())

end

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 1, "New" )

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
	if title then
		return true, "SHOP: " .. string.upper(title)
	else
		return true, "TALK"
	end

end

function ENT:OnRemove()
end

function ENT:PhysicsCollide( data, physobj )
end

function ENT:PhysicsUpdate( physobj )
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )

	self.AutomaticFrameAdvance = bUsingAnim

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

function GTowerNPCSharedInit(ent)
	RegisterNWTable(ent, {
		{"Sale", false, NWTYPE_BOOL, REPL_EVERYONE, CreateSaleSign},
	})
end

function CreateSaleSign(npc, name, old, new)

	if new && !old then
		local edata = EffectData()
		edata:SetOrigin(npc:EyePos() + Vector(0,0,24))
		edata:SetEntity(npc)

		util.Effect("saleeffect", edata)

		return
	end

end

ImplementNW() -- Implement transmit tools instead of DTVars