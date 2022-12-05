DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Gourmet Race", "gourmetrace", {
	DrawHatsAlways = false, // Always draw hats
	AllowChangeSize = false,
} )

GM.MaxSpeed = 800
GM.NumRounds = 4

// === GAMEMODE NETVARS ===
RegisterNWTableGlobal( {
	{ "Round", 0, NWTYPE_NUMBER, REPL_EVERYONE },
} )

RegisterNWTablePlayer( {
	{ "Rank", 99, NWTYPE_NUMBER, REPL_EVERYONE },
	{ "Pos", 99, NWTYPE_NUMBER, REPL_EVERYONE },
	{ "Invincible", false, NWTYPE_BOOLEAN, REPL_EVERYONE },
	{ "Powerup", "", NWTYPE_STRING, REPL_EVERYONE },
	{ "Time", 0, NWTYPE_NUMBER, REPL_EVERYONE },
	{ "DoubleJumpNum", 0, NWTYPE_NUMBER, REPL_EVERYONE },
	{ "Points", 0, NWTYPE_NUMBER, REPL_EVERYONE },
} )

STATE_WAITING		= 0 // waiting for players
STATE_INTERMISSION	= 1 // wait time after end
STATE_WARMUP		= 2 // 3, 2, 1
STATE_PLAYING		= 3 // playing

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
MUSIC_WIN = 5
MUSIC_LOSE = 6
MUSIC_TIMEUP = 7
MUSIC_30SEC = 8
MUSIC_INVINCIBLE = 9
MUSIC_TAKEFIRST = 10
MUSIC_FINISH = 11

music.DefaultVolume = .85
music.DefaultFolder = "gmodtower/gourmetrace/music"

music.Register( MUSIC_WAITING, "waiting/waiting", { Num = 5 } )
music.Register( MUSIC_WARMUP, "warmup" )
music.Register( MUSIC_ROUND, "round/round", { Num = 9 } )
music.Register( MUSIC_ENDROUND, "endround/endround", { Num = 3 } )

music.Register( MUSIC_WIN, "win" )
music.Register( MUSIC_LOSE, "lost" )
music.Register( MUSIC_TIMEUP, "timeup" )

music.Register( MUSIC_30SEC, "30sec/30sec", { Num = 3 } )
music.Register( MUSIC_INVINCIBLE, "invincibility", { Ext = ".wav" } )
music.Register( MUSIC_TAKEFIRST, "take1st" )
music.Register( MUSIC_FINISH, "finish", { Ext = ".wav", Oneoff = true } )

function GM:IsRoundOver()
	return self:GetState() == STATE_INTERMISSION
end

function GM:ShouldCollide( ent1, ent2 )

	if ( IsValid( ent1 ) and IsValid( ent2 ) and ent1:IsPlayer() and ent2:IsPlayer() ) then return false end

	return true

end