if SERVER then
	AddCSLuaFile("halloween/cl_effect_vhs.lua")
	AddCSLuaFile("halloween/cl_tracker.lua")
else
	include("halloween/cl_effect_vhs.lua")
	include("halloween/cl_tracker.lua")
end

module("halloween2014", package.seeall )


--game.AddDecal( "BloodyFootstepLeft", "decals/bloody_footstep_left" )
--game.AddDecal( "BloodyFootstepRight", "decals/bloody_footstep_right" )

DelayBetweenEvents = 60 * 15
CenterPos = Vector( 7795, 2, -543-64 )
ConnectionPos = Vector( 7062, 0, -332 )

FootstepsLeft = {
	{ pos = Vector( 592.213806, -2002.303833, 6.268330 ), ang = Angle( 0, 131.946, 0 ) },
	{ pos = Vector( 541.507263, -1947.046631, 1.031250 ), ang = Angle( 0, 131.946, 0 ) },
	{ pos = Vector( 485.667053, -1884.684937, 1.031250 ), ang = Angle( 0, 131.401, 0 ) },
	{ pos = Vector( 427.160461, -1818.323853, 1.031250 ), ang = Angle( 0, 131.401, 0 ) },
	{ pos = Vector( 338.945923, -1721.356812, 1.031250 ), ang = Angle( 0, 132.765, 0 ) },
	{ pos = Vector( 247.476334, -1628.375977, 1.031250 ), ang = Angle( 0, 139.039, 0 ) },
	{ pos = Vector( 142.263397, -1545.052368, 1.031250 ), ang = Angle( 0, 145.859, 0 ) },
	{ pos = Vector( 24.683216, -1484.245972, 1.031250 ), ang = Angle( 0, 157.044, 0 ) },
	{ pos = Vector( -84.944054, -1452.597534, 1.031250 ), ang = Angle( 0, 171.367, 0 ) },
	{ pos = Vector( -195.107666, -1443.303345, 1.031250 ), ang = Angle( 0, 175.731, 0 ) },
	{ pos = Vector( -313.882660, -1430.444336, 1.031250 ), ang = Angle( 0, 170.139, 0 ) },
	{ pos = Vector( -419.081024, -1393.996216, 1.031250 ), ang = Angle( 0, 139.449, 0 ) },
	{ pos = Vector( -414.598755, -1306.407837, 33.031250 ), ang = Angle( 0, 87.480, 0 ) },
	{ pos = Vector( -414.667023, -1247.720825, 33.031250 ), ang = Angle( 0, 90.208, 0 ) },
}
FootstepsRight = {
	{ pos = Vector( 546.095459, -1986.017090, 1.031250 ), ang = Angle( 0, 134.675, 0 ) },
	{ pos = Vector( 493.337006, -1932.808594, 1.031250 ), ang = Angle( 0, 133.856, 0 ) },
	{ pos = Vector( 434.729980, -1870.722412, 1.031250 ), ang = Angle( 0, 133.311, 0 ) },
	{ pos = Vector( 370.327026, -1801.428101, 1.031250 ), ang = Angle( 0, 132.356, 0 ) },
	{ pos = Vector( 281.915680, -1704.454712, 1.031250 ), ang = Angle( 0, 132.356, 0 ) },
	{ pos = Vector( 205.642960, -1624.722534, 1.031250 ), ang = Angle( 0, 138.085, 0 ) },
	{ pos = Vector( 104.936264, -1549.539063, 1.031250 ), ang = Angle( 0, 149.543, 0 ) },
	{ pos = Vector( 2.321885, -1501.065430, 1.031250 ), ang = Angle( 0, 162.773, 0 ) },
	{ pos = Vector( -114.521149, -1475.844116, 1.031250 ), ang = Angle( 0, 169.730, 0 ) },
	{ pos = Vector( -235.590729, -1461.673218, 1.031250 ), ang = Angle( 0, 173.413, 0 ) },
	{ pos = Vector( -364.752899, -1445.015259, 1.031250 ), ang = Angle( 0, 143.064, 0 ) },
	{ pos = Vector( -458.849548, -1373.268066, 1.031250 ), ang = Angle( 0, 86.117, 0 ) },
	{ pos = Vector( -434.759552, -1265.494629, 33.031250 ), ang = Angle( 0, 87.890, 0 ) },
	{ pos = Vector( -433.355865, -1199.005005, 33.031250 ), ang = Angle( 0, 90.345, 0 ) },
}

