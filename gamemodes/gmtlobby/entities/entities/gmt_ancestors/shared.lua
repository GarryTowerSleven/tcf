ENT.Type 			= "anim"
ENT.PrintName		= "Voices of Ancestors Artifact"

ENT.Model = "models/gmod_tower/headheart.mdl"
ENT.Sound1 = "GModTower/pvpbattle/HeadphonesOn.mp3"

util.PrecacheModel( ENT.Model )

function ENT:CanUse( ply )
		return true, "USE"
end
