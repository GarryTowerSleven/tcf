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
local math = math
local pairs = pairs
local IsValid = IsValid
local VectorRand = VectorRand
local Vector = Vector
local Angle = Angle
local SafeCall = SafeCall
local _G = _G
local print = print
local CurTime = CurTime
local ACHIEVEMENTS = ACHIEVEMENTS
local Location = Location
local Dueling = Dueling
local EffectData = EffectData
local util = util

local OBAMA_GAME_ACTIVE = false

module("minigames.obamasmash" )

TotalMoney = 0
ObamaCount = 0
ObamaMax = 0
ObamaRate = 0
MoneyPerKill = 3
Smashers = 0
Adjustment = 0

function GiveWeapon( ply )

	if !ply:HasWeapon( WeaponName ) then
		ply.CanPickupWeapons = true
		ply:Give( WeaponName )
		ply:SelectWeapon( WeaponName )
		ply.CanPickupWeapons = false
		ply.HasCrowbar = true
	end

end

function CheckGiveWeapon( ply, loc )

	if loc == MinigameLocation  then
		Smashers = Smashers + 1
		GiveWeapon( ply )
	else
		RemoveWeapon( ply )
	end

end

function RemoveWeapon( ply )
	if ply:HasWeapon(WeaponName) then
		Smashers = Smashers - 1
		ply:StripWeapons()
		ply.HasCrowbar = false
	end
end

function PlayerDissallowResize( ply )
	if !ply:IsAdmin() then
		return false
	end
end

local function ObamaControlSuites()

	local entities = ents.FindInSphere(Vector(4512.097656, -10177.549805, 4096),130)
	
	CompareSpawn = (CurTime() - LastSpawn + Adjustment)
	
	if Smashers >= 6 then
		ObamaRate = math.Clamp( 0.425 - ( Smashers * 0.015 ), 0.15, 0.35)
	else
		ObamaRate = 0.35
	end
	//Debug
	//print("Obama count is: " .. ObamaCount .. " Max: " .. ObamaMax .. "  Obama rate is: " .. ( ObamaRate - CurTime() ) .. " Smasher count is: " .. Smashers )
	if CompareSpawn > ObamaRate && ObamaCount < ObamaMax then
		//print(CompareSpawn .. " " .. ObamaRate)
		ObamaCount = (ObamaCount+1)
		local ent = ents.Create("gmt_minigame_obama")
		local entposX = math.Rand(4288.218262, 4911.975586)	
		local entposY = math.Rand(-10543.968750, -9808.031250)
		ent:SetPos( Vector(entposX,entposY, 4096) )
		ent:SetAngles(Angle(0,math.Rand(0,360),0))
		ent.MiniGame = true
		ent:Spawn()
		LastSpawn = CurTime()
	end
	
	Adjustment = 0
	
	for index, ent in pairs(entities) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end
	
end

local function ObamaControlLobby()

	local entities = ents.FindInSphere(Vector(928, -1472, 0),130)
	
	CompareSpawn = (CurTime() - LastSpawn + Adjustment)
	
	if Smashers >= 6 then
		ObamaRate = math.Clamp( 0.425 - ( Smashers * 0.015 ), 0.10, 0.35)
	else
		ObamaRate = 0.35
	end
	//Debug
	//print("Obama count is: " .. ObamaCount .. " Max: " .. ObamaMax .. "  Obama rate is: " .. ( ObamaRate - CurTime() ) .. " Smasher count is: " .. Smashers )
	if CompareSpawn > ObamaRate && ObamaCount < ObamaMax then
		ObamaCount = (ObamaCount+1)
		local ent = ents.Create("gmt_minigame_obama")
		local entposX = math.Rand(345, 1510)	
		local entposY = math.Rand(-2125.968750, -815.031250)
		ent:SetPos( Vector(entposX,entposY, 0) )
		ent:SetAngles(Angle(0,math.Rand(0,360),0))
		ent.MiniGame = true
		ent:Spawn()
		LastSpawn = CurTime()
	end
	
	Adjustment = 0

	for index, ent in pairs(entities) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end
