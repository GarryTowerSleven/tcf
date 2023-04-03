AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Use( ply )
	if CurTime() < self.NextUse then return end
	self.NextUse = CurTime() + 1

	ply:Msg2( "This machine is currently out of service, try again later!" )
end