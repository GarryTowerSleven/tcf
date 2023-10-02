AddCSLuaFile()

SWEP.Base 					= "weapon_virusbase"

//Basic Setup
SWEP.PrintName				= "Dual Silencers"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

//Types
SWEP.HoldType				= "duel"
SWEP.GunType				= "default"  //for muzzle/shell effects  (default, shotgun, rifle, highcal, or scifi)

//Models
SWEP.ViewModel				= "models/weapons/v_vir_dsilen.mdl"
SWEP.WorldModel				= "models/weapons/w_vir_dsilen.mdl"

//Primary
SWEP.Primary.ClipSize		= 36
SWEP.Primary.DefaultClip	= 36
SWEP.Primary.Ammo			= "Pistol"
SWEP.Primary.Delay			= 0.09
SWEP.Primary.Recoil	 		= 2
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Damage			= { 16, 20 }

//Secondary
SWEP.Secondary				= SWEP.Primary
SWEP.Secondary.Anim 		= ACT_VM_SECONDARYATTACK

//Parameters
SWEP.TracerOrigin			= "1"

//Sounds
SWEP.Primary.Sound			= Sound( "gmodtower/virus/weapons/dualsilencer/shoot.wav" )
SWEP.SoundDeploy	 		= Sound( "gmodtower/virus/weapons/dualsilencer/deploy.wav" )
SWEP.SoundReload			= Sound( "gmodtower/virus/weapons/dualsilencer/reload.wav" )

function SWEP:PrimaryAttack()
	self.TracerOrigin = "2"
	if self.BaseClass.PrimaryAttack(self.Weapon) then return end

	self:SetNextSecondaryFire( CurTime() + 0.10 )
end

function SWEP:SecondaryAttack()
	self.TracerOrigin = "1"
	if self.BaseClass.SecondaryAttack(self.Weapon) then return end
	
	self:SetNextPrimaryFire( CurTime() + 0.10 )
end

function SWEP:GetTracerOrigin()
	if not IsValid( self:GetOwner() ) then return end
	
	local vm = self:GetOwner():GetViewModel()
	if not IsValid( vm ) then return end
	
	local attach = vm:LookupAttachment(self.TracerOrigin)
	if attach > 0 then --It returns 0 if the attachment does not exist and -1 if the model is invalid.
		return vm:GetAttachment( attach ).Pos
	end
end