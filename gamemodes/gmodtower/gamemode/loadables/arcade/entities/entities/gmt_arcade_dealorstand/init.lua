AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

ENT.KickOutTime = 20

function ENT:Initialize()

	self.Entity:SetModel( self.Model )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end

	self:DrawShadow( false )

end

function ENT:StartRound()
	local round = (self:GetRound() + 1) or 1

	if round > 20 then
		self:SetLoseReason( self.LoseReasons.MAXROUNDS )
		self:SetState( self.States.END )
		self:End()
		return
	end

	self:SetRound( round )
	self:SetState( self.States.PICK )

	self:GetPlayer()._ArcadeTime = CurTime() + self.KickOutTime
end

function ENT:Payout()
	self:SetState( self.States.TICKETS )
	self:End()

	--self:GetPlayer()._ArcadeTime = CurTime() + self.KickOutTime
end

function ENT:OnGameStart()
	logger.debug( "Starting...", "DealOrStand" )

	self:StartRound()
end

function ENT:End()
	self:SetRound( 0 )

	logger.debug( self:CalculateChance() )
	self:GiveTickets( 50 )
end

function ENT:PickNumber()
	local _, c2 = self:GetChances()

	self:SetPickedNumber( math.random( 1, c2 ) )

	self:GetPlayer()._ArcadeTime = CurTime() + self.KickOutTime

	local won = self:IsWinningNumber()
	if won then
		self:SetState( self.States.CONTINUE )
	else
		self:SetLoseReason( self.LoseReasons.BADNUMBER )
		self:SetState( self.States.END )
		self:End()
	end
end

util.AddNetworkString( "dos_net" )
net.Receive( "dos_net",  function( len, ply )
	local ent = net.ReadEntity()
	local act = net.ReadInt(4)

	if !IsValid( ply ) || !IsValid( ent ) then return end

	if act == ent.Net.STOP then
		ent:PickNumber()
	elseif act == ent.Net.STAND then
		ent:StartRound()
	elseif act == ent.Net.DEAL then
		ent:Payout()
	end

	logger.debug( string.format( "Act received: %s", tostring(act) ), "DealOrStand" )
end )

// kick the bitch out if idle
function ENT:Think()
	local ply = self:GetPlayer()

	if ply && IsValid(ply) then
		if ply._ArcadeTime && ply._ArcadeTime < CurTime() then
			
		end
	end
end