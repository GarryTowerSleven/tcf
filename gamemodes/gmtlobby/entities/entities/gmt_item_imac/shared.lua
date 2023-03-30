ENT.Base		= "base_anim"
ENT.Type		= "anim"
ENT.PrintName	= "iMac"
ENT.Purpose		= "For GMod Tower"

ENT.Model		= Model( "models/gmod_tower/suite/imac.mdl" )

function ENT:CanUse( ply )
	return true, "USE COMPUTER"
end
