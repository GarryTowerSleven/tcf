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