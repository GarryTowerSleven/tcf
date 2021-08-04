AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

include "shared.lua"

function ENT:Initialize()
	self:SetModel( self.Model )
	self:DrawShadow( false )
end

hook.Add( "PlayerFullyJoined", "webreload", function( ply )
	ply:ConCommand( "gmt_clearwebboard" )
end )