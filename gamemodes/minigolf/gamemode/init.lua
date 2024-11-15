AddCSLuaFile("cl_camera.lua");
AddCSLuaFile("cl_controls.lua");
AddCSLuaFile("cl_draw.lua");
AddCSLuaFile("cl_hud.lua");
AddCSLuaFile("cl_hud_customize.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("cl_music.lua");
AddCSLuaFile("cl_scorecard.lua");

AddCSLuaFile("meta_player.lua");

AddCSLuaFile("sh_move.lua");
AddCSLuaFile("sh_scores.lua");
AddCSLuaFile("shared.lua");

include("meta_player.lua");
include("round.lua");
include("sh_move.lua");
include("sh_scores.lua");
include("shared.lua");
include("sv_control.lua");

CreateConVar("gmt_srvid", 14 )
//CreateConVar("mp_flashlight", 0 )

-----------------------------------------------------
function GM:Intialize()
	self:SetState(STATE_NOPLAY)
end

function GM:PlayerSwitchFlashlight( ply )
	return false
end

//Flag Setup
function FlagSetup()
	timer.Simple( 2, function()
		for k,v in pairs (ents.FindByClass('golfhole')) do
			local flagbase = ents.Create( "flagbase" )
			flagbase:SetPos(v:GetPos())
			flagbase:Spawn()
			flagbase:SetParent(v)
		end

		timer.Simple( 2, function()
			FlagSpawn()
		end )
	end )
end

function FlagSpawn()
	for k,v in pairs (ents.FindByClass('flagbase')) do
		local flag = ents.Create( "flag" )
		flag:SetOwner(v)
		flag:SetPos(flag:GetOwner():GetPos())
		flag:Spawn()
		flag:SetParent(v)
	end
end

function FlagDestroy()
	for k,v in pairs (ents.FindByClass('flagbase')) do
		v:Remove()
	end
end

function FlagUnspawn()
	for k,v in pairs (ents.FindByClass('flag')) do
		v:Remove()
	end
end

//GetAll Functions
function SetAllMoveType(movetype)
	for k,v in pairs (player.GetAll()) do
		v:SetMoveType(movetype)
	end
end

function PrepAllBalls()
	for k,v in pairs (player.GetAll()) do
		v:SetupForHole()
	end
end

function RemoveAllBalls()
	for k,v in pairs (player.GetAll()) do
		v:RemoveBall()
	end
end

function FreezeAll()
	for k,v in pairs (player.GetAll()) do
		v:Freeze( true )
	end
end

function UnpocketAllBalls()
	for k,v in pairs (player.GetAll()) do
		v:GetGolfBall().IsPocketed = false
	end
end

function SetUnfinishedPenalty( ply )
	local penalty = PenaltyScores(GAMEMODE:GetHole()) + 3

	if ply:Swing() > penalty then
		penalty = ply:Swing() 
	end

	return penalty
end

function GetAllUnfinished()
	for k,v in pairs (player.GetAll()) do
		if v:Team() != TEAM_FINISHED then
			v:SetSwing( SetUnfinishedPenalty( v ) )
			v:AutoFail( "TIME LIMIT" )
		end
	end
end

function SetAllTeams(team)
	for k,v in pairs (player.GetAll()) do
		v:SetTeam(team)
	end
end

function SetAllCams(state)
	for k,v in pairs (player.GetAll()) do
		v:SetCamera( state, 0 )
	end
end

function SetWaitingCams()
	for k,v in pairs (player.GetAll()) do
		v:SetCamera( "Waiting", 1.0 )
	end
end

function SetupAllBalls()
	for k,v in pairs (player.GetAll()) do
		v:SetupBall(CurrentHole)
	end
end

//Penalty Functions
function PenaltyScores(HoleNumber)
	for _,hole in pairs(ents.FindByClass("golfstart")) do
		if hole.Hole == tostring(HoleNumber) then
			return hole.par
		end
	end
end

//Gamemode Functions
function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )
	return true
end

function GM:HUDMessage(ent, msg)
	print(msg)
	umsg.Start( "HUDMessage", ent )
		umsg.String(msg)
	umsg.End()
end

local afks = {}

hook.Add( "PlayerAFK", "MiniAFK", function( ply, afk )
	
	if afk then
		table.insert(afks,ply)
	elseif table.HasValue(afks,ply) then
		table.RemoveByValue(afks,ply)
	end

end)

