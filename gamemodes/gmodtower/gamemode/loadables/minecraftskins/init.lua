AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_meta.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("minecraft_skin_updated")
util.AddNetworkString("minecraft_skin_update")

net.Receive("minecraft_skin_updated", function(len, ply)

	local skin = net.ReadString()
	MinecraftSkinUpdate( ply, skin )

	if ply:GetModel() == "models/player/mcsteve.mdl" then
		ply:Msg2( T( "MCSkinChange" ) )
		ply:SetNet( "MCSkinName", skin )
	end

end )

function MinecraftSkinUpdate( ply, new )
	net.Start( "minecraft_skin_update" )
		net.WriteEntity( ply )
		net.WriteString( ply:GetInfo("cl_minecraftskin") )
		net.WriteString( new or "" )
	net.Broadcast()
end

hook.Add( "PlayerSpawnClient", "JoinMCSkin", function(ply)
	if ply:GetModel() == "models/player/mcsteve.mdl" && ply:GetInfo("cl_minecraftskin") != "" then
		ply:SetNet( "MCSkinName", ply:GetInfo("cl_minecraftskin"))
	end
end )

hook.Add( "Location", "SkinRefresh", function(ply)
	MinecraftSkinUpdate(ply, ply:GetInfo("cl_minecraftskin"))
end )