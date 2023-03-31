ENT.PrintName = "GMT Theater Screen (Lobby 2)"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.RenderGroup = RENDERGROUP_OPAQUE

local BaseClass = baseclass.Get( "mediaplayer_base" )

function ENT:Initialize()

	if SERVER then
		self:SetNoDraw( true )

		local kv = self.keyvalues or {}

		-- Unique ID (optional)
		local mpId = kv.mpid

		-- Media player type (optional)
		local mpType = kv.mptype or "theater"
		mpType = tostring(mpType):lower()

		-- Install media player to entity
		self:InstallMediaPlayer( mpType, mpId )
	end

end

if SERVER then

	function ENT:SetupMediaPlayer( mp )

		local kv = self.keyvalues or {}

		mp:SetTheaterConfig({
			location = kv.location,
			screenwidth = kv.screenwidth,
			screenheight = kv.screenheight
		})

	end

	function ENT:Use()
	end

	function ENT:KeyValue( key, value )
		if MediaPlayer and MediaPlayer.DEBUG then
			print(self, key, value)
		end

		if not self.keyvalues then
			self.keyvalues = {} or self.keyvalues
		end

		self.keyvalues[key] = value

		if key:StartWith("On") then
			self:StoreOutput( key, value )
		end
	end

end