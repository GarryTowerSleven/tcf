function GAMEMODE:GiveMoney()



	if CLIENT then return end



	for _, ply in pairs( player.GetAll() ) do


		if ply.AFK then continue end

		payout.Clear( ply )



		local swing = ply:Swing()

		local pardiff = ply:GetParDiff( swing )



		if swing == 1 then

			payout.Give( ply, "HoleInOne" )

		elseif pardiff > 2 then

			payout.Give( ply, "OverBogey" )

		else

			payout.Give( ply, Scores[ pardiff ] )

		end



		payout.Payout( ply )



	end



end