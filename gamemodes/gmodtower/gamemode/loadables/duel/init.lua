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
	{Vector(-4850.8125,-8231.9375,409.15625), Angle(0,187.40008544922,0)},
	{Vector(-5493.375,-8315.40625,400.5625), Angle(0,187.40008544922,0)},
	{Vector(-6199.375,-8407.125,391.125), Angle(0,187.40008544922,0)},
	{Vector(-6919.9375,-8438,378.78125), Angle(0,213.36024475098,0)},
	{Vector(-7416.375,-9151.625,355.875), Angle(0,242.62026977539,0)},
	{Vector(-8083.84375,-9914.59375,383.15625), Angle(0,230.740234375,0)},
	{Vector(-7984.25,-10521.34375,313.28125), Angle(0,306.20031738281,0)},
	{Vector(-8170.5625,-11329.21875,441.46875), Angle(0,343.16033935547,0)},
	{Vector(-7441.5,-11350.0625,361.1875), Angle(0,15.500329971313,0)},
	{Vector(-7163.28125,-10943.96875,368.15625), Angle(0,40.360374450684,0)},
	{Vector(-6637.0625,-11160.34375,344.4375), Angle(0,321.38037109375,0)},
	{Vector(-5935.28125,-11744.34375,375.34375), Angle(0,10.000370025635,0)},
	{Vector(-5399.28125,-11367.46875,445.1875), Angle(0,60.820415496826,0)},
	{Vector(-5224.375,-10786.96875,483.6875), Angle(0,101.08046722412,0)},
	{Vector(-5435.15625,-10324.09375,465.375), Angle(0,104.60042572021,0)},
	{Vector(-5634.8125,-9571.0625,502.1875), Angle(0,106.36043548584,0)},
	{Vector(-6294.28125,-9199.625,505.15625), Angle(0,195.90051269531,0)},
	{Vector(-6458.96875,-10027.4375,509.03125), Angle(0,271.80059814453,0)},
	{Vector(-6724.875,-10618.09375,482.71875), Angle(0,218.78062438965,0)},
	{Vector(-6973.78125,-8964.21875,517.65625), Angle(0,26.940263748169,0)},
	{Vector(-4637.71875,-8633,548.75), Angle(0,214.9001159668,0)},
	{Vector(-4980.5,-9481.5625,241.53125), Angle(0,262.86019897461,0)},
	{Vector(-5016.65625,-10761.875,230.78125), Angle(0,267.70016479492,0)},
	{Vector(-5460.96875,-11543.84375,303.59375), Angle(0,168.91996765137,0)},
	{Vector(-6626.5625,-11304.90625,342.125), Angle(0,171.5599822998,0)},
	{Vector(-7135.40625,-10803.3125,376.25), Angle(0,132.61996459961,0)},
	{Vector(-8041,-10248.65625,336.03125), Angle(0,69.699897766113,0)},
	{Vector(-7406.1875,-9232.53125,421.5625), Angle(0,27.459844589233,0)},
	{Vector(-6076.3125,-8362.5,416.78125), Angle(0,3.2598395347595,0)},
	{Vector(-5316.53125,-9853.15625,402.65625), Angle(0,280.75979614258,0)},
	{Vector(-6155,-10332.53125,524.3125), Angle(0,136.43963623047,0)}
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

	local requester_ball = Requester:GetBallRaceBall()
	if requester_ball and IsValid( requester_ball ) then
		requester_ball:SetPos(Spawn1[1])
		requester_ball:SetAngles(Spawn1[2])
	elseif IsValid(Requester.GolfBall) then
		Requester.GolfBall:SetPos(Spawn1[1])
		Requester.GolfBall:SetAngles(Spawn1[2])
	else
		Requester:SetPos( Spawn1[1] )
		Requester:SetAngles( Spawn1[2] )
	end

	local arriver_ball = Requester:GetBallRaceBall()
	if arriver_ball and IsValid( arriver_ball ) then
		arriver_ball:SetPos(Spawn2[1])
		arriver_ball:SetAngles(Spawn2[2])
	elseif IsValid(Arriver.GolfBall) then
		Arriver.GolfBall:SetPos(Spawn2[1])
		Arriver.GolfBall:SetAngles(Spawn2[2])
	else
		Arriver:SetPos( Spawn2[1] )
		Arriver:SetAngles( Spawn2[2] )
	end

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

	Requester:Freeze(true)
	Arriver:Freeze(true)

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

		GAMEMODE:ColorNotifyAll( Format( "%s has won the duel!", ply:Name() ), DuelMessageColor, "Duels" )
	else
		ply:SetHealth( 100 )
		ply:SetCustomCollisionCheck( true )
		Opponent:SetHealth( 100 )
		Opponent:SetCustomCollisionCheck( true )
		
		if Amount > 0 then
			GAMEMODE:ColorNotifyAll( Format( "%s has won the with %s, winning %s GMC!", ply:Name(), Opponent:Name(), Amount ), DuelMessageColor, "Duels" )
		else
			GAMEMODE:ColorNotifyAll( Format( "%s has won the with %s!", ply:Name(), Opponent:Name() ), DuelMessageColor, "Duels" )
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

	if disconnected and !IsValid( victim ) and target:Location() == DuelLocation then
		EndDuelClient( target, victim )
		target.DuelRespawnDelay = 5 + CurTime()
		target = nil
		return
	end

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

	local plys = Location.GetPlayersInLocation( DuelLocation )

	if #plys > 0 then

		for k,v in pairs( plys ) do
			if IsValid( v ) then
				if v.DuelRespawnDelay != nil && v.DuelRespawnDelay < CurTime() then
					RespawnDuelers( v )
				end
			end
		end
		
	end

end )

hook.Add( "PlayerDeathThink", "DuelingPreventRespawn", function( ply )

	if ply:Location() == DuelLocation then
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
		if loc == DuelLocation && Dueling.IsDueling( ply ) then
			ply:SetModel( "models/player/normal.mdl" )
		end
	end

end )