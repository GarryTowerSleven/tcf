SWEP.Base					= "weapon_base"

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.DrawCrosshair	 = false
end

SWEP.PrintName 			 = "Toy Hammer"
SWEP.Slot				 = 0
SWEP.SlotPos			 = 1

SWEP.ViewModel			 = "models/weapons/v_pvp_toy.mdl"
SWEP.WorldModel			 = "models/weapons/w_pvp_toy.mdl"
SWEP.ViewModelFlip		 = false
SWEP.HoldType			 = "melee"

SWEP.Primary.Automatic	= true
SWEP.Primary.UnlimAmmo	= true
SWEP.Primary.Effect		= "toy_zap"
SWEP.Primary.Sound		= "GModTower/pvpbattle/ToyHammer/ToyZap.wav"
SWEP.Primary.Damage		= {8, 12}

SWEP.Secondary.Damage	= {80, 90}

SWEP.AutoReload			= false

SWEP.SoundDeploy		= Sound("GModTower/pvpbattle/ToyHammer/ToyDeploy.wav")
SWEP.SoundSwing			= Sound("weapons/iceaxe/iceaxe_swing1.wav")

SWEP.CrosshairDisabled	= true
SWEP.LaserDelay			= CurTime()

SWEP.MeleeHitSound		= {	"GModTower/pvpbattle/ToyHammer/ToyHit1.wav",
							"GModTower/pvpbattle/ToyHammer/ToyHit2.wav",
							"GModTower/pvpbattle/ToyHammer/ToyHit3.wav" }

SWEP.Description		= "Squeak your opponents to their death. Doesn't deal much damage, so be careful."
SWEP.StoreBuyable		= true
SWEP.StorePrice 		= 0

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:Think()
	self.BaseClass:Think()

	if self.LaserDelay < CurTime() then
		self.Owner._LaserOn = false
	end

	self:SetHoldType("melee")
end

function SWEP:FireLaser()

	self:SetNextPrimaryFire( CurTime() + 1 )
	self.Owner._LaserOn = true
	self.LaserDelay = CurTime() + 0.15

	self:ShootBullet(self.Primary.Damage, 1, 0, "none")
	self:ShootEffects(self.Primary.Sound, Angle( 2, 1, 0 ), self.Primary.Effect, ACT_VM_HITCENTER)

end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end


		self:SetNextPrimaryFire( CurTime() + 0.5 )
		self:ShootMelee( self.Primary.Damage, self.MeleeHitSound, self.MeleeHitSound, self.SoundSwing )

end


function SWEP:ShootMelee( dmg, hitworld_sound, hitply_sound, miss_sound )

	local trace = util.TraceHull({start=self.Owner:GetShootPos(),
			endpos=self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50,
			mins=Vector(-8, -8, -8), maxs=Vector(8, 8, 8),
			filter=self.Owner})

	local sound = miss_sound

	if trace.Hit then
		sound = hitply_sound
	end

	if sound && IsFirstTimePredicted() then
		if type(sound) == "table" then
			self.Weapon:EmitSound( sound[math.random(1, #sound)], 80 )
		else
			self.Weapon:EmitSound( sound, 80 )
		end
	end

	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if SERVER && IsValid(trace.Entity) && trace.Entity:IsPlayer() then
		local bdmg = 0

		if type(dmg) == "table" then
			bdmg	= math.random(dmg[1],dmg[2])
		else
			bdmg	= dmg
		end

		trace.Entity:TakeDamage(bdmg)
	end
end

function SWEP:SecondaryAttack()

	if ( !self.Owner:IsAdmin() ) then return end

	if !string.StartWith(game.GetMap(),"gmt_lobby") then return end

	self:FireLaser()

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