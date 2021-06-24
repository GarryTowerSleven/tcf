
-----------------------------------------------------
AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

ENT.Models = {
	"zombie_classic",
}

function ENT:Initialize()
	self:SetModel( "models/player/" .. self.Models[math.random(1,#self.Models)] .. ".mdl" )
end

function ENT:BehaveAct()
end

function ENT:RunBehaviour()

	while ( true ) do
		self:PlaySequenceAndWait( "FireIdle" )
	end

end

function ENT:OnTakeDamage()
end
