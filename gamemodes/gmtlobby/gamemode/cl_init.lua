
include("shared.lua")
include("cl_hud.lua")
include("cl_hudchat.lua")
include("cl_playermenu.lua")
include("cl_post_events.lua")
include("cl_scoreboard.lua")
include("milestones/uch_animations.lua")
include("milestones/virus_radar.lua")

-- Lobby 2 soundscape system
include("cl_soundscape.lua")
include("cl_soundscape_music.lua")
include("cl_soundscape_songlengths.lua")

include("cl_webboard.lua")

EnableParticles = CreateClientConVar( "gmt_enableparticles", "1", true, false )

// Cursor for 3D2D stuff
Cursor2D = surface.GetTextureID( "cursor/cursor_default" )
CursorLock2D = surface.GetTextureID( "cursor/cursor_lock" )

// ball orb support
hook.Add( "GShouldCalcView", "ShouldCalcVewBall", function( ply, pos, ang, fov )

	// if the ball race ball is set, we should override the pos and dist
	return IsValid( ply.BallRaceBall )

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

hook.Add( "KeyPress", "UsePlayerMenu", function( ply, key )
	if ( key == IN_USE ) then
		local ent = LocalPlayer():GetEyeTrace().Entity
		if IsValid(ent) and ent:IsPlayer() and ent:Alive() and (LocalPlayer():GetPos():Distance(ent:GetPos()) < 100) then
			PlayerMenu.Show(ent)
		end
	end
end )