function GAMEMODE:GiveMoney()

	if CLIENT then return end

	--local PlayerTable = player.sqlGetAll()

	for _, ply in pairs( player.GetAll() ) do

		if ply.AFK then continue end

		payout.Clear( ply )

		local placement = ply:GetNWInt("Placement")

		if ply:Team() == TEAM_COMPLETED then
			payout.Give( ply, "Completed" )
		end

		if !ply:GetNWBool("Died") then
			payout.Give( ply, "NoDeath" )
		end

		if ply:GetNWBool("PressedButton") then
			payout.Give( ply, "Button" )
		end

		if placement == 1 then
			payout.Give( ply, "Rank1" )
		elseif placement == 2 then
			payout.Give( ply, "Rank2" )
		elseif placement == 3 then
			payout.Give( ply, "Rank3" )
		end

		if ply:Frags() > 0 then
			payout.Give( ply, "Collected", ply:Frags() * 5 )
		end

		payout.Payout( ply )

	end

end
