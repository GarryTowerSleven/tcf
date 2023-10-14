
PERM_STAFF = 1
PERM_ADMIN = 2

module( "Admins", package.seeall )

ActCommands = {}

function RegisterAct( name, permission, func )

	if not name or not func then return end

	permission = permission or PERM_ADMIN

	ActCommands[ name ] = function( ply, args )

		if permission == PERM_STAFF then
			
			if ply:IsStaff() then
				func( ply, args )
			end

		elseif permission == PERM_ADMIN then
		
			if ply:IsAdmin() then
				func( ply, args )
			end

		end

	end

end

function RegisterTargetAct( name, permission, func )

	local newfunc = function( ply, args )

		local id = table.remove( args, 1 )
		local target = player.GetByID( tonumber( id ) )
		if not IsValid( target ) or not target:IsPlayer() then return end

		func( ply, target, args )

	end

	RegisterAct( name, permission, newfunc )

end

concommand.StaffAdd( "gmt_act", function( ply, _, args )

	if table.Count( args ) < 1 then return end

	local cmd = table.remove( args, 1 )

	local handler = ActCommands[ cmd ]
	if not handler or not isfunction( handler ) then return end

	handler( ply, args )

end )

RegisterAct( "rement", PERM_STAFF, function( ply, args )

	local ent = ply:GetEyeTrace().Entity
	if not IsValid( ent ) then return end

	if ent:IsPlayer() then return end
	if ent:GetClass() == "func_brush" then return end

	AdminNotif.SendStaff( Format( "%s has removed entity \"%s\"", ply:Nick(), ent:GetClass() ), nil, "RED", 2 )

	ent:Remove()

end )

RegisterAct( "physgun", PERM_STAFF, function( ply, args )

	if not ply:HasWeapon( "weapon_physgun" ) then
		ply:Give( "weapon_physgun" )
	end

end )

RegisterTargetAct( "slay", PERM_ADMIN, function( ply, target, args )

	target:Kill()
	AdminNotif.SendStaff( Format( "%s has slayed %s.", ply:Nick(), target:NickID() ), nil, "RED", 2 )

end )

RegisterTargetAct( "givemoney", PERM_STAFF, function( ply, target, args )

	local amount = tonumber( args[1] )
	if not amount or amount < 1 then return end

	target:GiveMoney( amount )
	AdminNotif.SendStaff( Format( "%s has given %s GMC to %s.", ply:Nick(), amount, target:NickID() ), nil, "GREEN", 2 )

end )

RegisterTargetAct( "takemoney", PERM_STAFF, function( ply, target, args )

	local amount = tonumber( args[1] )
	if not amount or amount < 1 then return end

	target:TakeMoney( amount, true )
	AdminNotif.SendStaff( Format( "%s has taken %s GMC from %s.", ply:Nick(), amount, target:NickID() ), nil, "RED", 2 )

end )

RegisterTargetAct( "setmoney", PERM_STAFF, function( ply, target, args )

	local amount = tonumber( args[1] )
	if not amount or amount < 0 then return end

	local previous = target:Money()

	target:SetMoney( amount )
	target:MsgT( "AdminSetMoney", ply:Nick(), amount )

	AdminNotif.SendStaff( Format( "%s has set %s's GMC to %s. (Was %s GMC)", ply:Nick(), target:NickID(), amount, previous ), nil, "GREEN", 2 )

end )

RegisterTargetAct( "revive", PERM_STAFF, function( ply, target )

	target:UnSpectate()

	local pos = target:GetPos()
	local ang = target:EyeAngles()

	target:Spawn()

	target:SetPos( pos )
	target:SetEyeAngles( ang )

	AdminNotif.SendStaff( Format( "%s has revived %s.", ply:Nick(), target:NickID() ), nil, "GREEN", 3 )

end )

RegisterTargetAct( "slap", PERM_STAFF, function( ply, target, args )

	target:TakeDamage( tonumber( args[1] or 5 ), ply, ply )

	if target:Alive() then
		target:SetVelocity( VectorRand() * 2048 )
	end

	AdminNotif.SendStaff( Format( "%s has slapped %s.", ply:Nick(), target:NickID() ), nil, "RED", 3 )

end )

RegisterTargetAct( "goto", PERM_STAFF, function( ply, target, args )

	ply:SetPos( target:GetPos() )

end )

RegisterTargetAct( "teleport", PERM_STAFF, function( ply, target, args )

	target:SetPos( ply:GetPos() )

end )
