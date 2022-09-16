AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

include("shared.lua")

local SnowSpawnPoints = {
	{Vector(2782.172852,565.080750,-253.891693), Angle(0, -90, 0)}
}

//local umsg, math, ents, timer, table = umsg, math, ents, timer, table
//local hook, util = hook, util
//local Msg = Msg
//local Vector = Vector

module("minigames.plane",package.seeall )

ActiveSpawnPoints = SnowSpawnPoints
ActivePlayers = {}
BallEntity = nil
TrailEnabled = true
TotalMoneyEarned = 0

sound.Add( {
	name = "plane_engine",
	volume = 0.8,
	level = 90,
	pitch = { 95, 110 },
	sound = "vehicles/airboat/fan_motor_fullthrottle_loop1.wav"
} )

function GetPlaneVel( ply )
	return ply._PlaneVelocity or 100
end

function SetPlaneVel( ply, vel, ang  )
	ply._PlaneVelocity = vel

	if !ply._LastPlaneSend || CurTime() > ply._LastPlaneSend then
		umsg.Start("plane", ply )
			umsg.Char( 2 )
			umsg.Float( vel )

			if ang then
				umsg.Bool( true)
				umsg.Angle( ang )
			else
				umsg.Bool( false )
			end

		umsg.End()

		ply._LastPlaneSend = CurTime() + 1.0
	end
end

