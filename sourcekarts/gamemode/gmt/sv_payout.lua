function GAMEMODE:GiveMoney( race )



	if CLIENT then return end



	local PlayerTable = player.GetAll()


	// Payout race

	if race then



		for k, ply in pairs( PlayerTable ) do

			if ply.AFK then continue end

			payout.Clear( ply )



			if ply:GetPosition() && ply:GetPosition() > 0 then

				if ply:GetPosition() == 1 then payout.Give( ply, "Rank1" ) end

				if ply:GetPosition() == 2 then payout.Give( ply, "Rank2" ) end

				if ply:GetPosition() == 3 then payout.Give( ply, "Rank3" ) end

			end



			if ply:Team() == TEAM_FINISHED then

				payout.Give( ply, "FinishBonus" )

			end



			payout.Payout( ply )



		end



	// Payout battle

	else



		for k, ply in pairs( PlayerTable ) do



			payout.Clear( ply )



			if ply:GetPosition() && ply:GetPosition() > 0 then

				if ply:GetPosition() == 1 then payout.Give( ply, "RankBattle1" ) end

				if ply:GetPosition() == 2 then payout.Give( ply, "RankBattle2" ) end

				if ply:GetPosition() == 3 then payout.Give( ply, "RankBattle3" ) end

			end



			payout.Payout( ply )



		end



	end



end