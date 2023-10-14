
module( "Admins", package.seeall )

concommand.AdminAdd( "gmt_create", function( ply, _, args )

	if table.Count( args ) < 1 then return end

	local arg = string.Trim( args[1] )
	if arg == "" then return end

	local hitpos = ply:GetEyeTrace().HitPos

	if util.IsValidModel( arg ) then

		local ent = ents.Create("prop_physics_multiplayer")

		ent:SetPos( hitpos )
		ent:SetModel( arg )
		ent:Spawn()
		
		AdminNotif.SendStaff( Format( "%s has created a prop with model \"%s\"", ply:Nick(), arg ), nil, "GREEN", 2 )

		return
	end

	local ent = ents.Create( arg )
	if not IsValid( ent ) then return end

	ent:SetPos( hitpos )
	ent:Spawn()

	AdminNotif.SendStaff( Format( "%s has created a \"%s\"", ply:Nick(), ent:GetClass() ), nil, "GREEN", 2 )

end )

concommand.StaffAdd( "gmt_mute", function( ply, _, args )

	if table.Count( args ) < 1 then return end

	local target = player.GetByID( tonumber( args[1] ) )
	if not IsValid( target ) then return end

	target._Muted = not target._Muted

	if target._Muted then

		ply:MsgT( "PlayerMute", target:Nick() )
		target:MsgT( "PlayerMuteAlert" )

		AdminNotif.SendStaff( Format( "%s has muted %s.", ply:Nick(), target:NickID() ), nil, "RED", 2 )

	else
	
		ply:MsgT( "PlayerUnmute", target:Nick() )
		target:MsgT( "PlayerUnmuteAlert" )

		AdminNotif.SendStaff( Format( "%s has unmuted %s.", ply:Nick(), target:NickID() ), nil, "GREEN", 2 )

	end

end )

concommand.StaffAdd( "gmt_gag", function( ply, _, args )

	if table.Count( args ) < 1 then return end

	local target = player.GetByID( tonumber( args[1] ) )
	if not IsValid( target ) then return end

	target._Gagged = not target._Gagged

	if target._Gagged then

		ply:MsgT( "PlayerGag", target:Nick() )
		target:MsgT( "PlayerGagAlert" )
		AdminNotif.SendStaff( Format( "%s has gagged %s.", ply:Nick(), target:NickID() ), nil, "RED", 2 )

	else
	
		ply:MsgT( "PlayerUngag", target:Nick() )
		target:MsgT( "PlayerUngagAlert" )
		AdminNotif.SendStaff( Format( "%s has ungagged %s.", ply:Nick(), target:NickID() ), nil, "GREEN", 2 )

	end

end )

concommand.StaffAdd( "gmt_sprayban", function( ply, _, args )

	if table.Count( args ) < 1 then return end

	local target = player.GetByID( tonumber( args[1] ) )
	if not IsValid( target ) then return end

	local set = not target:GetSetting( "GTAllowSpray" )

	local msg = set and "You have spray banned %s." or "You have un spray banned %s."

	target:SetSetting( "GTAllowSpray", set )
	ply:Msg2( Format( msg, target:Nick() ) )

end )

concommand.StaffAdd( "gmt_cleardecals", function( ply )

	local lua = [[for _, v in ipairs( ents.GetAll() ) do v:RemoveAllDecals() end game.GetWorld():RemoveAllDecals()]]

	BroadcastLua( lua )
	//BroadcastLua( "RunConsoleCommand( 'r_cleardecals' )" )
	AdminNotify( T( "AdminClrDecals", ply:Nick() ) )

end )

concommand.StaffAdd( "gmt_fakename", function( ply, _, _, str )

    str = string.Trim( str )

    if str == "" then
        str = nil
    end

    ply:SetNet( "FakeName", str or "" )

end )

/*concommand.StaffAdd( "gmt_cloak", function( ply )

	local set = not ply:GetNoDraw()

	ply._Cloaked = set
	ply:SetNoDraw( set )

	if set then
		ply:Msg2( "You have been cloaked." )
	else
		ply:Msg2( "You have been uncloaked." )
	end

end )*/

local ValidRockets = {}
local function MakeRocketDoDamage( ent )
	
	if ent:GetClass() != "rpg_missile" then return end
	
	for k, v in pairs( ValidRockets ) do
		
		if not IsValid( v ) then

			table.remove( ValidRockets, k )
		
		elseif ent == v then
			
			table.remove( ValidRockets, k )
			
			util.BlastDamage( ent, ent.EntityOwner, ent:GetPos(), ent.Damage * 2, ent.Damage )
			
		end
		
	end
	
	if table.Count( ValidRockets ) == 0 then
		hook.Remove( "EntityRemoved", "ExplodeRocket" )
	end	
	
end

concommand.AdminAdd( "gmt_firerocket", function( ply, _, args )

	local aim = ply:GetAimVector()
	local aimangle = aim:Angle()
	local pos = ply:GetShootPos() + aimangle:Forward() * 12 + aimangle:Right() * 6 + aimangle:Up() * -3
	
	local missile = ents.Create("rpg_missile")
	missile:SetOwner( ply )
	missile.EntityOwner = ply
	missile:SetPos( pos	)
	missile:SetAngles( aimangle )
	missile:SetVelocity( aim * 256 )
	
	missile:Spawn()
	missile:DrawShadow( false )

	missile.Damage = math.Clamp( tonumber( args[1] ) or 50, 1, 5000 )  

	table.insert( ValidRockets, missile )

	hook.Add( "EntityRemoved", "ExplodeRocket", MakeRocketDoDamage )

	AdminNotif.SendStaff( Format( "%s has fired a rocket.", ply:Nick() ), nil, "RED", 5 )

end )