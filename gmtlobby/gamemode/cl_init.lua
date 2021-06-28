include("shared.lua")
include("cl_hud.lua")
include("cl_hwhud.lua")
include("cl_post_events.lua")
include("cl_scoreboard.lua")
include("cl_gamemode.lua")
--include("cl_soundscapes.lua")

include("cl_soundscape.lua")
include("cl_soundscape_music.lua")
include("cl_soundscape_songlengths.lua")

include("calcview.lua")
include("playerhook.lua")
include("minigames/shared.lua")
include("tetris/cl_init.lua")
include("cl_webboard.lua")
include("cl_hudchat.lua")
include("cl_tetris.lua")
include("uch_anims.lua")
include("event/cl_init.lua")

local tourmsgnotice = CreateClientConVar( "gmt_enabletournotice", "1", true, true )

EnableParticles = CreateClientConVar( "gmt_enableparticles", "1", true, false )
NoGMMsg 				= CreateClientConVar( "gmt_ignore_gamemode", "0", true, false )
NoPartyMsg 			= CreateClientConVar( "gmt_ignore_party", "0", true, false )

VoiceDistance 	= CreateClientConVar( "gmt_voice_distance", "1024", true, true )

CondoSkyBox 		= CreateClientConVar( "gmt_condoskybox" , "1", true, true )
CondoDoorbell 	= CreateClientConVar( "gmt_condodoorbell" , "1", true, true )
CondoBackground = CreateClientConVar( "gmt_condobg" , "1", true, true )
CondoBlinds 		= CreateClientConVar( "gmt_condoblinds" , "1", true, true )

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

surface.CreateFont( "ChangelogItem", { font = "Oswald", size = 24, weight = 400 } )

local progress
local CurPage
local SwipeOffset = Vector( 0, 0, 0 )
local SwipeOffsetNum = 0
local CanSwipe = false
local NewPageArriving = false

local HasRequestedChangelog = false

local Changelog /*= {
	["Date"] = "August 11th, 2019",
	[1] = {
		"Lobby",
		"Testing item 1",
		"More testing items.",
		"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
		"Yes hello.",
	},
	[2] = {
		"Ballrace",
		"Balls roll now.",
		"Removed bananas.",
		"Added bananas back",
	},
}*/

function GetChangelog()
    http.Fetch( "https://www.gmodtower.org/apps/changelog.json",
    function( body, len, headers, code )
        Changelog = util.JSONToTable(body)
    end,
    function( error )
			timer.Simple(30,function()
				GetChangelog()
			end)
    end
    )
end

local mat = Material( "gmod_tower/nightclub/bar_gradient" )
local mat2 = Material( "gmod_tower/nightclub/panel_mountains" )

local pos = Vector( 7511, 172.5, -967 )
local ang = Angle( 180, 90, -90 )
local scale = 1

