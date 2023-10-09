AddCSLuaFile("cl_init.lua")
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player.lua" )

include( "shared.lua" )
include( "sh_player.lua" )

require("fwens")

GroupID = "103582791464989702"

function SQLSetup( ply, vip )

	if not Database.IsConnected() then return end
	
	Database.Query( "SELECT * FROM `gm_vip` WHERE `steamid` = '" .. ply:SteamID() .. "';", function( res, status, err )
    
		if status != QUERY_SUCCESS then
			return
		end
		
		if table.Count( res ) == 0 and vip then
		
			//print("inserting player, this is a newbie!")
			Database.Query( "INSERT INTO `gm_vip` (steamid, current, rewarded) VALUES ('" .. ply:SteamID() .. "', 1, 0);" )
			ply._NeedsRewarding = true
			
		elseif table.Count( res ) >= 1 then
		
			if vip then
			
				if res[1].current != 1 then
					//print("you should be current!")
					Database.Query( "UPDATE `gm_vip` SET `current` = 1 WHERE `steamid` = '" .. ply:SteamID() .. "';" )
				end
				
				if res[1].rewarded != 1 then
					//print("what! why don't you have a reward.")
					ply._NeedsRewarding = true
				end
				
			end
			
			if not vip and res[1].current != 0 then
				//print("removing vip")
				Database.Query( "UPDATE `gm_vip` SET `current` = 0 WHERE `steamid` = '" .. ply:SteamID() .. "';" )
			end
			
		end
		
		PrintTable( res )
		
    end )
	
end
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

	if returnedData.isMember or false then
		SQLSetup( ply, true )
		ply.IsVIP = true
		ply:SetNet( "VIP", true )
		
		if IsLobby then
			ply:SetNet( "RoomMaxEntityCount", 400 )
		end
	else
		SQLSetup( ply, false )
		ply.IsVIP = false
		ply:SetNet( "VIP", false )
		
		if IsLobby then
			ply:SetNet( "RoomMaxEntityCount", 200 )
		end
	end

end )

// Glow Stuff
local delay = .5
local timeSince = 0
concommand.Add( "gmt_updateglow", function( ply, cmd, args )
	if not IsLobby then return end
	
	if !ply:IsVIP() then return end
	if (ply:GetInfoNum( "gmt_vip_enableglow", 1 )) == 0 then ply:SetNet( "GlowEnabled", false ) return end

	ply:SetNet( "GlowEnabled", true )
end)
concommand.Add( "gmt_updateglowcolor", function( ply, cmd, args )
	if not IsLobby then return end

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

hook.Add( "PlayerSpawnClient", "JoinSetGlow", function( ply )
	if not IsLobby then return end

	if !ply:IsValid() || ply:IsBot() || !ply:IsVIP() then return end

	ply:ConCommand( "gmt_updateglow" )
	ply:ConCommand( "gmt_updateglowcolor" )
end )

/*hook.Add( "PlayerInitialSpawn", "JoinSetGlow", function( ply )
	if !ply:IsValid() || ply:IsBot() || !ply:IsVIP() then return end

    ply:ConCommand( "gmt_updateglowcolor" )
end)*/