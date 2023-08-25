include('shared.lua')

ENT.Sprite = Material( "sprites/glow04_noz" )

FLEnts = FLEnts or {} // For the screen effects.

gmt_visualizer_effects = CreateClientConVar( "gmt_visualizer_effects", 1, true, false )
gmt_visualizer_advanced = CreateClientConVar( "gmt_visualizer_advanced", 1, true, false )
//gmt_visualizer_shake = CreateClientConVar( "gmt_visualizer_shake", 1, true, false )

local ColorList = {

	Color( 255, 180, 80 ),
	Color( 255, 80, 130 ),
	Color( 225, 135, 255 ),
	Color( 65, 30, 255 ),
	Color( 30, 190, 255 ),

}

function ENT:Initialize()

	self:FLLoad( /*scale*/ .95, /*volume*/ .9, /*power*/ 1.2 )	self.Emitter = ParticleEmitter( self:GetPos() )

	self.Color = Color( 255, 255, 255, 255 )
	self.NextParticle = CurTime()

	self.BaseClass.Initialize( self )

end

function ENT:Think()

	self.BaseClass.Think( self )

	if gmt_visualizer_effects:GetBool() == false then if IsValid(self.Proj) then self.Proj:Remove() end return end
	
	if not self:IsStreaming() then if IsValid(self.Proj) then self.Proj:Remove() end return end

	if not self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	self:FLUpdateSpec( Stream )
	self:ParticleThink()

	if !IsValid(self.Proj) then
		self.Proj = ProjectedTexture()
	else
		self.Proj:SetTexture("effects/flashlight001")
		self.Proj:SetAngles(Angle(90, 0, 0))
		self.Proj:SetPos(self:GetPos())
		if gmt_visualizer_advanced:GetBool() == true then
			self.Proj:SetEnableShadows(true)
		else
			self.Proj:SetEnableShadows(false)
		end
		self.Proj:SetBrightness(2)
		self.Proj:SetColor(self.Color)
		self.Proj:SetFOV(109 + (70) * self.FFTScale)
		self.Proj:SetFarZ(140 + (100) * self.FFTScale)
		self.Proj:Update()

		return
	end

	local dlight = DynamicLight( self:EntIndex() + 10)
	if ( dlight ) then
		local r, g, b, a = col
		dlight.Pos = self:GetPos()
		dlight.r = self.Color.r
		dlight.g = self.Color.g
		dlight.b = self.Color.b
		dlight.Brightness = 1
		dlight.Size = self.FFTScale * 2400
		dlight.Decay = (self.FFTScale * 1200) * 2
		dlight.DieTime = CurTime() + 1
	end

end

