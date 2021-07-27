AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

include("shared.lua")

//local umsg, math, ents, timer, table = umsg, math, ents, timer, table
//local hook, util = hook, util
//local Msg = Msg
//local Vector = Vector
local hook, string = hook, string
local umsg = umsg
local player = player
local table = table
local timer = timer
local ents  = ents
local pairs = pairs
local IsValid = IsValid
local VectorRand = VectorRand
local Vector = Vector
local SafeCall = SafeCall
local _G = _G
local print = print
local CurTime = CurTime
local Location = Location
local ACHIEVEMENTS = ACHIEVEMENTS
local util = util
local SetGlobalFloat = SetGlobalFloat
local net = net

module("minigames.chainsaw" )

PlayerSpawnOnLobby = {}
MoneyPerKill = 3
TotalMoney = 0

function GiveWeapon( ply )

	if !ply:HasWeapon( WeaponName ) then
		ply.CanPickupWeapons = true
		ply:Give( WeaponName )
		ply:SelectWeapon( WeaponName )
		ply.CanPickupWeapons = false
	end

	ply:GodDisable()

end

function CheckGiveWeapon( ply, loc )

	if loc == MinigameLocation  then
		GiveWeapon( ply )
		ply:SetNWBool("MinigameOn",true)

		if !ply.BMusic then
			net.Start("MinigameMusic")
				net.WriteBool(true)
				net.WriteString("chainsaw")
			net.Send(ply)
			ply.BMusic = true
		end
	else
		RemoveWeapon( ply )
		ply:SetNWBool("MinigameOn",false)

		if ply.BMusic then
			net.Start("MinigameMusic")
				net.WriteBool(false)
			net.Send(ply)
			ply.BMusic = false
		end
	end

end

function CheckRemoveBall( ply )

	if ply:Location() == MinigameLocation then


		if IsValid( ply.BallRaceBall ) then

			ply.BallRaceBall:Remove()
			ply.BallRaceBall = nil

		end

	end

end

function RemoveWeapon( ply )
	--if ply:HasWeapon(WeaponName) && ply:GetSetting( "GTAllowWeapons" ) == false && !ply:IsAdmin() then
	if ply:HasWeapon(WeaponName) then
		ply:StripWeapons()
	end

	ply:SetNWBool("MinigameOn",false)

	if ply.BMusic then
		net.Start("MinigameMusic")
			net.WriteBool(false)
		net.Send(ply)
		ply.BMusic = false
	end

	ply:ResetGod()
end

function playerDies( ply, inflictor, killer )

	if ply:Location()  == MinigameLocation then
		table.insert( PlayerSpawnOnLobby, ply )

		//print( ply, inflictor, killer )

		if killer != ply && IsValid( killer ) &&  killer:IsPlayer() then
			killer:AddMoney( MoneyPerKill )
			killer:SetNWInt("MinigameScore", ( killer:GetNWInt("MinigameScore") + 100 ) )
			killer:AddAchievement(ACHIEVEMENTS.MGGIBBIG,1)
			TotalMoney = TotalMoney + MoneyPerKill
		end

	end

end

function PlayerInitialSpawn( ply )
	if !IsValid( FlyingText ) then
		return
	end

	for k, v in pairs( PlayerSpawnOnLobby ) do
		if v == ply then
			table.remove( PlayerSpawnOnLobby, k )
			return FlyingText
		end
	end
end

function PlayerSpawn( ply )

	local Pos = ply:Location()

	if Pos == MinigameLocation then

		ply:SetVelocity( VectorRand() * 800 )
		ply.DisableCollision = CurTime() + 3.0
		GiveWeapon( ply )

	end

end

function GetLocation()
	return MinigameLocation
end

function SendStartMessage( rp )
	umsg.Start("chainsaw", rp )
		umsg.Char( 0 )
		umsg.Char( GetLocation() )
	umsg.End()
end

function PlayerConnected( ply )
	SendStartMessage( ply )
end

local function GetSpawnPos( flags )
	if string.find( flags, "a" ) then
		return Vector( 2676.160889, -18.642038, -787.967468 )
	end
	return Vector(2676.160889, -18.642038, -787.967468)
end

function PlayerDissalowResize( ply )
	if !ply:IsAdmin() then
		return false
	end
end

function Start( flags )

	hook.Add("Location", "ChainsawLocation", CheckGiveWeapon )
	//hook.Add("ShouldCollide", "LobbyColide", ShouldCollide )
	hook.Add( "PlayerDeath", "ChainSawCheckDeath", playerDies )
	hook.Add("PlayerSelectSpawn", "ChainSawPlayerSpawn", PlayerInitialSpawn )
	hook.Add("PlayerInitialSpawn", "ChainsawSendNW", PlayerConnected )
	hook.Add("PlayerSpawn", "ChainsawPlayerSpawn", PlayerSpawn )
	hook.Add("PlayerResize", "DoNotAllowResize", PlayerDissalowResize )
	hook.Add("PlayerThink", "ChainsawCheckRemoveBall", CheckRemoveBall )

	for _, v in pairs( player.GetAll() ) do
		v:SetNWInt("MinigameScore",0)
		SafeCall( CheckGiveWeapon, v, v:Location() )
	end

	SetGlobalFloat("MinigameRoundTime",CurTime()+120)

	if !IsValid( FlyingText ) then
		FlyingText = ents.Create("gmt_skymsg")
		FlyingText:KeyValue( "text", "Chainsaw Battle!" )
		FlyingText:Spawn()
	end

	FlyingText:SetPos( GetSpawnPos( flags ) )

	SendStartMessage( nil )
	MinigameLocation = GetLocation()
	TotalMoney = 0

end

function End()

	hook.Remove("Location", "ChainsawLocation" )
	//hook.Remove("ShouldCollide", "LobbyColide" )
	hook.Remove( "PlayerDeath", "ChainSawCheckDeath" )
	hook.Remove("PlayerSelectSpawn", "ChainSawPlayerSpawn" )
	hook.Remove("PlayerInitialSpawn", "ChainsawSendNW" )
	hook.Remove("PlayerSpawn", "ChainsawPlayerSpawn" )
	hook.Remove("PlayerResize", "DoNotAllowResize")
	hook.Remove("PlayerThink", "ChainsawCheckRemoveBall" )

	for _, v in pairs( player.GetAll() ) do
		SafeCall( RemoveWeapon, v )
	end

	for _, v in pairs( ents.FindByClass(WeaponName) ) do
		v:Remove()
	end

	umsg.Start("chainsaw")
		umsg.Char( 1 )
		umsg.Long( TotalMoney )
	umsg.End()

	if IsValid( FlyingText ) then
		FlyingText:Remove()
		FlyingText = nil
	end



end
