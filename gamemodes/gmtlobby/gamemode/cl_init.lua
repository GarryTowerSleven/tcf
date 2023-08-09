
include("shared.lua")
include("cl_hud.lua")
include("cl_hudchat.lua")
include("cl_playermenu.lua")
include("cl_post_events.lua")
include("cl_scoreboard.lua")
include("event/cl_init.lua")
include("minigames/shared.lua")
include("milestones/uch_animations.lua")

include("cl_tetris.lua")

EnableParticles = CreateClientConVar( "gmt_enableparticles", "1", true, false )

// Cursor for 3D2D stuff
Cursor2D = surface.GetTextureID( "cursor/cursor_default" )
CursorLock2D = surface.GetTextureID( "cursor/cursor_lock" )

// ball orb support
hook.Add( "GShouldCalcView", "ShouldCalcVewBall", function( ply, pos, ang, fov )

	// if the ball race ball is set, we should override the pos and dist
	return IsValid( ply:GetBallRaceBall() )

end )

hook.Add( "GCalcView", "CalcViewBall", function( ply, pos, dist )

	// we'll eventually want to support multiple cases, so that only one ent can override the position and distance
	if IsValid( ply:GetBallRaceBall() ) then

		local pos2 = ply:GetBallRaceBall():GetPos() + Vector( 0, 0, 30 )
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

function GM:HUDWeaponPickedUp() return false end
function GM:HUDItemPickedUp() return false end
function GM:HUDAmmoPickedUp() return false end
function GM:DrawDeathNotice( x, y ) end

hook.Add( "PlayerBindPress", "PlayerGMTUse", function( ply, bind, pressed )

	if bind == "+use" && pressed then

		if !ply._NextUse || CurTime() > ply._NextUse then

			ply._NextUse = CurTime() + .25

			// Player Use Menu
			if PlayerMenu.PlayerMenuEnabled:GetBool() then
				if PlayerMenu.IsVisible() then
					PlayerMenu.Hide()
					return
				end
			end

			local ent = GAMEMODE:PlayerUseTrace( ply )
			ent = GAMEMODE:FindUseEntity( ply, ent )
			if IsValid( ent ) then

				// Player Use Menu
				if PlayerMenu.PlayerMenuEnabled:GetBool() then

					if ent:IsPlayer() then
						PlayerMenu.Show( ent )
						gui.SetMousePos( ScrW() / 2, ScrH() / 2 )
					end

				end

				if ent:GetClass() == "prop_physics_multiplayer" then
					ply._NextUse = CurTime() + 2
					GTowerItems:UseProp(ent)
				end

			end

		end

	end

end )

local ChangeLevelEnabled = CreateClientConVar( "gmt_changelevel_warn", 1, true, false )
hook.Add( "HUDPaint", "ChangeLevelUI", function()
	if !ChangeLevelEnabled:GetBool() || !GetGlobalBool("ShowChangelevel") then return end

	local time = GetGlobalInt("NewTime")
	if time <= 0 then return end

	local timeUntil = time-CurTime()

	local c = Color( 255,0,0,255 )

	c.a = math.Clamp( math.sin( math.fmod( RealTime() * .8, 1 ) * math.pi ) * 255, 50, 255 )

	local display
	if timeUntil < .5 then
		display = "RESTARTING..."
	else
		display = string.FormattedTime(timeUntil, "%02i:%02i")
	end
	draw.NiceText( "INCOMING MAP RESTART", "GTowerHUDMainSmall", ScrW()/2, (ScrH()/1.90), c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )
	draw.NiceText( display or "???", "GTowerHUDMainSmall", ScrW()/2, (ScrH()/1.90)+18, c, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )
end )

local skies = {
	lf = "",
	rt = "",
	up = "",
	dn = "",
	ft = "",
	bk = ""
}

local skybox = GetConVar("sv_skyname"):GetString()

SETUPSKY = true
function GM:PostDraw2DSkyBox()
	if SETUPSKY then
		for _, sky in pairs(skies) do
			skies[_] = Material("skybox/" .. skybox .. _)
		end

		SETUPSKY = false
	end

	render.SetColorMaterial()
	render.CullMode(MATERIAL_CULLMODE_CW)
	render.DrawSphere(EyePos(), 128, 4, 4, color_black)
	render.SetMaterial(skies["rt"])
	render.CullMode(MATERIAL_CULLMODE_CCW)
	cam.Start3D(EyePos(), EyeAngles())
	
	local s = 64
	local s2 = s / 2
	print(EyePos().z * -1 / 100)
	render.DrawQuadEasy( EyePos() + Vector(s2, 0, (((EyePos().z - 7000 )* -1) / 1000)), Vector(-1,0,0), s, s, Color(255,255,255), 180 )
	render.SetMaterial(skies["lf"])
	render.DrawQuadEasy( EyePos() - Vector(s2, 0, ((EyePos().z - 7000 ) / 1000)), Vector(1,0,0), s, s, Color(255,255,255), 180 )

	render.SetMaterial(skies["bk"])
	render.DrawQuadEasy( EyePos() + Vector(0, s2, (((EyePos().z - 7000 )* -1) / 1000)), Vector(0,-1,0), s, s, Color(255,255,255), 180 )
	render.SetMaterial(skies["ft"])
	render.DrawQuadEasy( EyePos() - Vector(0, s2, ((EyePos().z - 7000 ) / 1000)), Vector(0,1,0), s, s, Color(255,255,255), 180 )

	render.SetMaterial(skies["dn"])
	render.DrawQuadEasy( EyePos() - Vector(0, 0, (EyePos().z + 24500) / 1000), Vector(0,0,1), s, s, Color(255,255,255), 0 )
	render.SetMaterial(skies["up"])
	render.DrawQuadEasy( EyePos() + Vector(0, 0, ((EyePos().z - 38950) * -1) / 1000), Vector(0,0,-1), s, s, Color(255,255,255), 0 )
	render.CullMode(MATERIAL_CULLMODE_CCW)
	cam.End3D()
	return true
end

/*hook.Add("HUDPaint", "PaintMapChanging", function()
	if !GetGlobalBool("ShowChangelevel") then return end

	local curClientTime = os.date("*t")
	local timeUntilChange = GetGlobalInt("NewTime") - CurTime()

	local timeUntilChangeFormatted = string.FormattedTime(timeUntilChange,"%02i:%02i")

	draw.RoundedBox(0, 0, 0, ScrW(), 40, Color(25,25,25,200))
	draw.SimpleText("RESTARTING FOR UPDATE IN: " .. timeUntilChangeFormatted, "GTowerHUDMainLarge", ScrW()/2, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)*/

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

hook.Add( "KeyPress", "UsePlayerMenu", function( ply, key )
	if ( key == IN_USE ) then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:IsPlayer() and ent:Alive() and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 100) then
			PlayerMenu.Show(ent)
		end
	end
end )