function ENT:Draw()

	self:SetMaterial()

	self.F = self.F or 0
	self.S = self.S or 0
	self.F = self.F + FrameTime() * Lerp(self.FFTScale, 8, 1) * (!self:IsStreaming() && 1 or self.FFTScale * 1.8 + (self.S * 0.1))

	if !self:IsStreaming() or gmt_visualizer_effects:GetBool() == false /*or GTowerMainGui.MenuEnabled*/ then
		render.DrawWireframeSphere(self:GetPos(), 8 + math.sin(CurTime()), 8, 8, color_white, true)
		//render.DrawWireframeSphere(self:GetPos(), 9 + math.sin(CurTime()), 6, 6, Color(255, 255, 255, 32), true)

		render.SetMaterial( self.Sprite )
		render.DrawSprite( self:GetPos(), 72, 72, Color(255, 255, 255, 128 + math.sin(CurTime()) * 32) )

		for i = 1, 24 do
			local ang = Angle(i * 30 + self.F * 8, i * 45 + self.F * 8, 0)

			local hsv = HSVToColor(math.fmod(i * 8 + self.F * 8, 360), 1, 1)
			local r = Vector(math.sin(self.F * 0.4) * 8 + i, math.sin(self.F * 0.4) * 8 - i, math.sin(self.F / 2) * 6 + i) * 0.1
			render.DrawWireframeBox(self:GetPos() + ang:Forward() * (math.sin(i) * 8 + 24), Angle(self.F * 8 + i * 8, -self.F * 3, self.F * 2), -r, r, hsv, true)
		end
		
		//self:DrawModel()
		return
	end

	self:SetMaterial("models/debug/debugwhite")


	local color = colorutil.Smooth( .15 )

	local hue, sat, val = ColorToHSV( color )

	if val > 1 - 1 / (math.Clamp( self.FFTScale / 2, 0, 1 )) then
		hue = hue + 190
	end

	local col = HSVToColor( hue, 0.8 + 0.2 * self.FFTScale, val )

	render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255)
	//self:DrawModel()
	local add = self.FFTScale * 4 + 1
	render.DrawWireframeSphere(self:WorldSpaceCenter(), 8 + self.FFTScale * 8, 3 + add, 3 + add, col, true)
	local size = self.FFTScale or .1
	render.SetMaterial( self.Sprite )
	render.DrawSprite( self:GetPos(), 15 + ( size * 128 ), 15 + ( size * 128 ), self.Color )
	//i = i + math.sin(CurTime() * 8) * util.SharedRandom(i + math.sin(CurTime()) * 8, 0, 40)
	self.Ang = self.Ang or Angle(0, 0, 0)

	if !self.LastAng or self.LastAng < CurTime() then
		self.Ang2 = AngleRand()
		self.LastAng = CurTime() + 0.4

	end

	self.Ang = LerpAngle(FrameTime() * 4 * 0, self.Ang, self.Ang2)
	self.Ang.p = math.ApproachAngle(self.Ang.p, self.Ang2.p, 0)
	self.S = math.Approach(self.S, self.FFTScale, FrameTime() * 0)

	for i=1, 25 do
		if !self.FFT[1] then continue end
		local lscale = 1.6 + (self.FFT[i] + self.FFT[i + 1]) * (8 + i)
		local base = self:GetPos()
		//local i = i + util.SharedRandom(i, 0, 4)
		local basepos1 = base // + Vector(math.sin(RealTime() + i) * 18, math.cos(RealTime() + i) * 18, math.cos(RealTime()*2 + i) * 18) * size * 0.1
		local basepos2 = base + Vector(math.sin(RealTime() + i) * 18, math.cos(RealTime() + i) * 18, math.sin(RealTime()*2 + i) * 18) * size * 0.1

		
		local ang = Angle(self.F * 8, self.F * 8, 0)
		ang.p = ang.p + util.SharedRandom(i, -90, 90)
		ang.y = ang.y + util.SharedRandom(i, -360, 360)
		//basepos1 = basepos1 + Angle(util.SharedRandom(i, -90, 90), util.SharedRandom(i, -3600, 3600), 0):Forward() * (64 - self.S * 32) // (32 + util.SharedRandom(i, -8, 0))
		basepos1 = basepos1 + ang:Forward() * (16 * self.S + (32 * lscale * 0.1) + math.sin(i * 4) * 32)
		size = 8 + self.FFTBass * 80

		render.SetColorMaterial()

		lscale = lscale * 0.8
		render.DrawLine(self:GetPos() + ang:Forward() * 0, basepos1, col, true)
		col.a = self.FFTScale * 255
		render.DrawWireframeBox( basepos1, (base - basepos1):Angle(), Vector(-1, -1, -1) * lscale, Vector(1, 1, 1) * lscale, col, true )
		col.a = self.FFTScale * 64
		render.DrawBox( basepos1, (base - basepos1):Angle(), Vector(-1, -1, -1) * lscale, Vector(1, 1, 1) * lscale, col, true )
		//lscale = 1.6 + math.pow(self.FFT[i], 2) * (8*i)//(math.abs(math.log(2048)/math.log(self.FFT[i])))// * (8 + i)
		//render.DrawBox( basepos2, (base - basepos2):Angle(), Vector(-1, -1, -1) * lscale, Vector(1, 1, 1) * lscale, col, false )
	end

end

function ENT:OnRemove()

	if IsValid( self.Emitter ) then

		self.Emitter:Finish()
		self.Emitter = nil

	end

	if IsValid(self.Proj) then
		self.Proj:Remove()
	end

	self:FLUnload()

end

function ENT:IsStreaming()

	local Stream = self:GetStream()
	return Stream and self:StreamIsPlaying()

end

function ENT:FLLoad( scale, vol, pow )

	local BANDS = 2048

	self.FFT = {}
	for i = 1, BANDS do
		self.FFT[i] = 0
	end

	self.FFTBass = 0
	self.FFTScale = 0

	local FFTDetail = 6
	self.MultFFT = BANDS / 6

	self.FLScale = scale
	self.FLVolMulti = vol
	self.FLPow = pow

	table.insert( FLEnts, self )
	hook.Add( "RenderScreenspaceEffects", "FLPost", RenderScreenspaceEffects )

end

function ENT:FLUnload()

	self.FFTBass = 0
	self.FFTScale = 0
	self.FLScale = 0

	table.RemoveValue( FLEnts, self )
	hook.Remove( "FLPost", "RenderScreenspaceEffects" )

end

