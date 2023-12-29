include("shared.lua")
include("cl_hud.lua")
include("cl_hud_old.lua")
include("cl_hud_lobby2.lua")
include("cl_hudchat.lua")
include("cl_playermenu.lua")
include("cl_post_events.lua")
include("cl_scoreboard.lua")
include("milestones/uch_animations.lua")
include("milestones/virus_radar.lua")

// include( "minigames_new/cl_init.lua" )
include( "sh_events.lua" )

include("cl_tetris.lua")

EnableParticles = CreateClientConVar( "gmt_enableparticles", "1", true, false )

// Cursor for 3D2D stuff
Cursor2D = surface.GetTextureID( "cursor/cursor_default" )
CursorLock2D = surface.GetTextureID( "cursor/cursor_lock" )

hook.Add( "ShouldAutoScalePlayers", "AutoScalePlayers", function()
	return true
end )

local LastRain = 0
local Snow = {
	Vector(706.14721679688, 421.42169189453, 1091.9674072266),
	Vector(1170.7950439453, 855.70544433594, 1119.1126708984),
	Vector(741.64282226563, 1395.2475585938, 1134.5695800781),
	Vector(1121.4671630859, 1754.4324951172, 1051.3114013672),
	Vector(942.35095214844, -236.72450256348, 1235.5153808594)
}
local SnowVisible = {
	2, 3, 45, 10, 32, 31, 44, 51
}

hook.Add( "Think", "Weather", function()

	local type = IsChristmas && 2 || GetGlobalInt( "WeatherType", 0 )

	if type != 0 && LastRain < CurTime() then

		local effect = EffectData()

		if type == 1 then // Rain
			effect:SetFlags( 1 )
			util.Effect( "rain", effect )

			LastRain = CurTime() + 0.04
		elseif type == 2 then // Snow
			local loc = LocalPlayer():Location()

			if !loc then return end

			if table.HasValue(SnowVisible, loc) then
				for _, p in ipairs(Snow) do
					if p:DistToSqr( EyePos() ) > 3200000 then continue end

					p.x = math.random(700, 1400)
					effect:SetOrigin( p )
					effect:SetFlags( 2 )
					util.Effect( "rain", effect )
				end

				LastRain = CurTime() + 0.4
			elseif Location.IsSuite(loc) then
				local center = GTowerRooms:Get(Location.GetSuiteID(loc))
				

				for _, e in ipairs(ents.FindByClass("gmt_roomloc")) do
					if e:Location() == loc then
						local p = e:GetPos() + e:GetRight() * 428 + e:GetForward() * 128 + e:GetUp() * 256
						debugoverlay.Text(p, "HERE")
						effect:SetOrigin( p )
						effect:SetFlags( 3 )
						util.Effect( "rain", effect )
					end
				end

				LastRain = CurTime() + 0.2
			elseif loc >= 54 && loc <= 57 then
				effect:SetOrigin( EyePos() + Vector(0, 0, 512) )
				effect:SetFlags( 4 )
				util.Effect( "rain", effect )

				LastRain = CurTime() + 0.2
			end
		end
	end

end )

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

	if cl_viewbob:GetBool() && ply:Alive() && !ply:GetNWBool( "InLimbo" ) && not ( ply.ThirdPerson || ply.ViewingSelf ) then

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

	if bind == "+use" && pressed && !ply:GetNWBool( "InLimbo" ) then

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

hook.Add("PrePlayerDraw", "ThisIsHowFreelancersTalk", function(ply)
	local vol = ply:VoiceVolume() * 4
	local head = ply:LookupBone("ValveBiped.Bip01_Head1")

	if head then
		if vol < 0.04 then
			vol = vol * 4
		end

		local halo = string.find(ply:GetModel(), "spartan")
		ply.HeadBob = ply.HeadBob or 0
		ply.HeadBob = ply.HeadBob + FrameTime() * vol * 8
		ply.HeadLerp = ply.HeadLerp or 0
		ply.HeadLerp = math.Approach(ply.HeadLerp, vol, FrameTime() * (halo and 0.4 or 1))
		ply:ManipulateBoneAngles(head, Angle(0, !halo and ply.HeadLerp * 8 or math.sin(ply.HeadBob) * ply.HeadLerp * (halo and 32 or 8) or 0, 0))
	end
end)

function InitTree()

	Material("models/props/de_inferno/tree_large"):SetTexture("$basetexture", "models/gmod_tower/tree_winter")

end

hook.Add( "PreRender", "Tree", function()


	if !TreeWinter then

		InitTree()
		TreeWinter = true

	end

end )

local locations = {
	[21] = true,
	[60] = true
}

local pos, ang = Vector( -11199, 12540, 800 ), Angle( 0, -90, 0 )
local pos2 = Vector( 2166, -10221, 4152 )
local mat, rt, rendering

function GM:PostDraw2DSkyBox()

	if !locations[LocalPlayer():Location()] then return end
	if rendering then return end

	cam.Start2D()

	surface.SetMaterial( mat )
	surface.DrawTexturedRect( 0, 0, ScrW() * 2, ScrH() * 2 )

	cam.End2D()

	return true
end

function GM:RenderScene(eyepos, eyeang)

	if !locations[LocalPlayer():Location()] then return end
	if rendering then return end

	rendering = true

	local w, h = ScrW(), ScrH()
	rt = rt or GetRenderTarget( "Sky_" .. w, w, h )
	mat = CreateMaterial( rt:GetName() .. w, "UnlitGeneric", {["$basetexture"] = rt:GetName(), ["$model"] = 1, ["$ignorez"] = 1})


	render.PushRenderTarget(rt)

	local p = (eyepos - pos2)

	render.RenderView({
		w = w / 2, h = h / 2, origin = pos - ang:Forward() * p.x + ang:Right() * p.y + ang:Up() * p.z, angles = ang + eyeang + Angle( 0, 180, 0 ), bloomtone = true
	})

	render.PopRenderTarget()

	



	rendering = false


end