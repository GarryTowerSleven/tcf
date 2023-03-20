AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_meta.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("minecraft_skin_updated")
util.AddNetworkString("minecraft_skin_update")

net.Receive("minecraft_skin_updated", function(len, ply)

	local skin = net.ReadString()
	MinecraftSkinUpdate( ply, skin )

	//ply:Msg2( T( "MCSkinChange" ) )

end )

function MinecraftSkinUpdate( ply, new )
	net.Start( "minecraft_skin_update" )
		net.WriteEntity( ply )
		net.WriteString( ply:GetNWString( "MinecraftSkin", "" ) )
		net.WriteString( new or "" )
	net.Broadcast()

	ply:SetNWString( "MinecraftSkin", new )
end

hook.Add( "PlayerInitialSpawn", "JoinMCSkin", function(ply)
end)

hook.Add( "Location", "SkinRefresh", function(ply)
end )