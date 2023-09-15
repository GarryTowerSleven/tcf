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
local Angle = Angle
local Color = Color
local SafeCall = SafeCall
local _G = _G
local print = print
local CurTime = CurTime
local math = math
local ACHIEVEMENTS = ACHIEVEMENTS
local Location = Location
local EffectData = EffectData
local util = util
local SetGlobalFloat = SetGlobalFloat
local net = net
local Dueling = Dueling

local BALLOON_GAME_ACTIVE = false

module("minigames.balloonpop" )

TotalMoney = 0
Poppers = 0
BalloonRate = 0

function BalloonControl()
	CompareSpawn = (CurTime() - LastSpawn)	
	if Poppers >= 6 then
		BalloonRate = math.Clamp( 0.55 - ( Poppers * 0.01 ), 0.1, 0.5 )
	else
		BalloonRate = 0.5
	end
	if CompareSpawn > BalloonRate then
		//print(CompareSpawn .. " " .. BalloonRate)
		local entposX = math.Rand(151.338440,1696.545044)
		local entposY = math.Rand(-2046.452148,-910.703613)
		local ent = ents.Create("gmt_minigame_balloon")
		ent:SetModel("models/maxofs2d/balloon_classic.mdl")
		ent:SetAngles(Angle(0,0,0))
		ent:SetPos( Vector(entposX,entposY,373.151642) )
		ent.MiniGame = true
		ent:SetColor(Color(math.random(100,255),math.random(100,255),math.random(100,255),255))
		ent:Spawn()
		ent:SetForce(12.5)
		LastSpawn = CurTime()
	end
	
	for k,v in pairs (ents.FindByClass("gmt_minigame_balloon")) do
		if v:GetClass() == "gmt_minigame_balloon" && v.MiniGame == true && v:GetPos().z >= 3200 then
			v:Remove()
		end
		if v:GetClass() == "gmt_minigame_balloon" && v.MiniGame == true then
			local check_stagnant = v:GetPos().z
			timer.Simple( 2, function()
				if v:IsValid() then
					if check_stagnant == v:GetPos().z then
						v:Remove()
					end
				end
			end)
		end
	end
	
end

function BalloonPopStop()

	hook.Remove("Think", "BalloonPopSpawning" )
	
	for k,v in pairs (ents.FindByClass("gmt_minigame_balloon")) do
		if v.MiniGame == true then
			v:Remove()
		end
	end
	
end

local function BalloonPopped( ent, dmg )
	if ( ent:GetClass() == "gmt_minigame_balloon" && ent.MiniGame == true ) then

		local ply = dmg:GetAttacker()
		
		ply:AddAchievement( ACHIEVEMENTS.MGPOPPER, 1 )
		
		local magni

		if IsValid(ply) then
			local distance = ent:GetPos().z - ply:GetPos().z
			if distance < 250 then distance = 250 end
			dmg:GetAttacker():AddMoney( math.Round(distance / 250) )
			magni = math.Round(distance / 250)
			TotalMoney = TotalMoney + math.Round(distance / 250)

			local vPoint = ent:GetPos()
			local effectdata = EffectData()
			effectdata:SetOrigin( vPoint )
			effectdata:SetMagnitude( magni )
			util.Effect( "gmt_money", effectdata )
		end
	end
end
hook.Add( "EntityTakeDamage", "BalloonPop", BalloonPopped )

function GiveWeapon( ply )

	if !ply:HasWeapon( WeaponName ) then
		ply.CanPickupWeapons = true
		ply:Give( WeaponName )
		ply:GiveAmmo( 999, WeaponAmmo )
		ply:SelectWeapon( WeaponName )
		ply.CanPickupWeapons = false
		ply.HasCrossbow = true
	end

	--ply:GodDisable()

end

function CheckGiveWeapon( ply, loc )

	if loc == MinigameLocation then
		Poppers = Poppers + 1
		GiveWeapon( ply )
	elseif ply.HasCrossbow then
		RemoveWeapon( ply )
	end

end

function RemoveWeapon( ply )
	if ply:HasWeapon(WeaponName) then
		Poppers = Poppers - 1
		ply:StripWeapons()
		ply.HasCrossbow = false
	end
end

function PlayerDissalowResize( ply )
	if !ply:IsAdmin() then
		return false
	end
end

function Start( flags )

	BALLOON_GAME_ACTIVE = true

	LastSpawn = CurTime()
	hook.Add("Think", "BalloonPopSpawning", BalloonControl )
	hook.Add("Location", "BalloonPopLocation", CheckGiveWeapon )
	hook.Add("PlayerResize", "DoNotAllowResize", PlayerDissalowResize )

	hook.Add("PlayerDeath", "Ninjaspeak", function( victim )
		if ( victim.HasCrossbow == true ) then
			victim.HasCrossbow = false
			Poppers = Poppers - 1
		end
	end)

	hook.Add("PlayerDisconnected", "Ninjaleave", function(ply)
		if ( ply.HasCrossbow == true ) then
			Poppers = Poppers - 1
		end
	end)

	Poppers = 0
	
	for _, v in pairs( player.GetAll() ) do
		SafeCall( CheckGiveWeapon, v, v:Location() )
	end

	TotalMoney = 0

end

function End()

	BALLOON_GAME_ACTIVE = false

	BalloonPopStop()

	hook.Remove("Location", "BalloonPopLocation" )
	hook.Remove("PlayerResize", "DoNotAllowResize" )
	hook.Remove("PlayerDeath", "Ninjaspeak" )
	hook.Remove("PlayerDisconnected", "Ninjaleave" )

	for _, v in pairs( player.GetAll() ) do
		SafeCall( RemoveWeapon, v )
	end

	for _, v in pairs( ents.FindByClass(WeaponName) ) do
		v:Remove()
	end

	umsg.Start("balloonpop")
		umsg.Char( 1 )
		umsg.Long( TotalMoney )
	umsg.End()

end

hook.Add("ScalePlayerDamage","BalloonDamage",function(ply, h, d)

	if ( BALLOON_GAME_ACTIVE and !Dueling.IsDueling( ply ) ) then
		return true
	end

end)
