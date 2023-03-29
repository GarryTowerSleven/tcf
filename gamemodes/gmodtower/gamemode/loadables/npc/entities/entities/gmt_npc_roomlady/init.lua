AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Use( ply )
	GTowerRooms.ShowRentWindow( self, ply )
end