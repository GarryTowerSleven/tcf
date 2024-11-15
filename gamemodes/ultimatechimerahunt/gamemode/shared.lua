GM.Name 	= "GMod Tower: Ultimate Chimera Hunt"
GM.Author 	= "Aska & Fluxmage/GMT Krew"

GM.AllowSpecialModels = false
GM.AllowChangeSize = false

GM.NumRounds = 15
GM.RoundTime = 2 * 60

DeriveGamemode( "gmtgamemode" )
SetupGMTGamemode( "Ultimate Chimera Hunt", "ultimatechimerahunt", {
	DrawHatsAlways = false, // Always draw hats
	AFKDelay = 60, // Seconds before they will be marked as AFK
	ChatBGColor = Color( 148, 19, 76, 180 ), -- Color of the chat gui
	ChatScrollColor = Color( 179, 29, 96, 215 ), -- Color of the chat scroll bar gui
} )

/* NETWORK VARS SETUP */
globalnet.Register( "Float", "RoundStart" )
globalnet.Register( "Entity", "UC" )

/* Ranks */
plynet.Register( "Int", "Rank", { default = 1 } )
plynet.Register( "Int", "NextRank", { default = 1 } )

/* Player States */
plynet.Register( "Bool", "IsChimera" )
plynet.Register( "Bool", "IsGhost" )
plynet.Register( "Bool", "IsFancy" )

/* Pigs */
plynet.Register( "Bool", "IsScared" )
plynet.Register( "Bool", "IsTaunting" )
plynet.Register( "Bool", "IsStunned" )
plynet.Register( "Bool", "IsPancake" )
plynet.Register( "Bool", "PressedButton" )
plynet.Register( "Bool", "KilledWithSaturn" )

/* Chimera */
plynet.Register( "Bool", "IsRoaring" )
plynet.Register( "Bool", "IsBiting" )
plynet.Register( "Bool", "FirstDoubleJump" )
plynet.Register( "Int", "DoubleJumpNum" )
plynet.Register( "Float", "SwipeMeter" )
plynet.Register( "Int", "TimesRoared" )
//plynet.Register( "Bool", "Stunned" )

/* Sprint */
plynet.Register( "Float", "Sprint" )
plynet.Register( "Bool", "IsSprinting" )
//plynet.Register( "Bool", "IsSwimming" )
plynet.Register( "Bool", "Flashlight" )

/* Animations */
plynet.Register( "Float", "PlaybackRate", { default = 1 } )
plynet.Register( "Bool", "PlaybackRateOver" )

/* Saturn */
plynet.Register( "Bool", "HasSaturn" )


/* WONDERFUL ARRAY OF INDEXES */

STATE_WAITING		= 1
STATE_PLAYING		= 2
STATE_INTERMISSION	= 3

TEAM_PIGS		= 1
TEAM_CHIMERA	= 2
TEAM_GHOST		= 3
TEAM_SALSA		= 4

RANK_ENSIGN		= 1
RANK_CAPTAIN	= 2
RANK_MAJOR		= 3
RANK_COLONEL	= 4

MSG_FIRSTJOIN = 1
MSG_WAITJOIN = 2
MSG_UCSELECT = 3
MSG_UCNOTIFY = 4
MSG_PIGNOTIFY = 5
MSG_PIGWIN = 6
MSG_UCWIN = 7
MSG_TIEGAME = 8
MSG_30SEC = 9
MSG_MRSATURN = 10
MSG_ANGRYUC = 11
MSG_MRSATURNDEAD = 12

MUSIC_WAITING = 1
MUSIC_ROUND = 2
MUSIC_ENDROUND = 3
MUSIC_SPAWN = 4
MUSIC_GHOST = 5
MUSIC_FGHOST = 6
MUSIC_30SEC = 7
MUSIC_MRSATURN = 8


/* MUSIC */

GM.Music = {
	[MUSIC_WAITING] = { "UCH/newmusic/waiting/waiting_music", 13 },
	[MUSIC_ROUND] = { "UCH/newmusic/round/round_music", 10 },
	[MUSIC_ENDROUND] = {

		Chimera =  {
			win 	= Sound( "UCH/newmusic/endround/chimera_win.mp3" ),
			lose 	= Sound( "UCH/newmusic/endround/chimera_lose.mp3" ),
		},

		Pigmask = {
			win 	= Sound( "UCH/newmusic/endround/pigs_win.mp3" ),
			lose 	= Sound( "UCH/newmusic/endround/pigs_lose.mp3" ),
		},

		Tie	= Sound( "UCH/newmusic/endround/gameend.mp3" ),
		Salsa = Sound( "UCH/newmusic/endround/salsa.mp3" ),

	},
	[MUSIC_SPAWN] = {

		Chimera = Sound( "UCH/newmusic/spawn/chimera_spawn.mp3" ),

		Pigmask = {

			ensign 	= Sound( "UCH/newmusic/spawn/ensign_spawn.wav" ),
			captain = Sound( "UCH/newmusic/spawn/captain_spawn.wav" ),
			major 	= Sound( "UCH/newmusic/spawn/major_spawn.wav" ),
			colonel = Sound( "UCH/newmusic/spawn/colonel_spawn.wav" ),

		},

	},
	[MUSIC_GHOST] = { "UCH/newmusic/ghost/ghost_music", 8 },
	[MUSIC_FGHOST] = { "UCH/newmusic/ghost/fancy/fancyghost_music", 5 },
	[MUSIC_30SEC] = Sound( "UCH/newmusic/round/round_30secsleft.mp3" ),
	[MUSIC_MRSATURN] = Sound( "UCH/saturn/saturn_win.wav" ),
}