hook.Add( "PostDrawOpaqueRenderables", "ChangeLog", function()

	if !Changelog && !HasRequestedChangelog then
		HasRequestedChangelog = true
		GetChangelog()
	end

	if !LocalPlayer():GetPos():WithinDistance(pos, 2500) then return end

	local wave = math.sin( CurTime() * 2 ) * 16

	local x,y = 515, 125

	cam.Start3D2D( pos, ang, scale )

		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

		surface.SetMaterial(mat)
		surface.DrawTexturedRect(0, 0, x, y)

		surface.SetDrawColor( Color( 255, 255, 255, 125  ) )

		surface.SetMaterial(mat2)
		surface.DrawTexturedRect(0, 0, x, y)

		surface.SetDrawColor( Color(25,25,25,125 + wave) )
		surface.DrawRect(0, 0, x, y)

	cam.End3D2D()

	local pos = Vector( "7511 122.5 -967" )
	local scale = 0.25

	cam.Start3D2D( pos, ang, scale )

		// Title
		-----------------
		draw.DrawText("GMTower: Deluxe Changelog",
		"GTowerSkyMsgSmall",
		-125,
		0,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_LEFT)

		// Date
		-----------------
		local date
		if Changelog then date = Changelog["date"] else date = "Unknown" end
		draw.DrawText(date,
		"GTowerSkyMsgSmall",
		1100,
		0,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_RIGHT)

	cam.End3D2D()

	if !Changelog then
		cam.Start3D2D( pos, ang, 0.2 )
			draw.DrawText("The changelog is currently unavailable...",
			"GTowerSkyMsg",
			625,
			200,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER)
			cam.End3D2D()
		return
	end

	cam.Start3D2D( pos + SwipeOffset, ang, scale )

		// Backdrop
		-----------------
		surface.SetDrawColor( Color( 25, 25, 25, 125 ) )
		surface.DrawRect( -125, 70, 1225, 350 )

		// Progress bar
		-----------------
		surface.SetDrawColor( Color( 25, 25, 25, 200 ) )
		surface.DrawRect( -125, 70 + 350, 1225, 15 )

		surface.SetDrawColor( Color( 225, 225, 225, 200 ) )

		if !progress then progress = 0 end

		if !CurPage then CurPage = 1 end

		// Progress bar is full
		if progress > 1225 then
			// NEXT PAGE

			// Increases the swipe offset
			SwipeOffsetNum = SwipeOffsetNum - FrameTime() * 120

			// Panel is outside screen, teleport it back
			if SwipeOffsetNum < -350 then
				CanSwipe = true
				SwipeOffsetNum = SwipeOffsetNum + 700

				// Change page, end of pages? Loop back.
				if CurPage != #Changelog then CurPage = CurPage + 1 else CurPage = 1 end
				NewPageArriving = true
			end

			// Back to normal state after done swiping.
			if CanSwipe && SwipeOffsetNum < 0 then
				CanSwipe = false
				progress = 0
				NewPageArriving = false
			end

			SwipeOffset.y = SwipeOffsetNum

		elseif #Changelog > 1 then
			progress = progress + FrameTime() * 15
		end

		if !NewPageArriving then
			surface.DrawRect( -125, 70 + 350, progress, 15 )
		end

		// Title
		-----------------
		surface.SetTextColor( Color( 255, 255, 255, 255 ) )
		surface.SetFont("GTowerSkyMsgSmall")
		surface.SetTextPos(-100, 75)

		surface.DrawText( Changelog[ CurPage ][1] )

		// Items
		-----------------

		local str = ""

		for k,v in pairs( Changelog ) do

			if k != CurPage then continue end

			for num, item in pairs( v ) do
				if num == 1 then continue end

				// Adds newline every so many characters
				item = (item):gsub(("."):rep(175),"%1\n")

				str = str .. "• " .. item .. "\n"
			end
		end

		draw.DrawText(str,
		"ChangelogItem",
		-100, 145,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_LEFT)

		draw.DrawText( tostring( CurPage ) .. "/" .. tostring( #Changelog ) ,
		"GTowerSkyMsgSmall",
		1075, 355,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_RIGHT)

	cam.End3D2D()

end )

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

//Halloween map only
local function RemoveAllFogs()
	Msg("REMOVING ALL FOG!\n")
	for _, v in pairs( ents.FindByClass("func_smokevolume") ) do
		v:Remove()
	end
end

local allowfog = cookie.GetNumber("gmtallowfog", 0 )

hook.Add("OnEntityCreated", "GMTRemoveFog", function( ent )
	if IsValid(ent) && allowfog > 0 && ent:GetClass() == "func_smokevolume" then
		timer.Simple(3.0, RemoveAllFogs )
	end
end )

hook.Add("InitPostEntity", "GMTRemoveFog", function()
	timer.Simple(5.0, function()
		if allowfog > 0 then
			Msg("Start: REMOVING ALL FOG!\n")
			RemoveAllFogs()
		end
	end )
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

	local Question = Msg2( Gmode .. " is about to begin with " .. plys .. " players, join?" )
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

concommand.Add("gmt_removefog", function( ply, cmd, args )

	if !args[1] then
		Msg("Usage: gmt_removefog <1/0>\n")
		return
	end

	local val = tonumber( args[1] ) or 0
	cookie.Set("gmtallowfog", val )

	if val > 0 then
		Msg2("All fog entites have been removed.")
		timer.Simple(0, RemoveAllFogs )
	else
		Msg2("Fog entities will not be removed next time you join the server.")
	end

end )

hook.Add( "KeyPress", "UsePlayerMenu", function( ply, key )
	if ( key == IN_USE ) then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:IsPlayer() and ent:Alive() and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 100) then
			PlayerMenu.Show(ent)
		end
	end
end )

/*hook.Add( "PostDrawTranslucentRenderables", "CurveDebug", function(b, sky)
	if STORED_CURVES && !sky then

		for curveName, curve in pairs( STORED_CURVES ) do

			for num, point in pairs( curve.Points ) do

				if LocalPlayer():GetPos():Distance(point.Pos) > 3000 then continue end

				render.SetColorMaterialIgnoreZ()

				// Forward
				render.DrawBeam( point.Pos, point.Pos + point.Angle:Forward() * 50, 4, 0, 0, Color(0,255,0,255) )

				// Pre Magnitude
				render.DrawBeam( point.Pos, point.Pos + point.Angle:Forward() * -point.PreMagnitude, 2, 0, 0, Color(255,255,0,255) )

				// Post Magnitude
				render.DrawBeam( point.Pos, point.Pos + point.Angle:Forward() * point.PostMagnitude, 2, 0, 0, Color(255,255,0,255) )

				// Origin
				render.DrawSphere( point.Pos, 16, 24, 24, Color(255,0,0,255) )

				local camAng = LocalPlayer():EyeAngles()
				camAng:RotateAroundAxis( LocalPlayer():GetForward(), 90)
				camAng:RotateAroundAxis( LocalPlayer():GetUp(), -90)
				cam.Start3D2D( point.Pos + Vector(0,0,150), camAng, .5 )
					draw.DrawText(num,"GTowerSkyMsg",0,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
					draw.DrawText(tostring(point.Angle),"GTowerSkyMsgSmall",0,-30,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)

					if point.Speed then
						draw.DrawText("SPEED: " .. point.Speed,"GTowerSkyMsgSmall",0,-80,Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER)
					end

				cam.End3D2D()

			end

		end

	end
end)*/