function GM:AreAllPlayersFinished()
	if player.GetCount() >= 1 then

		if #afks > 0 then
			if(team.NumPlayers(TEAM_FINISHED) == ( player.GetCount() - #afks ) && self:GetState() != STATE_PREVIEW && self.PreGame != true ) then
				for _,ply in pairs(afks) do
					if ply:Team() == TEAM_FINISHED then continue end
					ply:SetSwing( SetUnfinishedPenalty( ply ) )
					ply:AutoFail( "AFK" )
					GAMEMODE:ColorNotifyAll( T( "AfkKickMessage", ply:Name()), Color(200, 200, 200, 255) )
				end
			end
		end

		if(team.NumPlayers(TEAM_FINISHED) == ( player.GetCount() ) && self:GetState() != STATE_PREVIEW && self.PreGame != true ) then

			if self:GetHole() != 18 then
				if self:GetState() == STATE_INTERMISSION then
					return true
				else
					self:SetState(STATE_INTERMISSION)
					self:SetTime(60)
				end
			else
				return true
			end
		else
			return false
		end
	end
end

function GM:PlaySound( SOUNDINDEX, ply, NUM )
	if IsValid(ply) then
		umsg.Start( "PlaySoundEffect", ply )
		umsg.Char(SOUNDINDEX)
		umsg.Char(NUM)
		umsg.End()
	else
		umsg.Start( "PlayMusic" )
		umsg.Char(SOUNDINDEX)
		umsg.End()
	end
end

function GM:EntityTakeDamage( target, dmginfo )

	if ( target:IsPlayer() ) then

		dmginfo:ScaleDamage( 0 ) // Damage is now half of what you would normally take.

	end

end

//ConCommands
concommand.Add( "minigolf_color", function( ply, cmd, args )
	local color = tostring(args[1])
	ply:SetNWString('BallColor', color)
end )

//Hooks
local function BlockSuicide(ply)
	return false
end
hook.Add( "CanPlayerSuicide", "BlockSuicide", BlockSuicide )

hook.Add( "PlayerDisconnected", "PlayerPopulationCheck", function( ply )
	timer.Simple(0.2, function()
		if (GAMEMODE:GetState() != STATE_NOPLAY && #player.GetAll() == 0) then
			GAMEMODE:EndServer()
			return
		end
	end)
end)

hook.Add( "PlayerInitialSpawn", "InitialSpawnCheck", function( ply )
	if #player.GetAll() == 1 && !ply:IsBot() then
		GAMEMODE:BeginGame()
		ply:ChatPrint("You are the first to join, waiting for additional players!")
	end

	if !ply:IsBot() then
		ply:SetNWString( "BallColor", "1 1 1" )
		ply:SetNWInt( "Swing", 0 )
	end

end)
hook.Add( "PostGamemodeLoaded", "FlagSpawing", FlagSetup )
--hook.Add( "Initialize", "FlagSpawing", FlagSetup )

hook.Add( "PlayerSpawn", "PlayerSetup", function( ply )
	ply:SetNoDraw(true)

	if GAMEMODE:IsPracticing() && ply.InitialSpawn != true then
		ply.InitialSpawn = true
		GAMEMODE:GetHoles()
		timer.Simple( 1, function() ply:SetupBall(PracticeSpawn()) GAMEMODE:PlaySound( MUSIC_WAITING, ply ) end )
	end

	if !GAMEMODE:IsPracticing() && ply.LateSpawned != true then
		ply:LateJoin()
		ply:SetupBall(CurrentHole)
		ply:SetCamera("Playing",0)
	end

	ply:SetMoveType(MOVETYPE_NOCLIP)
end)

hook.Add( "PlayerThink", "MinigolfAFKPlayerThink", function( ply )
	if GAMEMODE:IsPlaying() then
		local CurrentAFKTime = ( ply._AFKTime - CurTime() )
		
		if ( IsValid( ply ) && ply:GetGolfBall().IsPocketed == true && CurrentAFKTime < 20 ) then
			ply:ResetAFKTimer()
		end
	end
end )

//Network Strings
util.AddNetworkString("MinigolfPutt");
util.AddNetworkString("Payouts");
