AddCSLuaFile("cl_init.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player.lua" )

include( "shared.lua" )
include( "sh_player.lua" )

/*util.AddNetworkString("CLPlayerThink")

hook.Add("PlayerThink", "teast", function(ply)
	net.Start("CLPlayerThink")
		net.WriteEntity(ply)
	net.Broadcast()
end)*/

// Set VIP on join
hook.Add( "PlayerInitialSpawn", "JoinSetVIP", function( ply )
	if !ply:IsValid() || ply:IsBot() then return end

	if Vip.VIPForAll then
		ply:SetNWBool( "VIP", true )
		ply.IsVIP = true
		return
	end

	// TODO: code for actually getting vips from DB
end)

// Glow Stuff
local delay = .5
local timeSince = 0
concommand.Add( "gmt_updateglowcolor", function( ply, cmd, args )
    if CurTime() < timeSince then return end
    if !ply:IsVIP() then return end

    local color = ply:GetInfo( "cl_playerglowcolor" )
    if color then
        timeSince = CurTime() + delay
        ply:SetNWVector( "GlowColor", Vector(color) )
    end
end)

hook.Add( "PlayerFullyJoined", "JoinSetGlow", function( ply )
    if !ply:IsValid() || ply:IsBot() || !ply:IsVIP() then return end

    ply:ConCommand( "gmt_updateglowcolor" )
end )

/*hook.Add( "PlayerInitialSpawn", "JoinSetGlow", function( ply )
	if !ply:IsValid() || ply:IsBot() || !ply:IsVIP() then return end

    ply:ConCommand( "gmt_updateglowcolor" )
end)*/