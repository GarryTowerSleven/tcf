
-----------------------------------------------------
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "iMac"
ENT.Information		= "It spins around"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model("models/gmod_tower/suite/imac.mdl")

function ENT:CanUse()
  return true, "USE"
end
