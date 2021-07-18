include('shared.lua')

ENT.CurFFT = {}

function ENT:Initialize()	
	self:GetStream()
end

function ENT:Think()

	if not IsValid( self.Stream ) then
		self:GetStream() -- Try to find a stream
	end

end

local CurrentCondo
local CurrentMediaPlayer

function ENT:GetFirstMediaPlayerInLocation()
	-- Return already valid media player
	if IsValid(self.MediaPlayer) then return self.MediaPlayer end

	-- Find new one
	local mp = Location.GetMediaPlayersInLocation( self:Location() )[1]
	if mp then
		self.MediaPlayer = mp
		return self.MediaPlayer
	end
end

function ENT:GetStream()

	-- Return already valid stream
	if IsValid(self.Stream) then return self.Stream end

	-- Find new stream
	local mp = self:GetFirstMediaPlayerInLocation()
	if not IsValid( mp ) then return end

	local media = mp:GetMedia()
	if not IsValid(media) then return end

	local channel = media.Channel
	if not IsValid(channel) then return end

	self.Stream = channel

	return self.Stream

end

function ENT:StreamIsPlaying()

	local mp = self:GetFirstMediaPlayerInLocation()
	if not IsValid( mp ) then return end

	return mp:IsPlaying()

end

function ENT:GetFFTFromStream()

	if not IsValid(self.Stream) then return end -- There's no stream apparently

	self.Stream:FFT( self.CurFFT, FFT_2048 )
	return self.CurFFT

end

net.Receive( "OpenReqMenu", function()
	local ent = net.ReadEntity()
	MediaPlayer.OpenRequestMenu( ent:GetFirstMediaPlayerInLocation() )
end )

----------------------------------------------------
-- HELPER FUNCTIONS
----------------------------------------------------

local SPECHEIGHT 	= 64
local SPECWIDTH		= 300
local BANDS			= 28
local ox, oy		= -100, -45

function ENT:DrawSpectrumAnalyzer()

	local Stream = self.Stream
	local fft = self:GetFFTFromStream()
	local b0 = 0

	local Col = Color( 0, 255, 255 )
	for x = 0, BANDS-2 do
		Col = colorutil.Rainbow(x*10)
		surface.SetDrawColor(Color( Col.r, Col.g, Col.b, 150))
		local sum = 0
		local sc = 0
		local b1 = math.pow(2,x*10.0/(BANDS-1))

		if (b1>1023) then b1=1023 end
		if (b1<=b0) then b1=b0+1 end
		sc=10+b1-b0
		while b0 < b1 do
			sum = sum + fft[2+b0]
			b0 = b0 + 1
		end
		y = (math.sqrt(sum/math.log10(sc))*1.7*SPECHEIGHT)-4
		y = math.Clamp(y, 0, SPECHEIGHT)
		surface.DrawRect(ox + x*8, oy - y - 1, 7, y + 1)
	end

end

function ENT:DrawParticles( ply )

	if !self.Emitter then
		self.Emitter = ParticleEmitter( self:GetPos() )
	end

	local Stream = self.Stream
	local bass = fft.GetBass( Stream )

	local pos = self:ParticlePosition( ply ) + Vector( 0, 0, 0 )
	local angle = Vector(0,0,1)
	local color = colorutil.Smooth( .5 )

	for i=1, 10 do

		//local flare = Vector( 0, math.random( -10, 10 ), 0 )
		local flare = Vector( CosBetween( -16, 16, CurTime() * bass ), SinBetween( -16, 16, CurTime() * bass), 0 )

		local particle = self.Emitter:Add( "sprites/powerup_effects", pos + flare )
		if particle then

			particle:SetVelocity( ( angle * bass * 1000 ) )
			particle:SetDieTime( math.Rand( 1, 2 ) )
			particle:SetStartAlpha( bass * 1000 )
			particle:SetEndAlpha( 0 )

			particle:SetStartSize( bass * 100 )
			particle:SetEndSize( 0 )

			///particle:SetGravity( ( angle:Forward() * 50 * -1 ) /*- ( flare / 3 )*/ )
			particle:SetGravity( Vector(0,0,-200) )

			particle:SetColor( color.r, color.g, color.b, 255 )

			particle:SetCollide( true )

		end

	end

end

function ENT:ParticlePosition( ply, bound )

	local pos = util.GetCenterPos( ply )

	if bound then
		pos = pos + ( VectorRand() * ( self:BoundingRadius() * ( bound or .35 ) ) )
	end

	return pos

end