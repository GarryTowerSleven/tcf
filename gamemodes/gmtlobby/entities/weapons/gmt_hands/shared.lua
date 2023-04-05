if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_base"
SWEP.NoBank				= true
SWEP.WeaponSafe 		= true

SWEP.PrintName 			= "Hands"
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.HoldType			= "normal"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

if SERVER then
	function SWEP:Think()
		if IsValid( self.Owner ) then
			self.Owner:DrawViewModel( false )
			self.Owner:DrawWorldModel( false )
		end
		self:DrawShadow( false )
	end
end

function SWEP:Precache()
end

if SERVER then
	function SWEP:Deploy()
		if IsValid( self.Owner ) then
			self.Owner:DrawViewModel( false )
			self.Owner:DrawWorldModel( false )
		end
		self:DrawShadow( false )
	end
end

function SWEP:Holster()
	return true
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:DrawWorldModel()
end