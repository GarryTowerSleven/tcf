SWEP.Base 					= "weapon_virusbase"

if SERVER then
	AddCSLuaFile( "shared.lua" )
else
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFlip		= false
end

//Basic Setup
SWEP.PrintName				= "Adrenaline"
SWEP.Slot					= 0

//Types
SWEP.HoldType				= "grenade"

//Models
SWEP.ViewModel				= Model("models/weapons/v_vir_adrenaline.mdl")
SWEP.WorldModel				= Model("models/weapons/w_vir_adrenaline.mdl")

//Parameters
SWEP.Duration				= 10
SWEP.Used					= false

//Sounds
SWEP.Primary.Sound			= Sound("GModTower/virus/weapons/Adrenaline/use.wav")
SWEP.SoundDeploy			= Sound("GModTower/virus/weapons/Adrenaline/deploy.wav")
SWEP.ExtraSounds				= Sound("GModTower/virus/weapons/Adrenaline/heartbeat.wav")

function SWEP:PrimaryAttack()

	if !IsFirstTimePredicted() || self.Used then return end

	self.Used = true

	self.Owner:EmitSound( self.SoundDeploy )

	local vm = self.Owner:GetViewModel()
	if IsValid( vm ) then

		local sequence = vm:LookupSequence( "adrenaline_injection" )
		vm:SetSequence( sequence )

	end

	self.Owner.AdrenalineStart = CurTime() + 0.5

end

function SWEP:CanSecondaryAttack() return false end