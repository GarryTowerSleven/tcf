AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Sequence = "vip_store_idle01"

function ENT:CanPlayerUse( ply )
	local vip = ply:IsVIP() or false

	if ( not vip ) then
		ply:Msg2( T( "StoreVIPOnly" ) )
	end

    return vip
end