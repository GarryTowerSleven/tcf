
-----------------------------------------------------
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Pet Balloonicorn"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.AutomaticFrameAdvance = true
ENT.Model			= "models/gmod_tower/balloonicorn_nojiggle.mdl"

function ENT:SetupDataTables()

	self:NetworkVar( "String", 0, "PetName" )

end
