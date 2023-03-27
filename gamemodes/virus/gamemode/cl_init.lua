include( "shared.lua" )
include( "sh_player.lua" )

include( "cl_deathnotice.lua" )
include( "cl_hud.lua" )
include( "cl_post_events.lua" )
include( "cl_hudmessage.lua" )
include( "cl_radar.lua" )

GM.DamageFade = 255
GM.NextFadeThink = 0

hook.Add( "ShouldHideHats", "ShouldHideHats", function( ply ) 

	if GAMEMODE:GetState() != STATE_WAITING && ply == LocalPlayer() && !ply:GetNet( "IsVirus" ) then
		return true
	end

end )

hook.Add( "OverrideHatEntity", "OverrideForRagdoll", function( ply ) 

	if IsValid( ply ) and ( ply.Alive and !ply:Alive() ) then
		return ply:GetRagdollEntity()
	end

end )

function GM:Initialize()

	self.DamageFade = 0
	self.NextFadeThink = 0

end

function GM:InitPostEntity()
	timer.Simple( 1, function()
		if ( self:GetState() == STATE_WAITING ) then
			LocalPlayer().IsThirdPerson = true
		end
	end )
	
end

local TimeLeftUsed = {}

function GM:Think()

	for _, v in pairs( player.GetAll() ) do

		if v:GetNet( "IsVirus" ) then
			self:LightThink( v )
			self:ClickerThink( v )
		end

		/*local Flame = v:GetNetworkedEntity("Flame1")
		local Flame2 = v:GetNetworkedEntity("Flame2")
		
		if IsValid( Flame ) && IsValid( Flame2 ) then
			
			local Torso = v:LookupBone( "ValveBiped.Bip01_Spine2" ) 
			local pos, ang = v:GetBonePosition( Torso )
			
			Flame:SetPos( pos )
			Flame2:SetPos( pos )
			
		end*/
		
	end
	
	if ( CurTime() >= self.NextFadeThink ) then
	
		self.DamageFade = self.DamageFade - 1
		
		if self.DamageFade < 0 then
			self.DamageFade = 0
		end
		
		self.NextFadeThink = CurTime() + .01
		
	end
	
	if ( self:GetState() != STATE_PLAYING ) then return end
	
	local endTime = self:GetTime()
	local timeLeft = endTime - CurTime() - 1 // adjusting for hud message sliding
	
	if ( timeLeft <= 0 ) then
		timeLeft = 0
	end
	
	timeLeft = math.Round( timeLeft )
	
	if ( TimeLeftUsed[ timeLeft ] ) != nil then return end
	
	if ( timeLeft == 15 ) then
		
		HudMessage( HudMessages[ 5 /* 15 seconds remaining! */ ], 5, nil, true )
		
		LocalPlayer():EmitSound( "GModTower/virus/ui/navigate.wav", 300, 100 )
		
		TimeLeftUsed[ timeLeft ] = timeLeft
		
	elseif ( timeLeft <= 5 && timeLeft > 0 ) then
		
		local msgIndex = 6 + (5 - timeLeft)
		HudMessage( HudMessages[ msgIndex ], 0.7, "CountDown", true )
		
		local pitch = 100
		if ( timeLeft == 1 ) then
			pitch = 150
		end
		
		LocalPlayer():EmitSound( "GModTower/virus/ui/navigate2.wav", 300, pitch )
		
		TimeLeftUsed[ timeLeft ] = timeLeft
		
	end

end

function GM:ClickerThink( ply )

	if self:GetState() != STATE_PLAYING then return end

	for _, v in pairs( player.GetAll() ) do

		--if v == ply || !v:Alive() || !v:GetNet( "IsVirus" ) then return end
		if ( v:Team() == ply:Team() ) || !v:Alive() then return end

		local dist = ply:GetPos():Distance( v:GetPos() )
		//ply:ChatPrint( tostring(v) .. "| Dist: " .. tostring(dist) )

		local rad = 950  //start kicking in they're fucking close
		local scale_mod = 0.5

		if dist < rad then
			if dist < ( rad / 2 ) then
				scale_mod = 0.15  //freak the hug out
			end

			local scale = ( dist / rad ) * scale_mod
			//ply:ChatPrint( tostring(v) .. "| Scale: " .. tostring(scale) )

			if ( ply.NextRadSound or 0 ) < CurTime() then

				if scale < 0.015 then
					scale = 0.015
				end

				ply.NextRadSound = CurTime() + scale

				local ran = math.random( 1, 2 )
				if ran == 1 then
					ply:EmitSound( "Geiger.BeepLow", 50, math.random( 90, 110 ) )
				else
					ply:EmitSound( "Geiger.BeepHigh", 50, math.random( 90, 110 ) )
				end

			end

		end

	end

