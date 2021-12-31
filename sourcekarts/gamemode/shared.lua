// === GAMEMODE SETUP ===
GM.Name 	= "GMod Tower: Source Karts"

DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Source Karts", "sourcekarts", {
	AFKDelay = 6000, // Seconds before they will be marked as AFK
	ChatBGColor = Color( 7, 34, 48, 180 ), // Color of the chat gui
	ChatScrollColor = Color( 7 + 5, 34 + 5, 48 + 5, 150 ), // Color of the chat scroll bar gui
} )

RaveMode = string.StartWith( game.GetMap(), "gmt_sk_rave" )

GM.Cameras = 3 // How many cameras for before race?

GM.CameraTime = 3 // How much time the camera is on



GM.WaitingTime = 80 // Time to wait for players

GM.ReadyTime = ( GM.Cameras * GM.CameraTime ) + 6 // Time before race

GM.RaceTime = 5*60 // Max time for race

GM.BattleTime = 3*60 // Max time for battle round



GM.MaxTracks = 3 // Max tracks

GM.MaxLaps = 3 // Max laps

GM.FirstCountdown = 60 // How many seconds they have before the race auto ends

GM.MaxRounds = 2 // How many battles do we want to have

GM.MaxLives = 3 // Max lives on battle



GM.SlowDownScale = 2 // How much to divide when being slowed down


physenv.AddSurfaceData([["kart"

{

	"base"		"default_silent"

	"density"	"917"

	"friction"	"0.1"

	"elasticity"	"0.1"

} ]])


// STATE

STATE_WAITING = 1 // waiting for players

STATE_PREVIEW = 2 // selecting

STATE_READY = 3 // reading up game

STATE_PLAYING = 4 // playing game

STATE_NEXTTRACK = 7 // in between tracks

STATE_TOBATTLE = 5 // going to battle

STATE_NEXTBATTLE = 6 // in between battles

STATE_BATTLEINTRO = 10 // battle intro

STATE_BATTLEENDING = 11 // battle outro

STATE_BATTLE = 8 // battle

STATE_ENDING = 9 // game is ending


// TEAM

TEAM_READY = 1

TEAM_PLAYING = 2

TEAM_FINISHED = 3


// SOUNDS

SOUND_SPIN = Sound("GModTower/sourcekarts/effects/spin.wav"
)
SOUND_JUMP = Sound("GModTower/sourcekarts/effects/jump.wav"
)
SOUND_REV = Sound("GModTower/sourcekarts/effects/rev.wav"
)
SOUND_REFLECT = Sound("GModTower/sourcekarts/effects/reflect.wav"
)


SOUND_EXPLOSION = Sound("GModTower/sourcekarts/effects/powerups/explosion.wav"
)
SOUND_ROCKET = Sound("GModTower/sourcekarts/effects/powerups/launch.wav"
)
SOUND_SHOCK = Sound("GModTower/sourcekarts/effects/powerups/shock.wav"
)


SOUND_LASER = Sound("GModTower/sourcekarts/effects/powerups/laser.wav"
)
SOUND_LASERHIT = Sound("GModTower/sourcekarts/effects/powerups/laser_hit.wav"
)


SOUND_FLUX = Sound("GModTower/sourcekarts/effects/powerups/flux.wav"
)
SOUND_SLOWED = Sound("GModTower/sourcekarts/effects/powerups/slowed.wav"
)


SOUND_TELEPORT = Sound("GModTower/sourcekarts/effects/powerups/teleport.wav"
)


SOUND_BLOB = Sound("GModTower/sourcekarts/effects/powerups/blob.wav"
)
SOUND_BLOBTHROW = Sound("GModTower/sourcekarts/effects/powerups/blob_throw.wav"
)


SOUND_DISCO = "GModTower/sourcekarts/effects/powerups/disco" // 1-7 .mp3



SOUND_EXPLOSIONS = {

	Sound( "GModTower/zom/weapons/explode3.wav" ),

	Sound( "GModTower/zom/weapons/explode4.wav" ),

	Sound( "GModTower/zom/weapons/explode5.wav" )

}


