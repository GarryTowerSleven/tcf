if SERVER then
	AddCSLuaFile()
else
	SWEP.DrawAmmo				= false
	SWEP.DrawCrosshair			= true
	SWEP.ViewModelFOV			= 64
	SWEP.ViewModelFlip			= true
	SWEP.CSMuzzleFlashes		= false
end

//Muzzle/Shell
SWEP.MuzzleAttachment		= "1" //1 for css, muzzle for hl2
SWEP.ShellEjectAttachment	= "2" //2 for css, 1 for hl2

//Basic Setup
SWEP.PrintName				= "Ecto-gun"
SWEP.Slot					= 1
SWEP.SlotPos				= 0

//Types
SWEP.HoldType				= "revolver"
SWEP.GunType				= "default"  //for muzzle/shell effects  (default, shotgun, rifle, highcal, or scifi)

//Models
SWEP.ViewModel		 		= Model("models/weapons/v_vir_scifihg.mdl")
SWEP.WorldModel		 		= Model("models/weapons/w_vir_scifihg.mdl")
SWEP.UseHands = false

//Primary
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 6
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "AR2"
SWEP.Primary.Delay			= 0.15
SWEP.Primary.Recoil	 		= 2
SWEP.Primary.Cone			= 0.005
SWEP.Primary.Damage			= 10
SWEP.Primary.AmmoAmount		= 1

//Parameters
SWEP.Ricochet				= 3
SWEP.ReloadDelay			= SWEP.Primary.Delay

//Effects
SWEP.Trace					= "phaser"
SWEP.Effect					= "phaser"
SWEP.HitEffect				= "phaser_hitworld"

//Sounds
SWEP.Primary.Sound			= Sound("GModTower/zom/weapons/laser_fire.wav")
SWEP.SoundReload	 		= Sound("GModTower/virus/weapons/ScifiHandgun/reload.wav")
SWEP.SoundDeploy	 		= Sound("GModTower/virus/weapons/ScifiHandgun/deploy.wav")
SWEP.SoundEmpty		 		= "Weapon_Pistol.Empty"

function SWEP:Initialize()

	self:SetHoldType( self.HoldType )
	
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
end

function SWEP:Precache()	
end

function SWEP:Reload()

	if ( self:GetOwner():IsPlayer() && self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) || self:Clip1() >= self.Primary.ClipSize then
		return
	end

	if self.SoundReload && IsFirstTimePredicted() then
		self:GetOwner():EmitSound( self.SoundReload )
	end

	self:DefaultReload( ACT_VM_RELOAD )
	self:GetOwner():SetAnimation( PLAYER_RELOAD )

end

function SWEP:Deploy()

	if self.SoundDeploy && IsFirstTimePredicted() then
		self:GetOwner():EmitSound( self.SoundDeploy )
	end

	self:SendWeaponAnim( self.AnimDeploy or ACT_VM_DRAW )
	self:GetOwner().Reloading = false

	return true

end

function SWEP:Holster()

	return true

end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return true end

	if ( self:Clip1() - self.Primary.AmmoAmount ) < 0 then
		return true
	end

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )

	self:ShootBullet( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Primary.Ammo )
	self:ShootEffects( self.Primary.Sound, self.Primary.Recoil, self.Effect, ACT_VM_PRIMARYATTACK )

	self:TakePrimaryAmmo( self.Primary.AmmoAmount )

end

