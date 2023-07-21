if ( SERVER ) then
AddCSLuaFile( "shared.lua" )
end

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName 			= "Smith's Hands"
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.ViewModel			= "models/weapons/c_arms_citizen.mdl"
SWEP.WorldModel			= ""

SWEP.Primary.Delay		= 1
local TotalTime = 7.5
--local heartsound = Sound(ply, "player/heartbeat1.wav")

function SWEP:Deploy()
	self.Owner:DrawViewModel(true)
	local vm = self:GetOwner():GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	vm:SetPlaybackRate( 1 )
	self.Owner:DrawWorldModel(false)
end

local function UpdatePlayerColor( ply, TargetTime )

	local Color2 = ( TargetTime - CurTime() ) / TotalTime * 255

	print(Color2)
	if IsValid( ply ) then
		ply:SetColor( Color(Color2, Color2, Color2) )
	end

end

local function EndPlayerTransformation( ply, owner )

	if IsValid( ply ) then //Make sure it is valid, otherwise, if the player disconnects, it is going to give errors

		ply:StopSound("player/heartbeat1.wav")
		ply:EmitSound("vo/npc/Barney/ba_laugh02.wav", 120)

		ply:SetColor(Color(255, 255, 255))
		ply:SetModel("models/player/smith.mdl")
		ply:Freeze(false)

	end

	if IsValid( owner ) then

		timer.Destroy("SmithTransform" .. owner:UserID())
		owner:EmitSound("ambient/energy/whiteflash.wav", 120)
		owner:Freeze( false )

	end


end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() or self.Owner:GetPos():Distance(self.Owner:GetEyeTrace().Entity:GetPos()) > 50 then return end
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

	self.Owner:ViewPunch( Angle( -20, 0, 0 ) )

	if !IsFirstTimePredicted() then return end

	if SERVER then

		local ply = self.Owner:GetEyeTrace().Entity

		if ply:IsPlayer() and self.Owner:IsAdmin() then
			/*if self.Owner:GetModel() != "models/player/smith.mdl" then
				self.Owner:Msg2("You don't seem to be real Agent Smith!")
				return
			end*/

			self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )

			ply:Freeze(true)

			if SMITH then
				ply.CanPickupWeapons = true
				ply:Give("clone_maker")
				ply:SelectWeapon( "clone_maker" )
				ply.CanPickupWeapons = false
			end

			self.Owner:Freeze(true)

			ply:EmitSound("vo/npc/Barney/ba_pain08.wav", 120)
			self.Owner:EmitSound("vo/gman_misc/gman_04.wav", 120)

			local vm = self:GetOwner():GetViewModel()
			vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_uppercut" ) )
			vm:SetPlaybackRate( 1 )


			ply:EmitSound("physics/body/body_medium_break2.wav")
			self:SetHoldType("pistol")

			timer.Simple(1, function()
				vm:SetPlaybackRate(0.01)
			end)

			self.Time = CurTime() + TotalTime
			timer.Create( "SmithTransform" .. self.Owner:UserID(), 0.01, TotalTime * 100, function()
				UpdatePlayerColor(ply, self.Time)
			end)
			timer.Simple( TotalTime, function()
				EndPlayerTransformation(ply, self.Owner)
				self:SetHoldType("normal")
			end)
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

if CLIENT then return end
