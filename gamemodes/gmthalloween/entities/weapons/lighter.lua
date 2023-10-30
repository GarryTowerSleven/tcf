AddCSLuaFile()

if SERVER then
	SWEP.Weight = 5
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
else
	SWEP.PrintName = "Lighter"
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false
	SWEP.DrawSecondaryAmmo = false
end

SWEP.ViewModel = "models/weapons/v_lighter.mdl"
SWEP.WorldModel = "models/weapons/w_lighter.mdl"
SWEP.HoldType = "slam"
SWEP.UseHands = false

SWEP.Sounds_Draw = Sound( "room209/lighter_draw.wav" )
SWEP.Sounds_Holster = Sound( "room209/lighter_holster.wav" )

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Holster()	

	self:EmitSound( self.Sounds_Holster, 100, 100 )
	return true

end

function SWEP:Deploy()

	self:EmitSound( self.Sounds_Draw, 100, 100 )
	return true

end

function SWEP:PrimaryAttack()

	if !self:CanPrimaryAttack() then return end
	
	--self:ToggleLighter()
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

end

function SWEP:CanPrimaryAttack()
	return self:GetNextPrimaryFire() <= CurTime()
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload() end

function SWEP:ToggleLighter()

	if self:IsLit() then

		// Put Lighter away
		self:SendWeaponAnim( ACT_VM_HOLSTER )
		
		timer.Simple( self:SequenceDuration(), function()
			self:SetNWBool( "Light", false )
		end )
			
		self:Holster()

	else			

		// Take Lighter Out
		self:SendWeaponAnim( ACT_VM_DRAW )
		self:SetNWBool( "Light", true )
	
		timer.Simple( self:SequenceDuration(), function()
			self:SendWeaponAnim( ACT_VM_IDLE )
		end )
		
		self:Deploy()

	end

end

function SWEP:IsLit()
	return true --self:GetNWBool("Light", true)
end

function SWEP:GetLightColor()
	return 212, 131, 43
end

if CLIENT then
	
	function SWEP:Think()

		if self:IsLit() then

			local ViewModel = self.Owner:GetViewModel()
			ViewModel:SetColor( Color( 255, 255, 255, 255 ) )
		
			local pos = self.Owner:EyePos()
			local dlight = DynamicLight( self:EntIndex() )
			if dlight then
				local r, g, b = self:GetLightColor()
				dlight.Pos = pos
				dlight.r = r
				dlight.g = g
				dlight.b = b
				dlight.Brightness = 2
				dlight.Size = 200
				dlight.Decay = 200 / 2
				dlight.DieTime = CurTime() + .01
				dlight.Style = 6
			end
		
		end
		
		self:NextThink( CurTime() + .25 )

		return true

	end


	function SWEP:GetFlamePos( vm )

		local att = vm:LookupAttachment("lighter_fire_point")
		local attach = vm:GetAttachment(att)

		return attach.Pos

	end

	SWEP.SpriteMat = Material( "room209/softglow" )

	function SWEP:PostDrawViewModel( vm, wep, ply )

		if self:IsLit() then

			local pos = self:GetFlamePos( vm )
			local offset = Vector( 3,-.4,0 )

			-- Blue
			render.SetMaterial( self.SpriteMat )
			render.DrawSprite( pos + util.TranslateOffset( offset, vm ), 5, 5, Color( 128, 128, 255, math.SinBetween( 50, 150, CurTime()*5 ) ) )

			-- Flame
			render.SetMaterial( Material( "particles/flamelet" .. math.random( 1 , 5 ) ) )
			render.DrawSprite( pos + util.TranslateOffset( offset, vm ), math.CosBetween( .5, 1, CurTime()*50 ), math.SinBetween( 4, 7, CurTime()*50 ), Color( 255, 255, 255, 255 ) )

			--self:EmitFlames( pos, vm:GetUp() )

		else

			if IsValid( self.Emitter ) then
				self.Emitter:Finish()
				self.Emitter = nil
			end

		end

	end
	
end

function SWEP:ShouldDropOnDie()
	return false
end