GM.Name     = "GMod Tower: Gourmet Race"
GM.Author   = "GMT Crew~"
GM.Website  = "http://www.gmtower.org/"

GM.AllowSpecialModels = false
GM.AllowHats = false

GM.MaxSpeed = 800
GM.NumRounds = 4

--DeriveGamemode( "base" )

DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Gourmet Race", "gourmetrace", {
	AllowChangeSize = false,
	
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