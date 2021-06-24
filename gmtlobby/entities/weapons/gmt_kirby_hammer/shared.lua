SWEP.Base					= "weapon_base"

if SERVER then
	AddCSLuaFile( "shared.lua" )
	util.AddNetworkString("JumpPuff")
end

if CLIENT then
	SWEP.DrawCrosshair		= false
end

SWEP.PrintName 				= "Kirby Hammer"
SWEP.Slot					= 0
SWEP.SlotPos				= 2

SWEP.ViewModel				= "models/weapons/v_kirby_hammer.mdl"
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

	if Location.IsTheater( GTowerLocation:FindPlacePos(self:GetOwner():GetPos()) ) then return end

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
		if IsValid(trace.Entity) && (trace.Entity:IsPlayer() or trace.Entity:IsNPC()) then
			sound = hitply_sound
		else
			sound = miss_sound
		end
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

if SERVER then

function SWEP:Think()
	if !self.Owner:Alive() then return end
	self:NextThink(CurTime() + 6)
end

end

hook.Add( "KeyPress", "keypress_jump_super_l", function( ply, key )
	if not IsFirstTimePredicted() then return end
	if !IsValid( ply:GetActiveWeapon() ) or ply:GetActiveWeapon():GetClass() != "gmt_kirby_hammer" then return end
	if Location.IsTheater( GTowerLocation:FindPlacePos(ply:GetPos()) ) then return end
	if ( key == IN_JUMP ) then
		if ply:CanDoubleJump() && SERVER then
			ply:DoubleJump()
			net.Start("JumpPuff")
			net.WriteEntity(ply)
			net.Broadcast()
		end
	end
end )

hook.Add( "OnPlayerHitGround", "ResetDoubleJump", function( ply )
	ply.FirstDoubleJump = true
end )

net.Receive("JumpPuff",function()
	local ent = net.ReadEntity()
	if !IsValid(ent) then return end
	local vPoint = ent:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "jump_puff", effectdata)
end)

local meta = FindMetaTable( "Player" )

function meta:CanDoubleJump()

	local add = 36; //how much to increase the required z velocity per jump
	local numjumps = 1; //how many jumps you're allowed before increasing the required z velocity

	local num = -( 150 - ( add * numjumps ) + ( add * self:GetNWInt( "DoubleJumpNum" ) ) )

	if !self:IsOnGround() and self.FirstDoubleJump then
		return true
	else
	   return false
   end

end

function meta:DoubleJump()

	local upward_velocity = 175

	self:SetVelocity((self:GetVelocity() * 0.6 )+Vector(0,0,upward_velocity));

	self.FirstDoubleJump = false
	self:EmitSound( "GModTower/gourmetrace/actions/jump.wav", 60, math.random(100,110) )
	self:SetNWInt( "DoubleJumpNum", self:GetNWInt( "DoubleJumpNum" ) + 1 )

end
