---------------------------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()

	self:PhysicsInitBox( Vector( -20, -64, 0 ), Vector( 20, 64, 128 ) )
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:DrawShadow(false)

end

function ENT:Think()

	local p = self:GetPos()

	for _, ply in ipairs( player.GetAll() ) do

		if ply:Alive() && ply:GetPos():WithinAABox( p + Vector( -20, -20, 0 ), p + Vector( 20, 20, 72 ) ) then

			self:OnEnter( ply )

		end

	end

end

function ENT:OnEnter()

end