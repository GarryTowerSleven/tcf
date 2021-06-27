AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

include("shared.lua")

local SnowSpawnPoints = {
	{Vector(-4866.0224609375,-12475.3984375,7744.03125), Angle(0,90,0)},
	{Vector(-6331.6708984375,-10977.309570313,7744.03125), Angle(0,0,0)},
	{Vector(-4868.5385742188,-9497.5908203125,7744.03125), Angle(0,-90,0)},
	{Vector(-3181.5385742188,-10977.309570313,7744.03125), Angle(0,-180,0)},
	{Vector(-4866.0874023438,-10680.135742188,7873.03125), Angle(0,-90,0)},
	{Vector(-4572.9306640625,-11640.715820313,7424.03125), Angle(0,120,0)},
	{Vector(-5408.21875,-10471.103515625,7424.03125), Angle(0,-40,0)},
	{Vector(-5960,-9867.232421875,7616.03125), Angle(0,-45,0)},
	{Vector(-3754.6674804688,-9866.55078125,7616.03125), Angle(0,-135,0)},
	{Vector(-3154.3400878906,-11744.799804688,7744.03125), Angle(0,-180,0)},
	{Vector(-4865.8720703125,-12167.959960938,7424.03125), Angle(0,90,0)},
	{Vector(-5655.0415039063,-11776.6640625,7420.03125), Angle(0,45,0)},
	{Vector(-5244.08203125,-9512.1640625,7744.03125), Angle(0,-50,0)},
	{Vector(-3177.51953125,-11676.516601563,7744.03125), Angle(0,155,0)},
	{Vector(-5193.6206054688,-11636.732421875,7424.03125), Angle(0,55,0)},
	{Vector(-5920.0205078125,-9818.5791015625,7616.03125), Angle(0,-45,0)}
}

//local umsg, math, ents, timer, table = umsg, math, ents, timer, table
//local hook, util = hook, util
//local Msg = Msg
//local Vector = Vector
local GTowerLocation = GTowerLocation

module("minigames.tronarnia",package.seeall )


ActivePlayers = {}
SpawnPoints = {}
WeaponList = {}
BallEntity = nil
RandomWeapons = true

function CheckLocation( ply )

	if GTowerLocation:GetPlyLocation( ply ) != 41 then

		local Random = table.Random( SnowSpawnPoints )

		ply:SetPos( Random[1] )

	end

end

function GiveRandomWeapons( ply )

	local GivenWeapons = {"weapon_sword"}

	ply:Give("weapon_sword")

	for k, weplist in ipairs( WeaponList ) do
		if #weplist > 0 then

			local WeaponName = table.Random( weplist )
			ply:Give( WeaponName )
			table.insert( GivenWeapons, WeaponName )

		end
	end

	return GivenWeapons

end

function SpawnPlayer( ply )

	ply:GodDisable()

	ply.CanPickupWeapons = true
	local GivenWeapons

	if RandomWeapons == true then
		GivenWeapons = GiveRandomWeapons( ply )
	else
		GivenWeapons = PvpBattle:GiveWeapons( ply )
	end

	//Ammo
	ply:GiveAmmo( 54, "SMG1", true )
	ply:GiveAmmo( 1, "SMG1_Grenade", true )
	ply:GiveAmmo( 24, "357", true )
	ply:GiveAmmo( 28, "Pistol", true )
	ply:GiveAmmo( 18, "Buckshot", true )
	ply:GiveAmmo( 50, "AR2", true )
	ply:GiveAmmo( 12, "SniperRound", true )
	ply:GiveAmmo( 4, "RPG_Round", true )
	ply:GiveAmmo( 4, "slam", true )

	ply.CanPickupWeapons = false

	ply:SelectWeapon( table.Random( GivenWeapons ) )

	timer.Simple( 0.0, CheckLocation, ply )
end

function HookOnDeath( pl, inf, attacker )

	if IsValid( attacker ) && attacker:IsPlayer() && attacker != pl then
		attacker:AddMoney( 5 )
	end

end

function OnEntUse( ply, caller )
	if ply:IsPlayer() then
		GTowerModels.Set( ply, 1.0 )
		AddPlayer( ply )
		ply:Spawn()
	end
end