function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then

		--[[if self.SoundEmpty && IsFirstTimePredicted() then
			if type(self.SoundEmpty) == "table" then
				self:EmitSound( self.SoundEmpty[math.random( 1, #self.SoundEmpty )] )
			else
				self:EmitSound( self.SoundEmpty )
			end
		end]]

		self:SetNextPrimaryFire( CurTime() + self.ReloadDelay )
		self:SetNextSecondaryFire( CurTime() + self.ReloadDelay )
		self:Reload()

		return false

	else

		return true

	end

end

function SWEP:CanSecondaryAttack() return false end

function SWEP:ShootBullet( dmg, numbul, cone, ammo )

	dmg		= dmg		or 0
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01

	self:GetOwner():LagCompensation( true )

	local bullet = {}
	bullet.Num 			= numbul
	bullet.Src 			= self:GetOwner():GetShootPos()
	bullet.Dir 			= self:GetOwner():GetAimVector()
	bullet.Spread 		= Vector( cone, cone, 0 )
	bullet.Tracer		= 1
	bullet.TracerName 	= "none"

	self:GetOwner():LagCompensation( false )

	bullet.Force		= .25

	if type(dmg) == "table" then
		bullet.Damage	= math.random( dmg[1],dmg[2] )
	else
		bullet.Damage	= dmg
	end

	if ammo != "none" then
		bullet.AmmoType	= ammo
	end

	bullet.Callback = function( att, tr, dmginfo ) if SERVER then self:BulletCallback( att, tr, dmginfo ) end end
	
	self:GetOwner():FireBullets( bullet )

end

function SWEP:ShootEffects( snd, viewpunch, effect, anim )

	self:SendWeaponAnim( anim or ACT_VM_PRIMARYATTACK )
	self:GetOwner():MuzzleFlash()
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )

	if viewpunch then
		self:GetOwner().ViewPunchAngle = Angle( math.Rand(-0.2,-0.1) * viewpunch, math.Rand( -0.1, 0.1 ) * viewpunch, 0 )
	end

	if !IsFirstTimePredicted() then return end
	
	if snd then

		if type(snd) == "table" then
			self:EmitSound( snd[math.random(1, #snd)] )
		else
			self:EmitSound( snd )
		end

	end

	if effect then

		local tr = self:GetOwner():GetEyeTrace()

		if SERVER then

			local attach = self:LookupAttachment( "muzzle" )
			if attach > 0 then
				attach = self:GetAttachment(attach)
				attach = attach.Pos
			else
				attach = self:GetOwner():GetShootPos() + Vector( 0, 5, 0 )
			end
		
			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetStart( attach )
				effectdata:SetAttachment( self.MuzzleAttachment )
				effectdata:SetEntity( self )
			util.Effect( effect, effectdata )

		else

			local vm = LocalPlayer():GetViewModel()
			local attach = self:GetMuzzlePos( vm ) + util.TranslateOffset( Vector(0,0,1.5), vm )

			local effectdata = EffectData()
				effectdata:SetOrigin( tr.HitPos )
				effectdata:SetStart( attach )
				effectdata:SetEntity( self )
			util.Effect( effect, effectdata )

		end

	end

	-- Muzzle flash
	local scale = 4

	//Muzzle disabled for the time being. I haven't coded the effect yet.
	local effectdata = EffectData()
		effectdata:SetEntity( self )
		effectdata:SetOrigin( self:GetOwner():GetShootPos() )
		effectdata:SetNormal( self:GetOwner():GetAimVector() )
		effectdata:SetAttachment( self.MuzzleAttachment )
		effectdata:SetScale( scale )  //this is a hack
	util.Effect( "muzzleflash", effectdata )


	local effectdata2 = EffectData()
		effectdata2:SetEntity( self )
		effectdata2:SetNormal( self:GetOwner():GetAimVector() )
		effectdata2:SetAttachment( self.ShellEjectAttachment )
		effectdata2:SetScale( scale )  //this is a hack
	util.Effect( "shelleject", effectdata2 )

end

function SWEP:GetMuzzlePos( vm )

	/*local bone = vm:LookupBone( "v_weapon.Left_Pinky01" )
	if bone then
		local pos = vm:GetBonePosition( bone )

		return pos + ( vm:GetForward() * 5 )
	end*/

	local attach = vm:LookupAttachment( "muzzle" )
	if attach > 0 then
		attach = vm:GetAttachment(attach)
	else
		attach = vm:GetAttachment(2)
	end

	return attach.Pos, attach.Ang

end

	if CLIENT then
	// Syndicate like ammo
	local gradientUp = surface.GetTextureID( "gui/gradient_up" )
	local gradientDown = surface.GetTextureID( "gui/gradient_down" )

	surface.CreateFont( "GunText", { font = "Bebas Neue", size = 32, weight = 100 } )
	surface.CreateFont( "GunTextSmall", { font = "Bebas Neue", size = 16, weight = 100 } )

	local staticTex = Material("gmod_tower/halloween/static")

	local function GetViewModelAttachment( nFOV, vOrigin, bFrom )
		local vEyePos = EyePos()
		local aEyesRot = EyeAngles()
		local vOffset = vOrigin - vEyePos
		local vForward = aEyesRot:Forward()
	
		local nViewX = math.tan(nFOV * math.pi / 360)
	
		if (nViewX == 0) then
			vForward:Mul(vForward:Dot(vOffset))
			vEyePos:Add(vForward)
			
			return vEyePos
		end
	
		-- FIXME: LocalPlayer():GetFOV() should be replaced with EyeFOV() when it's binded
		local nWorldX = math.tan(LocalPlayer():GetFOV() * math.pi / 360)
	
		if (nWorldX == 0) then
			vForward:Mul(vForward:Dot(vOffset))
			vEyePos:Add(vForward)
			
			return vEyePos
		end
	
		local vRight = aEyesRot:Right()
		local vUp = aEyesRot:Up()
	
		if (bFrom) then
			local nFactor = nWorldX / nViewX
			vRight:Mul(vRight:Dot(vOffset) * nFactor)
			vUp:Mul(vUp:Dot(vOffset) * nFactor)
		else
			local nFactor = nViewX / nWorldX
			vRight:Mul(vRight:Dot(vOffset) * nFactor)
			vUp:Mul(vUp:Dot(vOffset) * nFactor)
		end
	
		vForward:Mul(vForward:Dot(vOffset))
	
		vEyePos:Add(vRight)
		vEyePos:Add(vUp)
		vEyePos:Add(vForward)
	
		return vEyePos
	end

	function SWEP:PostDrawViewModel( vm, wep, ply )

		local attachPos, attachAng = self:GetMuzzlePos( vm )

		local pos = GetViewModelAttachment( self.ViewModelFOV or 0, attachPos, false )
		local ang = EyeAngles()

		ang:RotateAroundAxis( ang:Forward(), 90 )
		ang:RotateAroundAxis( ang:Right(), 90 )

		pos = pos + util.TranslateOffset( Vector( -3.5, 1.85, -0.5 ), vm )

		// Debug3D.DrawAxis( pos, ang:Forward(), ang:Right(), ang:Up(), 1 )

		local ammo_left = wep:Clip1()
		local ammo_total = wep:Ammo1()

		if ammo_left == -1 then return end

		cam.Start3D2D( pos, Angle( ang.p, ang.y, ang.r ), 0.025 )

			local text = ammo_left .."/".. ammo_total

			surface.SetDrawColor( 0, 0, 150, CosBetween( 50, 150, FrameTime() * 1000 ) )

			if self:GetOwner().Reloading then
				text = "RELOADING"
				surface.SetDrawColor( 150, 0, 0, CosBetween( 50, 150, FrameTime() * 1000 ) )
			end

			surface.SetFont( "GunText" )
			local w, h = surface.GetTextSize( text )
			h = h / 2

			local padding = 8

			if self.LastAmmo != ammo_left then
				self.LastAmmo = ammo_left
				padding = 10
			end

			local x = ( w / 2 + ( padding / 2 ) ) * - 1
			local y = ( h / 2 + ( padding / 2 ) ) * - 1

			// Draw box top
			surface.SetTexture( gradientUp )
			surface.DrawTexturedRect( x, y, w + padding, h + padding )

			// Draw box bottom
			surface.SetTexture( gradientDown )
			surface.DrawTexturedRect( x, y, w + padding, h + padding )

			// Draw dots
			surface.SetDrawColor( 80, 80, 255, 255 )
			if self:GetOwner().Reloading then
				surface.SetDrawColor( 255, 80, 80, 255 )
			end


			surface.DrawRect( x, y, 2, 2 )
			surface.DrawRect( x, y + h + padding - 1, 2, 2 )
			surface.DrawRect( x + w + padding - 1, y, 2, 2 )
			surface.DrawRect( x + w + padding - 1, y + h + padding - 2, 2, 2 )

			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(staticTex)
			surface.DrawTexturedRect(x, y, w + padding, h + padding)

			draw.SimpleText( text, "GunText", 0, 2, nil, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
				
		cam.End3D2D()

	end

	SWEP.SpriteMat = Material( "sprites/pickup_light" )

	function SWEP:PreDrawViewModel( vm, wep, ply )

		if (wep:Clip1() or 0) == 0 then return end

		local attachPos, _ = self:GetMuzzlePos( vm )

		local pos = GetViewModelAttachment( self.ViewModelFOV or 0, attachPos, false )

		render.SetMaterial( self.SpriteMat )
		render.DrawSprite( pos + util.TranslateOffset( Vector(0,-.1,.5), vm ), 10, 10, Color( 128, 128, 255, SinBetween( 15, 100, CurTime() ) ) )

	end

	function SWEP:Think()

		local pos = self:GetOwner():EyePos()
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			
			dlight.Pos = pos
			dlight.r = 50
			dlight.g = 50
			dlight.b = 255
			dlight.Brightness = 2
			dlight.Size = 128
			//dlight.Decay = dlight.Size * 5
			dlight.DieTime = CurTime() + .1
			dlight.Style = 1
		end

		return true

	end

end

if SERVER then

	function SWEP:BulletCallback( att, tr, dmginfo )

		//if tr.MatType == MAT_GLASS then return end

		if IsValid(tr.Entity) && tr.Entity:IsNextBot() then

			if !IsFirstTimePredicted() then return end
		
			local eff = EffectData()
				eff:SetOrigin( tr.HitPos )
				eff:SetNormal( tr.HitNormal )
			util.Effect( "phaser_hitghost", eff, true, true )

		end

		if tr.MatType != MAT_FLESH then

			local eff = EffectData()
				eff:SetOrigin( tr.HitPos )
				eff:SetNormal( tr.HitNormal )
			util.Effect( "phaser_hitworld", eff, true, true )

			local eff = EffectData()
				eff:SetOrigin( tr.HitPos )
				eff:SetNormal( tr.HitNormal )
			util.Effect( "phaser_hitsmoke", eff, true, true )

			util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos + tr.HitNormal * -20 + VectorRand() * 15 )

		end

	end

end