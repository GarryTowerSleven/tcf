
include( "shared.lua" )

AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )

local meta = FindMetaTable("Player")

module( "Emotions", package.seeall )

function meta:SetEmotion( enum )
	self.DesiredEmotion = enum
	self.LastEmotion = CurTime()
end

hook.Add("PlayerThink", "Emotions", function(ply)
	local default = ply.AFK and EMOTION_SLEEPY || ply.LastKeyPress + 30 < CurTime() && EMOTION_BORED || EMOTION_HAPPY

	if ply.LastDefault != default then
		ply:SetEmotion( default )
		ply.LastDefault = default
	end

	if ply.LastEmotion + 30 < CurTime() || ply.LastEmotion != ply.DesiredEmotion then
		ply:SetNet( "Emotion", ply.DesiredEmotion )
		ply.LastEmotion = ply.DesiredEmotion
	end
end)

hook.Add("KeyPress", "Emotion", function(ply, key)
	ply.LastKeyPress = CurTime()
end)