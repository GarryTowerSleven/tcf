
-----------------------------------------------------
AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.Sequence 		= "walk_suitcase" -- 

ENT.Models = {
	"mossman",
	"alyx",
	"p2_chell",
	"skeleton",
	"zelda",
	"foohysaurusrex",
	"spacesuit",
	"gmen",
	"jawa",
	"knight"
}

function ENT:Initialize()
	self:SetModel( "models/player/" .. self.Models[math.random(1,#self.Models)] .. ".mdl" )
end

function ENT:BehaveAct()
end

function ENT:RunBehaviour()

	while ( true ) do

		local rnd = math.random(1,2)
		if rnd == 1 then
			self:PlaySequenceAndWait( "taunt_dance_base" )
		else
			self:PlaySequenceAndWait( "taunt_robot_base" )
		end

	end

end

function ENT:OnTakeDamage()
end