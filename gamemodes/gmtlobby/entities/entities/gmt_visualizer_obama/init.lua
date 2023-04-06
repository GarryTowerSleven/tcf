AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit ) then return end
	
	local ent = ents.Create( "gmt_visualizer_disco" )
	ent:SetPos( tr.HitPos + Vector(0,0,32) )	
	ent:Spawn()
	ent:Activate()
	
	return ent
end

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
end