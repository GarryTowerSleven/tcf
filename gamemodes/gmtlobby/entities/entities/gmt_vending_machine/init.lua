include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()

	self:SetModel(self.Model)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE ) // Or else it'll go WOBLBLBLBLBLBLBLBL

	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:EnableMotion( false )
	end

	if ( not IsLobbyOne ) then
		self:SetMaterial( "models/map_detail/deluxe_vendingmachine", true )
	end

end

function ENT:SetSale( sale )
	self:SetNWBool("Sale",sale)
end