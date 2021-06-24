---------------------------------
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model("models/gmod_tower/toy_lightsaber.mdl")

function ENT:CanUse( ply )
		return true, "TURN ON/OFF"
end