end

local function ObamaControlPlaza()

	local entities = ents.FindInSphere(Vector(715, 270, 0),100)
	local entities2 = ents.FindInSphere(Vector(1135, 270, 0),100)
	local entities3 = ents.FindInSphere(Vector(930, 545, 0),100)
	local entities4 = ents.FindInSphere(Vector(930, 1245, 0),100)
	local entities5 = ents.FindInSphere(Vector(715, 1525, 0),100)
	local entities6 = ents.FindInSphere(Vector(1135, 1525, 0),100)
	
	CompareSpawn = (CurTime() - LastSpawn + Adjustment)
	
	if Smashers >= 6 then
		ObamaRate = math.Clamp( 0.39 - ( Smashers * 0.01 ), 0.10, 0.35)
	else
		ObamaRate = 0.35
	end
	//Debug
	//print("Obama count is: " .. ObamaCount .. " Max: " .. ObamaMax .. "  Obama rate is: " .. ( ObamaRate - CurTime() ) .. " Smasher count is: " .. Smashers )
	if CompareSpawn > ObamaRate && ObamaCount < ObamaMax then
		ObamaCount = (ObamaCount+1)
		local ent = ents.Create("gmt_minigame_obama")
		local entposX = math.Rand(675, 1175)	
		local entposY = math.Rand(200, 1600)
		ent:SetPos( Vector(entposX,entposY, -16) )
		ent:SetAngles(Angle(0,math.Rand(0,360),0))
		ent.MiniGame = true
		ent:Spawn()
		LastSpawn = CurTime()
	end

	Adjustment = 0
	
	for index, ent in pairs(entities) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end
	
	for index, ent in pairs(entities2) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end

	for index, ent in pairs(entities3) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end
	
	for index, ent in pairs(entities4) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end

	for index, ent in pairs(entities5) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end

	for index, ent in pairs(entities6) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end
end

local function ObamaControlGamemodes()

	local entities = ents.FindInSphere(Vector(10240, 10625, 6655),325)
	
	CompareSpawn = (CurTime() - LastSpawn + Adjustment)
	
	if Smashers >= 6 then
		ObamaRate = math.Clamp( 0.39 - ( Smashers * 0.01 ), 0.15, 0.35)
	else
		ObamaRate = 0.35
	end
	//Debug
	//print("Obama count is: " .. ObamaCount .. " Max: " .. ObamaMax .. "  Obama rate is: " .. ( ObamaRate - CurTime() ) .. " Smasher count is: " .. Smashers )
	if CompareSpawn > ObamaRate && ObamaCount < ObamaMax then
		//print(CompareSpawn .. " " .. ObamaRate)
		ObamaCount = (ObamaCount+1)
		local ent = ents.Create("gmt_minigame_obama")
		local entposX = math.Rand(10000, 11020)	
		local entposY = math.Rand(10260, 10985)
		ent:SetPos( Vector(entposX,entposY, 6657) )
		ent:SetAngles(Angle(0,math.Rand(0,360),0))
		ent.MiniGame = true
		ent:Spawn()
		LastSpawn = CurTime()
	end
	
	Adjustment = 0
	
	for index, ent in pairs(entities) do
		if ent:GetClass() == "gmt_minigame_obama" && ent.MiniGame == true then
			ent:Remove()
			ObamaCount = (ObamaCount-1)
			Adjustment = .35
		end
	end
	
end

