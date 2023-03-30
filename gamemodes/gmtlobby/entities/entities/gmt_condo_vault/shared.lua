
-----------------------------------------------------
ENT.Base		= "base_anim"
ENT.Type		= "anim"

ENT.Model		= Model( "models/map_detail/condo_vault.mdl" )

hook.Add( "PhysgunPickup", "VaultGrab", function( ply, ent )

	if ent:GetClass() == "gmt_condo_vault" then return false end

end )

function ENT:CanUse( ply )
	return true, "OPEN VAULT"
end

