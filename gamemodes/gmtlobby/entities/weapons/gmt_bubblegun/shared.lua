
if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.PrintName 			= "Bubble Gun"
SWEP.Slot				= 0
SWEP.SlotPos			= 0

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel 		= "models/weapons/w_pistol.mdl"
SWEP.UseHands			= true

SWEP.Primary.Delay		= 0.25

SWEP.AdminDelay			= 0.25
SWEP.HoldType			= "pistol"

SWEP.Shooting = false
SWEP.NextCheck = 0

function SWEP:Initialize()

	self:SetWeaponHoldType( self.HoldType )
	self:SetColor(Color(0,255,255))

	if SERVER then return end
	self.NextParticle = CurTime()

end

function SWEP:Deploy()

	self.Color = colorutil.GetRandomColor()

	if SERVER && self.InventoryItem && self.InventoryItem.WeaponDeployed then
		self.InventoryItem:WeaponDeployed()
	end

	return true

end

function SWEP:Holster()
	if SERVER && self.InventoryItem && self.InventoryItem.WeaponHolstered then
		self.InventoryItem:WeaponHolstered()
	end

	if self.Emitter then

		self.Emitter:Finish()
		self.Emitter = nil

	end

	return true
end

function SWEP:DrawWorldModel()

	self:DrawModel()

	local attach = self:LookupAttachment("muzzle")
	if attach > 0 then
		attach = self:GetAttachment(attach)
		attach = attach.Pos
	else
		attach = self.Owner:GetShootPos()
	end

	render.SetMaterial( Material( "sprites/powerup_effects" ) )
	render.DrawSprite( attach, 15, 15, Color( 0,255,255 ) )

	if CLIENT and LocalPlayer() ~= self.Owner then
		if self:GetNWBool("Shooting") then
			if CurTime() < self.NextParticle then return end

			if !self.Emitter then
				self.Emitter = ParticleEmitter( self:GetPos() )
			end

			for i=0, 1 do

				local particle = self.Emitter:Add( "effects/bubble", attach )

				local vel = self.Owner:GetForward() * math.random(10,30) + VectorRand() * 5

				if particle then

					self:GetOwner():EmitSound("ambient/water/rain_drip2.wav",60,math.random(75,125))

					particle:SetVelocity( vel )
					particle:SetDieTime( math.Rand( 1, 10 ) )
					particle:SetStartAlpha( 100 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.random( 1,4 ) )
					particle:SetEndSize( 0 )
					particle:SetRoll( math.Rand( 0, 360 ) )
					particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
					particle:SetColor( math.random( 240, 255 ), math.random( 240, 255 ), math.random( 240, 255 ) )
					particle:SetCollide( true )
				end
			end
			self.NextParticle = CurTime() + 0.05

		end
	end

end

/*function SWEP:ViewModelDrawn()

	local attach = self:LookupAttachment("muzzle")
	if attach > 0 then
		attach = self:GetAttachment(attach)
		attach = attach.Pos
	else
		attach = self.Owner:GetShootPos()
	end

	render.SetMaterial( Material( "sprites/powerup_effects" ) )
	render.DrawSprite( attach, 10, 10, Color( self.Color.r, self.Color.g, self.Color.b, 255 ) )

end*/

function SWEP:PreDrawViewModel(vm)
	render.SetColorModulation(0, 1, 1)
end

function SWEP:PostDrawViewModel(vm)
	render.SetColorModulation(1, 1, 1)


end

hook.Add("PreDrawPlayerHands", "GMT_BubbleGun", function(hands, vm, ply, wep)
	if IsValid(wep) and wep:GetClass() == "gmt_bubblegun" then
		render.SetColorModulation(1, 1, 1)
	end
end)

function SWEP:Precache()
	//GtowerPrecacheSound(self.PartySound)
end

function SWEP:PrimaryAttack()

	if !self:CanPrimaryAttack() then return end

	if !self.Owner:IsAdmin() then
		self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	else
		self.Weapon:SetNextPrimaryFire( CurTime() + self.AdminDelay	)
	end

end

function SWEP:Think()

	if SERVER and IsValid(self) then

		if self.NextCheck > CurTime() then return end

		if self.Owner:KeyDown(IN_ATTACK) then
			self:SetNWBool("Shooting",true)
		else
			self:SetNWBool("Shooting",false)
		end

		self.NextCheck = CurTime() + 1

	end

	if SERVER then return end

	if !self.Owner:KeyDown(IN_ATTACK) then return end

	if !self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	local att = (self.Owner == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() and LocalPlayer():GetViewModel()) or self
	local attach = att:LookupAttachment("muzzle")
	if attach > 0 then
		attach = att:GetAttachment(attach)
		attach = attach.Pos
	else
		attach = self.Owner:GetShootPos()
	end

	if CurTime() < self.NextParticle then return end

	for i=0, 1 do

		local particle = self.Emitter:Add( "effects/bubble", attach )

		local vel = self.Owner:GetForward() * math.random(10,30) + VectorRand() * 5

		if particle then

			self:GetOwner():EmitSound("ambient/water/rain_drip2.wav",40,math.random(75,125))

			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand( 1, 10 ) )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.random( 1,4 ) )
			particle:SetEndSize( 0 )
			particle:SetRoll( math.Rand( 0, 360 ) )
			particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
			particle:SetColor( math.random( 240, 255 ), math.random( 240, 255 ), math.random( 240, 255 ) )
			particle:SetCollide( true )
		end
	end
	self.NextParticle = CurTime() + 0.05
end

function SWEP:Reload()
	return false
end

function SWEP:CanPrimaryAttack()
	return !Location.IsEquippablesNotAllowed( self.Owner._Location )
end

function SWEP:CanSecondaryAttack()
	return false
end
