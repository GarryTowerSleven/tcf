AddCSLuaFile()

ENT.PrintName = "GMT Theater Screen"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.Model = Model( "models/props_phx/rt_screen.mdl" )

ENT.MediaPlayerType = "entity"
ENT.IsMediaPlayerEntity = true

ENT._Location = nil

ENT.RenderGroup = RENDERGROUP_OPAQUE

DEFINE_BASECLASS( "mediaplayer_base" )

list.Set( "MediaPlayerModelConfigs", ENT.Model, {
	angle = Angle( -90, 90, 0 ),
	offset = Vector( 0, 0, 0 ),
	width = 880,
	height = 495
} )

function ENT:OnMediaChanged( media )
	if SERVER && media && self._Location then
		SetGlobalString( "TheaterThumb_" .. tostring(self._Location), media:Thumbnail() or 0 )
		SetGlobalString( "TheaterTitle_" .. tostring(self._Location), media:Title() or 0 )
	end
end

function ENT:SetupMediaPlayer( mp )
	if SERVER then
		mp:on("mediaChanged", function(media) self:OnMediaChanged(media) end)
	end

	local locName = Location.Get(self:Location()).Name
	if locName then
		self._Location = locName
		if SERVER then
			SetGlobalString( "TheaterThumb_" .. tostring(locName), 0 )
			SetGlobalString( "TheaterTitle_" .. tostring(locName), 0 )
		end
	end
end