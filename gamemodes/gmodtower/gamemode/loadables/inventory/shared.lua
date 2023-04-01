GTowerItems = GTowerItems or {}
GTowerItems.NetworkLoaded = true

local function ReloadMaxItems()
	if CLIENT then
		timer.Simple( 0, function() GTowerItems:ReloadMaxItems() end)
	end
end

plynet.Register( "Int", "MaxItems", {
	callback = ReloadMaxItems,
	default = GTowerItems.DefaultInvCount,
} )

plynet.Register( "Int", "BankMax", {
	callback = ReloadMaxItems,
	default = GTowerItems.DefaultBankCount,
} )

hook.Add( "GTowerPhysgunPickup", "OnlyAllowInvItems", function( ply, ent )

	if ply:GetSetting("GTAllowPhysInventory") == true then
		return GTowerItems:FindByEntity( ent ) != nil
	end

	return true
end )
