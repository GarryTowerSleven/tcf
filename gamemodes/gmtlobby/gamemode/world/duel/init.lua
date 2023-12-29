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

DuelLocation = Location.GetIDByName( "Narnia" )

local DuelMessageColor = Color( 150, 35, 35, 255 )

hook.Add( "CanPlayerSuicide", "DuelSuicide", function( ply )

	if Dueling.IsDueling( ply ) then return false end
	
	if ply:GetNWBool( "InLimbo" ) then return false end

end )

hook.Add( "EntityTakeDamage", "GiveThisAName", function( target, dmginfo )

	local attacker = dmginfo:GetAttacker()
	if ( target:IsPlayer() and attacker:IsPlayer() and Dueling.IsDueling( target ) and Dueling.IsDueling( attacker ) ) then
		if target:GetNWEntity( "DuelOpponent" ) == attacker then
			attacker:SendLua([[surface.PlaySound("GModTower/lobby/duel/duel_hit.wav")]])
		else
			dmginfo:ScaleDamage( 0.0 )
		end
	end
	
end )

local SnowSpawnPoints = {
	{Vector(-4303.244140625, -7731.9306640625, -101.05592346191), Angle(0, -145, 0)},
	{Vector(-6991.8178710938, -7431.8720703125, -91.668594360352), Angle(0, -75, 0)},
	{Vector(-7981.1787109375, -11411.256835938, -124.44875335693), Angle(0, 85, 0)},
	{Vector(-5647.1298828125, -9082.15234375, -8.8297119140625), Angle(0, 90, 0)}
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

	if Arriver:IsBot() then
		StartDueling( Weapon, ply, Arriver, 0 )
		return
	end

	if !Requester:Afford(Amount) || !Arriver:Afford(Amount) then
		ply:MsgT("DuelInviteFailFunds", Arriver:Name() )
		return
	end

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
		net.WriteEntity( Arriver )
		net.WriteEntity( Requester )
		net.WriteString( WeaponName )
	net.Broadcast()

end )

function StartDueling( Weapon, Requester, Arriver, Amount )
	Requester.IsDueling = true 
	Arriver.IsDueling = true

	Requester.FinishedDuel = false
	Arriver.FinishedDuel = false

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

	Requester:SafeTeleport( Spawn1[1], Spawn1[2] )
	Arriver:SafeTeleport( Spawn2[1], Spawn2[2] )

	Requester:SetEyeAngles( ( Arriver:EyePos() - Requester:EyePos() ):Angle() )
	Arriver:SetEyeAngles( ( Requester:EyePos() - Arriver:EyePos() ):Angle() )

	if ( Amount == 0 ) then
		GAMEMODE:ColorNotifyAll( Format( "%s has challenged %s to a duel!", Requester:Name(), Arriver:Name() ), DuelMessageColor, "Duels" )
	else
		GAMEMODE:ColorNotifyAll( Format( "%s has challenged %s to a duel for %s GMC!", Requester:Name(), Arriver:Name(), Amount or 0), DuelMessageColor, "Duels" )
	end


	Requester:StripWeapons()
	Arriver:StripWeapons()

	Requester.CanPickupWeapons = true
	Arriver.CanPickupWeapons = true

	Requester.DuelStartTime = CurTime()
	Arriver.DuelStartTime = CurTime()

	Requester:UnDrunk()
	Arriver:UnDrunk()
	
	Requester:SetModel( "models/player/normal.mdl" )
	Arriver:SetModel( "models/player/normal.mdl" )
	
	timer.Simple( 1, function()

		if IsValid(Requester) then
			Requester:Give( Weapon )
		end

		if IsValid(Arriver) then
			Arriver:Give( Weapon )
		end

	end )

	if Weapon == "weapon_giant_fist" then
		GTowerModels.SetTemp( Requester, 4 )
		GTowerModels.SetTemp( Arriver, 4 )
	else
		GTowerModels.SetTemp( Requester, 1 )
		GTowerModels.SetTemp( Arriver, 1 )
	end
	Requester:SetHealth( 300 )
	Arriver:SetHealth( 300 )

	Requester:SetNWEntity( "DuelOpponent", Arriver )
	Arriver:SetNWEntity( "DuelOpponent", Requester )

	if IsValid( Requester ) && IsValid( Arriver ) then
		Requester:RemoveAllAmmo()
		Arriver:RemoveAllAmmo()
		GiveDuelerAmmo( Requester )
		GiveDuelerAmmo( Arriver )
	end

	Requester:Freeze(true)
	Arriver:Freeze(true)

	Requester:SetCustomCollisionCheck( false )
	Arriver:SetCustomCollisionCheck( false )


	timer.Simple( 7, function()
		if IsValid( Requester ) && IsValid( Arriver ) then
			Requester.CanPickupWeapons = false
			Arriver.CanPickupWeapons = false
		end
	end )

	timer.Simple( DuelStartDelay, function()
		if IsValid( Requester ) && IsValid( Arriver ) then
			Requester:Freeze(false)
			Arriver:Freeze(false)
		end
	end )

	net.Start( "StartDuel" )
		net.WriteEntity( Requester )
		net.WriteEntity( Arriver )
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
	ply:GiveAmmo( 3, "SMG1_Grenade", true )
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
	ply:GiveAmmo( 2, "AR2AltFire", true )
	ply:GiveAmmo( 250, "slam", true )

end

