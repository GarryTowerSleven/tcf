include('shared.lua')

ENT.Sprite = Material( "sprites/powerup_effects" )

FLEnts = FLEnts or {} // For the screen effects.

gmt_visualizer_effects = CreateClientConVar( "gmt_visualizer_effects", 1, true, false )
gmt_visualizer_shake = CreateClientConVar( "gmt_visualizer_shake", 1, true, false )

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

	if not self:IsStreaming() then return end

	if not self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	self:FLUpdateSpec( Stream )
	self:ParticleThink()

end

function ENT:Draw()

	if not self:IsStreaming() /*or GTowerMainGui.MenuEnabled*/ then
		self:DrawModel()
	end

	local size = self.FFTScale or .1
	render.SetMaterial( self.Sprite )
	render.DrawSprite( self:GetPos(), 15 + ( size * 400 ), 15 + ( size * 400 ), self.Color )
	
end

function ENT:OnRemove()

	if IsValid( self.Emitter ) then

		self.Emitter:Finish()
		self.Emitter = nil

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

				glow:SetStartAlpha( 255 )
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
			
				local velocity = ( ( EyePos() - self:GetPos() ):GetNormal() * 2 + VectorRand() ):GetNormal()* volume
			
				local particle = self.Emitter:Add( "sprites/light_glow02_add", self:GetPos() + ( velocity * 80 * self.FLScale ) )
				if particle then

					particle:SetVelocity( velocity * 1200 * self.FLScale )
			
					particle:SetLifeTime( 0 )
					particle:SetDieTime( math.Clamp( volume^3, 0.1, 0.8 ) )

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

		for i=1, ( 32 * self.FFTScale ) do
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

		self.NextParticle = CurTime() + ( 1 - self.FFTScale ) * .25

	end

	/*if self.FFTScale >= .8 then

		for i=0, 4 do

			local smoke = self.Emitter:Add( "particle/particle_noisesphere", self:GetPos() )
			if smoke then

				local vel = VectorRand():GetNormal() * math.Rand( 150, 300 ) * self.FFTScale
				smoke:SetVelocity( vel )

				smoke:SetLifeTime( 0 )
				smoke:SetDieTime( 2 )

				smoke:SetStartAlpha( 20 )
				smoke:SetEndAlpha( 0 )

				smoke:SetRoll( 0, 360 )
				smoke:SetRollDelta( math.Rand( -1, 1 ) )

				local Size = math.Rand( 5, 10 )
				smoke:SetStartSize( Size * self.FFTScale )
				smoke:SetEndSize( Size * math.Rand( 2, 5 ) )

				smoke:SetAirResistance( 100 )
				smoke:SetGravity( Vector( 0, 0, 0 ) )

				local RandDarkness = math.Rand( 0.25, 1 )
				smoke:SetColor( 255 * RandDarkness, 255 * RandDarkness, 255 * RandDarkness )

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
			multi = multi * math.Clamp( ( -distance / 6000 ) + 1, 0, 1 )

			if multi < 0.001 then return end
			multi = math.Clamp( multi, 0, 1 )

			// Shake player.
			/*if gmt_visualizer_shake:GetBool() == true then

				local angle = VectorRand() * FLStream:FLGetAverage( 1, 5 ) ^ 2.2 * 10 * multi
				angle.z = 0
				LocalPlayer():SetEyeAngles( EyeAngles() + angle )

			end*/

			// Post Events
			if gmt_visualizer_effects:GetBool() == false then return end

			--local bass = FLStream.FFTScale

			if --[[bass < .15 ||]] distance > 2048 then return end

			local volume = FLStream.FFTBass * FLStream.FLVolMulti
			local blur = math.Clamp( ( volume * -10 ) + 1, 0.3, 1 )
			local invert = volume * -10 + 1
			local darkness = -multi + 1.5
			//local avg = math.Clamp( volume * 2  - 0.1, 0, 1 )
			//local smooth = smooth + (( avr - smooth )*FrameTime()*10)	

			--DrawSunbeams( math.Clamp( 1 * volume, .9, 1 ), math.Clamp( .8 * volume, .1, .8 ), math.Clamp( 3 * bass, 2.5, 3 ), toscrpos.x / w, toscrpos.y / h )
			DrawSunbeams( darkness, math.max( volume * 0.8, 0.1 ), math.max( volume * 0.5, 0.3 ), toscrpos.x / w, toscrpos.y / h )
			DrawMotionBlur( blur, 1, 0 )
			DrawBloom( darkness, invert * ( multi / 10 ), math.max( invert * 40 + 2, 5 ), math.max( invert * 40 + 2, 5 ), 4, 8, 1, 1, 1 )

			// This shit is too intense, yo
			/*local colormod = {
				["$pp_colour_addr"] 		= 3 / 255 * multi,
				["$pp_colour_addg"] 		= 0,
				["$pp_colour_addb"] 		= 4 / 255 * multi,
				["$pp_colour_brightness"] 	= Lerp( multi, 0, -0.11 ),
				["$pp_colour_contrast"] 	= Lerp( multi, 2, 1.4 ),
				["$pp_colour_colour"] 		= Lerp( multi, 1, 2.32 ),
				["$pp_colour_mulr"] 		= 0,
				["$pp_colour_mulg"] 		= 0,
				["$pp_colour_mulb"] 		= 0,
			}
			DrawColorModify( colormod )*/

		end

	end

end