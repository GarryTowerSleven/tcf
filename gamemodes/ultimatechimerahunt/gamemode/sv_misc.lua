// misc things that shouldn't really be touched much

hook.Add("AllowSpecialAdmin", "DisallowGodmode", function()
	return false
end)

// no anti-tranquility on gamemodes
hook.Add( "AntiTranqEnable", "GamemodeAntiTranq", function() return false end )

function GM:CanNoClip( ply )
	return false
end

function GM:CanPlayerSuicide( ply ) 
    return ply:IsAdmin()
end

function GM:PlayerDeathSound()
	return true
end