function GM:GetTimeLeft()



	local timeLeft = ( self:GetTime() or 0 ) - CurTime()

	if timeLeft < 0 then timeLeft = 0 end



	return timeLeft



end



function GM:NoTimeLeft()

	return self:GetTimeLeft() <= 0

end



function GM:SetTime( time )

	if not time then return end

	MsgN( "[GMode] Setting time: " .. time )

	--GetWorldEntity():SetNWInt( "Time", CurTime() + time )

	SetGlobalInt("Time",CurTime() + time)
end


function GM:SetTotalStartTime()
	SetGlobalInt( "TotalStartTime", CurTime() )
end

function GM:GetTotalStartTime()

	return GetGlobalInt("LapStartTime")
end

function GM:GetTime()

	return GetGlobalInt("Time") --GetWorldEntity():GetNWInt( "Time" )

end

function GM:GetState()
	return GetGlobalInt("State",1) --GetWorldEntity():GetNWInt( "State", STATE_WAITING )
end

function GM:SetState( state )
	SetGlobalInt("State",state) --GetWorldEntity():SetNWInt( "State", state )
end

function GM:GetTimeElapsed( time )

	return math.max( CurTime() - ( time or self:GetTime() or 0 ), 0 )

end



function GM:GetRound()

	return GetGlobalInt("Round",1) --GetWorldEntity():GetNWInt("Round",1)

end



function GM:SetRound( round )

	SetGlobalInt("Round",round) --GetWorldEntity():SetNWInt("Round", round)

end



function GM:IncreaseRound()

	self:SetRound( self:GetRound() + 1 )

end



function GM:GetTrack()

	return GetGlobalInt("Track",1) --GetWorldEntity():GetNWInt("Track",1)

end



function GM:SetTrack( track )

	SetGlobalInt("Track",track) --GetWorldEntity():SetNWInt("Track", track)

	checkpoints.Load( track )

end



function GM:IncreaseTrack()

	self:SetTrack( self:GetTrack() + 1 )

end



