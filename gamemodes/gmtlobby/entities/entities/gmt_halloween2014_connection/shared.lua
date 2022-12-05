ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model( "models/props_lab/blastdoor001c.mdl" )

function ENT:CanUse( ply )
	return true, "ENTER THE MADNESS"
end