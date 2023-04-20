--print('a')
hook.Add( "Move", "EmoteMove", function( ply, mv ) 
	
	if IsEmoting(ply) then
		return true
	end
	
end)

hook.Add( "PlayerDeath", "GlobalDeathMessage", function( victim, inflictor, attacker )
	victim:SetNWBool("Emoting",false)
	victim:SetNWBool("Sitting",false)
	victim:SetNWBool("Laying",false)
	victim:SetNWBool("Lounging",false)
	victim:SetNWBool("Dancing",false)
end )

function IsEmoting( ply )

	return ply:GetNWBool("Emoting") --ply.EmoteID && ply.EmoteID > 0

end