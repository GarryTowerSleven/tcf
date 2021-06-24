
-----------------------------------------------------
AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

ENT.Models = {
	"mossman",
	"alyx",
	"p2_chell",
	"zoey",
	"skeleton",
	"faith",
	"zelda",
	"foohysaurusrex",
	"spacesuit",
}

function ENT:Initialize()
	self:SetModel( "models/player/" .. self.Models[math.random(1,#self.Models)] .. ".mdl" )
end

function ENT:BehaveAct()
end

function ENT:RunBehaviour()

	while ( true ) do
		self:PlaySequenceAndWait( "walk_suitcase" )
	end

end

function ENT:OnTakeDamage()
end