/* TEAM SETUP */
team.SetUp( TEAM_PIGS, "Pigmasks", Color( 225, 150, 150, 255 ) )
team.SetUp( TEAM_CHIMERA, "Ultimate Chimera", Color( 230, 30, 110, 255 ) )
team.SetUp( TEAM_GHOST, "Ghosts", Color( 255, 255, 255, 255 ) )

team.SetSpawnPoint( TEAM_PIGS, { "info_player_start", "info_player_teamspawn" } )
team.SetSpawnPoint( TEAM_CHIMERA, { "chimera_spawn" } )
team.SetSpawnPoint( TEAM_GHOST, { "info_player_start", "info_player_teamspawn" } )


/* PLAYER VARIABLES */
GM.SprintRecharge = .0062
GM.SprintDrain = .01
GM.DJumpPenalty = .042


/* RANKS */

GM.Ranks = {
	[RANK_ENSIGN] = {
		Name = "Ensign",
		Color = Color( 250, 180, 180 ),
		SatColor = Color( 255, 255, 255 )
	},
	[RANK_CAPTAIN] = {
		Name = "Captain",
		Color = Color( 150, 200, 250 ),
		SatColor = Color( 153, 204, 255 )
	},
	[RANK_MAJOR] = {
		Name = "Major",
		Color = Color( 90, 200, 90 ),
		SatColor = Color( 115, 255, 115 )
	},
	[RANK_COLONEL] = {
		Name = "Colonel",
		Color = Color( 250, 250, 250 ),
		SatColor = Color( 225, 225, 225 )
	},
}

/* STATE/GAMEMODE LOGIC FUNCTIONS */

function GM:IsRoundOver()
	return self:GetState() == STATE_INTERMISSION
end

function GM:GetUC()
	return globalnet.GetNet( "UC" ) or NULL
end

/* Timer Functions */

function GM:AddTime( add )

	if !self:IsPlaying() then return end
	if self.Intense then return end

	local time = self:GetTimeLeft()

	time = math.Clamp( time + add, 0, 2.10 * 60 )
	
	self:SetTime( time )

	umsg.Start( "UpdateRoundTimer" )
		umsg.Long( add )
	umsg.End()

end


/* MISC SHARED FUNCTIONS */

function team.AlivePigs()

	local num = 0

	for k, v in ipairs( team.GetPlayers( TEAM_PIGS ) ) do

		if v:IsPig() && !v.IsDead then // just in case
			//Msg( tostring( v ), "\n" )
			num = num + 1
		end

	end

	return num

end

function GM:IsLastPigmasks()
	return #team.GetPlayers( TEAM_PIGS ) <= 3
end

function GM:UpdateHull( ply )

	if !IsValid( ply ) then return end

	if ply:GetNet( "IsChimera" ) then

		ply:SetHull( Vector(-25, -25, 0), Vector( 25, 25, 55 ) )
		ply:SetHullDuck( Vector(-25, -25, 0), Vector( 25, 25, 55 ) )

		ply:SetViewOffset( Vector( 0, 0, 68)  )
		ply:SetViewOffsetDucked( Vector( 0, 0, 68 ) )

	else

		ply:SetHull( Vector(-16, -16, 0), Vector( 16, 16, 55 ) )
		ply:SetHullDuck( Vector(-16, -16, 0), Vector( 16, 16, 40 ) )

		ply:SetViewOffset( Vector( 0, 0, 48 ) )
		ply:SetViewOffsetDucked( Vector( 0, 0, ( 48 * .75 ) ) )

		if ply:IsGhost() then

			ply:SetHull( Vector(-16, -16, 0 ), Vector( 16, 16, 55 ) )
			ply:SetHullDuck( Vector(-16, -16, 0 ), Vector( 16, 16, 55 ) )

			ply:SetViewOffset( Vector( 0, 0, 55 ) )
			ply:SetViewOffsetDucked( Vector( 0, 0, 55 ) )

		end

	end

end

function GM:ShouldCollide( ent1, ent2 )
	if (ent1:IsValid() && ent2:IsValid()) then
		if ((ent1:IsPlayer() && ent1:IsGhost()) || (ent2:IsPlayer() && ent2:IsGhost())) then
			return false;
		end
		
		if (ent1:IsPlayer() && ent2:IsPlayer() && ent1:Team() == ent2:Team()) then
			return false;
		end
		
		if (ent1:IsPlayer() && !ent1:GetNet("IsChimera") && ent2:GetClass() == "mr_saturn") then
			return false;
		end
	end
	
	return true;
end

if CLIENT then return end

function GM:PlayerCanHearPlayersVoice( ply1, ply2 )

	return ( ply1:Team() == ply2:Team() ) || 
			( ply1:GetNet( "IsChimera" ) && !ply2:IsGhost() ) || 
			( !ply1:IsGhost() && ply2:GetNet( "IsChimera" ) ) || 
			!self:IsPlaying()

end