---------------------------------
if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base = "weapon_pvpbase"
SWEP.NoBank				= true

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName 		 = "Jumper Super Shotty"
SWEP.Slot		 = 0
SWEP.SlotPos		 = 0

SWEP.ViewModel		 = "models/weapons/v_pvp_supershoty.mdl"
SWEP.WorldModel		 = "models/weapons/w_pvp_supershoty.mdl"
SWEP.HoldType		 = "shotgun"

SWEP.DrawCrosshair = false

SWEP.Primary.Delay	 = .8

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:ShootEffects()

end

function SWEP:ShootEffects(sound, recoil)
	self.BaseClass.ShootEffects(self.Weapon, sound, recoil)
	self.Weapon:EmitSound("GModTower/pvpbattle/SuperShotty/SSGFire.wav", 75, 100, .4, CHAN_WEAPON )
	if SERVER then
		self.Owner:SetVelocity( self.Owner:GetAimVector() * -500, 0 )
	end
end

function SWEP:CanSecondaryAttack()
	return false
end