function GM:GetTotalPlayers()

	return ( #team.GetPlayers( TEAM_PLAYING ) + #team.GetPlayers( TEAM_FINISHED ) )

end



function GM:GetAllPlayers()

	return table.Add( team.GetPlayers( TEAM_PLAYING ), team.GetPlayers( TEAM_FINISHED ) )

end


function GM:GetFinishedPlayers()

	return #team.GetPlayers( TEAM_FINISHED )
end


function GM:GetLeader()



	local players = player.GetAll()

	local leader = nil

	for _, ply in pairs( players ) do

		if ply:GetPosition() == 1 then

			return ply

		end

	end



end



function GM:IsBattle()

	return self:GetState() == STATE_BATTLE || self:GetState() == STATE_TOBATTLE || self:GetState() == STATE_NEXTBATTLE || self:GetState() == STATE_BATTLEENDING

end



function GM:ShouldCollide( ent1, ent2 )

	// These should never touch

	if ent1:IsPlayer() && ent2:IsPlayer() then

		return false

	end



	local ghost1 = IsValid( ent1:GetOwner() ) && ent1:GetOwner():IsGhost()

	local ghost2 = IsValid( ent2:GetOwner() ) && ent2:GetOwner():IsGhost()



	// Ghosts don't collide with projectiles

	if ( ghost1 && ent2.Base == "sk_item_base" ) || ( ghost2 && ent1.Base == "sk_item_base" ) then

		return false

	end



	// Ghosts don't collide with karts

	if ( ghost1 && ent2:GetClass() == "sk_kart" ) || ( ghost2 && ent1:GetClass() == "sk_kart" ) then

		return false

	end



	// Karts/Wheels don't collide with projectiles

	local item1 = ( ent1.Base == "sk_item_base" || ent1.Base == "sk_item_base_ground" || ent1.Base == "sk_item_base_homing" )

	local item2 = ( ent2.Base == "sk_item_base" || ent2.Base == "sk_item_base_ground" || ent2.Base == "sk_item_base_homing" )



	if ( ent1:GetClass() == "sk_kart" && item2 ) || ( ent2:GetClass() == "sk_kart" && item1 ) then

		return false

	end

	if ( ent1:GetClass() == "sk_wheel" && item2 ) || ( ent2:GetClass() == "sk_wheel" && item1 ) then

		return false

	end



	// Disable collision for non-battle

	if !GAMEMODE:IsBattle() then

		if ent1:GetClass() == "sk_kart" && ent2:GetClass() == "sk_kart" then

			return false

		end

	end


	if ent1:GetClass() == "sk_kart" && ent2:IsPlayer() then

		return false

	end



	// Wheels should never touch. That'd be gay.

	if (ent1:GetClass() == "sk_wheel" && ent2:GetClass() == "sk_wheel") || (ent1:GetClass() == "sk_kart" && ent2:GetClass() == "sk_wheel" ) || ( ent1:GetClass() == "sk_wheel" && ent2:GetClass() == "sk_kart") then

		return false

	end


	return true


end

function timetoint( min, sec )

	return min * 60 + sec

end

function numtobool( num )

	return num > 0

end



function booltonum( bool )

	if bool then return 1 end

	return 0

end

// MUSIC

MUSIC_WAITING = 1

MUSIC_RACE1 = 2

MUSIC_RACE2 = 3

MUSIC_RACE3 = 4

MUSIC_WIN = 5

MUSIC_LOSE = 6

MUSIC_BATTLE1 = 7

MUSIC_BATTLE2 = 8

MUSIC_CAMERA = 9

MUSIC_COUNTDOWN = 10

MUSIC_BATTLEINTRO = 11



music.DefaultVolume = .5

music.DefaultFolder = "GModTower/sourcekarts"



music.Register( MUSIC_WAITING, "music/waiting", { Num = 3 } )

music.Register( MUSIC_CAMERA, "music/race_reveal3" )

music.Register( MUSIC_COUNTDOWN, "effects/countdown", { Oneoff = true } )

music.Register( MUSIC_WIN, "music/race_win" )

music.Register( MUSIC_LOSE, "music/race_lose" )

music.Register( MUSIC_BATTLEINTRO, "music/battle_intro" )


if game.GetMap() == "gmt_sk_island02" then

	music.Register( MUSIC_RACE1, "music/island_race1", { Length = timetoint( 3, 50 ), Loops = true } )

	music.Register( MUSIC_RACE2, "music/island_race2", { Length = timetoint( 3, 34 ), Loops = true } )

	music.Register( MUSIC_RACE3, "music/island_race3", { Length = timetoint( 3, 41 ), Loops = true } )



	music.Register( MUSIC_BATTLE1, "music/island_battle1", { Length = timetoint( 1, 1 ), Loops = true } )

	music.Register( MUSIC_BATTLE2, "music/island_battle2", { Length = timetoint( 1, 3 ), Loops = true } )


elseif game.GetMap() == "gmt_sk_lifelessraceway01" then

	music.Register( MUSIC_RACE1, "music/raceway_race1", { Length = timetoint( 2, 12 ), Loops = true } )

	music.Register( MUSIC_RACE2, "music/raceway_race2", { Length = timetoint( 3, 49 ), Loops = true } )

	music.Register( MUSIC_RACE3, "music/raceway_race3", { Length = timetoint( 1, 53 ), Loops = true } )



	music.Register( MUSIC_BATTLE1, "music/raceway_battle1", { Length = timetoint( 1, 8 ), Loops = true } )

	music.Register( MUSIC_BATTLE2, "music/raceway_battle2", { Length = timetoint( 0, 52 ), Loops = true } )


elseif game.GetMap() == "gmt_sk_rave" then

	music.Register( MUSIC_RACE1, "music/rave_race1", { Length = timetoint( 3, 1 ), Loops = true } )

	music.Register( MUSIC_RACE2, "music/rave_race2", { Length = timetoint( 2, 26 ), Loops = true } )

	music.Register( MUSIC_RACE3, "music/rave_rave3", { Length = timetoint( 2, 54 ), Loops = true } )



	music.Register( MUSIC_BATTLE1, "music/rave_battle1", { Length = timetoint( 3, 39 ), Loops = true } )

	music.Register( MUSIC_BATTLE2, "music/rave_battle2", { Length = timetoint( 3, 23 ), Loops = true } )


end