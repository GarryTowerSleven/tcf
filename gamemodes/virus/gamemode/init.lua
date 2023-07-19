AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_deathnotice.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_post_events.lua" )
AddCSLuaFile( "cl_hudmessage.lua" )
AddCSLuaFile( "cl_radar.lua" )

include( "shared.lua" )
include( "sh_player.lua" )

include( "sv_cleanup.lua" )
include( "sv_round.lua" )
include( "sv_spawn.lua" )
include( "sv_player.lua" )
include( "sv_weapons.lua" )
include( "sv_think.lua" )

GM.NumRounds = 10

GM.VirusSpeed = 330
GM.HumanSpeed = 300

GM.WaitingTime = 45
GM.IntermissionTime = 12
GM.InfectingTime = { 15, 24 }
GM.RoundTime = 90

GM.NumWaitingForInfection = 8
GM.NumRoundMusic = 5

GM.NumLastAlive = 2

GM.HasLastSurvivor = false

CreateConVar("gmt_srvid", 6)

function GM:Initialize()
	globalnet.SetNet( "MaxRounds", self.NumRounds )
end

function GM:HudMessage( ply, index, time, ent, ent2, color )

	net.Start( "HudMsg" )
		net.WriteInt( index, 8 )
		net.WriteInt( time, 8 )

		if ( IsValid( ent ) ) then
			net.WriteEntity( ent )
		end

		if ( IsValid( ent2 ) ) then
			net.WriteEntity( ent2 )
		end

		if color != nil then
			net.WriteInt( color.r, 16 )
			net.WriteInt( color.g, 16 )
			net.WriteInt( color.b, 16 )
			net.WriteInt( color.a, 16 )
		end

	if ply == nil then
		net.Broadcast()
	else
		net.Send( ply )
	end

end

function GM:ProcessRank( ply )

	local rank = 1
	
	for _, v in ipairs( player.GetAll() ) do
		
		if ( v:Frags() > ply:Frags() ) then
		
			rank = rank + 1
			
		elseif ( v:Frags() == ply:Frags() ) then

			if ( v:Deaths() < ply:Deaths() ) then
				rank = rank + 1
			end

		end

	end
	
	ply:SetNet( "Rank", rank )
	
end

hook.Add( "InitPostEntity", "MapCleanUp", function()
	GAMEMODE:CleanUpMap()
end )

hook.Add( "EntityTakeDamage", "DamageNotes",  function( target, dmginfo )

	if GAMEMODE:GetState() == STATE_PLAYING then

		if target:IsPlayer() && dmginfo:GetAttacker():IsPlayer() && target:GetNet( "IsVirus" ) then
			net.Start( "DamageNotes" )
				net.WriteFloat( math.Round( dmginfo:GetDamage() ) )
				net.WriteVector( target:GetPos() + Vector( math.random(-3,3), math.random(-3,3), math.random(48,50) ) )
			net.Send( dmginfo:GetAttacker() )
		end

	end

end )

util.AddNetworkString( "DamageNotes" )
util.AddNetworkString( "ScorePoint" )
util.AddNetworkString( "HudMsg" )
util.AddNetworkString( "StartRound" )
util.AddNetworkString( "EndRound" )
util.AddNetworkString( "Infect" )
util.AddNetworkString( "DmgTaken" )
util.AddNetworkString( "Spawn" )
util.AddNetworkString( "Scream" )