
// no anti-tranquility on gamemodes
//hook.Add( "AntiTranqEnable", "GamemodeAntiTranq", function() return false end )

hook.Add("AllowSpecialAdmin", "DisalowGodmode", function() return false end)


function GM:PlayerSwitchFlashlight( ply, on ) 
	
	if on == true then
		return false
	end

end

function GM:GTCanNoClip( ply )
	return false
end

function GM:CanPlayerSuicide( ply ) 
    return false
end

function GM:PlayerDeathSound()
	return true
end

function GM:EntityTakeDamage( ent, inflictor, attacker, amount, dmginfo )

	if ent:IsPlayer() then

		if dmginfo:IsFallDamage() then

			dmginfo:ScaleDamage( 0 )

		end
		
	end
 
end