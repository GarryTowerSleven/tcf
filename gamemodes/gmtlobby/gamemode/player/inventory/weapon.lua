local function WeaponOverride( ply )
	return hook.Call("WeaponOverride", GAMEMODE, ply )
end

local function GetEquipedItems( ply )

	local Items = {}

	for i=1, GTowerItems.EquippableSlots do
		local Slot = GTowerItems:NewItemSlot( ply, i )
		local Item = Slot:Get()

		if IsValid( Item ) then
			table.insert( Items, Item )
		end

	end

	return Items

end

hook.Add( "PlayerLoadout", "GiveWeaponsInv", function( ply )

	if WeaponOverride( ply ) == true then
		return
	end

	local ItemList = ply:GetEquipedItems()

	for _, Item in pairs( ItemList ) do
		GTowerItems:GiveWeapon( ply, Item )
	end

	ply:GiveAmmo(100, "slam", true )

end )

concommand.Add("gmt_selwep", function( ply, command, args )

	if !ply:Alive() || #args != 1 || WeaponOverride( ply ) == true || Dueling.IsDueling( ply ) then
		return
	end

	local WeaponId = tonumber( args[1] )

	if !WeaponId || !GTowerItems:IsEquipSlot( WeaponId )  then
		return
	end

	local Slot = GTowerItems:NewItemSlot( ply, WeaponId )
	local Item = Slot:Get()

	if Item && Item:IsWeapon() then
		GTowerItems:GiveWeapon( ply, Item, true )
	else
		ply:StripWeapons()
	end

end )

function GTowerItems:CanHaveWeapon( ply, Classname )
	if !ClientSettings || ply:IsAdmin() then return true end

	if Classname == "weapon_physgun" then
		return ClientSettings:Get( ply, "GTAllowPhysGun" )
	end

	if Classname == "weapon_physcannon" then
		return true
	end

	if hook.Call( "AllowWeapons", GAMEMODE, ply ) == false then
		return false
	end

	return true
end

function GTowerItems:GiveWeapon( ply, item, select )

	if IsValid( ply:GetVehicle() ) then
		return
	end

	if !item:IsWeapon() then
		return
	end

	local Classname = item.ClassName

	if !Classname || (item.WeaponSafe == false && GTowerItems:CanHaveWeapon( ply, Classname ) == false) then
		return
	end

	ply.CanPickupWeapons = true

	if !ply:HasWeapon( Classname ) then
		ply:Give( Classname )
	end

	if select == true then
		ply:SelectWeapon( Classname )
	end

	local Weapon = ply:GetWeapon( Classname )

	if IsValid( Weapon ) then
		Weapon.InventoryItem = item
	end

	ply.CanPickupWeapons = false

end


local function PlayerCheckWeapons( ply )

	if not ply._DataLoaded|| WeaponOverride( ply ) == true then
		return
	end

	local PosibleWeapons = {}
	local ItemList = ply:GetEquipedItems()

	for _, Item in ipairs( ItemList ) do
		if Item:IsWeapon() then
			table.insert( PosibleWeapons, Item.Classname )
		end
	end

	for _, v in pairs(ply:GetWeapons()) do
		local Class = v:GetClass()

		if !table.HasValue( PosibleWeapons, Class ) || GTowerItems:CanHaveWeapon( ply, Class ) == false then
			v:Remove()
		end

	end

end

hook.Add("InvSwap", "CheckWeaponsSwap", PlayerCheckWeapons )
hook.Add("InvDrop", "CheckWeaponsDrop", PlayerCheckWeapons )
hook.Add("InvRemove", "CheckWeaponRemove", PlayerCheckWeapons )

hook.Add("ClientSetting", "GTCheckWeapons", function( ply, id, val )

	local Name = ClientSettings:GetName( id )

	if Name == "GTAllowPhysGun" then
		PlayerCheckWeapons( ply )
	end

end )

hook.Add( "PlayerCanPickupWeapon", "ShouldGrabWeapon", function(ply, wep)

	if ply.CanPickupWeapons == true || wep._CanPickUpWeapon == false then
		return
	end

	timer.Create( "PlyCheckWeapons"..ply:EntIndex(), 0.1, 1, function() PlayerCheckWeapons(ply ) end)
	if ply:InvGrabEnt( wep, nil ) != false then
		wep:Remove()
		wep._CanPickUpWeapon = false
	end

	return false
end )
