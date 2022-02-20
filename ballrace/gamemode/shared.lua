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

music.DefaultVolume = .85
music.DefaultFolder = "gmodtower/balls"

music.Register( MUSIC_BONUS, "bonusstage" )

music.Register( MUSIC_LEVEL, "ballsmusicwgrass", { Length = 126.955102, Loops = true }, "gmt_ballracer_grassworld" )
music.Register( MUSIC_LEVEL, "ballsmusicwice", { Length = 225, Loops = true }, "gmt_ballracer_iceworld" )
music.Register( MUSIC_LEVEL, "ballsmusicwkhromidro", { Length = 322 * ( 1 / .75 ), Pitch = 75, Loops = true }, "gmt_ballracer_khromidro" )
music.Register( MUSIC_LEVEL, "ballsmusicwmemories", { Length = 260.127347, Loops = true }, "gmt_ballracer_memories" )
music.Register( MUSIC_LEVEL, "ballsmusicwmetal", { Length = 169, Loops = true }, "gmt_ballracer_metalworld" )
music.Register( MUSIC_LEVEL, "midori_vox", { Length = 259, Loops = true }, "gmt_ballracer_midori" )
music.Register( MUSIC_LEVEL, "pikauch/music/manzaibirds", { Length = 164, Loops = true }, "gmt_ballracer_neonlights" )
music.Register( MUSIC_LEVEL, "ballsmusicwnight", { Length = 162, Loops = true }, "gmt_ballracer_nightball" )
music.Register( MUSIC_LEVEL, "ballsmusicwparadise", { Length = 305.057959, Loops = true }, "gmt_ballracer_paradise" )
music.Register( MUSIC_LEVEL, "ballsmusicwsand", { Length = 71, Loops = true }, "gmt_ballracer_sandworld" )
music.Register( MUSIC_LEVEL, "ballsmusicwsky", { Length = 83.644082, Loops = true }, "gmt_ballracer_skyworld" )
music.Register( MUSIC_LEVEL, "ballsmusicwspace", { Length = 119, Loops = true }, "gmt_ballracer_spaceworld" )
music.Register( MUSIC_LEVEL, "ballsmusicwwater", { Length = 195, Loops = true }, "gmt_ballracer_waterworld" )
music.Register( MUSIC_LEVEL, "ballsmusicwfacile", { Length = 143, Loops = true }, "gmt_ballracer_facile" )
music.Register( MUSIC_LEVEL, "ballsmusicwflyinhigh", { Length = 195, Loops = true }, "gmt_ballracer_flyinhigh" )
music.Register( MUSIC_LEVEL, "ballsmusicwtranquil", { Length = 145, Loops = true }, "gmt_ballracer_tranquil" )
music.Register( MUSIC_LEVEL, "rainbow_world/ravenholm", { Length = 77, Loops = true }, "gmt_ballracer_rainbowworld" )

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