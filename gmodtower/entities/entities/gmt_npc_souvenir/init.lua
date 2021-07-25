AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

/*
function ENT:AcceptInput( name, activator, ply )

    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then
	GTowerStore:OpenStore( ply, 6 )
	self:TypeOnComp()
    end
end
*/