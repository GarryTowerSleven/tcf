AddCSLuaFile "shared.lua"
AddCSLuaFile "cl_init.lua"

include "shared.lua"

function ENT:Initialize()
	self:SetModel( self.Model )
	self:DrawShadow( false )

	self:SetSolid( SOLID_NONE )

	//self.NextUse = 0
end

hook.Add( "PlayerSpawnClient", "webreload", function( ply )
	ply:ConCommand( "gmt_clearwebboard" )
end )

/*function ENT:Use( ply )
	if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + 1

	SendUserMessage( "OpenTowerUnite", ply )
end*/