end

function GM:LightThink( ply )

	if !ply:Alive() then return end
	
	local dlight = DynamicLight( ply:EntIndex() )
	if ( dlight ) then
		dlight.Pos = ply:GetPos() + Vector( 0, 0, 40 )
		dlight.r = 150
		dlight.g = 255
		dlight.b = 150
		dlight.Brightness = 1
		dlight.Decay = 768
		dlight.Size = 192
		dlight.DieTime = CurTime() + 1
	end
	
end

function GM:PlayerBindPress( ply, bind, pressed )

	if ( bind == "+jump" || bind == "+duck" ) then return true end
	
	if ( bind == "+menu" && pressed ) then
		LocalPlayer():ConCommand( "lastinv" )
		return true
	end
	
	if ( bind == "+menu_context" && pressed ) then
		LocalPlayer():ConCommand( "use_adrenaline" )
		return true
	end	

	return false

end

local WalkTimer = 0
local VelSmooth = 0
local CurViewPunch = Angle(0,0,0)
local infecttime

function GM:CalcView( ply, pos, ang, fov )

	if self:GetState() == STATE_WAITING && LocalPlayer().WaitMessageSeen == nil then

		LocalPlayer().WaitMessageSeen = true

		timer.Simple( 2, function()
			if LocalPlayer() == player.GetAll()[1] then
				HudMessage( HudMessages[ 14 /* first to join waiting */ ], 5, nil, true )
			else
				HudMessage( HudMessages[ 15 /* waiting for additional players */ ], 5, nil, true )
			end
		end )

	end

	if ( ply:GetNet( "IsVirus" ) || self:GetState() == STATE_WAITING ) then

		local dist = 150
		local ent = ply

		if !infecttime or infecttime > CurTime() then
			infecttime = infecttime or CurTime() + 1
			local l = infecttime - CurTime()
			l = l / 1
			l = math.max(l, 0)
			l = 1 - l
			l = math.ease.OutCubic(l)
			dist = dist * l
		end

		// Follow rag when dying
		if !ply:Alive() then
			if IsValid( ply:GetRagdollEntity() ) then
				ent = ply:GetRagdollEntity()
			end
	 	end

		local center = ent:GetPos() + Vector( 0, 0, 75 )
		local filters = player.GetAll()

		// Check for intersections
		local tr = util.TraceLine( { start = center, 
									 endpos = center + ( ang:Forward() * -dist * 0.95 ),
									 filter = filters } )
		if tr.Fraction < 1 then
			dist = dist * ( tr.Fraction * 0.95 )
		end

		// Check for walls
		local trWall = util.TraceHull( { start = center,
									 endpos = center + ( ang:Forward() * -dist * 0.95 ),
									 mins= Vector( -8, -8, -8 ), maxs = Vector( 8, 8, 8 ),
									 filter = filters } )
		if trWall.Fraction < 1 then
			dist = dist * ( trWall.Fraction * 0.95 )
		end

		// Final position
		local finalPos = center + ( ang:Forward() * -dist * 0.95 )

		return {
			["origin"] = finalPos,
			["angles"] = Angle(ang.p + 2, ang.y, ang.r)
		}

	else

		infecttime = nil

	end
	
	local rag = ply:GetRagdollEntity()

	if IsValid( rag ) then 
		local att = rag:GetAttachment( rag:LookupAttachment("eyes") ) 
 		return self.BaseClass:CalcView( ply, att.Pos, att.Ang, fov ) 
 	end 

	if !ply:Alive() then return end

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()

	VelSmooth = VelSmooth * 0.9 + vel:Length() * 0.075
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.05

	ang.roll = ang.roll + ang:Right():DotProduct( vel ) * 0.01

	if ( ply:GetGroundEntity() != NULL ) then	
		ang.roll = ang.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		ang.pitch = ang.pitch + math.sin( WalkTimer * 0.5 ) * VelSmooth * 0.001
	end

	if ply.ViewPunchAngle then
		if CurViewPunch == ply.ViewPunchAngle then
			ply.ViewPunchAngle = Angle( 0,0,0 )
		end

		CurViewPunch.p = math.Approach( CurViewPunch.p, ply.ViewPunchAngle.p, FrameTime() * 5 )
		CurViewPunch.r = math.Approach( CurViewPunch.r, ply.ViewPunchAngle.r, FrameTime() * 5 )
		CurViewPunch.y = math.Approach( CurViewPunch.y, ply.ViewPunchAngle.y, FrameTime() * 5 )
		ang = ang + CurViewPunch
	end

	return self.BaseClass:CalcView( ply, pos, ang, fov )

end

