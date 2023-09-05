
include( "shared.lua" )

AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "shared.lua" )

local meta = FindMetaTable("Player")

module( "Emotions", package.seeall )

function meta:SetEmotion( enum, time, fear )
	self.DesiredEmotion = enum
	self.LastEmotion = CurTime() + ( time or 30 )
	if fear then return end
	hook.GetTable()["PlayerThink"]["Emotions"]( self )
end

hook.Add("PlayerSpawn", "Emotions", function(ply)
	ply:SetEmotion(EMOTION_HAPPY, 1)
end)

hook.Add("PlayerThink", "Emotions", function(ply)
	local default = ply.AFK and EMOTION_SLEEPY || ply:GetNet( "BAL" ) > 0 && EMOTION_WASTED || ply.LastKeyPress and ply.LastKeyPress + 30 < CurTime() && EMOTION_BORED || EMOTION_HAPPY

	if ply.LastDefault != default || ply.LastEmotion < CurTime() then
		ply:SetEmotion( default, nil, true )
		ply.LastDefault = default
	end

	if ply.LastEmotion != ply.DesiredEmotion then
		ply:SetNet( "Emotion", ply.DesiredEmotion )
		ply.LastEmotion = ply.DesiredEmotion
	end
end)

hook.Add("KeyPress", "Emotion", function(ply, key)
	ply.LastKeyPress = CurTime()
end)

hook.Add("EntityTakeDamage", "Emotion", function(ply, dmg)
	if ply:IsPlayer() then
		ply:SetEmotion( EMOTION_PAIN, 2 )
	end
end)