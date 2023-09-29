GTowerItems = GTowerItems or {}
GTowerItems.NetworkLoaded = true

hook.Add( "GTowerPhysgunPickup", "OnlyAllowInvItems", function( ply, ent )

	if ply:GetSetting("GTAllowPhysInventory") == true then
		return GTowerItems:FindByEntity( ent ) != nil
	end

	return true
end )