function ENT:FLUpdateSpec( stream )

	local Stream = self:GetStream()
	self.FFT = self:GetFFTFromStream()
	if !self.FFT[1] then return end
	self.FFTBass = fft.GetBass( self.FFT )
	self.FFTScale = ( self.FFTBass ) * 10

	self.Color = self:FLGetColor( math.Clamp( self.FFTScale / 2, 0, 1 ) )

end

function ENT:FLScaleVolume( vol )

	vol = vol or 1

	return ( ( vol ^ self.FLPow ) * 100 ) * self.FLVolMulti

end

function ENT:FLGetRandomColor()

	local rand = math.random( 0, 6 )
	local color = Color( math.random( 125, 255 ), math.random( 125, 255 ), math.random( 125, 255 ) )
	if rand == 1 then
		color = Color( math.random( 125, 255 ), math.random( 50, 120 ), math.random( 50, 120 ) )
	elseif rand == 2 then
		color = Color( math.random( 50, 120 ), math.random( 125, 255 ), math.random( 50, 120 ) )
	elseif rand == 3 then
		color = Color( math.random( 50, 120 ), math.random( 50, 120 ), math.random( 125, 255 ) )
	elseif rand == 4 then
		color = Color( math.random( 50, 120 ), math.random( 125, 255 ), math.random( 125, 255 ) )
	elseif rand == 5 then
		color = Color( math.random( 125, 255 ), math.random( 50, 120), math.random( 125, 255 ) )
	elseif rand == 6 then
		color = Color( math.random( 125, 255 ), math.random( 125, 255 ), math.random( 50, 120 ) )
	end

	local hue, sat, val = ColorToHSV( color )
	return HSVToColor( hue, sat * 2, val )

end

function ENT:FLGetColor( val )

	local Count = #ColorList + 1 
	/*local Perc = math.fmod( val, 1 / Count ) * Count
 
	local index = math.floor( val * ( #ColorList - 2 ) ) + 1
	local From = ColorList[ index ] 
	local To = ColorList[ index + 1 ]
 
	local color = Color(
		Lerp( Perc, From.r, To.r ),
		Lerp( Perc, From.g, To.g ),
		Lerp( Perc, From.b, To.b ),
		255
	)*/

	local color = colorutil.Smooth( .15 )

	local hue, sat, val = ColorToHSV( color )

	if val > 1 - 1 / Count then
		hue = hue + 190
	end

	return HSVToColor( hue, sat * 3 * self.FFTScale, val )

end