function RespawnDuelers( ply )

	print( ply or "nil" )
	
	if IsValid(ply) then
		ply.DuelRespawnDelay = nil
    	ply:StripWeapons()
		ply:Spawn()
		ply:SetNWEntity( "DuelOpponent", NULL )
	end

end

local function ClearDuel( ply, disconnect )

	local ByDisconnect = disconnect or false
    local Opponent = ply:GetNWEntity( "DuelOpponent", NULL )
	local Amount = tonumber( ply:GetNWInt( "DuelAmount", 0 ) )

	if ply.FinishedDuel or ( IsValid(Opponent) and Opponent.FinishedDuel ) then return end

	if IsValid( ply ) && !IsDueling( ply ) then return end
	if IsValid( Opponent ) && !IsDueling( Opponent ) then return end

	ply.FinishedDuel = true
	
	if IsValid( Opponent ) then
		Opponent.FinishedDuel = true
	end

	if !ByDisconnect then
		ply:SetCustomCollisionCheck(true)
		Opponent:SetCustomCollisionCheck(true)

		local Timestamp = os.time()
		local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
		SQLLog( 'duel', ply:Name() .. " has won a duel with " .. Opponent:Name() .. " winning " .. tostring(Amount) .. "GMC. (" .. TimeString .. ")" )
		local OpponentMoney = tonumber( Opponent:Money() )

		if Amount > 0 then
			if OpponentMoney <= Amount then
				ply:AddMoney( OpponentMoney, nil, nil, nil, "DuelWin" )
				if !ByDisconnect then
					Opponent:AddMoney( -OpponentMoney, nil, nil, nil, "DuelLose" )
				end
			else
				ply:AddMoney( ply:GetNWInt( "DuelAmount" ), nil, nil, nil, "DuelWin2" )
			end

			if !ByDisconnect then
				Opponent:AddMoney( -Opponent:GetNWInt( "DuelAmount" ), nil, nil, nil, "DuelLose2" )
			end
		end
	end

	if ByDisconnect then
		ply:SetHealth( 100 )
		ply:SetCustomCollisionCheck( true )

		GAMEMODE:ColorNotifyAll( Format( "%s has won the duel!", ply:Name() ), DuelMessageColor, "Duels" )
	else
		ply:SetHealth( 100 )
		ply:SetCustomCollisionCheck( true )
		Opponent:SetHealth( 100 )
		Opponent:SetCustomCollisionCheck( true )
		
		if Amount > 0 then
			GAMEMODE:ColorNotifyAll( Format( "%s has won the duel with %s, winning %s GMC!", ply:Name(), Opponent:Name(), Amount ), DuelMessageColor, "Duels" )
		else
			GAMEMODE:ColorNotifyAll( Format( "%s has won the duel with %s!", ply:Name(), Opponent:Name() ), DuelMessageColor, "Duels" )
		end
	end

end

local function EndDuelClient( target, victim )

	if IsValid( target ) then
		net.Start( "EndDuelClient" )
			net.WriteBool( true )
			net.WriteEntity( victim )
		net.Send( target )
		ClearDuel( target, !target:GetNWEntity( "DuelOpponent", NULL ) )
	end
	
	if IsValid( victim ) then
		net.Start( "EndDuelClient" )
			net.WriteBool( false )
			net.WriteEntity( target )
		net.Send( victim )
	end

end

local function EndDuel( victim, disconnected )

    local target = victim:GetNWEntity( "DuelOpponent", NULL )

	victim.IsDueling = false
	target.IsDueling = false 

	if disconnected and !IsValid( victim ) and target:Location() == DuelLocation then
		EndDuelClient( target, victim )

		timer.Simple( 5, function()
			RespawnDuelers( target )
		end)

		target = nil
		return
	end

	EndDuelClient( target, victim )

	timer.Simple( 5, function()
		RespawnDuelers( target )
		RespawnDuelers( victim )
	end)
end

hook.Add( "PostPlayerDeath", "DuelDeathCheck", function( ply )

	ply.RespawnDelay = 1.5 + CurTime()
	if !Dueling.IsDueling( ply ) then return end
    EndDuel( ply, false )

end )

hook.Add( "PlayerDisconnected", "DisconnectDeathCheck", function(ply)

	if !Dueling.IsDueling( ply ) then return end
    EndDuel( ply, true )

	local Timestamp = os.time()
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
	SQLLog( 'duel', ply:Nick() .. " has left the game during a duel. (" .. TimeString .. ")" )

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

hook.Add( "PlayerDeathThink", "DuelingPreventRespawn", function( ply )

	//LETS JUST MAKE THIS THE ENTIRE LOBBY RESPWAN SYSTEM?? GENIUS ^_^
	if ply:Location() == DuelLocation && Dueling.IsDueling( ply ) then
		if ply.DuelRespawnDelay != nil && ply.DuelRespawnDelay < CurTime() then
			if IsValid( ply ) then
				RespawnDuelers( ply )
				return
			end
		else
			return false
		end
	elseif ply.RespawnDelay != nil then // is this necessary? are catch alls good?
		if ply.RespawnDelay < CurTime() then
			if ( ply:IsBot() || ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) then
				ply:Spawn()
			end
		end
	else // see above
		ply:Spawn()
	end

	return true

end )

hook.Add( "PlayerShouldTakeDamage", "DuelDamage", function( ply, attacker )
	
	if ply.IsDueling and attacker.IsDueling then
		return ply == attacker:GetNWEntity( "DuelOpponent", NULL ) and ply:GetNWEntity( "DuelOpponent", NULL ) == attacker
	end

end )