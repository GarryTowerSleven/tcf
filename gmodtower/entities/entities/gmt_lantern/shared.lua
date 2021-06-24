---------------------------------
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model("models/gmod_tower/halloween_lantern.mdl")

function ENT:CanUse( ply )
		return true, "TURN ON/OFF"
end
