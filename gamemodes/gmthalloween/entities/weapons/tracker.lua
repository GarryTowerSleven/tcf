AddCSLuaFile()

SWEP.Base				= "weapon_base"

SWEP.PrintName 			= "Ghost Tracker"
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.HoldType			= "ar2"

SWEP.ViewModel			= "models/weapons/v_alyxgun.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.UseHands = false

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Battery"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

if SERVER then

	local BatteryRemoveDelay = .25 -- Remove battery every X seconds
	local BatteryAddDelay = .35 -- Add battery every X seconds
	hook.Add( "Think", "TrackerThink", function()

		for _, ply in ipairs( player.GetAll() ) do

			if not ply.BatteryUpdate then ply.BatteryUpdate = CurTime() end

			if ply.BatteryUpdate < CurTime() then

				local wep = ply:GetActiveWeapon()
				if IsValid( wep ) and wep:GetClass() == "tracker" then

					if ply:GetAmmoCount( "Battery" ) > 0 then
						ply:RemoveAmmo( 1, "Battery" )
						ply.BatteryUpdate = CurTime() + BatteryRemoveDelay
					end

				else

					if ply:GetAmmoCount( "Battery" ) < 100 then
						ply:GiveAmmo( 1, "Battery", true )
						ply.BatteryUpdate = CurTime() + BatteryAddDelay
					end

				end

			end

		end

	end )

end

function SWEP:Think()

end

function SWEP:Precache()
end

function SWEP:Deploy()
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

if CLIENT then

	function SWEP:Think()

		local pos = self.Owner:EyePos()
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			
			dlight.Pos = pos
			dlight.r = 50
			dlight.g = 50
			dlight.b = 255
			dlight.Brightness = 6

			local size = 128
			if self:GetBatteryPercent() <= 0 then
				size = 48
			end

			dlight.Size = size
			//dlight.Decay = dlight.Size * 5
			dlight.DieTime = CurTime() + .1
			dlight.Style = 1
		end

		return true

	end

	function SWEP:GetBatteryPercent()
		return self.Owner:GetAmmoCount( self.Primary.Ammo ) / self.Primary.DefaultClip
	end

end