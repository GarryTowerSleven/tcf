GM.Name 	= "GMod Tower Classic: Virus"
GM.Author   = "GMod Tower Team"
GM.Website  = "http://www.gmodtower.org/"

GM.AllowSpecialModels = true
GM.AllowChangeSize = false

DeriveGamemode( "gmodtower" )

function RegisterNWTable()
	SetGlobalInt("State",1)
	SetGlobalFloat("Time",0)
	SetGlobalInt("Round",0)
	SetGlobalInt("MaxRounds",0)
	SetGlobalInt("NumVirus",0)
end

function RegisterNWPlayer(ply)
	ply:SetNWBool("IsVirus",false)
	ply:SetNWFloat("MaxHealth",100)
	ply:SetNWInt("Rank",0)
end

STATUS_WAITING		= 1
STATUS_INFECTING	= 2
STATUS_PLAYING		= 3
STATUS_INTERMISSION	= 4

TEAM_PLAYERS	= 1
TEAM_INFECTED	= 2
TEAM_SPEC		= 3

MUSIC_WAITINGFORINFECTION	= 1
MUSIC_INTERMISSION			= 4

team.SetUp( TEAM_PLAYERS, "Survivors", Color( 255, 255, 100, 255 ) )
team.SetUp( TEAM_INFECTED, "Infected", Color( 175, 225, 175, 255 ) )
team.SetUp( TEAM_SPEC, "Waiting", Color( 255, 255, 100, 255 ) )

function GM:GetState()
	return GetGlobalInt("State")
end

function GM:IsPlaying()
	return GetGlobalInt("State") == STATUS_PLAYING
end

function GM:GetTimeLeft()
	return GetGlobalFloat("Time") - CurTime()
end

Loadables.Load( {
	"achivement",
	"friends",
	"afk2",
	"scoreboard3",
	"payout",
	"weaponfix",
	//"jetpack",
} )
