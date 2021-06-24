---------------------------------

-----------------------------------------------------
if SERVER then

	AddCSLuaFile( "shared.lua" )

end



SWEP.Base				= "weapon_base"



SWEP.PrintName 			= "Golden Cleaver"



SWEP.ViewModel			= ""

SWEP.WorldModel 		= "models/weapons/c_models/c_sd_aussclv/c_sd_cleaver.mdl"



SWEP.Primary.Delay		= 2

SWEP.VIPDelay			= 1.5

SWEP.AdminDelay			= .4



SWEP.HoldType			= "grenade"



function SWEP:Initialize()



	self:SetWeaponHoldType( self.HoldType )

	self.Color = self:GetRandomColor()



end



function SWEP:Deploy()



	self.Color = self:GetRandomColor()



	if SERVER && self.InventoryItem && self.InventoryItem.WeaponDeployed then

		self.InventoryItem:WeaponDeployed()

	end



	return true



end



function SWEP:Holster()



	if SERVER && self.InventoryItem && self.InventoryItem.WeaponHolstered then

		self.InventoryItem:WeaponHolstered()

	end



	return true



end



function SWEP:DrawWorldModel()
	self:DrawModel()
end



function SWEP:PrimaryAttack()



	if !self:CanPrimaryAttack() then return end

	if Location.IsTheater(self.Owner.GLocation) then return end

	if self.Owner:IsAdmin() then

		self:SetNextPrimaryFire( CurTime() + self.AdminDelay )

	else



		if SERVER && self.InventoryItem && self.InventoryItem.WeaponFired then

			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		else

			self:SetNextPrimaryFire( CurTime() + self.VIPDelay )

		end



	end



	self.Owner:ViewPunch( Angle( -20, 0, 0 ) )

	self:ShootEffects()



	if !IsFirstTimePredicted() then return end



	local attach = self:LookupAttachment("muzzle")

	if attach > 0 then

		attach = self:GetAttachment(attach)

		attach = attach.Pos

	else

		attach = self.Owner:GetShootPos()

	end



	if SERVER then



		local viewAng = self.Owner:EyeAngles()

		local bullet = ents.Create( "ammo_cleaver" )

			bullet:SetAngles( Angle( viewAng.p + 90, viewAng.y, viewAng.r ) )

			bullet:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) )

			bullet:SetOwner( self.Owner )


		bullet:Spawn()

		bullet:Activate()



		local phys = bullet:GetPhysicsObject()

		if IsValid( phys ) then

			phys:ApplyForceCenter( self.Owner:GetAimVector() * 750 )

			phys:AddAngleVelocity( Vector( 0, 0, 500 ) )

		end





		if self.InventoryItem && self.InventoryItem.WeaponFired then

			self.InventoryItem:WeaponFired()

		end



		if FunMeter && FunMeter.Enabled then

			self.Owner:AddFunLevel( 50 )

		end



	end



	//get a new random color

	self.Color = self:GetRandomColor()



end



function SWEP:ShootEffects()



	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

	self.Owner:MuzzleFlash()

	self.Owner:SetAnimation( PLAYER_ATTACK1 )



end



function SWEP:Reload() return false end

function SWEP:CanPrimaryAttack() return true end

function SWEP:CanSecondaryAttack() return false end



function SWEP:GetRandomColor()



	local rand = math.random( 0, 6 )

	local color = Color( math.random( 125, 255 ), math.random( 125, 255 ), math.random( 125, 255 ) )

	if rand == 1 then

		color = Color( math.random( 125, 255 ), math.random( 30, 80 ), math.random( 30, 80 ) )

	elseif rand == 2 then

		color = Color( math.random( 30, 80 ), math.random( 125, 255 ), math.random( 30, 80 ) )

	elseif rand == 3 then

		color = Color( math.random( 30, 80 ), math.random( 30, 80 ), math.random( 125, 255 ) )

	elseif rand == 4 then

		color = Color( math.random( 30, 80 ), math.random( 125, 255 ), math.random( 125, 255 ) )

	elseif rand == 5 then

		color = Color( math.random( 125, 255 ), math.random( 30, 80 ), math.random( 125, 255 ) )

	elseif rand == 6 then

		color = Color( math.random( 125, 255 ), math.random( 125, 255 ), math.random( 30, 80 ) )

	end



	return color



end