local function SmashObama( ent, dmg )

	if ( ent:GetClass() == "gmt_minigame_obama" && dmg:IsDamageType(128) && ent.MiniGame == true ) then

		ObamaMax = 0

		if ObamaCount != nil then
			ObamaCount = (ObamaCount-1)
		end
		
		if MinigameLocation == 2 then
			ObamaMax = math.Clamp(Smashers * 5, 10, 100)
		else
			ObamaMax = math.Clamp(Smashers * 5, 10, 50)
		end
		//print(ObamaMax)
		
		local ply = dmg:GetAttacker()
		
		ply:AddAchievement( ACHIEVEMENTS.MGVOTED, 1 )
		
		local ComboTime = 1

		if CurTime() - (ply.SmashTime or CurTime()) > ComboTime then
			ply.Combo = 0
		end
		ply.Combo = (ply.Combo or 0) + 1

		ply.SmashTime = CurTime()

		MoneyPerKill = math.Clamp( (ply.Combo or 1), 1, 1000)

		TotalMoney = TotalMoney + MoneyPerKill

		local vPoint = ent:GetPos()
		local effectdata = EffectData()
		effectdata:SetOrigin( vPoint+Vector(0,0,55) )
		effectdata:SetMagnitude( MoneyPerKill )
		util.Effect( "gmt_money", effectdata )

		dmg:GetAttacker():AddMoney( MoneyPerKill )

		ent:Remove()
	end

end

local function ObamaManStop()

	hook.Remove("Think", "ObamaControlLobby" )
	hook.Remove("Think", "ObamaControlPlaza" )
	hook.Remove("Think", "ObamaControlGamemodes" )
	hook.Remove("Think", "ObamaControlSuites" )
	
	for k,v in pairs (ents.FindByClass("gmt_minigame_obama")) do
		if v.MiniGame == true then
			v:Remove()
			ObamaCount = 0
		end
	end

end

function Start( flags )

	OBAMA_GAME_ACTIVE = true

	ObamaCount = 0
	ObamaMax = 25 -- Lets preload some obamas before the dynamic effect comes in
	
	LastSpawn = CurTime()
	
	if flags == "a" then
		MinigameLocation = Location.GetIDByName( "Lobby" )
		hook.Add("Think", "ObamaControlLobby", ObamaControlLobby )
	elseif flags == "b" then
		MinigameLocation = Location.GetIDByName( "Entertainment Plaza" )
		hook.Add("Think", "ObamaControlPlaza", ObamaControlPlaza )
	elseif flags == "c" then
		MinigameLocation = Location.GetIDByName( "Gamemode Ports" )
		hook.Add("Think", "ObamaControlGamemodes", ObamaControlGamemodes )
	else
		MinigameLocation = Location.GetIDByName( "Suites" )
		hook.Add("Think", "ObamaControlSuites", ObamaControlSuites )
	end

	hook.Add("Location", "ObamaSmashLocation", CheckGiveWeapon )
	hook.Add("EntityTakeDamage", "SmashObama", SmashObama )

	hook.Add("PlayerDeath", "Piratespeak", function( victim )
		if ( victim.HasCrowbar == true ) then
			victim.HasCrowbar = false
			Smashers = Smashers - 1
		end
	end)

	hook.Add("PlayerDisconnected", "Pirateleave", function(ply)
		if ( ply.HasCrowbar == true ) then
			Smashers = Smashers - 1
		end
	end)

	Smashers = 0

	for _, v in pairs( player.GetAll() ) do
		v.HasCrowbar = false
		SafeCall( CheckGiveWeapon, v, v:Location() )
	end

	TotalMoney = 0

end

function End()

	OBAMA_GAME_ACTIVE = false

	ObamaManStop()

	hook.Remove("Location", "ObamaSmashLocation" )
	hook.Remove("EntityTakeDamage", "SmashObama" )
	hook.Remove("PlayerDeath", "Piratespeak")
	hook.Remove("PlayerDisconnected", "Pirateleave")
	
	for _, v in pairs( player.GetAll() ) do
		SafeCall( RemoveWeapon, v )
	end

	for _, v in pairs( ents.FindByClass(WeaponName) ) do
		v:Remove()
	end

	umsg.Start("obamasmash")
		umsg.Char( 1 )
		umsg.Long( TotalMoney )
	umsg.End()

end

hook.Add("ScalePlayerDamage","ObamaDamage",function(ply, h, d)

	if ( OBAMA_GAME_ACTIVE && !Dueling.IsDueling( ply ) ) then
		return true
	end

end)
