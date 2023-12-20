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

SWEP.DrawCrosshair = true

SWEP.Primary.Delay	 = .8
SWEP.Primary.ClipSize = 6

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Reloading" )
	self:NetworkVar( "Float", 0, "NextReload" )

end

function SWEP:PrimaryAttack()

	if !self:CanPrimaryAttack() || self:GetNextReload() > CurTime() then return end
	
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	if SERVER then
		self.Owner:SetVelocity( self.Owner:GetAimVector() * -500 * math.max( self:Clip1(), 1 ), 0 )
	end

	self:SetClip1( -1 )
	self:ShootEffects()

end

function SWEP:Think()

	self.BaseClass.Think( self )

	if self:GetOwner():KeyDown( IN_RELOAD ) && self:Clip1() != 6 then

		if !self:GetReloading() then

			self:SetReloading( true )
			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_START )
			self:SetNextReload( CurTime() + 0.1 )

		elseif self:GetNextReload() < CurTime() then

			self:SetClip1( math.max( self:Clip1(), 1 ) + 1 )
			self:SendWeaponAnim( ACT_VM_RELOAD )
			self:SetNextReload( CurTime() + 0.25 )

		end

	else

		if self:GetReloading() then

			self:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )
			self:SetNextReload( CurTime() + 0.5 )

		end

		self:SetReloading( false )

	end

end

function SWEP:ShootEffects(sound, recoil)

	self.BaseClass.ShootEffects(self.Weapon, sound, recoil)
	self.Weapon:EmitSound("GModTower/pvpbattle/SuperShotty/SSGFire.wav", 75, 100, .4, CHAN_WEAPON )

end

function SWEP:CanPrimaryAttack()
	return !Location.IsEquippablesNotAllowed( self.Owner._Location )
end

function SWEP:CanSecondaryAttack()
	return false
end
