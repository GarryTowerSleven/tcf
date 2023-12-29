---------------------------------
SWEP.Base = "weapon_pvpbase"

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.DrawCrosshair	= false
end

SWEP.PrintName 			= "Fists"
SWEP.Slot			= 0
SWEP.SlotPos			= 1
SWEP.Wait = false

SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= ""
SWEP.ViewModelFlip		= false
SWEP.HoldType			= "fist"

SWEP.Primary.Automatic		= true
SWEP.Primary.UnlimAmmo		= true
SWEP.Primary.Damage		= {100, 125}
SWEP.Primary.Delay		= 0.35

SWEP.Secondary = SWEP.Primary

SWEP.CrosshairDisabled	 	= true
SWEP.FistHit			= 	"GModTower/pvpbattle/Rage/RageHit.wav"
SWEP.FistHitFlesh		= {	"GModTower/pvpbattle/Rage/RageFlesh1.wav",
					"GModTower/pvpbattle/Rage/RageFlesh2.wav",
					"GModTower/pvpbattle/Rage/RageFlesh3.wav",
					"GModTower/pvpbattle/Rage/RageFlesh4.wav" }
SWEP.FistMiss			= {	"GModTower/pvpbattle/Rage/RageMiss1.wav",
					"GModTower/pvpbattle/Rage/RageMiss2.wav"  }

SWEP.UseHands = true
SWEP.ViewModelFOV = 54

util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

function SWEP:SetupDataTables()

	self:NetworkVar( "Int", 0, "Hits" )
	self:NetworkVar( "Float", 0, "IdleTime" )

end

function SWEP:SendAnim( seq, speed )

	local owner = self:GetOwner()

	if !IsValid( owner ) then return end

	local vm = owner:GetViewModel()

	if IsValid( vm ) then

		speed = speed || 1
		vm:SendViewModelMatchingSequence( vm:LookupSequence( seq ) )
		vm:SetPlaybackRate( speed )

		self:SetIdleTime( CurTime() + vm:SequenceDuration( vm:GetSequence() ) / speed )

	end

end

function SWEP:Deploy()

	if SERVER && self.InventoryItem && self.InventoryItem.WeaponDeployed then
		self.InventoryItem:WeaponDeployed()
	end

	self:SendAnim( "fists_draw" )

	return true

end

function SWEP:Holster()
	if SERVER && self.InventoryItem && self.InventoryItem.WeaponHolstered then
		self.InventoryItem:WeaponHolstered()
	end

	return true
end

function SWEP:PrimaryAttack()
	if IsLobby and !Dueling.IsDueling( self.Owner ) and !self.Owner:IsAdmin() then self.Primary.Damage = 0 end
	if !self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self:ShootMelee( self.Primary.Damage, self.FistHit, self.FistHitFlesh, self.FistMiss )
	self:SendAnim( self:GetHits() % 2 == 1 && "fists_left" || "fists_right", 1.4 )
	self:SetHits( self:GetHits() + 1 )

	if SERVER then
		if self.InventoryItem && self.InventoryItem.WeaponFired then
			self.InventoryItem:WeaponFired()
		end
	end
end

function SWEP:SecondaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	self:PrimaryAttack()
end

function SWEP:Think()

	if self:GetIdleTime() < CurTime() then

		self:SendAnim( "fists_idle_01" )

	end

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
