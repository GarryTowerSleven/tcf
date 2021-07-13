util.AddNetworkString("StartDuel")
util.AddNetworkString("SuddenDeath")
util.AddNetworkString("InviteDuel")
util.AddNetworkString("EndDuelClient")

include("shared.lua")
include("sh_player.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("sh_player.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_panel.lua")

local DeathCheck = {}

concommand.Add("gmt_printduellocation",function(ply)
	local pos = ply:GetPos()

	local str = "Vector(" .. tostring( pos.x ) .. "," .. tostring( pos.y ) .. "," .. tostring( pos.z ) .. "),"
	ply:ChatPrint(str)

end)

hook.Add("CanPlayerSuicide","DuelSuicide",function(ply)
	if ply:GetNWBool("IsDueling") then return false end
end)

hook.Add( "EntityTakeDamage", "EntityDamageExample", function( target, dmginfo )

	if ( target:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and target.ActiveDuel and dmginfo:GetAttacker().ActiveDuel and target.Opponent != dmginfo:GetAttacker() ) then
		dmginfo:ScaleDamage( 0.0 ) // Damage is now half of what you would normally take.
	end

	if ( target:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and target.ActiveDuel and dmginfo:GetAttacker().ActiveDuel and target.Opponent == dmginfo:GetAttacker() ) then
		dmginfo:GetAttacker():SendLua([[surface.PlaySound("GModTower/lobby/duel/duel_hit.wav")]])
	end

end )

local SnowSpawnPoints = {
Vector(-4866.0224609375,-12475.3984375,7744.03125),
Vector(-6331.6708984375,-10977.309570313,7744.03125),
Vector(-4868.5385742188,-9497.5908203125,7744.03125),
Vector(-4866.0874023438,-10680.135742188,7872.03125),
Vector(-4572.9306640625,-11640.715820313,7424.03125),
Vector(-5448.21875,-10471.103515625,7424.03125),
Vector(-5938.2006835938,-9867.232421875,7616.03125),
Vector(-3754.6674804688,-9866.55078125,7616.03125),
Vector(-3154.3400878906,-11744.799804688,7744.03125),
Vector(-4908.8720703125,-12167.959960938,7424.03125),
Vector(-5618.0415039063,-11829.6640625,7420.03125),
Vector(-5244.08203125,-9512.1640625,7744.03125),
Vector(-3177.51953125,-11676.516601563,7744.03125),
Vector(-5193.6206054688,-11636.732421875,7424.03125),
Vector(-5903.0205078125,-9899.5791015625,7616.03125),
Vector(-4119.2602539063,-9787.984375,7616.03125),
}

concommand.Add("gmt_dueldeny",function(ply, cmd, args)
	local Inviter = ents.GetByIndex(args[1])
	if Inviter:GetNWBool("HasSendInvite") then
		Inviter:SetNWBool("HasSendInvite",false)
		Inviter:Msg2(ply:GetName().." has denied your request or has dueling disabled.")
	end
end)

concommand.Add("gmt_duelaccept",function(ply, cmd, args)

	local Inviter = ents.GetByIndex(args[1])
	if ply:GetNWBool("IsDueling") || Inviter:GetNWBool("IsDueling") then return end
	if Inviter:GetNWBool("HasSendInvite") then
		Inviter:SetNWBool("HasSendInvite",false)

		local InviteItemID = Inviter:GetNWInt("DuelID")
		if !Inviter:HasItemById( InviteItemID ) then
			ply:Msg2("The person you've tried to duel with no longer owns the weapon. Duel has been cancelled.")
			return
		end

		for _, SlotList in pairs(Inviter._GtowerPlayerItems) do
			for slot, Item in pairs( SlotList ) do
				if Item.MysqlId == InviteItemID then
					Inviter:InvRemove(slot,true)
					StartDueling(Inviter:GetNWString("DuelWeapon"), Inviter, ply, Inviter:GetNWInt("DuelAmount"))
					return
				end
			end
		end

	end
end)

concommand.Add("gmt_duelinvite",function(ply, cmd, args)
  if #args != 6 then return end

  local Requester =  ents.GetByIndex(args[1])
  local Arriver =  ents.GetByIndex(args[2])
  local Weapon = args[3]
  local Amount = args[4]
	local WeaponName = args[5]
	local WeaponID = math.Round(args[6])

	if !Requester:IsPlayer() and !Arriver:IsPlayer() then return end

	if !Requester:HasItemById( WeaponID ) then return end

	Requester:SetNWBool("HasSendInvite", true)
	Requester:SetNWString("DuelWeapon", Weapon)
	Requester:SetNWInt("DuelID", WeaponID)

    Requester.Amount = tonumber(Amount)
    Arriver.Amount = tonumber(Amount)

    Requester:SetNWInt("DuelAmount", Amount)
    Arriver:SetNWInt("DuelAmount", Amount)

  net.Start("InviteDuel")
	net.WriteInt(Amount,32)
	net.WritePlayer(Arriver)
	net.WritePlayer(Requester)
	net.WriteString(WeaponName)
	net.Broadcast()
end)

function StartDueling(Weapon, Requester, Arriver, Amount)
	if !Requester:Alive() then
		Requester:Spawn()
	end

	if !Arriver:Alive() then
		Arriver:Spawn()
	end

	local Spawn1 = table.Random(SnowSpawnPoints)
	local Spawn2 = table.Random(SnowSpawnPoints)

	if Spawn1 == Spawn2 then
		for k,v in pairs( SnowSpawnPoints ) do
			if v == Spawn2 then
				if k == #SnowSpawnPoints then
					Spawn2 = SnowSpawnPoints[1]
				else
					Spawn2 = SnowSpawnPoints[ (k + 1) ]
				end
			end
		end
	end

	for k,v in pairs( player.GetAll() ) do
		if v:GetNWBool("IsDueling") then
			CanAchi = true
		end
	end

	if Requester.BallRaceBall and IsValid( Requester.BallRaceBall ) then
		Requester.BallRaceBall:SetPos(Spawn1)
	elseif IsValid(Requester.GolfBall) then
		Requester.GolfBall:SetPos(Spawn1)
	else
		Requester.DesiredPosition = Spawn1
	end

	if Arriver.BallRaceBall and IsValid( Arriver.BallRaceBall ) then
		Arriver.BallRaceBall:SetPos(Spawn2)
	elseif IsValid(Arriver.GolfBall) then
		Arriver.GolfBall:SetPos(Spawn2)
	else
		Arriver.DesiredPosition = Spawn2
	end

	GAMEMODE:ColorNotifyAll( Requester:Name().." has challenged "..Arriver:Name().." to a duel for "..(Amount or 0).." GMC!", Color(150, 35, 35, 255) )

	Requester:StripWeapons()
	Arriver:StripWeapons()

	Requester.CanPickupWeapons = true
	Arriver.CanPickupWeapons = true

	Requester.DuelStartTime = CurTime()
	Arriver.DuelStartTime = CurTime()

	timer.Simple(1,function()

		if IsValid(Requester) then
			Requester:Give(Weapon)
		end

		if IsValid(Arriver) then
			Arriver:Give(Weapon)
		end

	end)

	Requester:SetHealth(300)
	Arriver:SetHealth(300)

	Requester:SetNWBool("IsDueling",true)
	Arriver:SetNWBool("IsDueling",true)

	GiveDuelerAmmo(Requester)
	GiveDuelerAmmo(Arriver)

	Requester:GodDisable()
	Arriver:GodDisable()

	Requester.Opponent = Arriver
	Arriver.Opponent = Requester

	Requester:SetNWString("DuelOpponent",Arriver:Name())
	Arriver:SetNWString("DuelOpponent",Requester:Name())

	Requester.ActiveDuel = true
	Arriver.ActiveDuel = true
	Requester:SetCustomCollisionCheck(false)
	Arriver:SetCustomCollisionCheck(false)

	timer.Simple(0.5,function()
		GTowerModels.Set( Requester, 1 )
		GTowerModels.Set( Arriver, 1 )
	end)

	timer.Simple(7,function()
		Requester.CanPickupWeapons = false
		Arriver.CanPickupWeapons = false
	end)

	local CurPlayers = { Requester, Arriver }

	table.Add( DeathCheck , CurPlayers )

	net.Start( "StartDuel" )
	net.WritePlayer( Requester )
	net.WritePlayer( Arriver )
	net.Broadcast()
end

function GiveDuelerAmmo(ply)
  ply:GiveAmmo( 250, "SMG1", true )
  ply:GiveAmmo( 250, "AR2", true )
  ply:GiveAmmo( 250, "AlyxGun", true )
  ply:GiveAmmo( 250, "Pistol", true )
  ply:GiveAmmo( 250, "SMG1", true )
  ply:GiveAmmo( 250, "357", true )
  ply:GiveAmmo( 250, "XBowBolt", true )
  ply:GiveAmmo( 250, "Buckshot", true )
  ply:GiveAmmo( 250, "RPG_Round", true )
  ply:GiveAmmo( 250, "SMG1_Grenade", true )
  ply:GiveAmmo( 250, "SniperRound", true )
  ply:GiveAmmo( 250, "SniperPenetratedRound", true )
  ply:GiveAmmo( 250, "Grenade", true )
  ply:GiveAmmo( 250, "Trumper", true )
  ply:GiveAmmo( 250, "Gravity", true )
  ply:GiveAmmo( 250, "Battery", true )
  ply:GiveAmmo( 250, "GaussEnergy", true )
  ply:GiveAmmo( 250, "CombineCannon", true )
  ply:GiveAmmo( 250, "AirboatGun", true )
  ply:GiveAmmo( 250, "StriderMinigun", true )
  ply:GiveAmmo( 250, "HelicopterGun", true )
  ply:GiveAmmo( 250, "AR2AltFire", true )
  ply:GiveAmmo( 250, "slam", true )
end

local function RespawnWinner(ply)
    timer.Simple(5,function()
		if !IsValid(ply) then return end
		if ply.ActiveDuel or GTowerLocation:FindPlacePos(ply:GetPos()) != 41 then return end
        ply:StripWeapons()
        ply.DesiredPosition = Vector(7128.354980, 991.272339, -1255.968750)
        ply:SetEyeAngles(Angle(0, -90, 0))
    end)
end

local function ClearDeathCheck(ply)
	local ByDisconnect = net.ReadBool()
    local Opponent = ply.Opponent
	local Amount = tonumber(ply.Amount)

	if IsValid(ply) && !ply.ActiveDuel then return end
	if IsValid(Opponent) && !Opponent.ActiveDuel then return end

	if Amount > 0 then

		if !ByDisconnect then
			ply.ActiveDuel = false
			ply:SetNWBool("IsDueling",false)
			Opponent.ActiveDuel = false
			Opponent:SetNWBool("IsDueling",false)
			ply:SetCustomCollisionCheck(true)
			Opponent:SetCustomCollisionCheck(true)

			local Timestamp = os.time()
			local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
			SQLLog( 'duel', ply:Name() .. " has won a duel with " .. Opponent:Name() .. " winning " .. tostring(Amount) .. "GMC. (" .. TimeString .. ")" )
		local OpponentMoney = tonumber(Opponent:Money())

		if OpponentMoney <= Amount then
			ply:AddMoney(OpponentMoney)
			if !ByDisconnect then
			Opponent:AddMoney(-OpponentMoney)
			end
		else
			ply:AddMoney(ply.Amount)
		end

		if !ByDisconnect then
			Opponent:AddMoney(-Opponent.Amount)
		end

		end

		if ByDisconnect then
			ply:SetHealth(100)
			ply.ActiveDuel = false
			ply:SetNWBool("IsDueling",false)
			ply:SetCustomCollisionCheck(true)

			GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel!", Color(150, 35, 35, 255) )
		else
			ply.ActiveDuel = false
			ply:SetCustomCollisionCheck(true)
			ply:SetHealth(100)
			Opponent:SetHealth(100)
			Opponent.ActiveDuel = false
			Opponent:SetCustomCollisionCheck(true)

			GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel with "..Opponent:Name()..", winning "..Amount.." GMC!", Color(150, 35, 35, 255) )
		end
	else

		if ByDisconnect then

			if ply:GetNWBool("IsDueling") then
				ply:SetNWBool("IsDueling",false)
				ply.ActiveDuel = false
				ply:SetCustomCollisionCheck(true)
			end

			GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel!", Color(150, 35, 35, 255) )

		else

			if ply:GetNWBool("IsDueling") then
				ply:SetNWBool("IsDueling",false)
				ply.ActiveDuel = false
				ply:SetCustomCollisionCheck(true)
			end

			if Opponent:GetNWBool("IsDueling") then
				Opponent:SetNWBool("IsDueling",false)
				Opponent.ActiveDuel = false
				Opponent:SetCustomCollisionCheck(true)
			end

			GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel with "..Opponent:Name().."!", Color(150, 35, 35, 255) )

		end

	end

  if table.HasValue(DeathCheck, ply) then
    table.RemoveByValue(DeathCheck, ply)
  end

	if ByDisconnect then return end

  if table.HasValue(DeathCheck, Opponent) then
    table.RemoveByValue(DeathCheck, Opponent)
  end
end

local function EndDuelClient(won, target, victim)
    net.Start("EndDuelClient")
        net.WriteBool(won)
        net.WritePlayer(victim)
    net.Send(target)

    if IsValid(victim) then
        net.Start("EndDuelClient")
            net.WriteBool(false)
            net.WritePlayer(target)
        net.Send(victim)
    end
end

local function EndDuel(victim, disconnected)
    local target = victim.Opponent

	if disconnected and !IsValid(victim) and GTowerLocation:FindPlacePos(target:GetPos()) == 41 then
		ClearDeathCheck(target)

		target = nil

        EndDuelClient(won, target)
	end

	won = victim != target

	if won then
		ClearDeathCheck(target)
	end

	target.DuelOpponent = nil

    EndDuelClient(won, target, victim)

	RespawnWinner(target)
end

hook.Add( "PostPlayerDeath", "DuelDeathCheck", function(ply)
    if !table.HasValue(DeathCheck,ply) then return end

    EndDuel(ply, false)

    RespawnWinner()
end)

hook.Add( "PlayerDisconnected", "DisconnectDeathCheck", function(ply)
  if !table.HasValue(DeathCheck,ply) then return end

	table.RemoveByValue(DeathCheck, ply)

    EndDuel(ply, true)

  RespawnWinner()
end)

net.Receive("SuddenDeath",  function(_, ply)
	local Opponent = ply.Opponent

	if !ply.ActiveDuel || !Opponent.ActiveDuel then return end

	if (CurTime() - Opponent.DuelStartTime) < MaxDuelTime then return end

	local plyHealth = ply:Health()
	local opponentHealth = Opponent:Health()

	if plyHealth < opponentHealth then
		ply:Kill()
	else
		Opponent:Kill()
	end

	if Opponent:GetNWBool("IsDueling") then
		Opponent:SetNWBool("IsDueling",false)
		Opponent.ActiveDuel = false
		Opponent:SetCustomCollisionCheck(true)
	end

	if ply:GetNWBool("IsDueling") then
		ply:SetNWBool("IsDueling",false)
		ply.ActiveDuel = false
		ply:SetCustomCollisionCheck(true)
	end
end)

hook.Add("Location","MoonAchiCheck",function(ply,loc)
	if IsValid( ply ) then

		if loc == 41 then
			ply.MoonStoreModel = ply:GetModel()
			ply:SetModel("models/player/anon/anon.mdl")
		elseif loc != 41 && ply.GLastLocation == 41 then
			ply:SetModel(ply.MoonStoreModel)
		end

	end
end)
