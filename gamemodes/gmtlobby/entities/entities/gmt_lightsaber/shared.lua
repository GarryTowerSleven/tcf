ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model("models/gmod_tower/toy_lightsaber.mdl")
ENT.Sound = clsound.Register( "GModTower/inventory/use_lightsaber.wav" )

function ENT:CanUse( ply )
	return true, "TURN ON/OFF"
end