function ENT:ParticleThink()

	if self.FFTScale <= .35 then

		for i=0, ( 20 * self.FFTScale ) do

			local glow = self.Emitter:Add( "sprites/powerup_effects", self:GetPos() )

			local ran = math.random( 1, 2 )
			if ran == 2 then
				glow = self.Emitter:Add( "sprites/light_glow02_add", self:GetPos() )
			end

			if glow then

				local vel, addvel = 0, 50
				if self.FFTScale >= .95 then
					addvel = 300
				end

				vel = VectorRand():GetNormal() * ( ( 300 + addvel ) + ( self.FFTScale * 10 ) )

				glow:SetVelocity( vel )

				glow:SetLifeTime( 0 )
				glow:SetDieTime( .2 * ( self.FFTScale * 2 ) )

				glow:SetStartAlpha( 24 )
				glow:SetEndAlpha( 0 )

				local Size = math.Rand( 60, 80 )
				glow:SetStartSize( Size * self.FFTScale )
				glow:SetEndSize( 0 )

				local AirResistance = math.Rand( 145, 165 )
				glow:SetAirResistance( AirResistance )
				glow:SetGravity( Vector( 0, 0, 0 ) )

				glow:SetColor( self.Color.r, self.Color.g, self.Color.b )

				glow:SetStartLength( 35 * self.FFTScale )
				glow:SetEndLength( 0 )

			end

		end

	end

	if self.FFTScale <= .4 then

		for i = 1, 4 do

			local volume = self:FLScaleVolume( self.FFT[ math.Clamp( math.Round( i * self.MultFFT ), 1, fft.BANDS ) ] )
	
			if volume < 0.01 then continue end

			local fr = i * 256
			local n_fr = -( fr - 30 ) + fft.BANDS // negative fr, 1024 to 0
			local f_fr = ( fr - 30 ) / fft.BANDS // fraction fr, 0, 1
			local nf_fr = n_fr / fft.BANDS // negative fraction, 1, 0
	
			for i = 1, math.Clamp( math.Round( volume * 25 * self.FLScale ), 0, 25 ) do
		
				local size = self.FFTBass * 30 ^ 2

				local color = self:FLGetColor( math.Clamp( f_fr, 0, 1 ) )
			
				local velocity = AngleRand():Forward() * volume //( ( EyePos() - self:GetPos() ):GetNormal() * 2 + VectorRand() ):GetNormal()* volume
			
				local particle = self.Emitter:Add( "sprites/powerup_effects", self:GetPos() + ( velocity * 80 * self.FLScale ) )
				if particle then

					particle:SetVelocity( velocity * 1200 * self.FLScale )
			
					particle:SetLifeTime( 0 )
					particle:SetDieTime( 1 - self.FLScale * 0.4 )

					particle:SetStartLength( size * 3 * self.FLScale )
					particle:SetStartSize( size * .5 * self.FLScale )
					particle:SetEndSize( size * .25 * self.FLScale )
					particle:SetEndLength( size * 5 * self.FLScale )

					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 0 )

					particle:SetAirResistance( math.Clamp( -size + 400, 10, 800 ) * self.FLScale )
					//particle:SetGravity( ( VectorRand():GetNormal() * 50 ) * self.FLScale )

					particle:SetColor( color.r, color.g, color.b )

				end

			end

		end
		
	end

	if self.FFTScale >= .5 && self.FFTScale <= 1.8 then

		/*for i=1, ( 32 * self.FFTScale ) do
			local particle = self.Emitter:Add( "sprites/powerup_effects", self:GetPos() )
			if particle then
			
				local velocity = ( ( EyePos() - self:GetPos() ):GetNormal() * 2 + VectorRand() ):GetNormal() * self.FFTScale
				particle:SetVelocity( velocity * math.random( 900, 1200 ) * self.FLScale )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( .85 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 150 )
				particle:SetStartSize( math.random( 5, 10 ) * self.FFTScale )
				particle:SetEndSize( 0 )
				particle:SetColor( self.Color.r, self.Color.g, self.Color.b )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetAirResistance( 400 )
				particle:SetGravity( Vector( 0, 0, 0 ) )
			end
		end

		self.NextParticle = CurTime() + ( 1 - self.FFTScale ) * .25*/

	end

	if gmt_visualizer_advanced:GetBool() == false then return end
	
	/*if self.FFTScale >= .1 then

		for i=0, 24 do

			local smoke = self.Emitter:Add( "particle/particle_noisesphere", util.QuickTrace(self:GetPos(), Vector(0, 0, -2400), self).HitPos )
			if smoke then

				local vel = VectorRand():GetNormal() * math.Rand( 150, 300 ) * 20
				smoke:SetVelocity( vel )

				smoke:SetLifeTime( 0 )
				smoke:SetDieTime( 2 )

				smoke:SetStartAlpha( 0 )
				smoke:SetEndAlpha( 1 )

				smoke:SetRoll( 0, 360 )
				smoke:SetRollDelta( math.Rand( -1, 1 ) )

				local Size = math.Rand( 5, 10 ) * 8
				smoke:SetStartSize( Size * self.FFTScale )
				smoke:SetEndSize( Size * math.Rand( 2, 5 ) )

				smoke:SetAirResistance( 600 )
				smoke:SetGravity( Vector( 0, 0, -400 ) )

				local RandDarkness = math.Rand( 0.25, 1 )
				smoke:SetColor( self.Color.r, self.Color.g, self.Color.b )

			end

		end
		
	end*/

end

function RenderScreenspaceEffects()

	if !FLEnts || #FLEnts == 0 then return end

	local w, h = ScrW(), ScrH()
	local eyepos, eyeangles = EyePos(), EyeAngles()

	for _, FLStream in ipairs( FLEnts ) do
	
		if IsValid( FLStream ) && FLStream:IsStreaming() then

			local pos = FLStream:GetPos()
			local toscrpos = pos:ToScreen()

			// Limit effects
			local distance = eyepos:Distance( pos )
			local multi = math.max( eyeangles:Forward():DotProduct( ( pos - eyepos ):GetNormal() ), 0 ) ^ 3
			multi = 1 - math.Clamp( ( distance / 400 ), 0, 1 )

			//if multi < 0.001 then return end
			multi = math.Clamp( multi, 0, 1 )

			// Shake player.
			/*if gmt_visualizer_shake:GetBool() == true then

				local angle = VectorRand() * FLStream:FLGetAverage( 1, 5 ) ^ 2.2 * 10 * multi
				angle.z = 0
				LocalPlayer():SetEyeAngles( EyeAngles() + angle )

			end*/

			// Post Events
			if gmt_visualizer_advanced:GetBool() == false then return end

		end

	end

end

hook.Remove( "RenderScreenspaceEffects", "FLPost", RenderScreenspaceEffects )