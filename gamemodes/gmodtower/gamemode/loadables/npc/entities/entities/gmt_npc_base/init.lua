AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_expression.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
    self:SetupModel()
    self:SetSolid( SOLID_BBOX )

    self:SetUseType( SIMPLE_USE )
end

function ENT:CreateSaleSign()

	self.SaleEffect = EffectData()
	local pos = self:GetPos() + Vector( 0, 0, 80 )
	self.SaleEffect:SetStart(pos)
	self.SaleEffect:SetOrigin(pos)
	self.SaleEffect:SetScale(1)
	self.SaleEffect:SetEntity(self)
	
	util.Effect( "saleeffect", self.SaleEffect )
	
end

function ENT:SaleThink()
    if self:IsOnSale() then
        if ( not self.SaleEffect ) then
            // self:CreateSaleSign()
            self:PlaySequence( "lineidle02" )
            self.SaleEffect = true
            self.bAnimating = false
        end
    else
        if ( self.SaleEffect ) then
            self.SaleEffect = nil
            self.bAnimating = false
        end
    end
end

function ENT:Think()
    if ( not self.bAnimating ) then
        self:PlaySequence( self:IsOnSale() && "lineidle01" || self.Sequence or "idle_subtle" )
    end

    self:SaleThink()
    self:AdditionalThink()
end

function ENT:AdditionalThink() end

function ENT:CanPlayerUse( ply )
    return true
end

function ENT:Use( activator, caller, usetype, value )
    if not self:CanPlayerUse( activator ) then return end

    GTowerStore:OpenStore( activator, self.StoreId or 0 )
end