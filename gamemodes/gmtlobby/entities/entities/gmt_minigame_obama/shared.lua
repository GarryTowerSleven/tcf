AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.Model = Model("models/gmod_tower/obamacutout.mdl")

function ENT:Initialize()

    if CLIENT then return end

	self:SetModel( self.Model )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:Activate()
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

end

function ENT:Draw()

	self:DrawModel()

end

function ENT:OnTakeDamage( dmginfo )

    local attacker = dmginfo:GetAttacker()
	if ( IsValid( attacker ) && attacker:IsPlayer() ) then

		hook.Run( "ObamaSmashed", attacker, self )

	end

    self:Remove()

end