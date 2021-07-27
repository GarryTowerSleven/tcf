SWEP.Base					= "weapon_base"

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.DrawCrosshair		= false
end

SWEP.PrintName 				= "Kirby Hammer"
SWEP.Slot					= 0
SWEP.SlotPos				= 2

SWEP.ViewModel				= "models/weapons/v_shanasw.mdl"
SWEP.WorldModel				= "models/bumpy/kirby_hammer.mdl"
SWEP.ViewModelFlip			= false
SWEP.HoldType				= "melee2"

SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Damage			= {35, 45}
SWEP.Primary.Delay			= 1

SWEP.CrosshairDisabled	 	= true
SWEP.SwordHit				= "GModTower/gourmetrace/actions/hammer_hitblock.wav"
SWEP.SwordHitFlesh			= {	"GModTower/gourmetrace/actions/hammer_hitblock.wav",
								"GModTower/gourmetrace/actions/hammer_hitblock.wav",
								"GModTower/gourmetrace/actions/hammer_hitblock.wav",
								"GModTower/gourmetrace/actions/hammer_hitblock.wav" }
SWEP.SwordMiss				= {	"GModTower/gourmetrace/actions/hammer1.wav",
								"GModTower/gourmetrace/actions/hammer2.wav" }

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	/*if IsFirstTimePredicted() then
		self.Weapon:EmitSound( self.SwordSwing[#self.SwordSwing] )
	end*/

	self:ShootMelee( self.Primary.Damage, self.SwordHit, self.SwordHitFlesh, self.SwordMiss )
end

function SWEP:ShootMelee( dmg, hitworld_sound, hitply_sound, miss_sound )

	local trace = util.TraceHull({start=self.Owner:GetShootPos(),
			endpos=self.Owner:GetShootPos() + self.Owner:GetAimVector() * 50,
			mins=Vector(-8, -8, -8), maxs=Vector(8, 8, 8),
			filter=self.Owner})

	local sound = miss_sound

	if trace.Hit then
		if IsValid(trace.Entity) && trace.Entity:IsPlayer() and trace.Entity:Team() != TEAM_COMPLETED then
			trace.Entity:SetVelocity(self.Owner:GetForward() * 800 + Vector(0,0,200))
			if SERVER then
				self.Owner:AddAchievement(ACHIEVEMENTS.GRHAMMER,1)
			end
			sound = hitply_sound
		elseif IsValid(trace.Entity) && trace.Entity:GetClass() == "star_block" then
			local block = trace.Entity
			self.Owner:EmitSound("gmodtower/gourmetrace/actions/hammer_hitblock.wav")
			if SERVER then
				block:Break()
			end
		else
			sound = miss_sound
		end
	end

	if sound && IsFirstTimePredicted() then
		if type(sound) == "table" then
			self.Weapon:EmitSound( sound[math.random(1, #sound)] )
		else
			self.Weapon:EmitSound( sound )
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
	end
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	return true
end

if CLIENT then return end


function SWEP:Think()
	if !self.Owner:Alive() then return end
	self:NextThink(CurTime() + 6)
end
