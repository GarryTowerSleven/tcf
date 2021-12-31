AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "meta.lua" )

include('shared.lua')

function ENT:Initialize()
	self.Entity:SetModel( self.Model )

	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	self.Entity:SetUseType(SIMPLE_USE)

	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end
end

function ENT:Use( ply )
	net.Start( "RadioTestThing" )
		net.WriteEntity(self.Entity)
	net.Broadcast()
end

util.AddNetworkString( "RadioTestThing" )