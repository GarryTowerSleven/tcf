ENT.Type 			= "anim"
ENT.PrintName		= "Mystery Sack"

ENT.Model = "models/legoj15/ssb3ds/items/carryitem.mdl"
ENT.RespawnTime = 5
ENT.PickupSound = "physics/metal/chain_impact_hard1.wav"

function ENT:CanUse()
  return true, "TOUCH"
end
