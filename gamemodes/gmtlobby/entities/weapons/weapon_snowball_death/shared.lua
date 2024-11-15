SWEP.Base = "weapon_base"

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 64
	SWEP.CSMuzzleFlashes	= false
	killicon.AddFont("prop_snowball", "HL2MPTypeDeath", "5", Color(0, 0, 0, 255))
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

SWEP.Primary.Delay			= .5
SWEP.Primary.Cone			= 0
SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self.Owner:ViewPunch(Angle(5, 0, 0))
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:SendWeaponAnim(ACT_VM_THROW)

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
		self.Owner:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
		self:ShootSnow(1250)
	end
end

function SWEP:ShootSnow(force)
	if CLIENT then return end

	local ent = ents.Create("prop_snowball_death")
	if ent then
		ent:SetAngles(self.Owner:EyeAngles())
		ent:SetPos(self.Owner:GetShootPos())
		ent:SetOwner(self.Owner)
		ent:SetPhysicsAttacker(self.Owner) 
		ent:Spawn()
		ent:Activate()

		local phys = ent:GetPhysicsObject()
		if phys then
			phys:SetVelocity( self.Owner:GetVelocity() + (self.Owner:GetAimVector() * force) )
		end
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_IDLE)
	return true
end

function SWEP:Holster()
	if timer.Exists("SnowBallIdle" .. self.Owner:UserID()) then
		timer.Destroy( "SnowBallIdle" .. self.Owner:UserID() )
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


if CLIENT then

	local x, y, wd, hg, alpha = math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.3), math.Rand(10, 25), math.Rand(10, 25), 0

	local mat = CreateMaterial( "SnowImpactHUD", "UnlitGeneric", {
		["$basetexture"] = "decals/snow01",
		["$translucent"] = 1,
		["$vertexalpha"] = 1
	} )

	hook.Add( "HUDPaintBackground", "SnowHit", function()

		if alpha > 0 then

			alpha = alpha - FrameTime() * 24

		else

			return

		end

		local w, h = 64, 64

		surface.SetMaterial( mat )

		surface.SetDrawColor(255, 255, 255, alpha)

		surface.DrawTexturedRect(ScrW() * x, ScrH() * y, w * wd, h * hg)

	end)



	usermessage.Hook("SnowHit", function()



			x = math.Rand(-0.5, 0.5)

			y = math.Rand(-0.5, 0.3)

			wd = math.Rand(10, 25)

			hg = wd * math.Rand(0.8, 1.2)

			alpha = 128



		end)



end
