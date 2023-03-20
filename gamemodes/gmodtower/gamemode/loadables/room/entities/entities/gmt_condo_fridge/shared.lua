
-----------------------------------------------------
ENT.Base		= "base_anim"
ENT.Type		= "anim"

ENT.Model		= Model( "models/map_detail/condo_fridge.mdl" )

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Open" )
end


hook.Add( "PhysgunPickup", "FridgeGrab", function( ply, ent )

	if ent:GetClass() == "gmt_condo_fridge" then return false end

end )

function ENT:CanUse( ply )
	return true, "OPEN/CLOSE"
end
