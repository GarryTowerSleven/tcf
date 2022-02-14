AddCSLuaFile()

DEFINE_BASECLASS( "mediaplayer_tv" )

ENT.PrintName 		= "Small Screen TV"
ENT.Author 			= "Samuel Maddock"
ENT.Instructions 	= "Right click on the TV to see available Media Player options. Alternatively, press E on the TV to turn it on."
ENT.Category 		= "Media Player"

ENT.Type = "anim"
ENT.Base = "mediaplayer_tv"

ENT.Spawnable = true

ENT.Model = Model( "models/gmod_tower/suitetv.mdl" )

list.Set( "MediaPlayerModelConfigs", ENT.Model, {
	angle = Angle(-90, 90, 0),
	offset = Vector(1.1, 25.535, 35.06),
	width = 51.19,
	height = 27.928
} )