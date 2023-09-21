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

module("minigames.barfight" )

PlayerSpawnOnLobby = {}
MoneyPerKill = 5
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

	if loc == MinigameLocation || loc == MinigameLocation2  then
		GiveWeapon( ply )
	else
		RemoveWeapon( ply )
	end

end

function CheckRemoveBall( ply )

	if ply:Location() == MinigameLocation || ply:Location() == MinigameLocation2 then

		if IsValid( ply.BallRaceBall ) then

			ply.BallRaceBall:Remove()
			ply.BallRaceBall = nil

		end

	end

end

function RemoveWeapon( ply )
	if ply:HasWeapon(WeaponName) then
		ply:StripWeapons()
	end
end

function playerDies( ply, inflictor, killer )

	if ply:Location() == MinigameLocation || ply:Location() == MinigameLocation2 then
		table.insert( PlayerSpawnOnLobby, ply )

		//print( ply, inflictor, killer )

		if killer != ply && IsValid( killer ) &&  killer:IsPlayer() then
			killer:AddMoney( MoneyPerKill )
			killer:AddAchievement( ACHIEVEMENTS.MGFIGHTER, 1 )
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

	if Pos == MinigameLocation || pos == MinigameLocation2 then

		ply:SetVelocity( VectorRand() * 800 )
		ply.DisableCollision = CurTime() + 3.0
		GiveWeapon( ply )

	end

end

function GetLocation()
	return MinigameLocation
end

function SendStartMessage( rp )
	umsg.Start("barfight", rp )
		umsg.Char( 0 )
		umsg.Char( GetLocation() )
	umsg.End()
end

function PlayerConnected( ply )
	SendStartMessage( ply )
end

local function GetSpawnPos( flags )
	if string.find( flags, "a" ) then
		return Vector( 2910.156250, 2596.843750, 60)
	end
	return Vector(2910.156250, 2596.843750, 60)
end

function PlayerDissalowResize( ply )
	if !ply:IsAdmin() then
		return false
	end
end

function Start( flags )

	hook.Add("Location", "BarFightLocation", CheckGiveWeapon )
	//hook.Add("ShouldCollide", "LobbyColide", ShouldCollide )
	hook.Add( "PlayerDeath", "BarFightCheckDeath", playerDies )
	hook.Add("PlayerSelectSpawn", "BarFightPlayerSpawn", PlayerInitialSpawn )
	hook.Add("PlayerInitialSpawn", "BarFightSendNW", PlayerConnected )
	hook.Add("PlayerSpawn", "BarFightPlayerSpawn", PlayerSpawn )
	hook.Add("PlayerResize", "DoNotAllowResize", PlayerDissalowResize )
	hook.Add("PlayerThink", "BarFightCheckRemoveBall", CheckRemoveBall )

	for _, v in pairs( player.GetAll() ) do
		SafeCall( CheckGiveWeapon, v, v:Location() )
	end

	SetGlobalFloat("MinigameRoundTime",CurTime()+120) -- Do we need to touch these? I really dont know?

	if !IsValid( FlyingText ) then
		FlyingText = ents.Create("gmt_skymsg")
		FlyingText:KeyValue( "text", "Bar Fight!" )
		FlyingText:Spawn()
	end

	FlyingText:SetPos( GetSpawnPos( flags ) )

	SendStartMessage( nil )
	MinigameLocation = GetLocation()
	TotalMoney = 0

end

function End()

	hook.Remove("Location", "BarFightLocation" )
	//hook.Remove("ShouldCollide", "LobbyColide" )
	hook.Remove( "PlayerDeath", "BarFightCheckDeath" )
	hook.Remove("PlayerSelectSpawn", "BarFightPlayerSpawn" )
	hook.Remove("PlayerInitialSpawn", "BarFightSendNW" )
	hook.Remove("PlayerSpawn", "BarFightPlayerSpawn" )
	hook.Remove("PlayerResize", "DoNotAllowResize")
	hook.Remove("PlayerThink", "BarFightCheckRemoveBall" )

	for _, v in pairs( player.GetAll() ) do
		SafeCall( RemoveWeapon, v )
	end

	for _, v in pairs( ents.FindByClass(WeaponName) ) do
		v:Remove()
	end

	umsg.Start("barfight")
		umsg.Char( 1 )
		umsg.Long( TotalMoney )
	umsg.End()

	if IsValid( FlyingText ) then
		FlyingText:Remove()
		FlyingText = nil
	end



end
