// === GMT SETUP ===
DeriveGamemode("gmtgamemode")
SetupGMTGamemode( "Ball Race", "ballrace", {
	DrawHatsAlways = true, // Always draw hats
	AllowMenu = true, // Allow hook into menu events
	AFKDelay = 60 - 20, // Seconds before they will be marked as AFK
	ChatBGColor = Color( 172, 121, 84, 255 ), // Color of the chat gui
	ChatScrollColor = Color( 89, 49, 22, 255 ), // Color of the chat scroll bar gui
} )

// === GAMEMODE GLOBALS ===
GM.Lives = 2
GM.MaxFailedAttempts = 3 // max times players can repeat the same level if they fail
GM.DefaultLevelTime = 60

// Memories is harder!
if Maps.IsMap( "gmt_ballracer_memories" ) then
	GM.DefaultLevelTime = GM.DefaultLevelTime + 10
	GM.Lives = 3
end

if Maps.IsMap( "gmt_ballracer_midori" ) then
	GM.DefaultLevelTime = GM.DefaultLevelTime * 2
	GM.Lives = 3
end

if Maps.IsMap( "gmt_ballracer_tranquil" ) then
	GM.DefaultLevelTime = GM.DefaultLevelTime + 10
end

if game.GetMap() == "gmt_ballracer_facile" then
	GM.DefaultLevelTime = GM.DefaultLevelTime + 10
	GM.Lives = 3
end


// === GAMEMODE NETVARS ===
RegisterNWTableGlobal( {
	{"Passed", false, NWTYPE_BOOLEAN, REPL_EVERYONE },
} )

RegisterNWTablePlayer( {
	{"CompletedTime", "", NWTYPE_STRING, REPL_EVERYONE },
	{"CompletedRank", 99, NWTYPE_NUMBER, REPL_EVERYONE },
} )

// === STATES ===
STATE_WAITING = 1
STATE_PLAYING = 2
STATE_PLAYINGBONUS = 3
STATE_INTERMISSION = 4
STATE_SPAWNING = 5

MSGSHOW_LEVELCOMPLETE = 1
MSGSHOW_LEVELFAIL = 2
MSGSHOW_WORLDCOMPLETE = 3

TEAM_PLAYERS = 1
TEAM_DEAD = 2
TEAM_COMPLETED = 3

GM.IntermissionTime = 6
GM.WaitForPlayersTime = 60

MUSIC_LEVEL = 1
MUSIC_BONUS = 2

Levels = {
	"gmt_ballracer_grassworld01",
	"gmt_ballracer_iceworld03",
	"gmt_ballracer_khromidro02",
	"gmt_ballracer_memories02",
	"gmt_ballracer_metalworld",
	"gmt_ballracer_midori02",
	"gmt_ballracer_neonlights01",
	"gmt_ballracer_nightball",
	"gmt_ballracer_paradise03",
	"gmt_ballracer_sandworld02",
	"gmt_ballracer_skyworld01",
	"gmt_ballracer_spaceworld01",
	"gmt_ballracer_waterworld02",
	"gmt_ballracer_facile",
	"gmt_ballracer_flyinhigh01",
	"gmt_ballracer_tranquil01",
	"gmt_ballracer_rainbowworld"
}

LevelMusic = {
	{"balls/ballsmusicwgrass",126.955102},
	{"balls/ballsmusicwice",225},
	{"balls/ballsmusicwkhromidro",322.377143},
	{"balls/ballsmusicwmemories",260.127347},
	{"balls/ballsmusicwmetal",169},
	{"balls/midori_vox",259},
	{"pikauch/music/manzaibirds",164},
	{"balls/ballsmusicwnight",162},
	{"balls/ballsmusicwparadise",305.057959},
	{"balls/ballsmusicwsand",71},
	{"balls/ballsmusicwsky",83.644082},
	{"balls/ballsmusicwspace",119},
	{"balls/ballsmusicwwater",195},
	{"balls/ballsmusicwfacile",143},
	{"balls/ballsmusicwflyinhigh",195},
	{"balls/ballsmusicwtranquil",145},
	{"rainbow_world/ravenholm",77}
}

LevelMapSelect = table.KeyFromValue( Levels, game.GetMap() )

function GetMusicSelection()
	return LevelMusic[LevelMapSelect][1]
end

function GetMusicDuration()
	return LevelMusic[LevelMapSelect][2]
end

if Maps.IsMap( "gmt_ballracer_khromidro" ) then
	music.Register( MUSIC_LEVEL, GetMusicSelection(), { Length = 322 * ( 1 / .75 ), Pitch = 75, Loops = true } )
else
	music.Register( MUSIC_LEVEL, GetMusicSelection(), { Loops = true, Length = GetMusicDuration() } )
end

music.Register( MUSIC_BONUS, "balls/bonusstage" )

GM.ExplodeSound = Sound("weapons/ar2/npc_ar2_altfire.wav")
GM.FilteredEnts = {}

if Maps.IsMap( "gmt_ballracer_iceworld" ) then

	game.AddParticles("particles/stormfront.pcf")
	PrecacheParticleSystem("env_snow_stormfront_001")
	PrecacheParticleSystem("env_snow_stormfront_mist")

end

function GM:Initialize()

	// Setup camera filters
	table.Add( self.FilteredEnts, ents.FindByModel( "tubes_*" ) )

end

default_pm = 'models/player/kleiner.mdl'

function Passed()
	return ( ( #team.GetPlayers( TEAM_DEAD ) + #team.GetPlayers( TEAM_COMPLETED ) ) == #player.GetAll() )
end

function GetRaceTime()
	return GAMEMODE.DefaultLevelTime-GAMEMODE:GetTimeLeft()
end

local novel = Vector(0,0,0)
function GM:Move(ply, movedata)
	movedata:SetForwardSpeed(0)
	movedata:SetSideSpeed(0)
	movedata:SetVelocity(novel)
	if SERVER then ply:SetGroundEntity(NULL) end

	local ball = ply:GetBall()
	if IsValid(ball) then
		movedata:SetOrigin(ball:GetPos())
	end

	return true
end

hook.Add("DisableAdminCommand", "BallraceNoAdmin", function(cmd)
	if cmd == "addent" || cmd == "rement" || cmd == "physgun" then return true end
end)

function GM:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	return true
end

local Player = FindMetaTable("Player")

function GM:ShouldCollide(ent1, ent2)
	if !self.CollisionsEnabled && ent1:GetClass() == "player_ball" && ent2:GetClass() == "player_ball" then
		return false
	end
	return true
end

function Player:CameraTrace(ball, dist, angles)

	local ballorigin = ball:Center()
	local maxview = ballorigin + angles:Forward() * -dist

	local trace = util.TraceLine( { start = ballorigin,
									endpos = maxview,
									mask = MASK_OPAQUE,
									filter = GAMEMODE.FilteredEnts } )

	if trace.Fraction < 1 then
		dist = dist * trace.Fraction
	end

	return ballorigin + angles:Forward() * -dist * 0.95, dist
	//MASK_SOLID_BRUSHONLY

end

function Player:SetBall(ent)
	self:SetOwner(ent)
end

function Player:GetBall()
	return self:GetOwner()
end