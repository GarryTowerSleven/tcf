
-----------------------------------------------------

AddCSLuaFile()

if SERVER then
	util.AddNetworkString("gmt_club_request")
	AddCSLuaFile("nightclub.lua")
end
include("nightclub.lua")

DEFINE_BASECLASS( "mediaplayer_base" )

ENT.Type 			= "anim"
ENT.Base 			= "mediaplayer_base"
ENT.PrintName		= "Club DJ Turntable"
ENT.Author			= "Foohy"
ENT.Information		= "It spins around"
ENT.Category		= "Foohy"
--ENT.MediaPlayerType = "club"

ENT.IsMediaPlayerEntity = true

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.Model			= Model( "models/props_vtmb/turntable.mdl")

list.Set( "MediaPlayerModelConfigs", ENT.Model, {
	angle = Angle(-90, 90, 0),
	offset = Vector(1.7, 25.75, 35.75),
	width = 0,
	height = 0
} )

function ENT:Use(ply)

	if CurTime() < (ply.ClubWaitTime or 0) then return end

	ply.ClubWaitTime = CurTime() + 3

	net.Start("gmt_club_request")
		net.WriteEntity(self)
	net.Send(ply)
end

function ENT:SetupDataTables()
	BaseClass.SetupDataTables( self )

	self:NetworkVar( "String", 1, "MediaThumbnail" )
end

if SERVER then

	function ENT:SetupMediaPlayer( mp )
		mp:on("mediaChanged", function(media) self:OnMediaChanged(media) end)
	end

	function ENT:OnMediaChanged( media )
		self:SetMediaThumbnail( media and media:Thumbnail() or "" )
	end

else
-- Sizemodes
local VISUALIZER_SIZE_LINEAR  = 0
local VISUALIZER_SIZE_SQRT    = 1
local VISUALIZER_SIZE_DECIBEL = 2

ENT.FFT = {}
ENT.FFTSmoothed = {}
ENT.Ranges = {}

-- The number of indices in the smoothed fft
ENT.SmoothedResolution = 24

-- How fast for the rolling maximum to fall
ENT.MaxValueFallSpeed = 0.01

-- The minimum value for the maximum
-- Prevents bass values from approaching infinity as bass goes completely silent
ENT.MinBassMax = 0.08

ENT.FrequencyBias = 10

ENT.SizeMode = VISUALIZER_SIZE_DECIBEL
ENT.ApproachScale = 20 -- Scale how much to approach the new FFT value when smoothing out (higher = smoother)

local BaseClass = baseclass.Get( "mediaplayer_base" )

function ENT:Initialize()
	--BaseClass.Initialize(self)

	self.TotalAverage = 0

	-- Add some useful frequencies we'll use
	self:AddRange("bass", 20, 200)
	self:AddRange("bassmids", 20, 2500)
	self:AddRange("mids", 630, 2500)
	self:AddRange("treble", 200, 2000)

end


function ENT:SetupMediaPlayer( mp )
	-- Initial update in case media player is playing before its installed onto
	-- the entity.
	local channel = self:GetStream()
	if channel then
		self.Stream = channel
	end

	mp:on('mediaChanged', function(media)
		if not media then return end

		media:on('channelReady', function(channel)
			self.Stream = channel
		end)

		media:on('stop', function()
			self.Stream = nil
		end)
	end)
end

-- Use this to quickly get the correct height of a value depending on mode
function ENT:GetGraphHeight( value, height, sizemode )
	value = value or 0

	if sizemode == VISUALIZER_SIZE_LINEAR then
		return value * height * 9 -- Linear
	elseif sizemode == VISUALIZER_SIZE_SQRT then
		return math.sqrt(value) * height * 2 -- Sqrt
	elseif sizemode == VISUALIZER_SIZE_DECIBEL then
		return math.max(20 * math.log10(value) + 90, 0)
	end

	return -1
end

local clr = nil
-- Same as the rainbow function but the colors match for all clients
local function Rainbow( speed, offset, saturation, value )
	-- HSVToColor doesn't actually return a color object, just something that mimics one
	clr = HSVToColor( ( CurTime() * (speed or 50) % 360 ) + ( offset or 0 ),
		saturation or 1, value or 1 )

	return Color(clr.r, clr.g, clr.b, clr.a)
