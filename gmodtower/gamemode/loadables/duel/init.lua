util.AddNetworkString( "StartDuel" )
util.AddNetworkString( "SuddenDeath" )
util.AddNetworkString( "InviteDuel" )
util.AddNetworkString( "EndDuelClient" )

include( "shared.lua" )
include( "sh_player.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_player.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_panel.lua" )

module( "Dueling", package.seeall )

local DuelMessageColor = Color( 150, 35, 35, 255 )

hook.Add( "CanPlayerSuicide", "DuelSuicide", function( ply )

	if Dueling.IsDueling( ply ) then return false end

end )

hook.Add( "EntityTakeDamage", "EntityDamageExample", function( target, dmginfo )

	if ( target:IsPlayer() and dmginfo:GetAttacker():IsPlayer() and Dueling.IsDueling( target ) and Dueling.IsDueling( dmginfo:GetAttacker() ) ) then
		if target:GetNWEntity( "DuelOpponent" ) != dmginfo:GetAttacker() then
			dmginfo:ScaleDamage( 0.0 )
		elseif target:GetNWEntity( "DuelOpponent" ) == dmginfo:GetAttacker() then
			dmginfo:GetAttacker():SendLua([[surface.PlaySound("GModTower/lobby/duel/duel_hit.wav")]])
		end
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

concommand.Add( "gmt_dueldeny", function( ply, cmd, args )

	local Inviter = ents.GetByIndex( args[1] )
	if Inviter:GetNWBool( "HasSendInvite" ) then
		Inviter:SetNWBool( "HasSendInvite", false )
		Inviter:MsgT( "DuelDeny", ply:GetName() )
	end

end )

concommand.Add( "gmt_duelaccept", function( ply, cmd, args )

	local Inviter = ents.GetByIndex( args[1] )
	if Dueling.IsDueling( ply ) || Dueling.IsDueling( Inviter ) then return end
	if Inviter:GetNWBool( "HasSendInvite" ) then
		Inviter:SetNWBool( "HasSendInvite", false )

		local InviteItemID = Inviter:GetNWInt( "DuelID" )
		if !Inviter:HasItemById( InviteItemID ) then
			ply:Msg2( "The person you've tried to duel with no longer owns the weapon. Duel has been cancelled." )
			return
		end

		for _, SlotList in pairs( Inviter._GtowerPlayerItems ) do
			for slot, Item in pairs( SlotList ) do
				if Item.MysqlId == InviteItemID then
					Inviter:InvRemove( slot, true )
					ply:ExitVehicle()
					Inviter:ExitVehicle()
					StartDueling( Inviter:GetNWString( "DuelWeapon" ), Inviter, ply, Inviter:GetNWInt( "DuelAmount" ) )
					return
				end
			end
		end
	end

end )

concommand.Add( "gmt_duelinvite", function( ply, cmd, args )

	if Dueling.IsDueling( ply ) then
		return
	end

	if ply:GetNWBool( "HasSendInvite" ) then
		ply:MsgT( "DuelInviteFailActive" )
		return
	end

	if #args != 6 then return end

	local Requester = ents.GetByIndex( args[1] )
	local Arriver = ents.GetByIndex( args[2] )
	local Weapon = args[3]
	local Amount = tonumber( args[4] )
	local WeaponName = args[5]
	local WeaponID = math.Round( args[6] )

	if !Dueling.IsDueling( Arriver ) then
		ply:MsgT( "DuelInvite", Arriver:Name() )
	else
		ply:MsgT( "DuelInviteFailCurrent", Arriver:Name() )
		return
	end

	if !Requester:IsPlayer() && !Arriver:IsPlayer() then return end

	if !Requester:HasItemById( WeaponID ) then return end

	Requester:SetNWBool( "HasSendInvite", true )
	Requester:SetNWString( "DuelWeapon", Weapon )
	Requester:SetNWInt( "DuelID", WeaponID )

    Requester:SetNWInt( "DuelAmount", Amount )
    Arriver:SetNWInt( "DuelAmount", Amount )

	net.Start( "InviteDuel" )
		net.WriteInt( Amount, 32 )
		net.WritePlayer( Arriver )
		net.WritePlayer( Requester )
		net.WriteString( WeaponName )
	net.Broadcast()

end )

function StartDueling( Weapon, Requester, Arriver, Amount )

	if !Requester:Alive() then
		Requester:Spawn()
	end

	if !Arriver:Alive() then
		Arriver:Spawn()
	end

	local Spawn1 = table.Random( SnowSpawnPoints )
	local Spawn2 = table.Random( SnowSpawnPoints )

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

	local CanAchi = false

	for k,v in pairs( player.GetAll() ) do
		if IsDueling( v ) then
			v:AddAchievement( ACHIEVEMENTS.SIDEBYSIDE, 1 )
			CanAchi = true
		end
	end

	if CanAchi then
		Requester:AddAchievement( ACHIEVEMENTS.SIDEBYSIDE, 1 )
		Arriver:AddAchievement( ACHIEVEMENTS.SIDEBYSIDE, 1 )
	end

	Requester:AddAchievement( ACHIEVEMENTS.ITCHING, 1 )
	Arriver:AddAchievement( ACHIEVEMENTS.ITCHING, 1 )

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

	GAMEMODE:ColorNotifyAll( Requester:Name().." has challenged "..Arriver:Name().." to a duel for "..( Amount || 0 ).." GMC!", DuelMessageColor )

	Requester:StripWeapons()
	Arriver:StripWeapons()

	Requester.CanPickupWeapons = true
	Arriver.CanPickupWeapons = true

	Requester.DuelStartTime = CurTime()
	Arriver.DuelStartTime = CurTime()

	timer.Simple( 1, function()

		if IsValid(Requester) then
			Requester:Give( Weapon )
		end

		if IsValid(Arriver) then
			Arriver:Give( Weapon )
		end

	end )

	Requester:SetHealth( 300 )
	Arriver:SetHealth( 300 )

	Requester:SetNWEntity( "DuelOpponent", Arriver )
	Arriver:SetNWEntity( "DuelOpponent", Requester )

	if IsValid( Requester ) && IsValid( Arriver ) then
		GiveDuelerAmmo( Requester )
		GiveDuelerAmmo( Arriver )
	end

	Requester:GodEnable()
	Arriver:GodEnable()

	Requester:SetCustomCollisionCheck( false )
	Arriver:SetCustomCollisionCheck( false )

	timer.Simple( 0.5, function()
		GTowerModels.Set( Requester, 1 )
		GTowerModels.Set( Arriver, 1 )
	end )

	timer.Simple( 7, function()
		if IsValid( Requester ) && IsValid( Arriver ) then
			Requester.CanPickupWeapons = false
			Arriver.CanPickupWeapons = false
		end
	end )

	timer.Simple( DuelStartDelay, function()
		if IsValid( Requester ) && IsValid( Arriver ) then
			Requester:GodDisable()
			Arriver:GodDisable()
		end
	end )

	net.Start( "StartDuel" )
		net.WritePlayer( Requester )
		net.WritePlayer( Arriver )
	net.Broadcast()

end

function GiveDuelerAmmo( ply )

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

function RespawnDuelers( ply )
	
	if IsValid(ply) then
		ply.DuelRespawnDelay = nil
    	ply:StripWeapons()
		ply:Spawn()
    	ply:SetPos( ply.RespawnVector )
    	ply:SetEyeAngles( Angle( 0, 0, 0 ) )
		ply.RespawnVector = nil
		ply:SetNWEntity( "DuelOpponent", NULL )
	end

end

local function ClearDuel( ply )

	local ByDisconnect = !IsValid( ply:GetNWEntity( "DuelOpponent", NULL ) )
    local Opponent = ply:GetNWEntity( "DuelOpponent", NULL )
	local Amount = tonumber( ply:GetNWInt( "DuelAmount", 0 ) )

	if IsValid( ply ) && !IsDueling( ply ) then return end
	if IsValid( Opponent ) && !IsDueling( Opponent ) then return end

	if !ByDisconnect then
		ply:SetCustomCollisionCheck(true)
		Opponent:SetCustomCollisionCheck(true)

		local Timestamp = os.time()
		local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
		SQLLog( 'duel', ply:Name() .. " has won a duel with " .. Opponent:Name() .. " winning " .. tostring(Amount) .. "GMC. (" .. TimeString .. ")" )
		local OpponentMoney = tonumber( Opponent:Money() )

		if Amount > 0 then
			if OpponentMoney <= Amount then
				ply:AddMoney( OpponentMoney )
				if !ByDisconnect then
					Opponent:AddMoney( -OpponentMoney )
				end
			else
				ply:AddMoney( ply:GetNWInt( "DuelAmount" ) )
			end

			if !ByDisconnect then
				Opponent:AddMoney( -Opponent:GetNWInt( "DuelAmount" ) )
			end
		end
	end

	if ByDisconnect then
		ply:SetHealth( 100 )
		ply:SetCustomCollisionCheck( true )

		GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel!", DuelMessageColor )
	else
		ply:SetHealth( 100 )
		ply:SetCustomCollisionCheck( true )
		Opponent:SetHealth( 100 )
		Opponent:SetCustomCollisionCheck( true )
		
		if Amount > 0 then
			GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel with "..Opponent:Name()..", winning "..Amount.." GMC!", DuelMessageColor )
		else
			GAMEMODE:ColorNotifyAll( ply:Name().." has won the duel with "..Opponent:Name().."!", DuelMessageColor )
		end
	end

end

local function EndDuelClient( target, victim )

	if IsValid( target ) then
		ClearDuel( target )
		net.Start( "EndDuelClient" )
			net.WriteBool( true )
			net.WritePlayer( victim )
		net.Send( target )
	end
	
	if IsValid( victim ) then
		ClearDuel( victim )
		net.Start( "EndDuelClient" )
			net.WriteBool( false )
			net.WritePlayer( target )
		net.Send( victim )
	end

end

local function EndDuel( victim, disconnected )

    local target = victim:GetNWEntity( "DuelOpponent", NULL )

	target.RespawnVector = Vector( 4688, -565, -3520 )

	if IsValid( victim ) then
		victim.RespawnVector = Vector( 4688, -851, -3520 )
	end

	if disconnected and !IsValid( victim ) and Location.Is( target:Location(), "duelarena" ) then
		EndDuelClient( target, NULL )
		target.DuelRespawnDelay = 5 + CurTime()
		target = nil
		return
	end

	target:SetNWEntity( "DuelOpponent", NULL )
	victim:SetNWEntity( "DuelOpponent", NULL )

    EndDuelClient( target, victim )

	local respawnDelay = 5 + CurTime()

	target.DuelRespawnDelay = respawnDelay
	victim.DuelRespawnDelay = respawnDelay

end

hook.Add( "PostPlayerDeath", "DuelDeathCheck", function( ply )

	if !Dueling.IsDueling( ply ) then return end
    EndDuel( ply, false )

end )

hook.Add( "PlayerDisconnected", "DisconnectDeathCheck", function(ply)

	if !Dueling.IsDueling( ply ) then return end
    EndDuel( ply, true )

end )

net.Receive( "SuddenDeath",  function( _, ply )

	local Opponent = ply:GetNWEntity( "DuelOpponent" )

	if !Dueling.IsDueling( ply ) || !Dueling.IsDueling( Opponent ) then return end

	if ( CurTime() - Opponent.DuelStartTime ) < MaxDuelTime then return end

	local plyHealth = ply:Health()
	local opponentHealth = Opponent:Health()

	if plyHealth < opponentHealth then
		ply:Kill()
	else
		Opponent:Kill()
	end

	if Dueling.IsDueling( Opponent ) then
		Opponent:SetCustomCollisionCheck( true )
	end

	if Dueling.IsDueling( ply ) then
		ply:SetCustomCollisionCheck( true )
	end

end )


hook.Add( "Think", "DuelingWinnerRespawn", function()

	if #Location.GetPlayersInLocation( Location.GetIDByName( "duelarena" ) ) > 0 then

		for k,v in pairs( Location.GetPlayersInLocation( Location.GetIDByName( "duelarena" ) ) ) do
			if IsValid( v ) then
				if v.DuelRespawnDelay != nil && v.DuelRespawnDelay < CurTime() then
					RespawnDuelers( v )
				end
			end
		end
		
	end

end )

hook.Add( "PlayerDeathThink", "DuelingPreventRespawn", function( ply )

	if Location.Is( ply:Location(), "duelarena" ) then
		if ply.DuelRespawnDelay != nil && ply.DuelRespawnDelay < CurTime() then
			if IsValid( ply ) then
				RespawnDuelers( ply )
				return
			end
		else
			return false
		end
	else
		if ( ply:IsBot() || ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
			ply:Spawn()
		end
	end

	return true

end )

hook.Add( "Location","DuelingPlayermodel", function( ply, loc, lastloc )

	if IsValid( ply ) then
		if Location.Is( loc, "duelarena" ) && Dueling.IsDueling( ply ) then
			ply:SetModel( "models/player/anon/anon.mdl" )
		end
	end

end )