function Initialize()

	if CLIENT then return end

	timer.Simple( DelayBetweenEvents, function() EventLeadIn() end )

	local ent = ents.Create( "gmt_halloween2014_center" )
	ent:SetPos( CenterPos )
	ent:Spawn()

	local ent = ents.Create( "gmt_halloween2014_connection" )
	ent:SetPos( ConnectionPos )
	ent:SetAngles( Angle( 0, 0, 0 ) )
	ent:Spawn()

	local ent = ents.Create( "ghost_ghost" )
	ent:SetPos( CenterPos )
	ent:Spawn()

	timer.Simple(5,function()
		local pos
		for k,v in pairs(ents.FindByClass("ghost_ghost")) do
			pos = v:GetPos()
			v:Remove()
		end

		local e = ents.Create("ghost_ghost")
		e:SetPos( pos )
		e:Spawn()
	end)

	-- Setup skybox shit
	local ent = ents.Create( "prop_dynamic" ) -- Darken
	ent:SetPos( Vector( 8756, -10246, -8394 ) )
	ent:SetModel( "models/map_detail/duel_skydome_large.mdl" )
	ent:Spawn()
	local ent = ents.Create( "prop_dynamic" ) -- Fog
	ent:SetPos( Vector( 8697, -10219, -9429 ) )
	ent:SetAngles( Angle( 0, -45, 0 ) )
	ent:SetModel( "models/props/de_port/clouds.mdl" )
	ent:Spawn()
	local ent = ents.Create( "prop_dynamic" ) -- Haunted house portal
	ent:SetPos( Vector( 8876, -13619, -7802 ) )
	ent:SetAngles( Angle( 4, -73, 0 ) )
	ent:SetModel( "models/effects/portaltunnel.mdl" )
	ent:Spawn()
	local ent = ents.Create( "prop_dynamic" ) -- Haunted house
	ent:SetPos( Vector( 8965, -13349, -8250 ) )
	ent:SetAngles( Angle( 0, 90, 0 ) )
	ent:SetModel( "models/gmod_tower/propper/hauntedmansion.mdl" )
	ent:Spawn()

end
timer.Simple( 5, function() Initialize() end )

function EventLeadIn()

	-- Create foot step decals
	/*for i=1, #FootstepsLeft do
		timer.Simple( i * 1, function() CreateFootstep( FootstepsLeft[i], "BloodyFootstepLeft" ) end )
	end
	for i=1, #FootstepsRight do
		timer.Simple( i * 1.2, function() CreateFootstep( FootstepsRight[i], "BloodyFootstepRight" ) end )
	end*/

	local center = ents.FindByClass("gmt_halloween2014_center")[1]
	if IsValid( center ) then
	
		timer.Simple( 15, function() center:EmitSound("GModTower/lobby/halloween/wallslamming.wav") end )
		timer.Simple( 16, function() center:EmitSound("GModTower/lobby/halloween/sawmeatscream.wav") end )
		timer.Simple( 16, function() center:EmitSound("GModTower/lobby/halloween/breathe.wav") end )
		timer.Simple( 17, function() center:EmitSound("GModTower/lobby/halloween/stinger5.wav") end )
		timer.Simple( 17, function() center:EmitSound("GModTower/lobby/halloween/darkalert.wav") end )
		
		for i=1, 40 do
			timer.Simple( 17+(i*.25), function() local ed = EffectData() ed:SetOrigin( center:GetPos() + Vector(0,0,i*10) ) ed:SetScale( 4 ) util.Effect( "gib_bloodemitter", ed, true, true ) end )
		end

		timer.Simple( 21, function() center:EmitSound("GModTower/lobby/halloween/panic.mp3") end )
		timer.Simple( 35, function() center:EmitSound("GModTower/lobby/halloween/chant"..math.random(1,9)..".mp3") end )
		--timer.Simple( 21, function() center:EmitSound("GModTower/lobby/halloween/elevator_emergency_power_off_01.wav") end )
		--timer.Simple( 26, function() center:EmitSound("GModTower/lobby/halloween/elevator_power_msg.mp3") end )

	end

	timer.Simple( DelayBetweenEvents, function() EventLeadIn() end )

