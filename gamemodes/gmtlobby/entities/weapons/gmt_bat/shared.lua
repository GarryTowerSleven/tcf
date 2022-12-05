---------------------------------
if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName 			= "Batter"
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.ViewModel			= ""
SWEP.WorldModel			= ""
SWEP.HoldType			= "normal"

SWEP.Primary.Delay		= 1
local TotalTime = 7.5
--local heartsound = Sound(ply, "player/heartbeat1.wav")

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )

end

function SWEP:Deploy()
	self.Owner:DrawViewModel(false)
	self.Owner:DrawWorldModel(false)
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if ply.IsBat then return end

	if (ply.NextBat or 0) > CurTime() then return end

	if ( Location.IsEquippablesNotAllowed( ply:Location() ) ) then return end
	if ( Location.IsCondo( ply:Location(), ply:Location() ) ) then return end

	ply.NextBat = CurTime() + 5

	ply.IsBat = true

	ply.PreBatModel = ply:GetModel()
	ply:SetModel("models/map_detail/vampbat.mdl")

	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	util.Effect( "gmt_adminsmoke_effect", effectdata, true, true )

end

hook.Add("PlayerThink","BatSecureLOL",function(ply)
	if (ply.IsBat && !IsValid(ply:GetActiveWeapon())) or (ply.IsBat && IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetClass() != "gmt_bat") then
		ply:SetModel(ply.PreBatModel)
		ply.IsBat = false
	end
end)

function SWEP:Holster()
	local ply = self:GetOwner()
	if ply.IsBat && key == IN_ATTACK then
		ply:SetModel(ply.PreBatModel)
		ply.IsBat = false
	end
end

hook.Add( "KeyRelease", "UnBat", function(ply, key)

	if ply.IsBat && key == IN_ATTACK then
		ply:SetModel(ply.PreBatModel)
		ply.IsBat = false
	end

end)

hook.Add( "PlayerFootstep", "FootBat", function(ply)

	if ply.IsBat then return true end

end)

hook.Add( "Move", "BatMove", function(ply,mv)

	if ply.IsBat then
		local vel = ply:EyeAngles():Forward() * 1000
		mv:SetVelocity(vel)
	end

end)

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return false
end
