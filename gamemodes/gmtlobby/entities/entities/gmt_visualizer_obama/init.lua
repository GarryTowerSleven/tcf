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

function ENT:Think()
	self.Pos = self.Pos or self:GetPos()

	if self.Pos ~= self:GetPos() then
		self.Pos = self:GetPos()
		self.Ang = self:GetAngles()
		BroadcastLua([[obama = Entity(]] .. self:EntIndex() .. [[) obama.Pos = Vector(]] .. self.Pos.x .. [[,]] .. self.Pos.y .. [[,]] .. self.Pos.z ..[[) obama.Ang = Angle(]] .. self.Ang.p .. [[, ]] .. self.Ang.y .. [[, ]] .. self.Ang.r .. [[)]])
	end
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