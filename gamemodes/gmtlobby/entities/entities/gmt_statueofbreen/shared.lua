ENT.Type 			= "anim"
ENT.PrintName		= "Statue of Breen Artifact"

ENT.Model = "models/props_combine/breenbust.mdl"
ENT.Voices = {"vo/Citadel/br_create.wav", "vo/Citadel/br_laugh01.wav", "vo/Citadel/br_ohshit.wav", "vo/Citadel/br_youfool.wav", "vo/Citadel/br_failing11.wav", "vo/Citadel/br_freemanatlast.wav", "vo/Citadel/br_foundation.wav", "vo/Citadel/br_synapse02.wav", "vo/Citadel/br_goback.wav", "vo/Citadel/br_gravgun.wav"}

util.PrecacheModel( ENT.Model )

function ENT:CanUse( ply )
		return true, "USE"
end
