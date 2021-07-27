AddCSLuaFile()

ENT.PrintName = "GMT Theater Screen"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.Model = Model( "models/props_phx/rt_screen.mdl" )

ENT.MediaPlayerType = "entity"
ENT.IsMediaPlayerEntity = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

DEFINE_BASECLASS( "mediaplayer_base" )

list.Set( "MediaPlayerModelConfigs", ENT.Model, {
	angle = Angle( -90, 90, 0 ),
	offset = Vector( 0, 0, 0 ),
	width = 880,
	height = 495
} )

function ENT:SetupDataTables()
	BaseClass.SetupDataTables( self )

	self:NetworkVar( "String", 1, "MediaThumbnail" )
end

if SERVER then

	function ENT:SetupMediaPlayer( mp )
		mp:on("mediaChanged", function(media) self:OnMediaChanged(media) end)
	end

	function ENT:OnMediaChanged( media )
		self:SetMediaThumbnail( media and ( media._metadata.thumbnail || media:Thumbnail() ) or "" )
	end
	
end