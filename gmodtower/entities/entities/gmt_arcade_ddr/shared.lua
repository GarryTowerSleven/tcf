---------------------------------
ENT.Base		= "browser_base"
ENT.Type		= "anim"
ENT.PrintName		= "Arcade Cabinet DDR"
ENT.Contact		= ""
ENT.Purpose		= "For GMod Tower"
ENT.Instructions	= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model		= "models/gmod_tower/arcadecab_ddr.mdl"

GtowerPrecacheModel( ENT.Model )

function ENT:CanUse()
	return true, "PLAY"
end