end

-- Return the current theme color all visualizer things will share
ClubRainbowOffset = 0
function ENT:GetThemeColor( offset )
	return Rainbow(10, (self.TotalAverage or 0) * 12000 + (offset or 0) + (ClubRainbowOffset or 0))
end

function ENT:AddRange( name, low, high, smoothAmt )
	self.Ranges[name] =
	{
		Low = low,
		High = high,
		SmoothAmount = smoothAmt or 1,

		SmoothedAverage = 0,
		Average = 0,
		Max = 0,
	}
end

function ENT:SetHighLow( name, high, low )
	if not self.Ranges[name] then return end

	self.Ranges[name].High = high
	self.Ranges[name].Low = low
end

function ENT:SetSmoothAmount( name, amt)
	if not self.Ranges[name] then return end

	self.Ranges[name].SmoothAmount = amt
end

function ENT:GetMax( name )
	return self.Ranges[name] and self.Ranges[name].Max or 0
end

function ENT:GetSmoothedAverage( name, normalize )
	return (self.Ranges[name] and self.Ranges[name].SmoothedAverage or 0)
		 / (normalize and self:GetMax(name) or 1)
end

function ENT:GetAverage( name, normalize )
	return (self.Ranges[name] and self.Ranges[name].Average or 0)
		 / (normalize and self:GetMax(name) or 1)
end

function ENT:GetRange(name)
	return self.Ranges[name]
end

function ENT:GetStream()
	local mp = self:GetMediaPlayer()
	if not IsValid( mp ) then return end

	local media = mp:GetMedia()
	if not IsValid(media) then return end

	local channel = media.Channel
	if not IsValid(channel) then return end

	return channel
end

function ENT:CalculateFFT()

	local count = 2048
	local validStream = IsValid( self.Stream )
	if validStream then
		-- Get the current FFT at this moment
		count = self.Stream:FFT( self.FFT, FFT_4096)
	end

	if count <= 0 then return end

	-- Now smooth out the fft in a seperate buffer
	local fft = self.FFT
	local average = 0
	local indexLow = 0
	local indexHigh = 0
	for i=1, count do
		-- If there isn't a valid stream, default to 0
		if not validStream then
			fft[i] = 0
		end

		-- Retrieve the values of each bin
		local val = self.FFTSmoothed[i]
		local rawVal = fft[i]

		-- Smooth out the entire buffer
		self.FFTSmoothed[i] = Lerp( self.ApproachScale * RealFrameTime(), (val or 0), rawVal) -- Approach, scaled
		average = average + self.FFTSmoothed[i]

		-- Go through each of our 'ranges' of frequencies, and calculate some values
		for _, v in pairs( self.Ranges ) do
			indexLow = math.floor( (v.Low / 44100) * count )
			indexHigh = math.floor( (v.High / 44100) * count )

			-- Check if we're within bounds
			if i >= indexLow and i <= indexHigh then
				v.TempMax = math.max(rawVal, v.TempMax or 0)

				-- Calculate the average value
				v.Average = v.Average + rawVal

			elseif i == indexHigh + 1 or i == count then
				-- Calculate the rolling maximum value
				-- Used to normalize between loud and quiet songs
				local lowered = math.max(v.Max - self.MaxValueFallSpeed * RealFrameTime(), 0)
				v.Max = math.Clamp(math.max( lowered, v.TempMax), self.MinBassMax,1 )
				v.TempMax = 0

				v.Average = v.Average / (indexHigh - indexLow)
				v.SmoothedAverage = Lerp(  RealFrameTime() * v.SmoothAmount, v.SmoothedAverage or 0, v.Average)
			end
		end
	end

	average = average / count

	self.TotalAverage = Lerp( RealFrameTime() * 10, self.TotalAverage, average)
end

function ENT:Think()
	self:CalculateFFT()
end

function ENT:Draw()
	self:DrawModel()
end

-- Open a request panel when they use the dj thing
-- Temporary

net.Receive("gmt_club_request",function()
	local self = net.ReadEntity()
	if not IsValid( self ) then return end

	MediaPlayer.OpenRequestMenu( self )
end)

end

function ENT:CanUse( ply )
	return true, "REQUEST MUSIC"
end
