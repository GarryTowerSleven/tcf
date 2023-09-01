AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetNotSolid( true )
	self:SetParent( self:GetOwner() )
	self:SetPos( self:GetOwner():GetPos() )

	self:DrawShadow( false )

	self:AddToEquipment()

end

local meta = FindMetaTable("Player")
function meta:ReParentCosmetics()
	if not IsValid(self) or not self.CosmeticEquipment then return end

	for _, v in pairs( self.CosmeticEquipment ) do
		
		if not IsValid( v ) then continue end

		v:SetParent( NULL )

		v:SetPos( self:GetPos() )
		v:SetParent( self )

	end
end