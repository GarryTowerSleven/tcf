AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include("shared.lua")

function ENT:SphereInit(r)
	self:PhysicsInitSphere(r)

	local phys = self:GetPhysicsObjectNum(0)
	phys:SetMass(100)
	phys:SetDamping( 0.05, 1 )
	phys:SetBuoyancyRatio(0.5)

	self:StartMotionController()
	phys:EnableMotion(true)
end

function ENT:Initialize()

	self:SetCustomCollisionCheck( true )

	local ply = self:GetOwner()

	self.radius = 44

	self:SphereInit(self.radius)

	self:SetModel( "models/gmod_tower/ball_spiked.mdl" )
	// self:SetNoDraw( true )
	self:DrawShadow( false )

	self:AddEFlags( EFL_FORCE_CHECK_TRANSMIT )
end

function ENT:Think()
	self:PhysWake()
	self:GetPhysicsObject():EnableGravity(false)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

util.AddNetworkString("test")

net.Receive("test", function(_, ply)
	local pos = net.ReadVector()
	local ball = ply:GetBall()



	if pos:Distance(ball:GetPos()) > 64 then
		net.Start("test")
		net.WriteVector(ball:GetPos())
		net.Send(ply)
	else
		ball:GetPhysicsObject():SetPos(pos)
	end
end)