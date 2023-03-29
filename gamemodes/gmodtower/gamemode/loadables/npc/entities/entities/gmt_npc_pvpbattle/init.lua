AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Use( ply )
	PvpBattle:OpenStore( ply )
end