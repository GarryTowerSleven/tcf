
-----------------------------------------------------
SWEP.Base = "weapon_base"



if SERVER then

	AddCSLuaFile( "shared.lua" )

end



if CLIENT then

	SWEP.DrawAmmo			= true

	SWEP.DrawCrosshair		= false

	SWEP.ViewModelFOV		= 64

	SWEP.CSMuzzleFlashes	= false

	killicon.AddFont("ammo_snowball", "HL2MPTypeDeath", "5", Color(0, 0, 0, 255))

end



SWEP.PrintName 				= "Snowball"

SWEP.Slot 					= 5

SWEP.SlotPos				= 0



SWEP.Spawnable				= true

SWEP.AdminSpawnable			= true



SWEP.ViewModel				= "models/weapons/v_snowball.mdl"

SWEP.WorldModel				= "models/weapons/w_snowball.mdl"

SWEP.ViewModelFlip			= true

SWEP.HoldType				= "grenade"



SWEP.Primary.Delay			= 1.2

SWEP.Primary.Cone			= 0

SWEP.Primary.ClipSize		= -1

SWEP.Primary.DefaultClip	= -1

SWEP.Primary.Ammo			= "none"



function SWEP:Initialize()



	self:SetWeaponHoldType( self.HoldType )



end


function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "IdleTime" )

end

function SWEP:PrimaryAttack()

	if !self:CanPrimaryAttack() then return end



	if self.Owner:IsAdmin() then

		self.Weapon:SetNextPrimaryFire(CurTime() + 0.25)

	else

		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	end



	self.Owner:ViewPunch(Angle(5, 0, 0))

	self.Owner:SetAnimation(PLAYER_ATTACK1)

	self.Weapon:SendWeaponAnim(ACT_VM_THROW)

	self:UpdateIdle()



	if !IsFirstTimePredicted() then return end



	--Not sure if we should be creating a timer each time - so let's check if it's already there.

	if !timer.Exists("SnowBallIdle" .. self.Owner:UserID()) then

		timer.Create("SnowBallIdle" .. self.Owner:UserID(), self.Primary.Delay, 1, function()

			if !IsValid(self.Weapon) or !self.Weapon:IsValid() then return end

			self.Weapon:SendWeaponAnim(ACT_VM_IDLE)

		end )

	else

		timer.Start("SnowBallIdle" .. self.Owner:UserID())

	end



	if SERVER then

		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav", 75, math.random( 110, 125 ))

		self:ShootSnow(3000)



		if self.InventoryItem && self.InventoryItem.WeaponFired then

			self.InventoryItem:WeaponFired()

		end

	end

end

function SWEP:UpdateIdle()

	local vm = self:GetOwner():GetViewModel()
	self:SetIdleTime( CurTime() + vm:SequenceDuration( vm:GetSequence() ) )

end

function SWEP:Think()
	
	if self:GetIdleTime() < CurTime() then

		self:SendWeaponAnim( ACT_VM_IDLE )
		self:UpdateIdle()

	end

end


function SWEP:ShootSnow(force)

	if CLIENT then return end



	local ent = ents.Create("prop_snowball")

	if ent then

		ent:SetAngles(self.Owner:EyeAngles())

		ent:SetPos(self.Owner:GetShootPos())

		ent:SetOwner(self.Owner)

		ent:SetPhysicsAttacker(self.Owner)

		ent:Spawn()

		ent:Activate()



		local phys = ent:GetPhysicsObject()

		if IsValid(phys) then

			phys:SetVelocity( self.Owner:GetVelocity() + (self.Owner:GetAimVector() * force) )

		end

	end

end



function SWEP:Deploy()

	self:SendWeaponAnim( ACT_VM_DEPLOY )
	self:UpdateIdle()



	if SERVER then

		if self.InventoryItem && self.InventoryItem.WeaponDeployed then

			self.InventoryItem:WeaponDeployed()

		end

	end



	return true

end



function SWEP:Holster()

	if timer.Exists("SnowBallIdle" .. self.Owner:UserID()) then

		timer.Destroy( "SnowBallIdle" .. self.Owner:UserID() )

	end



	if SERVER then

		if self.InventoryItem && self.InventoryItem.WeaponHolstered then

			self.InventoryItem:WeaponHolstered()

		end

	end



	return true

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