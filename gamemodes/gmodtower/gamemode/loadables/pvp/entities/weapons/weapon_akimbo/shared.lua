AddCSLuaFile()

SWEP.Base = "weapon_pvpbase"

SWEP.PrintName	= "Akimbo"
SWEP.Slot		= 2
SWEP.SlotPos	= 1

SWEP.ViewModel		= "models/weapons/v_pvp_akimbo.mdl"
SWEP.WorldModel		= "models/weapons/w_pvp_akimbo.mdl"
SWEP.ViewModelFlip	= false
SWEP.HoldType		= "pistol"

SWEP.Primary.Delay			= 0.3
SWEP.Primary.Damage			= {12, 18}
SWEP.Primary.Cone			= 0.04
SWEP.Primary.ClipSize		= 24
SWEP.Primary.DefaultClip	= 24

SWEP.Primary.Ammo	 = "SMG1"
SWEP.Primary.Sound	 = {
	Sound( "gmodtower/pvpbattle/akimbo/akimbofire1.wav" ),
	Sound( "gmodtower/pvpbattle/akimbo/akimbofire2.wav" )
}

SWEP.Secondary		= SWEP.Primary

SWEP.TracerOrigin	= "1"

SWEP.Description 	= "Two guns are better than one. Primary fire shoots the left pistol; secondary shoots the right. Use this combo to your advantage and you'll end up wondering why CS:S didn't do this."
SWEP.StoreBuyable 	= true
SWEP.StorePrice 	= 550

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:PrimaryAttack()
	self.TracerOrigin = "2"
	if self.BaseClass.PrimaryAttack( self ) then return end

	self:SetNextSecondaryFire( CurTime() + 0.05 )
end

function SWEP:SecondaryAttack()
	self.TracerOrigin = "1"
	if self.BaseClass.SecondaryAttack( self ) then return end

	self:SetNextPrimaryFire( CurTime() + 0.05 )
end

function SWEP:GetTracerOrigin()
	if not IsValid( self:GetOwner() ) then return end
	
	local vm = self:GetOwner():GetViewModel()
	if not IsValid( vm ) then return end
	
	local attach = vm:LookupAttachment(self.TracerOrigin)
	if attach > 0 then
		return vm:GetAttachment( attach ).Pos
	end
end
