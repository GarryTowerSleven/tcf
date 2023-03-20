AddCSLuaFile("cl_init.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player.lua" )

include( "shared.lua" )
include( "sh_player.lua" )

module( "VIP", package.seeall )

require("fwens")

GroupID = "103582791464989702"

// Set VIP on join
hook.Add( "PlayerInitialSpawn", "JoinSetVIP", function( ply )
	if !ply:IsValid() || ply:IsBot() then return end

	if ( VIPForAll ) then
		ply:SetNWBool( "VIP", true )
		ply.IsVIP = true
		return
	end

	if ( fwens ) then
		fwens.GetInSteamGroup( ply:SteamID64(), GroupID )
	end
end)

hook.Add( "GroupDataReturned", "GetGroupData", function( returnedData )
	local ply = player.GetBySteamID64(returnedData.steamID64)
	if !ply || !IsValid(ply) then return end

	ply:SetSetting( "GTSuiteEntityLimit", 150 )

	if ( returnedData.isMember ) then
		ply:SetNWBool( "VIP", true )
		ply:SetSetting( "GTSuiteEntityLimit", 200 )
		ply.IsVIP = true
	end
end )

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