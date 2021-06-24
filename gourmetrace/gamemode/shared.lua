GM.Name     = "GMod Tower: Gourmet Race"
GM.Author   = "GMT Crew~"
GM.Website  = "http://www.gmtower.org/"

GM.AllowSpecialModels = false
GM.AllowChangeSize = false
GM.AllowHats = false

GM.MaxSpeed = 800
GM.NumRounds = 4

--DeriveGamemode( "base" )

DeriveGamemode( "gmodtower" )

TowerModules.LoadModules( {
	"achivement",
	"scoreboard3",
	"afk2",
	"friends",
	--"music",
	"weaponfix",
	"payout",
	//"jetpack",
} )

function NWTableGlobal()
	SetGlobalInt( "State", 0 )
	SetGlobalInt( "Round", 0 )
	SetGlobalInt( "Time", 0 )
	SetGlobalBool( "NoReadyScreen", false )
end

function NWTablePlayer(ply)
	ply:SetNWInt( "Rank", 0 )
	ply:SetNWInt( "Powerup", 0 )
	ply:SetNWInt( "Time", 0 )
	ply:SetNWInt( "DoubleJumpNum", 0 )
end

STATUS_WAITING		= 0 // waiting for players
STATUS_INTERMISSION	= 1 // wait time after end
STATUS_WARMUP		= 2 // 3, 2, 1
STATUS_PLAYING		= 3 // playing

TEAM_SPEC			= 0
TEAM_RACING			= 1
TEAM_FINISHED		= 2

team.SetUp( TEAM_FINISHED, "Finished", Color( 255, 128, 0, 255 ) )
team.SetUp( TEAM_RACING, "Racers", Color( 128, 0, 128, 255 ) )
team.SetUp( TEAM_SPEC, "Waiting", Color( 255, 255, 100, 255 ) )

/* MUSIC */
MUSIC_WAITING = 1
MUSIC_WARMUP = 2
MUSIC_ROUND = 3
MUSIC_ENDROUND = 4
MUSIC_WINLOSE = 5
MUSIC_30SEC = 6
MUSIC_INVINCIBLE = 7
MUSIC_TAKEFIRST = 8
MUSIC_FINISH = 9

GM.Music = {
	[MUSIC_WAITING] = { "GModTower/gourmetrace/music/waiting/waiting", 5 },
	[MUSIC_WARMUP] = Sound( "GModTower/gourmetrace/music/warmup.mp3" ),
	[MUSIC_ROUND] = { "GModTower/gourmetrace/music/round/round", 9 },
	[MUSIC_ENDROUND] = { "GModTower/gourmetrace/music/endround/endround", 3 },
	[MUSIC_WINLOSE] = {

		Win = Sound( "GModTower/gourmetrace/music/win.mp3" ),
		Lose = Sound( "GModTower/gourmetrace/music/lost.mp3" ),
		Timeup = Sound( "GModTower/gourmetrace/music/timeup.mp3" ),

	},
	[MUSIC_30SEC] = { "GModTower/gourmetrace/music/30sec/30sec", 3 },
	[MUSIC_INVINCIBLE] = Sound( "GModTower/gourmetrace/music/invincibility.wav" ),
	[MUSIC_TAKEFIRST] = Sound( "GModTower/gourmetrace/music/take1st.mp3" ),
	[MUSIC_FINISH] = Sound( "GModTower/gourmetrace/music/finish.wav" ),
}

function GM:SetGameState( state )
	SetGlobalInt( "State", state )
end

function GM:GetGameState()
	return GetGlobalInt( "State" )
end

function GM:IsPlaying()
	return GetGlobalInt( "State" ) == STATUS_PLAYING
end

function GM:IsRoundOver()
	return GetGlobalInt( "State" ) == STATUS_INTERMISSION
end

function GM:GetTimeLeft()
	return ( GetGlobalInt( "Time" ) or 0 ) - CurTime()
end

function GM:ShouldCollide( ent1, ent2 )

	if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() ) then return false end

	return true

end

------------------------------------------------------------------

payout.Register( "ThanksForPlaying", {
	Name = "Thanks For Playing",
	Desc = "For participating in the game!",
	GMC = 25,
} )

payout.Register( "FinishBonus", {
	Name = "Finished",
	Desc = "You finished the race!",
	GMC = 50,
	Diff = 1,
} )

payout.Register( "Rank1", {
	Name = "1st Place!",
	Desc = "Congratulations, you won the race!",
	GMC = 250,
	Diff = 3,
} )

payout.Register( "Rank2", {
	Name = "2nd Place",
	Desc = "Better luck next time!",
	GMC = 150,
	Diff = 3,
} )

payout.Register( "Rank3", {
	Name = "3rd Place",
	Desc = "",
	GMC = 100,
	Diff = 3,
} )

payout.Register( "Collected", {
	Name = "Collected Food",
	Desc = "Bonus for collecting food (5 GMC each up to 25).",
	Diff = 4,
	GMC = 0,
} )

function GM:GiveMoney()

	if CLIENT then return end

		for k, ply in pairs( player.GetAll() ) do

			if ply.AFK then continue end

			payout.Clear( ply )

			local points = ply:GetNWInt("Points")

			if ply:GetNWInt( "Pos" ) > 0 then
				if ply:GetNWInt( "Pos" ) == 1 then payout.Give( ply, "Rank1" ) end
				if ply:GetNWInt( "Pos" ) == 2 then payout.Give( ply, "Rank2" ) end
				if ply:GetNWInt( "Pos" ) == 3 then payout.Give( ply, "Rank3" ) end

				if points > 0 then
					payout.Give( ply, "Collected", math.Clamp( points * 5, 0, (25 * 5) ) )
				end

			end

			if ply:Team() == TEAM_FINISHED then
				payout.Give( ply, "FinishBonus" )
			end

			payout.Payout( ply )
		end

end
