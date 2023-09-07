---------------------------------

-----------------------------------------------------
if SERVER then

	AddCSLuaFile( "shared.lua" )

end



SWEP.Base				= "weapon_base"



SWEP.PrintName 			= "Firework Rocket"



SWEP.ViewModel			= "models/weapons/c_RPG.mdl"
SWEP.UseHands			= true

SWEP.WorldModel 		= "models/weapons/w_rocket_launcher.mdl"



SWEP.Primary.Delay		= 2

SWEP.VIPDelay			= 1.5

SWEP.AdminDelay			= .4



SWEP.HoldType			= "rpg"



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


	self:SetColor(self.Color)
	self:DrawModel()



	local attach = self:LookupAttachment("muzzle")

	if attach > 0 then

		attach = self:GetAttachment(attach)

		attach = attach.Pos

	else

		attach = self.Owner:GetShootPos()

	end



	render.SetMaterial( Material( "sprites/powerup_effects" ) )

	render.DrawSprite( attach, 25, 25, Color( self.Color.r, self.Color.g, self.Color.b, 255 ) )



end



function SWEP:PrimaryAttack()



	if !self:CanPrimaryAttack() then return end



	if self.Owner:IsAdmin() then

		self:SetNextPrimaryFire( CurTime() + self.AdminDelay )

	else



		if SERVER && self.InventoryItem && self.InventoryItem.WeaponFired then

			self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )

		else

			self:SetNextPrimaryFire( CurTime() + self.VIPDelay )

		end



	end



	self.Owner:ViewPunch( Angle( -2, 0, 0 ) )

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

		local bullet = ents.Create( "firework_rocket" )

			bullet:SetAngles( Angle( viewAng.p + 90, viewAng.y, viewAng.r ) )

			bullet:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 16 ) + self.Owner:GetRight() * 8 )

			bullet:SetPhysicsAttacker( self.Owner )

			bullet:SetOwner( self.Owner )

			bullet.Color = self.Color

		bullet:Spawn()

		bullet:Activate()

		bullet:DoFirework(true)



		local phys = bullet:GetPhysicsObject()

		if IsValid( phys ) then

			phys:SetVelocity( self.Owner:GetAimVector() * 800 )

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

function SWEP:CanPrimaryAttack() 
	return !Location.IsEquippablesNotAllowed( self.Owner._Location )
end

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

function SWEP:PreDrawViewModel(vm)
	local c = self.Color
	render.SetColorModulation(c.r / 255, c.g / 255, c.b / 255)
end

function SWEP:PostDrawViewModel(vm)
	render.SetColorModulation(1, 1, 1)


end

