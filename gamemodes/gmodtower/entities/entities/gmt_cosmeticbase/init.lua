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

function ENT:ReParent()
	self:SetParent(NULL)
	self:SetParent(self:GetOwner())
end

local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:ResetEquipmentAfterVehicle()
	if !IsValid(self) || !self.CosmeticEquipment then return end

	for k,v in pairs(self.CosmeticEquipment) do
		v:ReParent()
	end
end