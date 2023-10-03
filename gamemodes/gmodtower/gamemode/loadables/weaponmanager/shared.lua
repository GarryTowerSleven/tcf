AddCSLuaFile("shared.lua")

if CLIENT then return end

local playerMeta = FindMetaTable( "Player" )
local weapMeta = FindMetaTable( "Weapon" )

function playerMeta:GiveWeapon( weaponclass )

	self.CanPickupWeapons = true

	local weapon = self:Give( weaponclass )
	weapon.IsTemp = true

	self.CanPickupWeapons = false
	self:SelectWeapon( weaponclass )

	return weapon

end

function playerMeta:Refill( weapon, ammo )

	ammo = ammo or 1
	if weapon.GetPrimaryAmmoType then
		self:GiveAmmo( ammo, weapon:GetPrimaryAmmoType(), true )
	end

end

function playerMeta:GiveTempWeapon( weaponclass, ammo, removeon, location )

	if !self:Alive() then return end

	local weapon = nil

	// Give them the weapon
	if !self:HasWeapon( weaponclass ) then

		weapon = self:GiveWeapon( weaponclass )
		if ammo then
			self:Refill( weapon, ammo )
		end

	else // We already have it

		if self:GetActiveWeapon():GetClass() != weaponclass then
			self:SelectWeapon( weaponclass )
		end
		weapon = self:GetWeapon( weaponclass ) or self:GetActiveWeapon()

	end

	// We already have it, let's not set it up again
	if self.TempWeapons && table.HasValue( self.TempWeapons, weapon ) then
		return
	end

	if removeon then
		weapon.RemoveOn = removeon
	end

	if location && Location then
		weapon.LocationGiven = location
	end

	// Store
	if !self.TempWeapons then self.TempWeapons = {} end
	table.insert( self.TempWeapons, weapon )

end

function playerMeta:RemoveTempWeapon( weapon )

	if !weapon then return end

	if table.HasValue( self.TempWeapons, weapon ) then
		table.remove( self.TempWeapons, table.KeyFromValue( self.TempWeapons, weapon ) )
	end

	if weapon.IsTempWeapon && weapon:IsTempWeapon() then
		self:StripWeapon( weapon:GetClass() )
	end

	if #self.TempWeapons == 0 then
		self.TempWeapons = nil
	end

end

function playerMeta:IsValidTempWeapon( weapon )

	if !weapon then return false end

	if weapon != self:GetActiveWeapon() then
		return false
	end

	if weapon.RemoveOn && weapon.RemoveOn( self ) then
		return false
	end

	if weapon.LocationGiven then

		local loc = weapon.LocationGiven
		local id = weapon:Location()
		
		if type( loc ) == "table" then
			return table.HasValue( loc, id )
		end

		return loc == id

	end

	return true

end

function playerMeta:RemoveAllTempWeapons()

	if !self.TempWeapons then return end

	for id, weapon in pairs( self.TempWeapons ) do
		self:RemoveTempWeapon( weapon )
	end

end

function playerMeta:CheckTempWeapons()

	if !self.TempWeapons then return end

	for id, weapon in pairs( self.TempWeapons ) do

		if !self:IsValidTempWeapon( weapon ) then
			self:RemoveTempWeapon( weapon )
		end

	end

end

hook.Add( "PlayerThink", "CheckTempWeapons", function( ply )
	ply:CheckTempWeapons()
end )

function weapMeta:IsTempWeapon()
	return self.IsTemp
end