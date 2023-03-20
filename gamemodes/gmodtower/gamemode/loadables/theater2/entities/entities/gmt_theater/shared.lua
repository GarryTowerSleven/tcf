AddCSLuaFile()

ENT.PrintName = "GMT Theater Screen"

ENT.Type = "anim"
ENT.Base = "mediaplayer_base"

ENT.Model = Model( "models/gmod_tower/theater_screen.mdl")

ENT.MediaPlayerType = "entity"
ENT.IsMediaPlayerEntity = true

ENT.RenderGroup = RENDERGROUP_OPAQUE

DEFINE_BASECLASS( "mediaplayer_base" )

list.Set( "MediaPlayerModelConfigs", ENT.Model, {
	angle = Angle(-90, 90, 0),
	offset = Vector(10,346,480),
	width = 692,
	height = 355
} )

function ENT:OnMediaChanged( media )
	if SERVER && media && self:Location() == 41 && self:GetClass() == "gmt_theater" then
		local title = media:Title()

		SetGlobalString( "CurVideo", title )
	end
end

function ENT:SetupMediaPlayer( mp )
	if SERVER then
		mp:on("mediaChanged", function(media) self:OnMediaChanged(media) end)
	end
end