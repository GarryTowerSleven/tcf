include("shared.lua")

module( "Ambiance", package.seeall )

Enabled = CreateClientConVar( "gmt_ambiance_enable", "1", true, false )
PreferredVolume = CreateClientConVar( "gmt_ambiance_volume", "20", true, false )

IsPlaying = false

CurID = 0
LastID = 0

CurMusic = nil
CurMusicTime = nil
CurMusicEndTime = 0

CurMusicVolume = 20

CurMusicFading = false
CurMusicFadingVolume = 0

function Ambiance:SetupBGM( id )

	if !self.Enabled:GetBool() then return end

	local songData = self:GetSongData( id )

	self.SongData = songData
	self.CurID = id
	self.CurMusic = CreateSound( LocalPlayer(), songData[1] )
	self.CurMusicTime = songData[2]

end

function Ambiance:GetSongData( id )

	local songData = self.Music[ id ]

	// Handle multiple songs per location
	if type( songData[1] ) == "table" then
		local rand = math.random( 1, #songData[1] )

		songData = songData[rand]
	end

	return songData

end

function Ambiance:PlayBGM( volume )

	if !self.Enabled:GetBool() then return end
	if !self.CurMusic then return end

	self.CurMusic:Stop()
	self.CurMusic:PlayEx( volume or 1, 100 )
	self.CurMusicVolume = volume or 1

	self.IsPlaying = true

	if self.SongData then
		self.CurMusicEndTime = CurTime() + self.SongData[2]
	end

end

function Ambiance:CheckSetting()

	if !Ambiance.Enabled:GetBool() then
		self:StopBGM()
	end
	/*else
		if !self.IsPlaying then
			self:FadeInBGM( Ambiance.PreferredVolume:GetInt() * .01 )
		end
	end*/

end

function Ambiance:ThinkBGM()

	if !self.CurMusic then return end

	self:CheckSetting()

	if !Ambiance.Enabled:GetBool() then return end

	if CurTime() > self.CurMusicEndTime then
		self:PlayBGM()
	end

	self:ThinkBGMFade()

end

function Ambiance:ThinkBGMFade()

	if !self.CurMusicFading then return end

	if self.CurMusicFadingVolume != self.CurMusicVolume then

		local volume = self.CurMusicVolume or 0
		local fadeVolume = self.CurMusicFadingVolume or 0

		volume = math.Approach( volume, fadeVolume, .0015 )
		self:SetVolumeBGM( volume )

		if volume == 0 then
			self.CurMusic = nil
		end

	else
		self.CurMusicFading = false
	end

end

function Ambiance:FadeInBGM( volume )

	if !self.Enabled:GetBool() then return end

	if !self.CurMusic then return end

	//self:SetVolumeBGM( 0.0079 ) // this is a hack, setting to zero will reset the song!
	self:PlayBGM( 0 )

	self.CurMusicFading = true
	self.CurMusicFadingVolume = volume

end

function Ambiance:SetDefaultBGM( id )

	//if self.CurID == id then return end

	self:SetupBGM( id )
	self:FadeInBGM( self.PreferredVolume:GetInt() * .01 )

end

function Ambiance:SetVolumeBGM( volume )

	if !self.Enabled:GetBool() then return end

	if !self.CurMusic then return end

	self.CurMusicVolume = volume
	self.CurMusic:ChangeVolume( volume, 0 )

end

function Ambiance:FadeOutBGM()

	if !self.Enabled:GetBool() then return end

	if !self.CurMusic then return end

	if !self.CurMusic:IsPlaying() then return end

	self.CurMusicFading = true
	self.CurMusicFadingVolume = 0
	self.IsPlaying = false
	self.LastID = self.CurID
	//self.CurID = 0
	//self.CurMusicFadingVolume = 0.0079 // this is a hack, setting to zero will reset the song!

end

function Ambiance:StopBGM()

	if !self.CurMusic then return end

	self.CurMusic:Stop()
	self.CurMusic = nil
	self.IsPlaying = false
	self.LastID = self.CurID
	//self.CurID = 0

end

/*hook.Add( "InitPostEntity", "AmbianceInitPostEntity", function()

	if !Ambiance.Enabled:GetBool() then return end

	Ambiance:SetupBGM( 1 )
	Ambiance:PlayBGM( 0 )

end )*/

hook.Add( "Think", "AmbianceThink", function()

	Ambiance:ThinkBGM()

end )

net.Receive( "AmbianceMessage", function( len )
	
	local Id = net.ReadInt( 4 )

	if Id == 1 then -- Play Sound

		local Volume = net.ReadInt( 8 )
		Ambiance:PlayBGM( Volume )

	elseif Id == 2 then -- Stop

		Ambiance:StopBGM()

	elseif Id == 3 then -- Fade in

		local Volume = net.ReadInt( 8 )
		Ambiance:FadeInBGM( Volume )

	elseif Id == 4 then -- Fade out

		Ambiance:FadeOutBGM()

	elseif Id == 5 then -- New BGM

		local MNum = net.ReadInt( 8 )
		Ambiance:SetupBGM( MNum )

	elseif Id == 6 then -- Play single sound

		if Ambiance.Enabled:GetBool() then

			local Number = net.ReadInt( 8 )
			local Snd = Ambiance.Sounds[Number]
			if Snd then

				surface.PlaySound( Snd )

			end

		end

	end

end )

hook.Add( "GTowerOpenStore", "AmbianceStoreOpen", function()

	if Ambiance.Enabled:GetBool() then

		/*Ambiance.LastID = Ambiance.CurID
		LocalPlayer():ChatPrint( Ambiance.LastID )*/

		Ambiance:SetupBGM( 0 )
		Ambiance:FadeInBGM( Ambiance.PreferredVolume:GetInt() * .01 )

	end

end )

hook.Add( "GTowerCloseStore", "AmbianceStoreClose", function()

	if Ambiance.Enabled:GetBool() then

		/*if Ambiance.LastID then
			LocalPlayer():ChatPrint( Ambiance.LastID )
			Ambiance:SetupBGM( Ambiance.LastID )
			Ambiance:FadeInBGM( Ambiance.PreferredVolume:GetInt() * .01 )
		end*/

		Ambiance:FadeOutBGM()

	end

end )

hook.Add( "Location", "AmbianceLocation", function( ply, loc )

	if LocalPlayer() != ply then return end

	if Ambiance.Enabled:GetBool() then

		// Find ambiance based on the location ID
		local nextID = 0
		for id, tbl in pairs( Ambiance.Music ) do

			if loc == id then
				nextID = id
			end

			// Handle gamemodes
			if nextID == 36 || nextID == 37 then
				nextID = 35
			end

		end

		// Don't set the same ID
		if Ambiance.CurID == nextID then return end

		// Set the song
		if nextID != 0 then
			Ambiance:SetDefaultBGM( nextID )
		else
			// No song, fade whatever we have out
			if Ambiance.IsPlaying then
				Ambiance:FadeOutBGM()
			end
		end

	end

end )