function SpawnPlayer( ply )

	ply:DrawViewModel( false )
	//ply:SetModel("models/props_c17/doll01.mdl")

	local RandomPos = table.Random(SnowSpawnPoints)

	ply:SetPos( RandomPos[1] )
	ply:SetAllowFullRotation( true )

	if TrailEnabled then
		ply.m_entTrail = util.SpriteTrail( ply, 0, Color( 180, 180, 190, 255 ), true, 0, 16, 10, 0.01, "trails/smoke.vmt" )
		ply.m_entTrail:SetParent( ply )
	end

	ply:SetHull( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	ply:SetViewOffset( Vector( 0, 0, 0 ) )
	ply:SetMoveType( MOVETYPE_NOCLIP )

	ply:SetPos( ply:GetPos() )
	ply:SetAngles( Angle( 0, 0, 0 ) )

	ply.plane = ents.Create( "plane" )
		ply.plane:SetPos( ply:GetPos() )
		ply.plane:SetParent( ply )
		ply.plane:SetOwner( ply )
		ply.plane:Spawn()
		ply.plane:EmitSound("plane_engine")

	SetPlaneVel( ply, 100, RandomPos[2] )
	ply:GodDisable()

	if !ply:HasWeapon("weapon_planegun") then
		ply:StripWeapons()
		ply.CanPickupWeapons = true
		ply:Give( "weapon_planegun" )
		ply.CanPickupWeapons = false
	end

	ply:SetAnimation( ply:LookupSequence( "drive_jeep" ) )
end


function ExplodePlaneParts( pl )

	local explosion = ents.Create( "env_explosion" ) // Creating our explosion
	explosion:SetKeyValue( "spawnflags", 144 ) //Setting the key values of the explosion
	explosion:SetKeyValue( "iMagnitude", 0 ) // Setting the damage done by the explosion
	explosion:SetKeyValue( "iRadiusOverride", 256 ) // Setting the radius of the explosion
	explosion:SetPos(pl:GetPos()) // Placing the explosion where we are
	explosion:Spawn( ) // Spawning it
	explosion:Fire("explode","",0)

end


function HookOnDeath( pl, inf, attacker )

	if ( IsValid( pl.m_entTrail ) ) then
		pl.m_entTrail:SetAttachment( nil )
		local trail = pl.m_entTrail
		timer.Simple( 30, function() if ( IsValid( trail ) ) then trail:Remove() end end )
	end

	if IsValid( pl.plane ) then
		ExplodePlaneParts( pl )
		pl.plane:StopSound("plane_engine")
		pl.plane:Remove()
	end

	if InGame( pl ) && InGame( attacker ) && IsValid( attacker ) && attacker:IsPlayer() && attacker != pl then
		attacker:AddMoney( 5 )
		attacker:AddAchievement( ACHIEVEMENTS.MGREDBARON, 1 )
		attacker._PlaneKills = attacker._PlaneKills + 1
		TotalMoneyEarned = TotalMoneyEarned + 5
	end

end

function DoExplosion( pl )

	/*
	if ( !IsValid( pl ) ) then return end

	util.BlastDamage( pl, pl, pl:GetPos(), 300, 200 )

	local effectdata = EffectData()
		effectdata:SetOrigin( pl:GetPos() )
 	util.Effect( "Explosion", effectdata, true, true )
	*/
end

function OnEntUse( ply, caller )
	if ply:IsPlayer() then
		AddPlayer( ply )
		ply:Spawn()

		if IsValid( ply.BallRaceBall ) then

			ply.BallRaceBall:Remove()
			ply.BallRaceBall = nil

		end

	end
end

function AddPlayer( ply )

	table.insert( ActivePlayers, ply )

	umsg.Start("plane", ply )
		umsg.Char( 0 )
	umsg.End()

	ply._PlaneKills = 0

end

function HookPlayerSpawn( ply )
	if InGame( ply ) then
		SpawnPlayer( ply )
		return true
	end
end

function InGame( ply )
	for _, v in pairs( ActivePlayers ) do
		if v:EntIndex() == ply:EntIndex() then
			return true
		end
	end
	return table.HasValue( ActivePlayers, ply )
end

function RemovePlayer( ply )

	for k, v in pairs( ActivePlayers ) do
		if v == ply then
			table.remove( ActivePlayers, k )
		end
	end

	if IsValid( ply ) then
		umsg.Start("plane", ply )
			umsg.Char( 1 )
		umsg.End()

		if ply:Alive() then
			ply:Kill()
		end

		ply:ResetHull()
		ply:SetViewOffset( Vector(0,0,64) )
		ply:SetAllowFullRotation( false )
	end

end

function CheckNontheater( ply, loc )

	if InGame( ply ) && Location.IsTheater( loc ) then
		if ply:Alive() then
			ply:Kill()
		end
	end

end


function CheckRemoveBall( ply )

	if InGame( ply ) then

		if IsValid( ply.BallRaceBall ) then

			ply.BallRaceBall:Remove()
			ply.BallRaceBall = nil

		end

	end

end

function HookPlayerHurt( ent, inflictor, attacker, amount, dmginfo )

	if !InGame( ent ) then
		dmginfo:ScaleDamage( 0 )
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

	hook.Add("PlayerSpawn", "PlaneSpawn", HookPlayerSpawn )
	hook.Add("PlayerDeath", "PlaneDeath", HookOnDeath )
	hook.Add("EntityTakeDamage", "PlaneHurt", HookPlayerHurt )
	hook.Add("Location", "PlaneLocation", CheckNontheater )
	hook.Add("ShouldCollide", "PlaneShouldCollide", ShouldCollide )
	hook.Add("PlayerThink", "PlaneCheckRemoveBall", CheckRemoveBall )
	hook.Add("AllowWeapons", "PlaneAllowWeapons", function(ply) if IsValid(ply.plane) then return false end end )

	//Shared hooks
	hook.Add("Move", "PlaneMove", HookPlayerMove )
	hook.Add("CalcView", "PlaneCalcView", CalcView )
	hook.Add("CalcMainActivity", "PlaneAnim", HookPlayerAnim )

	for _, ply in pairs( player.GetAll() ) do
		ply._PlaneKills = nil
	end

	TotalMoneyEarned = 0

	if string.find( flags, "a" ) then
		ActiveSpawnPoints = SnowSpawnPoints
	else
		ActiveSpawnPoints = SpawnPos
	end

end

function End()

	hook.Remove("PlayerSpawn", "PlaneSpawn" )
	hook.Remove("PlayerDeath", "PlaneDeath" )
	hook.Remove("EntityTakeDamage", "PlaneHurt" )
	hook.Remove("Location", "PlaneLocation" )
	hook.Remove("ShouldCollide", "PlaneShouldCollide" )
	hook.Remove("PlayerThink", "PlaneCheckRemoveBall" )
	hook.Remove("AllowWeapons", "PlaneAllowWeapons" )

	//Shared hooks
	hook.Remove("Move", "PlaneMove" )
	hook.Remove("CalcView", "PlaneCalcView" )
	hook.Remove("CalcMainActivity", "PlaneAnim" )



	for _, ply in pairs( table.Copy( ActivePlayers ) ) do
		SafeCall( RemovePlayer, ply )
		RemovePlayer( ply )

		if ply.plane then
			ply.plane:StopSound("plane_engine")
			ply.plane:Remove()
		end
		if ( IsValid( ply.m_entTrail ) ) then
			ply.m_entTrail:SetAttachment( nil )
			local trail = ply.m_entTrail
			timer.Simple( 1, function() if ( IsValid( trail ) ) then trail:Remove() end end )
		end
	end

	if IsValid( BallEntity ) then
		BallEntity:Remove()
	end

	for k,v in pairs(ents.GetAll()) do
		if v:GetClass() == "gmt_minigame_entrance" then
			v:Remove()
		end
	end

	local SendData = {}

	for _, ply in pairs( player.GetAll() ) do

		if ply._PlaneKills then
			SendData[ ply:EntIndex() ] = ply._PlaneKills
		end

	end

	umsg.Start("plane", nil )
		umsg.Char( 3 )
		umsg.Char( table.Count( SendData ) )
		umsg.Long( TotalMoneyEarned )

		for k, v in pairs( SendData ) do
			umsg.Char( k )
			umsg.Char( v )
		end

	umsg.End()

end

concommand.Add("gmt_planeleave", function( ply, cmd, args )

	if InGame( ply ) then
		RemovePlayer( ply )
	end

end )

	//umsg.Start("plane", self)
	//	umsg.String( str )
	//umsg.End()
