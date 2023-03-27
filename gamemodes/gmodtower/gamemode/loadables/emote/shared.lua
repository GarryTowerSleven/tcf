--print('a')
hook.Add( "Move", "EmoteMove", function( ply, mv ) 
	
	if IsEmoting(ply) then
		return true
	end
	
end)

hook.Add( "PlayerDeath", "GlobalDeathMessage", function( victim, inflictor, attacker )
	if victim:GetNWBool("Emoting") then
		victim:SetNWBool("Emoting",false)
		victim:SetNWBool("Sitting",false)
		victim:SetNWBool("Laying",false)
		victim:SetNWBool("Lounging",false)
	end
end )

function IsEmoting( ply )

	return ply:GetNWBool("Emoting") --ply.EmoteID && ply.EmoteID > 0

end