ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Pet Chimera"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.AutomaticFrameAdvance = true
ENT.Model = Model( "models/UCH/uchimeraGM.mdl" )

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "PetName" )
end

ENT.Sound = clsound.Register( "UCH/chimera/roar.wav" )