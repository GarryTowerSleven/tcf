AddCSLuaFile("cl_init.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player.lua" )

include( "shared.lua" )
include( "sh_player.lua" )

require("fwens")

GroupID = "103582791464989702"

// Set VIP on join
hook.Add( "PlayerInitialSpawn", "JoinSetVIP", function( ply )
	if !ply:IsValid() || ply:IsBot() then return end

	if ( VIPForAll ) then
		ply:SetNet( "VIP", true )
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

	ply:SetSetting( "GTSuiteEntityLimit", 200 )

	if ( returnedData.isMember ) then
		ply:SetNet( "VIP", true )
		ply:SetSetting( "GTSuiteEntityLimit", 250 )
		ply.IsVIP = true
	end
end )

// Glow Stuff
local delay = .5
local timeSince = 0
concommand.Add( "gmt_updateglow", function( ply, cmd, args )
	if !ply:IsVIP() then return end
	if (ply:GetInfoNum( "gmt_vip_enableglow", 1 )) == 0 then ply:SetNet( "GlowEnabled", false ) return end

	ply:SetNet( "GlowEnabled", true )
end)
concommand.Add( "gmt_updateglowcolor", function( ply, cmd, args )
	if CurTime() < timeSince then return end
	if !ply:IsVIP() then return end
	if (ply:GetInfoNum( "gmt_vip_enableglow", 1 )) == 0 then ply:SetNet( "GlowEnabled", false ) return end

	ply:SetNet( "GlowEnabled", true )
    local color = ply:GetInfo( "cl_playerglowcolor", 1)
    if color then
        timeSince = CurTime() + delay
        ply:SetNet( "GlowColor", Vector(color) )
    end
end)

hook.Add( "PlayerFullyJoined", "JoinSetGlow", function( ply )
	if !ply:IsValid() || ply:IsBot() || !ply:IsVIP() then return end

	ply:ConCommand( "gmt_updateglow" )
	ply:ConCommand( "gmt_updateglowcolor" )
end )

/*hook.Add( "PlayerInitialSpawn", "JoinSetGlow", function( ply )
	if !ply:IsValid() || ply:IsBot() || !ply:IsVIP() then return end

    ply:ConCommand( "gmt_updateglowcolor" )
end)*/