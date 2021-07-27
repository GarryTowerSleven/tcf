include("sh_mapnames.lua")

GM.Name     = "GMod Tower: Ballrace"
GM.Author   = "GMT Crew~"
GM.Website  = "http://www.gmtower.org/"

--DeriveGamemode("base")

DeriveGamemode( "gmodtower" )

Loadables.Load( {
	"clientsettings",
	"achievement",
	"commands",
	"afk2",
	"friends",
	"scoreboard3",
	"weaponfix",
	"payout",
	"music",
	//"jetpack",
} )


GM.Lives = 2
GM.Tries = 3

if game.GetMap() == "gmt_ballracer_midori02" or game.GetMap() == "gmt_ballracer_midorib5" then
	GM.DefaultLevelTime = 120
	GM.Lives = 3
elseif game.GetMap() == "gmt_ballracer_memories02" then
	GM.DefaultLevelTime = 70
	GM.Lives = 3
elseif game.GetMap() == "gmt_ballracer_tranquil01" then
	GM.DefaultLevelTime = 70
elseif game.GetMap() == "gmt_ballracer_facile" then
	GM.DefaultLevelTime = 70
	GM.Lives = 3
else
GM.DefaultLevelTime = 60
end
GM.IntermissionTime = 6
GM.WaitForPlayersTime = 35

default_pm = 'models/player/kleiner.mdl'

function SetTime(lvltime)
	SetGlobalInt("GTIME", lvltime);
end

function GetTime()
	return GetGlobalInt("GTIME");
end

function GetRaceTime()
	return GAMEMODE.DefaultLevelTime-timer.TimeLeft("RoundEnd")
end

SetTime(GM.DefaultLevelTime)

Levels = {
"gmt_ballracer_grassworld01",
"gmt_ballracer_iceworld03",
"gmt_ballracer_khromidro02",
"gmt_ballracer_memories02",
--"gmt_ballracer_midori02",
"gmt_ballracer_paradise03",
"gmt_ballracer_sandworld02",
"gmt_ballracer_skyworld01",
}

LevelMusic = {
	{"balls/ballsmusicwgrass",126.955102},
	{"balls/ballsmusicwice",225},
	{"balls/ballsmusicwkhromidro",322.377143},
	{"balls/ballsmusicwmemories",260.127347},
	--{"balls/midori_vox",259},
	{"balls/ballsmusicwparadise",305.057959},
	{"balls/ballsmusicwsand",71},
	{"balls/ballsmusicwsky",83.644082},
}

LevelMapSelect = table.KeyFromValue( Levels, game.GetMap() )

function GetMusicSelection()
	return LevelMusic[LevelMapSelect][1]
end

function GetMusicDuration()
	return LevelMusic[LevelMapSelect][2]
end

GM.ExplodeSound	= "weapons/ar2/npc_ar2_altfire.wav"

STATUS_WAITING = 0 --1
STATUS_PLAYING = 2
STATUS_INTERMISSION = 3
STATUS_SPAWNING = 4

TEAM_PLAYERS = 1
TEAM_DEAD = 2
TEAM_COMPLETED = 3

--GLoadables:RequireModule( "scoreboard" )

function SetState(state)
	SetGlobalInt("GamemodeState", state);
end

function GetState()
	return GetGlobalInt("GamemodeState");
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

function Player:SetBall(ent)
	self:SetOwner(ent)
end

function Player:GetBall()
	return self:GetOwner()
end

function GM:ShouldCollide(ent1, ent2)
	if !self.CollisionsEnabled && ent1:GetClass() == "player_ball" && ent2:GetClass() == "player_ball" then
		return false
	end
	return true
end

MUSIC_LEVEL = 1
MUSIC_BONUS = 2

if game.GetMap() == "gmt_ballracer_khromidro02" then
	music.Register( MUSIC_LEVEL, GetMusicSelection(), { Length = 322 * ( 1 / .75 ), Pitch = 75, Loops = true } )
else
	music.Register( MUSIC_LEVEL, GetMusicSelection(), { Loops = true, Length = GetMusicDuration() } )
end

music.Register( MUSIC_BONUS, "balls/bonusstage" )
