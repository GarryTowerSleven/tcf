AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

module( "BoneMod", package.seeall )

function SetBoneMod( ply, id )
	net.Start( "BoneMod" )
		net.WriteEntity( ply )
		net.WriteInt( id, 6 )
	net.Broadcast()
end

hook.Add("PlayerFullyJoined", "RecheckBoneMod", function( ply )
	if BoneMod && ply.BoneModID != nil then
		SetBoneMod( ply, ply.BoneModID )
	end
end )


hook.Add( "PlayerSetModelPost", "BonemodModelRefresh", function( ply )
	timer.Simple(.05, function()
		if BoneMod && ply.BoneModID != nil then
			SetBoneMod( ply, ply.BoneModID )
		end
	end )
end ) 

util.AddNetworkString( "BoneMod" )
