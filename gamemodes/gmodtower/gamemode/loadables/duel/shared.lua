module( "Dueling", package.seeall )

Sounds = {
	Hit = "GModTower/lobby/duel/duel_hit.wav",
	Wager = "GModTower/lobby/duel/duel_wager.wav",
	Lose = "GModTower/lobby/duel/duel_lose.mp3",
	Win = "GModTower/lobby/duel/duel_win.mp3",
	Songs = { "GModTower/lobby/duel/duel_song", 8 }
}

MaxDuelTime = 60 * 2
MaxDuelDist = 2048
DuelStartDelay = 6

function IsDueling( ply )
	if ply:IsBot() then return false end
	return IsValid( ply.DuelOpponent )
end

hook.Add( "DisableJetpack", "DisableJetpackDueling", function( ply )
	if IsDueling( ply ) then
		return true
	end
end )