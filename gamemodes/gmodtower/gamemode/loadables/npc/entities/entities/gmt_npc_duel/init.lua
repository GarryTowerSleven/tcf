AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:AcceptInput( name, activator, ply )
    if ( !self.NextUse ) then self.NextUse = 0 end
    if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + 1

	ply:Msg2( T( "DuelsDisable" ) )
end