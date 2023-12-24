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

end

function ENT:SetSale( sale )
	self:SetSale( sale )
end

hook.Add( "StorePurchaseFinish", "PresentSack", function( ply, item )

	if item.storeid != GTowerStore.HOLIDAY then return end
	if !string.find( item.Name, "Present" ) then return end

	local store = GTowerStore.Stores[item.storeid]

	local ent, dis = nil, math.huge

	for _, entity in ipairs( ents.FindByClass( store.NpcClass ) ) do
		
		local dist = entity:GetPos( ply ):DistToSqr( ply:GetPos() )

		if dist < dis then

			ent = entity
			dis = dist

		end

	end

	if IsValid( ent ) then

		ply:AddAchievement( ACHIEVEMENTS.SANTASHELPER, 1 )

	end

end )