end

function CreateFootstep( step, decal )

	local pos, ang = step.pos, step.ang

	-- Sound
	sound.Play( "physics/flesh/flesh_squishy_impact_hard" .. math.random(1,4) .. ".wav", pos, 80, math.random( 40, 50 ) )

	-- Footestep decal
	--local tr = util.TraceLine( { start = pos, endpos = pos + Vector( 0, 0, -64 ) } )
	--util.Decal( decal, tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )

	-- Blood splash
	for i=1, 10 do
		local tr = util.TraceLine( { start = pos + VectorRand() * 60, endpos = pos + Vector( 0, 0, -64 ) } )
		util.Decal( "Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	end

end

if CLIENT then

	AddPostEvent( "devhq_spook_on", function( mul, time )

		local layer = postman.NewColorLayer()
		layer.contrast = 1.71
		layer.color = 0.1
		layer.brightness = -0.5
		layer.addr = 10/255
		layer.mulr = 50/255
		postman.FadeColorIn( "devhq_spook", layer, 1 )

	end )

	AddPostEvent( "devhq_spook_off", function( mul, time )

		postman.ForceColorFade( "devhq_spook" )
		postman.FadeColorOut( "devhq_spook", .25 )

	end )

	local function PlayAmbience( ply )

		if not LocalPlayer()._HalloweenLoop or LocalPlayer()._HalloweenLoop < CurTime() then

			if ply._HalloweenMusic then ply._HalloweenMusic:Stop() end
			ply._HalloweenMusic = CreateSound( LocalPlayer(), "room209/music_intothechaos.mp3" )
			ply._HalloweenMusic:PlayEx( 1, 60 )

			LocalPlayer()._HalloweenLoop = CurTime() + timetoint( 1, 27 )

		end

	end

	local HeartBeatPitch = 100
	local HeartBeatVolume = 0
	local HeartBeatSound = nil
	local BreathingPitch = 100
	local BreathingVolume = 0
	local BreathingSound = nil
	local CameraShake = 0
	local LightBrightness = 0
	local ScareLevel = 0
	local function AddScare( scare )
		ScareLevel = math.Clamp( ScareLevel + scare, 0, 1 )
	end

	hook.Add( "Think", "DevHQSpook", function()

		for _, ply in pairs( player.GetAll() ) do
		
			if not ply._InDevHQ then continue end

			-- Handle light brightness
			local LightColor = render.GetLightColor( LocalPlayer():GetPos() ) * 255
			LightBrightness = LightColor:Length() * .001

			if LightBrightness < 10 and ScareLevel < .45 then
				AddScare(.01)
			end

			-- Decrease scare level over time
			if ScareLevel > 0 then
				ScareLevel = math.Approach( ScareLevel, 0, .0001 )
			end

			-- Change heart beat volume/pitch based on scare level
			HeartBeatVolume = math.Approach( HeartBeatVolume, math.Fit(ScareLevel, 0, .5, 0, .5), .1 )
			HeartBeatPitch = math.Approach( HeartBeatPitch, math.Fit(ScareLevel, 0, 1, 100, 150), .1 )
			BreathingVolume = math.Approach( BreathingVolume, math.Fit(ScareLevel, .5, 1, 0, .85), .1 )
			BreathingPitch = math.Approach( BreathingPitch, math.Fit(ScareLevel, 0, 1, 80, 100), .1 )
			CameraShake = math.Approach( CameraShake, math.Fit(ScareLevel, 0, 1, 0, .15), .1 )

			-- Handle heart beat
			if HeartBeatVolume > 0 then
				if HeartBeatSound then
					HeartBeatSound:ChangeVolume(HeartBeatVolume, 0)
					HeartBeatSound:ChangePitch(HeartBeatPitch, 0)
				else
					HeartBeatSound = CreateSound( LocalPlayer(), "room209/heartbeat.wav" )
					HeartBeatSound:PlayEx( HeartBeatVolume, HeartBeatPitch )
				end
			else
				if HeartBeatSound then
					HeartBeatSound:FadeOut(1)
					HeartBeatSound = nil
				end
			end

			-- Handle breathing
			if BreathingVolume > 0 then
				if BreathingSound then
					BreathingSound:ChangeVolume(BreathingVolume, 0)
					BreathingSound:ChangePitch(BreathingPitch, 0)
				else
					BreathingSound = CreateSound( LocalPlayer(), "room209/breathing.wav" )
					BreathingSound:PlayEx( HeartBeatVolume, BreathingPitch )
				end
			else
				if BreathingSound then
					BreathingSound:FadeOut(1)
					BreathingSound = nil
				end
			end

		end

	end )

	hook.Add( "PlayerThink", "DevHQSpook", function( ply )

		if Location.IsGroup( ply:Location(), "lobby" ) then

			if not ply._InDevHQ then

				ply._InDevHQ = true
				PostEvent( "devhq_spook_on" )

			end

			PlayAmbience( ply )

		else

			if ply._InDevHQ then
			
				if ply._HalloweenMusic then ply._HalloweenMusic:FadeOut(1) end
				LocalPlayer()._HalloweenLoop = nil

				ply._InDevHQ = false
				PostEvent( "devhq_spook_off" )

			end

		end

	end )


	local VignetteMat = Material("gmod_tower/halloween/vignette")
	local StaticMat = Material("gmod_tower/halloween/static")
	local ScanMat = Material( "room209/scanlines" )
	local UICircle = Material( "room209/white_circle" )
	local StaticOpacity = 0
	local HeartBeatRate = 100
	local HeartBeatX = 0

	local ScreenRT = CreateMaterial("ScreenSpaceRT" .. CurTime(),"UnlitGeneric",{
		["$basetexture"] = "_rt_FullFrameFB", 
		["$selfillum"] = 1,
		["$ignorez"] = 1,
		["$additive"] = 1,
		["$vertexcolor"] = 1,
	})


	local function GhostStatic()

		local radius = 64
		local enemy = nil

		for k, npc in pairs( ents.FindByClass("ghost_*") ) do

			local dist = npc:GetPos():Distance( LocalPlayer():GetPos() )

			if dist < radius then
				enemy = npc
				radius = dist
			end

		end

		if enemy then

			surface.SetDrawColor(255,255,255,50)
			surface.SetMaterial(StaticMat)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())

		end

	end
	surface.CreateFont( "HUDVid", { font = "Digital-7 Mono", size = 50, weight = 500 } )
	surface.CreateFont( "HUDVidSmall", { font = "Digital-7 Mono", size = 32, weight = 500 } )

	local function DrawREC()

		-- Draw REC
		local x = ScrW()-256
		local size = 32
		surface.SetDrawColor(255,0,0,255)
		surface.SetMaterial(UICircle)

		local beep = SinBetween(0,1,RealTime()*5)
		if beep >= .5 then
			surface.DrawTexturedRect(x - (size/2),size+(size/2),size,size)
		end

		draw.SimpleText( "REC", "HUDVid", x + size + 16, size + 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

	end

	local function DrawClock()

		-- Draw timestamp
		local timeformat = os.date("%I:%M %p")
		draw.SimpleText( timeformat, "HUDVidSmall", ScrW() - 256, ScrH() - 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
		draw.SimpleText( "OCT 31,1978", "HUDVidSmall", ScrW() - 256, ScrH() - 100, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )

	end

	local function DrawCameraLines()

		-- Draw Camera lines
		local w, h = ScrW()/2, ScrH()/2
		local length, thickness = 64, 2
		local x, y = ScrW()/2 - w/2, ScrH()/2 - h/2

		surface.SetDrawColor(255,255,255,255)

		-- Top left
		surface.DrawRect(x,y,length,thickness)
		surface.DrawRect(x,y,thickness,length)

		-- Top right
		surface.DrawRect(x+w-length-thickness,y,length,thickness)
		surface.DrawRect(x+w-thickness,y,thickness,length)

		-- Bottom left
		surface.DrawRect(x,y+h-thickness,length,thickness)
		surface.DrawRect(x,y+h-length-thickness,thickness,length)

		-- Bottom right
		surface.DrawRect(x+w-length-thickness,y+h-thickness,length,thickness)
		surface.DrawRect(x+w-thickness,y+h-length,thickness,length)

	end

	local function ChromaticAbberation()

		surface.SetMaterial( ScreenRT )   

		-- Orange
		render.UpdateScreenEffectTexture()
		surface.SetDrawColor( 120, 50, 0, 255 )
		surface.DrawTexturedRect( 0, -3, ScrW(), ScrH() )

		-- Teal
		render.UpdateScreenEffectTexture()
		surface.SetDrawColor( 00, 100, 100, 255 )
		surface.DrawTexturedRect( -3, 1, ScrW(), ScrH() )
		
		-- Blue
		render.UpdateScreenEffectTexture()
		surface.SetDrawColor( 0, 0, 100, 255 )
		surface.DrawTexturedRect( 0, 3, ScrW(), ScrH() )

	end

	hook.Add( "HUDPaint", "DevHQSpook", function() 

		if LocalPlayer()._InDevHQ then

			ChromaticAbberation()
			DrawREC()
			DrawClock()
			DrawCameraLines()

		end

	end )


	local function DrawModelMaterial( ent, scale, material )

		// start stencil
		render.SetStencilEnable( true )
		
		// render the model normally, and into the stencil buffer
		render.ClearStencil()
		render.SetStencilFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
		render.SetStencilWriteMask( 1 )
		render.SetStencilReferenceValue( 1 )
		
			// render model
			/*ent:SetModelScale( 1, 0 )
			ent:SetupBones()
			ent:DrawModel()*/
		
		// render the outline everywhere the model isn't
		render.SetStencilReferenceValue( 0 )
		render.SetStencilTestMask( 1 )
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_ZERO )
		
		// render black model
		render.SuppressEngineLighting( true )
		render.MaterialOverride( material )
		
			// render model
			ent:SetModelScale( scale, 0 )
			ent:SetupBones()
			ent:DrawModel()
			
		// clear
		render.MaterialOverride()
		render.SuppressEngineLighting( false )
		
		// end stencil buffer
		render.SetStencilEnable( false )

	end

	hook.Add( "HUDPaintBackground", "DevHQSpook", function() 

		if LocalPlayer()._InDevHQ then
			surface.SetDrawColor(0,0,0,255)
			surface.SetMaterial(VignetteMat)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())

			StaticOpacity = math.Approach( StaticOpacity, math.Fit(LightBrightness, 0, 80, 15, 2), .1 )

			surface.SetDrawColor(255,255,255,StaticOpacity)
			surface.SetMaterial(StaticMat)
			surface.DrawTexturedRect(0,0,ScrW(),ScrH())

			if StaticScareEnabled then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(StaticMat)
				surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			end

			GhostStatic()

		end

	end )

	local MaterialGhost = Material( "sprites/heatwave" )
	--local MaterialGhostVisible = Material( "models/props_combine/cit_corebright" )
	--local MaterialEctogun = Material( "Models/effects/splodearc_sheet" )
	hook.Add( "PostDrawTranslucentRenderables", "Halloween", function()

		for _, v in pairs( ents.FindByClass("ghost_*") ) do

			if v:GetClass() == "ghost_ghost" then
				v:SetColor( Color( 0,0,0,150 ) )
				v:SetRenderMode( RENDERMODE_TRANSALPHA )
				DrawModelMaterial( v, 1.25, MaterialGhost )
			else
				v:SetColor( Color( 0,0,0, 0 ) )
				v:SetRenderMode( RENDERMODE_TRANSALPHA )
			end

		end

		--[[if IsCurrentlyHolding( "ectogun" ) then
			local wep = LocalPlayer():GetViewModel()
			DrawModelMaterial( wep, wep:GetModelScale() * 2, MaterialEctogun )
		end]]

	end )

end