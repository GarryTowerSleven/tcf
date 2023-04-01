// === GAMEMODE SETUP ===
GM.Name 	= "GMod Tower: Minigolf"

DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Minigolf", "minigolf", {
	DrawHatsAlways = false, -- Always draw hats
	AFKDelay = 30, -- Seconds before they will be marked as AFK
	DisablePlayerClick = true, -- Disable clicking on players
	ChatY = 450, -- Chat offset Y
	ChatX = 30, -- Chat offset X
	ChatBGColor = Color( 44, 83, 17, 180 ), -- Color of the chat gui
	ChatScrollColor = Color( 25, 49, 8, 215 ), -- Color of the chat scroll bar gui
} )

GM.Holes = GM.Holes || {};

STATE_NOPLAY 		= 0
STATE_WAITING 		= 1 -- waiting for players
STATE_SETTINGS 		= 2 -- selecting
STATE_PREVIEW 		= 3 -- selecting
STATE_PLAYING 		= 4 -- playing game
STATE_INTERMISSION 	= 5 -- in between holes (scoreboard show)
STATE_ENDING 		= 6 -- game is ending

// GAME SETTINGS
WaitTime = 80
MaxPower = 300
StrokeLimit = 15
LatePenality = 3 -- Amount of strokes + par for late joining

SafeMaterials = { -- Materials that are safe for the ball to be on
	"tools/toolsnodraw",
	"golf/grass_in",
	"golf/sand",
	"golf/puttputt_sand",
	"golf/puttputt_grass",
	"dev/dev_measuregeneric01b",
	"gmod_tower/mrsaturnvalley/saturn_grass",
	"gmod_tower/minigolf/green",
	"wood/milbeams002",
	"maps/gmt_minigolf_02/nature/blendrockslime01a_wvt_patch",
	"gmod_tower/minigolf/sand",
	"gmod_tower/minigolf/zen_green",
	"stone/stonewall033a",
	"garden/gravel_waves_single",
	"garden/gravel_waves",
	"maps/gmt_minigolf_zen/concrete/blendbunk_conc01_wvt_patch",
	"gmod_tower/minigolf/snowfall/snowfall_mainsnow",
	"gmod_tower/minigolf/snowfall/snowfall_mainice",
	"gmod_tower/minigolf/snowfall/snowfall_iceslide",
	"gmt_minigolf_moon/grass_in_blue",
	"metal/metalhull003a",
	"metal/metalfence007a",
	"gmod_tower/minigolf/forest/green_checkers",
	"cs_havana/woodm",
	"gmod_tower/minigolf/puttputt_wood_in",
	"gmt_minigolf_desert/desert_brick_edge",
	"gmt_minigolf_desert/desert_floor_tile",
	"gmt_minigolf_desert/desert_puttputt_start",
	"gmt_minigolf_desert/desert_stone",
}

SandMaterials = {
	"gmod_tower/minigolf/sand",
	"golf/sand",
	"garden/gravel_waves_single",
	"garden/gravel_waves",
}

IceMaterials = {
	"gmod_tower/minigolf/snowfall/snowfall_mainice",
	"gmod_tower/minigolf/snowfall/snowfall_iceslide",
}

Scores = {
	[-4] = "CONDOR",
	[-3] = "ALBATROSS",
	[-2] = "EAGLE",
	[-1] = "BIRDIE",
	[0] = "PAR",
	[1] = "BOGEY",
	[2] = "DOUBLE BOGEY",
}

function GM:GetHoles()
	for _,hole in pairs(ents.FindByClass("golfstart")) do
		table.insert(self.Holes, hole)
	end
end

// NETVARS
globalnet.Register( "Int", "Hole" )
globalnet.Register( "Int", "Par" )
globalnet.Register( "String", "HoleName" )
globalnet.Register( "Bool", "HasPractice" )

-- MUSIC
MUSIC_NONE = 0
MUSIC_WAITING = 1
MUSIC_SETTINGS = 2
MUSIC_INTERMISSION = 3
MUSIC_ENDGAME = 4
MUSIC_ENDINGGAME = 5

GM.Music = {
	[MUSIC_WAITING] = { "GModTower/minigolf/music/waiting", 7 },
	[MUSIC_SETTINGS] = { "GModTower/minigolf/music/customize", 2 },
	[MUSIC_INTERMISSION] = { "GModTower/minigolf/music/intermission", 5 },
	[MUSIC_ENDINGGAME] = { "GModTower/minigolf/music/ending", 2 },
	[MUSIC_ENDGAME] = {
		"GModTower/minigolf/music/end1.mp3",
		"GModTower/minigolf/music/end2.mp3",
		"GModTower/minigolf/music/end3.mp3",
		"GModTower/minigolf/music/end4.mp3",
	},
}

-- SOUNDS
SOUND_CUP = "GModTower/minigolf/effects/cup.wav"
SOUND_HIT = "GModTower/minigolf/effects/hit.wav"
SOUND_EXPLOSION = "GModTower/minigolf/effects/explosion.wav"
SOUND_ROCKET = "GModTower/minigolf/effects/launch.wav"
SOUND_SWING = "GModTower/minigolf/effects/swing" // power + .wav
SOUND_CLAP = "GModTower/minigolf/effects/golfclap" // 1-3 + .wav

SOUNDS_ANNOUNCER = {
	"GModTower/minigolf/effects/voice/niceapproach.wav",
	"GModTower/minigolf/effects/voice/nicein.wav",
	"GModTower/minigolf/effects/voice/niceon.wav",
	"GModTower/minigolf/effects/voice/niceshot.wav",
	"GModTower/minigolf/effects/voice/nicetouch.wav",
}

SOUNDINDEX_CLAP = 1
SOUNDINDEX_ANNOUNCER = 2

--STATE
function GM:IsPracticing()
	return self:GetState() == STATE_WAITING && globalnet.GetNet( "HasPractice" ) == true
end

-- TEAM
TEAM_PLAYING = 1
TEAM_FINISHED = 2

function GM:IsPlaying()
	return self:GetState() ==  STATE_PLAYING
end

function PracticeSpawn()
	local spawn

	for k,v in pairs (ents.FindByClass('golfwaiting')) do
		spawn = v
	end

	return spawn
end

function FirstSpawn()
	local spawn

	for k,v in pairs (ents.FindByClass('info_player_start')) do
		spawn = v
	end

	return spawn
end

function GM:GetPar()
	return globalnet.GetNet( "Par" )
end

function GM:SetPar( par )
	globalnet.SetNet( "Par", par )
end

function GM:GetHoleName()
	return globalnet.GetNet( "HoleName" )
end

function GM:SetHoleName( name )
	globalnet.SetNet( "HoleName", name )
end

function GM:UpdateNetHole( hole )
	globalnet.SetNet( "Hole", hole )
end

function GM:GetHole()
	return globalnet.GetNet( "Hole" ) or 0
end

hook.Add( "ShouldCollide", "ShouldCollideMinigolf", function( ent1, ent2 )
	if ent1:IsPlayer() && ent2:IsPlayer() then
		return false
	end

	if ent1:GetClass() == "golfball" && ent2:GetClass() == "golfball" then
		return false
	end

	return true
end )

/*hook.Add( "OverrideHatEntity", "OverrideHatMinigolf", function( ply )
	local ball = ply:GetGolfBall()

	if IsValid( ball ) then
		return ball
	end

	return ply
end )*/