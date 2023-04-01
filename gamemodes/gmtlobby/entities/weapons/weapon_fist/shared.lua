SWEP.Base = "weapon_rage"
SWEP.Primary.Damage		= {40, 60}

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self:ShootMelee( self.Primary.Damage, self.FistHit, self.FistHitFlesh, self.FistMiss )
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end