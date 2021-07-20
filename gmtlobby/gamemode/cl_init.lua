
include("shared.lua")
include("cl_hud.lua")
include("cl_post_events.lua")
include("cl_scoreboard.lua")

include("cl_soundscape.lua")
include("cl_soundscape_music.lua")
include("cl_soundscape_songlengths.lua")

include("cl_playermenu.lua")

include("calcview.lua")
include("playerhook.lua")
include("tetris/cl_init.lua")
include("cl_webboard.lua")
include("cl_hudchat.lua")
include("cl_tetris.lua")
include("uch_anims.lua")

local tourmsgnotice = CreateClientConVar( "gmt_enabletournotice", "1", true, true )

EnableParticles = CreateClientConVar( "gmt_enableparticles", "1", true, false )
NoGMMsg 				= CreateClientConVar( "gmt_ignore_gamemode", "0", true, false )
NoPartyMsg 			= CreateClientConVar( "gmt_ignore_party", "0", true, false )

VoiceDistance 	= CreateClientConVar( "gmt_voice_distance", "1024", true, true )

//CondoSkyBox 		= CreateClientConVar( "gmt_condoskybox" , "1", true, true )
CondoDoorbell 	= CreateClientConVar( "gmt_condodoorbell" , "1", true, true )
CondoBackground = CreateClientConVar( "gmt_condobg" , "1", true, true )
//CondoBlinds 		= CreateClientConVar( "gmt_condoblinds" , "1", true, true )

GMTMCore 				= CreateClientConVar( "gmt_usemcore", "1", true, true )

// holy shit cosmetics
function GM:OverrideHatEntity(ply)

	if IsValid( ply ) && !ply:Alive() then
		return ply:GetRagdollEntity()
	end

	if IsValid( ply.BallRaceBall ) then
		return ply.BallRaceBall.PlayerModel
	end

	return ply
end

// ball orb support
hook.Add( "GShouldCalcView", "ShouldCalcVewBall", function( ply, pos, ang, fov )

	// if the ball race ball is set, we should override the pos and dist
	return IsValid( ply.BallRaceBall )

end )

hook.Add( "DrawDeathNotice", "DisableLobbyDeaths", function()

	return false

end )

hook.Add( "GCalcView", "CalcViewBall", function( ply, pos, dist )

	// we'll eventually want to support multiple cases, so that only one ent can override the position and distance
	if IsValid( ply.BallRaceBall ) then

		local pos2 = ply.BallRaceBall:GetPos() + Vector( 0, 0, 30 )
		local dist2 = dist + 50

		return pos2, dist2

	end

	// default values
	return pos, dist

end )

local WalkTimer = 0
local VelSmooth = 0
local cl_viewbob = CreateConVar( "gmt_viewbob", "0", { FCVAR_ARCHIVE } )

hook.Add("CalcView", "GMTViewBob", function( ply, origin, angle, fov)

	if cl_viewbob:GetBool() && ply:Alive() && not ( ply.ThirdPerson || ply.ViewingSelf ) then

		local vel = ply:GetVelocity()
		local ang = ply:EyeAngles()

		VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.075
		WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

		angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.01

		if ( ply:GetGroundEntity() != NULL ) then
			angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
			angle.pitch = angle.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
		end

	end

end )

hook.Add("HUDPaint", "PaintMapChanging", function()

	if !GetGlobalBool("ShowChangelevel") then return end

	local curClientTime = os.date("*t")
	local timeUntilChange = GetGlobalInt("NewTime") - CurTime()

	local timeUntilChangeFormatted = string.FormattedTime(timeUntilChange,"%02i:%02i")

	draw.RoundedBox(0, 0, 0, ScrW(), 40, Color(25,25,25,200))
	draw.SimpleText("RESTARTING FOR UPDATE IN: " .. timeUntilChangeFormatted, "GTowerHUDMainLarge", ScrW()/2, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

local BMusic = Sound("gmodtower/minigame/balloon2.mp3")
local CMusic = Sound("gmodtower/gourmetrace/music/30sec/30sec1.mp3")
local MMusic = Sound("gmodtower/music/christmas/narniaevent2.mp3")

net.Receive("MinigameMusic",function()
	local Start = net.ReadBool()
	local Game = net.ReadString()

	if Start then
		if Game == "chainsaw" then
			LocalPlayer().BMusic = CreateSound( LocalPlayer(), CMusic )
			LocalPlayer().BMusic:PlayEx( 1, 100 )
		elseif Game == "snowbattle" then
			LocalPlayer().BMusic = CreateSound( LocalPlayer(), MMusic )
			LocalPlayer().BMusic:PlayEx( 0.75, 100 )
		else
			LocalPlayer().BMusic = CreateSound( LocalPlayer(), BMusic )
			LocalPlayer().BMusic:PlayEx( 0.5, 100 )
		end
	else
		LocalPlayer().BMusic:FadeOut(1)
	end

end)

net.Receive("gmt_gamemodestart",function()
	if NoGMMsg:GetBool() then return end

	local Gmode = net.ReadString()
	local plys = net.ReadInt(32)
	local id = net.ReadInt(32)

	local NiceNames = {}
	NiceNames["ballrace"] = "Ball Race"
	NiceNames["minigolf"] = "Minigolf"
	NiceNames["pvpbattle"] = "PvP Battle"
	NiceNames["virus"] = "Virus"
	NiceNames["zombiemassacre"] = "Zombie Massacre"
	NiceNames["sourcekarts"] = "Source Karts"
	NiceNames["ultimatechimerahunt"] = "UCH"
	NiceNames["gourmetrace"] = "Gourmet Race"
	NiceNames["monotone"] = "Monotone"

	Gmode = NiceNames[Gmode] or Gmode

	local Question = Msg2( T( "GamemodeStarting", Gmode, plys ), 18 )
	Question:SetupQuestion(
		function() RunConsoleCommand( "gmt_mtsrv", 1, id ) end,
		function() end,
		function() end,
		nil,
		{120, 160, 120},
		{160, 120, 120}
	)

end)

net.Receive("AdminMessage",function()

	local ply = net.ReadEntity()
	local Text = net.ReadString()

	if ( IsValid(ply) && !ply:IsAdmin() ) then return end

	MsgI( "admin", Text )


end)

concommand.Add("gmt_tourmsg",function(ply)

	/*if tourmsgnotice:GetInt() == 0 then return end

	local tourmsg = Msg2('Welcome to GMod Tower: Classic, would you like to watch a quick tour?')
	tourmsg:SetupQuestion( function() RunConsoleCommand("gmt_starttour") end, function()
		 RunConsoleCommand("gmt_enabletournotice","0")
		 Msg2("Okay, we won't show you this again.")
	 end,
	 function() end )*/
end)

hook.Add( "KeyPress", "UsePlayerMenu", function( ply, key )
	if ( key == IN_USE ) then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:IsPlayer() and ent:Alive() and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 100) then
			PlayerMenu.Show(ent)
		end
	end
end )