hook.Add( "ShouldDrawLocalPlayer", "ThirdDrawLocal", function()

	return LocalPlayer():GetNet( "IsVirus" ) || GAMEMODE:GetState() == STATE_WAITING

end )

local function ClientStartRound( len, ply )
	TimeLeftUsed = {}

	GAMEMODE.WinningTeam = nil
	
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	RunConsoleCommand( "gmt_showscores" )
	RunConsoleCommand( "r_cleardecals" )

	LocalPlayer().IsThirdPerson = false
	LocalPlayer():GetNet( "IsVirus", false )
end

local function ClientEndRound( len, ply )

	local virusWins = net.ReadBool()
	
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	RunConsoleCommand( "gmt_showscores", 1 )
	
	LocalPlayer():EmitSound( "GModTower/virus/ui/menu.wav", 300, 100 )
	
	GAMEMODE.WinningTeam = virusWins and TEAM_INFECTED or TEAM_PLAYERS
	
	GetWorldEntity().Started = false
	
end

local function ClientInfected( len, ply )

	local virusEnt = net.ReadEntity()
	local infector = net.ReadEntity()
	
	if ( !IsValid( LocalPlayer() ) ) then return end
	
	if ( !GetWorldEntity().Started ) then
		GetWorldEntity().Started = true
	end

	if ( infector != GetWorldEntity() ) then // world entity
		if ( virusEnt == LocalPlayer() ) then
			LocalPlayer().IsThirdPerson = true
		end

		infector:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_RANGE_ZOMBIE, true )
	end
	
	virusEnt:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_TAUNT_ZOMBIE, true )
end

local function ClientDmgTaken( len, ply )

	// starting the health bar fade at 350 so it stays at full opacity for a bit 
	GAMEMODE.DamageFade = 350

end

// this is to make sure when you spawn the sonic shotgun blue charge is undone
local function ClientSpawn( len, ply )

	if !IsValid( LocalPlayer() ) then return end
	
	local viewModel = LocalPlayer():GetViewModel()
	if !IsValid( viewModel ) then return end
	
	viewModel:SetColor( Color( 255, 255, 255, 255 ) )
	
end

net.Receive( "StartRound", ClientStartRound )
net.Receive( "EndRound", ClientEndRound )
net.Receive( "Infect", ClientInfected )
net.Receive( "DmgTaken", ClientDmgTaken )
net.Receive( "Spawn", ClientSpawn )

local screams = {
	{
		"sound/npc/zombie/moan_loop1.wav",
		4
	},
	{
		"sound/npc/zombie/moan_loop2.wav",
		5.48
	},
	{
		"sound/npc/zombie/moan_loop4.wav",
		2.1
	}
}

function p(s, e)
    local p2 = math.Rand(1.02, 1.12)
    s:SetPlaybackRate(p2)
    s:SetVolume(0.85)

	hook.Add("Think", s, function()
		if !IsValid(e) then return end
		s:SetPos(e:GetPos())
	end)

    timer.Simple(2.6 / p2, function()
		hook.Remove("Think", s)
		if !IsValid(s) then return end
        s:Stop()
    end)
end

net.Receive( "Scream", function()
	local ply = net.ReadEntity()
	local scream = screams[math.random(#screams)]

	sound.PlayFile(scream[1], "3d noblock", function(s)
		s:SetPos(ply:GetPos())
		s:SetTime(scream[2])
		s:Set3DFadeDistance(600, 10000) -- Currently doesn't go as far as I'd like it to
		p(s, ply)
	end)

end)

function HudMessage( msg, seconds, font, ignoreY, color )
	
	local VguiMsg = vgui.Create( "virus_HudMessage")
	
	VguiMsg:SetText( msg, font, color )
	VguiMsg.StayTime = seconds
	VguiMsg.IgnoreY = ignoreY or false
	VguiMsg:SetVisible( true )
	
	Msg( msg .. "\n")

end

/*hook.Add( "Think", "FlameThink", function()
	for _, v in ipairs( player.GetAll() ) do
		
	end
end )*/

// WIP flames
/*function FlamesPlayer( len, ply )
	local ply = net.ReadEntity()

	if ( !IsValid( ply ) ) then return end

	local on = net.ReadBool() or false

	print( "meow", ply )

	if ( not ply._Flames or not IsValid( ply._Flames ) ) then
		print( "Creating flames for " .. ply:Name() )
		ply._Flames = CreateParticleSystem( ply, "jb_burningplayer_green", PATTACH_ABSORIGIN_FOLLOW, 1, nil )
	end

	if ( on ) then
		ply._Flames:StartEmission()
	else
		ply._Flames:StopEmission()
	end
end

net.Receive( "IgnitePlayer", FlamesPlayer )*/