ENT.Type 			= "anim"
ENT.PrintName		= "Voices of Ancestors Artifact"

ENT.Model = "models/gmod_tower/headheart.mdl"
ENT.ActiveTime = 30
ENT.Sound1 = "GModTower/pvpbattle/HeadphonesOn.mp3"

GtowerPrecacheModel( ENT.Model )

function ENT:CanUse( ply )
		return true, "USE"
end