function AddPlayer( ply )

	table.insert( ActivePlayers, ply )

	umsg.Start("tronarnia", ply )
		umsg.Char( 0 )
	umsg.End()

	ply._DisabledJetpack = true

end

function HookPlayerSpawn( ply )
	if InGame( ply ) then
		SpawnPlayer( ply )
		return true
	end
end

function InGame( ply )
	return table.HasValue( ActivePlayers, ply )
end

function RemovePlayer( ply )

	for k, v in ipairs( ActivePlayers ) do
		if v == ply then
			table.remove( ActivePlayers, k )
		end
	end

	if IsValid( ply ) then
		umsg.Start("tronarnia", ply )
			umsg.Char( 1 )
		umsg.End()

		if ply:Alive() then
			ply:Kill()
		end

		ply._DisabledJetpack = nil
	end

end


function CheckNontheater( ply, loc )

	if InGame( ply ) && Location.IsTheater( loc ) then
		if ply:Alive() then
			ply:Kill()
		end
	end

end


function PlayerSelectSpawn( ply )

	if InGame( ply ) then
		local i
		for i=1, 5 do
			local random_entry = table.Random( SpawnPoints )

			if IsValid( random_entry ) then
				return random_entry
			end
		end
	end

end

function CleanSpawnPoints()
	for _, v in ipairs( SpawnPoints ) do
		SafeRemoveEntity( v )
	end
end

function HookDisableResize( ply, size )
	if InGame( ply ) then
		return false
	end
end

function WeaponOverride( ply )
	if InGame( ply ) then
		return true
	end
end

function ShouldCollide( ply1, ply2 )
	if InGame( ply1 ) && InGame( ply2 ) then
		return true
	end
end


function Start( flags )

	if !IsValid( BallEntity ) then
		BallEntity = ents.Create("gmt_minigame_entrance")
		BallEntity:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
		BallEntity:SetPos( Vector(2685, 0, -940) )
		BallEntity:Spawn()
		BallEntity:SetUse( OnEntUse )
	end

	CleanSpawnPoints()

	for _, v in pairs( SnowSpawnPoints ) do
		local Trace = util.QuickTrace(  v[1], Vector( 0, 0, -4096 ) )
		local Pos = Trace.HitPos + Vector(0,0,127)

		local ent = ents.Create("info_specialspawn")
		ent:SetPos( Pos )
		ent:Spawn()

		table.insert( SpawnPoints, ent )
	end

	WeaponList = {}

	for k, v in ipairs( PvpBattle.WeaponList ) do

		if !WeaponList[k] then
			WeaponList[k] = {}
		end

		for _, name in ipairs( v ) do

			local Item = GTowerStore:GetItemByName( name )
			local WeaponName = PvpBattle.WeaponsIds[ Item ]

			table.insert( WeaponList[k], WeaponName )

		end

	end

	--PrintTable( WeaponList )


	hook.Add("PlayerSelectSpawn","PVPNarniaChoose", PlayerSelectSpawn )
	hook.Add("PlayerSpawn", "PVPNarniaSpawn", HookPlayerSpawn )
	hook.Add("PlayerDeath", "PVPNarniaDeath", HookOnDeath )
	hook.Add("PlayerResize", "DisableResizing", HookDisableResize )
	hook.Add("WeaponOverride", "DisableWeaponOverride", WeaponOverride )
	hook.Add("ShouldCollide", "EnableNarniaCollisions", ShouldCollide )

end

function End()

	hook.Remove("PlayerSpawn", "PVPNarniaSpawn" )
	hook.Remove("PlayerDeath", "PVPNarniaDeath" )
	hook.Remove("PlayerSelectSpawn","PVPNarniaChoose" )
	hook.Remove("PlayerResize", "DisableResizing")
	hook.Remove("WeaponOverride", "DisableWeaponOverride")
	hook.Remove("ShouldCollide", "EnableNarniaCollisions" )

	for _, ply in pairs( table.Copy( ActivePlayers ) ) do
		SafeCall( RemovePlayer, ply )
	end

	CleanSpawnPoints()

	if IsValid( BallEntity ) then
		BallEntity:Remove()
	end

end

concommand.Add("gmt_pvpnarnialeave", function( ply, cmd, args )

	if InGame( ply ) then
		RemovePlayer( ply )
	end

end )
