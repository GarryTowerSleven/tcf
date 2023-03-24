// === GMT SETUP ===
DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Virus", "virus", {
	Loadables = { "weaponfix", "virus" }, // Additional loadables
	AllowSmall = true, // Small player models
	DrawHatsAlways = false, // Always draw hats
	AFKDelay = 90 - 20, // Seconds before they will be marked as AFK
	EnableWeaponSelect = true, // Allow weapon selection
	EnableCrosshair = true, // Draw the crosshair
	EnableDamage = true, // Draw red damage effects
	DisableDucking = true, -- Disable ducking
	DisableJumping = true, -- Disable jumping
	DisableRunning = true, -- Disable running
	ChatBGColor = Color( 70, 118, 34, 255 ), // Color of the chat gui
	ChatScrollColor = Color( 44, 80, 15, 255 ), // Color of the chat scroll bar gui
} )

-- game.AddParticles( "particles/jb_fire.pcf" )
-- PrecacheParticleSystem( "jb_burningplayer_green" )

RegisterNWTableGlobal({ 
	{ "Round", 0, NWTYPE_CHAR, REPL_EVERYONE },
	{ "MaxRounds", 0, NWTYPE_CHAR, REPL_EVERYONE },
})

RegisterNWTablePlayer({
	{ "IsVirus", false, NWTYPE_BOOLEAN, REPL_EVERYONE },
	{ "MaxHealth", 100, NWTYPE_NUMBER, REPL_PLAYERONLY },
	{ "Rank", 0, NWTYPE_CHAR, REPL_PLAYERONLY },
})

STATE_WAITING		= 1
STATE_INFECTING		= 2
STATE_PLAYING		= 3
STATE_INTERMISSION	= 4

TEAM_PLAYERS		= 1
TEAM_INFECTED		= 2
TEAM_SPEC			= 3

team.SetUp( TEAM_PLAYERS, "Survivors", Color( 255, 255, 100, 255 ) )
team.SetUp( TEAM_INFECTED, "Infected", Color( 175, 225, 175, 255 ) )
team.SetUp( TEAM_SPEC, "Waiting", Color( 255, 255, 100, 255 ) )

hook.Add("CalcMainActivity", "Virus", function(ply, vel)
	if ply:Team() == TEAM_INFECTED then
		return ACT_HL2MP_RUN_ZOMBIE, -1
	end
end)

// MUSIC
EVENT_PLAY = 1
EVENT_STOP = 2
EVENT_STOPALL = 3
EVENT_VOLUME = 4

MUSIC_WAITING_FOR_PLAYERS = 1
MUSIC_WAITING_FOR_INFECTION = 2
MUSIC_ROUNDPLAY = 3
MUSIC_LAST_ALIVE = 4
MUSIC_ROUNDEND_SURVIVORS = 5
MUSIC_ROUNDEND_VIRUS = 6

MUSIC_STINGER = 7
MUSIC_IGNITE = 8

music.DefaultVolume = .85
music.DefaultFolder = "gmodtower/virus"

music.Register( MUSIC_WAITING_FOR_PLAYERS, "waiting_forplayers", { Num = 8 } )
music.Register( MUSIC_WAITING_FOR_INFECTION, "waiting_forinfection", { Num = 8 } )
music.Register( MUSIC_ROUNDPLAY, "roundplay", { Num = 5 } )
music.Register( MUSIC_LAST_ALIVE, "roundlastalive", { Num = 2 } )
music.Register( MUSIC_ROUNDEND_SURVIVORS, "roundend_survivors" )
music.Register( MUSIC_ROUNDEND_VIRUS, "roundend_virus" )

music.Register( MUSIC_STINGER, "stinger", { Oneoff = true } )
music.Register( MUSIC_IGNITE, "ambient/fire/ignite.wav", { Oneoff = true } )