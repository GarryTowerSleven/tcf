include( "shared.lua" )

/* Client Side Files */
for k, v in pairs( file.Find( GM.Folder:Replace( "gamemodes/", "") .. "/gamemode/cl_*.lua", "LUA" ) ) do
	if v != "cl_init.lua" then
		include( v )
	end
end

/* Shared Files */
for k, v in pairs( file.Find( GM.Folder:Replace( "gamemodes/", "") .. "/gamemode/sh_*.lua", "LUA" ) ) do
	include( v )
end

local txtmat = surface.GetTextureID( "UCH/logo/UClogo1" )
local tailmat = surface.GetTextureID( "UCH/logo/UClogo2" )
local birdmat = surface.GetTextureID( "UCH/logo/UClogo3" )
local btnmat = surface.GetTextureID( "UCH/logo/UClogo4" )
local wingmat = surface.GetTextureID( "UCH/logo/UClogo5" )
local expmat = surface.GetTextureID( "UCH/logo/UClogo6" )

local waverot = 0
local wavetime = CurTime() + 6

CreateClientConVar("gmt_uch_optout", "0", true, true)
local pigglowconvar = CreateClientConVar("gmt_uch_pig_glow", "1", true)
local chimeraglowconvar = CreateClientConVar("gmt_uch_chimera_glow", "1", true)

hook.Add( "Think", "LogoThink", function()

	local t = wavetime - CurTime()
	if t < 0 then
		wavetime = CurTime() + math.random( 12, 24 )
	end

	if t > 1.25 then
		waverot = math.Approach( waverot, 0, FrameTime() * 75 )
	else
		local num = 16 * math.sin( CurTime() * 12 )
		waverot = math.Approach( waverot, num, FrameTime() * 400 )
	end

end )

local LastRain = 0

hook.Add( "Think", "Weather", function()

	if game.GetMap() != "gmt_uch_downtown04" then return end

	if LastRain < CurTime() then

		local effect = EffectData()
		effect:SetFlags( 1 )
		util.Effect( "rain", effect )

		LastRain = CurTime() + 0.04

	end

end)

hook.Add( "ShouldHideHats", "ShouldHideHats", function( ply )

	if ply:Team() == TEAM_GHOST && LocalPlayer():Team() != TEAM_GHOST then
		return true
	end

end )

hook.Add( "PositionHatOverride", "Hats", function( ent, data, pos, ang, scale, hat )

	if IsValid( ent ) && ent.GetNet && ent:GetNet( "IsChimera" ) then

		hat:SetMaterial()

	end

end)

function GM:DrawLogo( x, y, size )
	
	local size = size or 1 //if they didn't specify size, just default it to 1
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	local txtw = ((ScrH() * .8 ) * size )
	local txth = ( txtw * .5 )
	
	//Wing 1
	local w = ( txth * .575 )
	local h = w
	
	local deg = 8
	local sway = ( deg * math.sin((CurTime() * 1.25)))
	
	surface.SetTexture( wingmat )
	surface.DrawTexturedRectRotated((x - ( txtw * .038)), ( y - ( txth * .205)), w, h, (-36 + sway))
	
	//Button
	local w = ( txth * .116 )
	local h = w
	
	surface.SetTexture( btnmat )
	surface.DrawTexturedRect((x - ( txtw * .0625)), ( y - ( txth * .27)), w, h )

	//Wing 2
	local w = ( txth * .575 )
	local h = w
	
	local deg = 8
	local sway = deg * math.sin( CurTime() * 1 )
	
	surface.SetTexture( wingmat )
	surface.DrawTexturedRectRotated((x - ( txtw * .05)), ( y - ( txth * .21)), w, h, (-4 + sway))
	
	//Tail
	local w = ( txtw * .14 )
	local h = ( w * 4 )

	local deg = 6
	local sway = ( deg * math.sin((CurTime() * 2)))
	
	surface.SetTexture( tailmat )
	surface.DrawTexturedRectRotated((x - ( txtw * .255)), ( y - ( txth * .145)), w, h, (-6 + sway))
	
	//Bird
	local w = ( txth * .28 )
	local h = w
	
	surface.SetTexture( birdmat )
	surface.DrawTexturedRect((x + ( txtw * .146)), ( y - ( txth * .3575)), w, h )
	
	// (!)
	local w = ( txth * .64 )
	local h = w
	
	surface.SetTexture( expmat )
	surface.DrawTexturedRectRotated((x + ( txtw * .2425)), ( y + ( txth * .09)), w, h, waverot )
	
	//Text
	surface.SetTexture( txtmat )
	surface.DrawTexturedRect((x - ( txtw * .5)), ( y - ( txth * .5)), txtw, txth )
	
end

function GM:PositionScoreboard( ScoreBoard )
	
	ScoreBoard:SetSize( 700, ScrH() - 100 )
	ScoreBoard:SetPos( ScrW() - ScoreBoard:GetWide() / 2, 50 )
	
end

function GM:RenderScreenspaceEffects()
	
	if LocalPlayer():IsGhost() then
		DoGhostEffects()
	end

	for k, ply in pairs( player.GetAll() ) do

		if !LocalPlayer():IsGhost() && ply:IsGhost() || ( ply:GetNet( "IsChimera" ) && !ply:Alive() ) then
			ply:SetRenderMode( RENDERMODE_NONE )
		else
			ply:SetRenderMode( RENDERMODE_NORMAL )
		end

		ply.skin, ply.bgroup, ply.bgroup2 = ( ply.skin || nil ), ( ply.bgroup || nil ), ( ply.bgroup2 || nil )

		if ply:Alive() then
			ply.skin = ply:GetSkin()
			ply.bgroup = ply:GetBodygroup( 1 )
			ply.bgroup2 = ply:GetBodygroup( 2 )
		end

		local rag = ply:GetRagdollEntity()
		if IsValid( rag ) then
			if !ply:GetNet( "IsChimera" ) then
				rag:SetSkin( ply.skin or 1 )
				rag:SetBodygroup( 1, ply.bgroup or 1 )
				rag:SetBodygroup( 2, ply.bgroup2 or 1 )
				
				if !rag.Flew && ply.RagShouldFly then

					rag.Flew = true
					ply.RagShouldFly = false
					local uc = self:GetUC()
					if !IsValid( uc ) then return end

					local dir = uc:GetForward() + Vector( 0, 0, .75 )
					for i = 0, rag:GetPhysicsObjectCount() - 1 do
						rag:GetPhysicsObjectNum( i):ApplyForceCenter( dir * 50000 )
					end
					ply:Squeal( rag )

				end
				
			else
				rag:SetSkin( 1 )
				rag:SetBodygroup( 1, 0 )
			end
		end
		
		if ply:GetNet( "IsPancake" ) then
			ply:DoPancakeEffect()
		else
			ply.PancakeNum = 1
			ply:SetModelScale( 1, 0 )
		end
		
	end
	
end

function GM:PrePlayerDraw( ply )
	
	if ( !LocalPlayer():IsGhost() && ply:IsGhost() || ( ply:GetNet( "IsChimera" ) && !ply:Alive() ) || ( ply:IsGhost() && ply:GetModel() != "models/uch/mghost.mdl" ) ) then
		return true
	end
	
end

hook.Add( "PreDrawHalos", "UCAngryHalo", function()

	if pigglowconvar:GetBool() && GAMEMODE:GetTimeLeft() < 31 && LocalPlayer():GetNet( "IsChimera" ) && ( GAMEMODE:IsLastPigmasks() || !LocalPlayer():Alive() ) then
		for k, ply in pairs( player.GetAll() ) do
			if ply:IsPig() && ply:Alive() then
				halo.Add( { ply }, Color( 255, 135, 200, 50 ), 2, 2, 3 , true, true )
			end
		end
	end

end )

hook.Add( "PreDrawHalos", "GhostHalo", function()

	if LocalPlayer():Team() == TEAM_GHOST || !GAMEMODE:IsPlaying() then
	
		if pigglowconvar:GetBool() then
			for k, ply in pairs( player.GetAll() ) do
				if ply:IsPig() && ply:Alive() then
					halo.Add( { ply }, Color( 255, 135, 200, 50 ), 2, 2, 3 , true, true )
				end
			end
		end
	
		if chimeraglowconvar:GetBool() then
			for k, ply in pairs( player.GetAll() ) do
				if ply:GetNet( "IsChimera" ) && ply:Alive() then
					halo.Add( { ply }, Color( 100, 0, 50, 50 ), 2, 2, 3 , true, true )
				end
			end
		end
		
	end

end )
usermessage.Hook( "UCMakeRagFly", function( um )

	local ply = um:ReadEntity()
	
	if IsValid( ply ) then
		ply.RagShouldFly = true
	end

end )

usermessage.Hook( "UCRound", function( um )

	local GameEnd = um:ReadBool()

	if GameEnd then

		RunConsoleCommand( "gmt_showscores", 1 )

	else

		RunConsoleCommand( "gmt_showscores" )
		RunConsoleCommand( "r_cleardecals" )

	end

end )

/* Disable Bhop */
hook.Add( "CreateMove", "DisableBhop", function( input )
	local ply = LocalPlayer()
	if ply:Alive() && input:KeyDown( IN_JUMP ) && ply.NextJump && CurTime() < ply.NextJump then
		input:SetButtons( input:GetButtons() - IN_JUMP )
	end
end )

hook.Add( "OnPlayerHitGround", "SetNextJump", function( ply, bInWater, bOnFloater, flFallSpeed )
	ply.NextJump = CurTime() + 0.08
end )


local function GetEyeAttach( ent, attachmentname )
	
	local attach = ent:LookupAttachment(attachmentname)

	if attach > 0 then
		local attach = ent:GetAttachment(attach)
		return attach
	end

end

local function EmitFlames( ent, pos, i )
	
	if not ent.Emitter then
		ent.Emitter = ParticleEmitter( pos )
	end

	local flare = Vector( CosBetween( -1, 1, RealTime() * 10 ), SinBetween( -2, 2, RealTime() * 10 ), 0 )

	local particle = ent.Emitter:Add( "effects/fire_embers" .. math.random( 1 , 2 ), pos + ( VectorRand() * 3 ) )
	particle:SetVelocity( Vector( 0, 0, 40 ) + flare + ent:GetRight() * 16 * ( i == 2 and 1 or -1 ) )
	particle:SetDieTime( math.Rand( .5, 1 ) )
	particle:SetStartAlpha( math.random( 150, 255 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 1, 5 ) )
	particle:SetEndSize( 0 )
	particle:SetColor( 255, 255, 255 )
	particle:SetGravity( Vector( 0, 0, 50 ) )

	local particle = ent.Emitter:Add( "uch/fire", pos + ( VectorRand() * 3 ) )
	particle:SetVelocity( Vector( 0, 0, 40 ) + flare + ent:GetRight() * 16 * ( i == 2 and 1 or -1 ) )
	particle:SetDieTime( math.Rand( .5, 1 ) )
	particle:SetStartAlpha( math.random( 150, 255 ) )
	particle:SetEndAlpha( 0 )
	particle:SetStartSize( math.random( 1, 5 ) )
	particle:SetEndSize( 0 )
	particle:SetColor( 255, 255, 255 )
	particle:SetGravity( Vector( 0, 0, 50 ) - ent:GetRight() * 24 * ( i == 2 and 1 or -1 ) )
	particle:SetRoll( math.random(360) )
	particle:SetAirResistance( 180 / 2 )

end

local SpriteMat = Material( "sprites/glow04_noz" )
local GlowMat = Material( "sprites/light_ignorez" )
hook.Add("PostDrawOpaqueRenderables", "UCAngry", function()

	if GAMEMODE:IsLastPigmasks() then

		local uch = GAMEMODE:GetUC()

		if IsValid( uch ) && uch:Alive() then

			local LEye = GetEyeAttach( uch, "L_eye" )
			local REye = GetEyeAttach( uch, "R_eye" )

			if not LEye or not REye then return end

			-- Flames
			if not uch.NextParticle or RealTime() > uch.NextParticle then
				EmitFlames( uch, LEye.Pos, 1 )
				EmitFlames( uch, REye.Pos, 2 )
				uch.NextParticle = RealTime() + 0.05
			end
			
			-- Glow
			for i2 = 1, 2 do

				local att = i2 == 2 and REye || LEye
				local ang = att.Ang

				render.SetMaterial( SpriteMat )

				for i = -1, 2 do

					local flip = i2 == 1 and -1 or 1
					render.DrawSprite( att.Pos + ang:Right() * 2 * i + ang:Forward() * 3 - ang:Forward() * ( 1 - ( i / 2 ) ) * ( i2 == 1 && 0 || 4 ), 24, 20 - ( ( i / 2 ) ) * 24, Color( 255, 0, 0 ) )
				end

			end

		end

	end

end)

local flashlight = 0

hook.Add("PreRender", "Flashlight", function()

	for _, p in ipairs(player.GetAll()) do

		if p != LocalPlayer() && p:GetNet("Flashlight") then

			local light = DynamicLight(p:EntIndex(), true)

			if light then

				local att = p:GetAttachment( 2 )
				light.pos = att && att.Pos || p:WorldSpaceCenter()
				light.r = 255
				light.g = 255
				light.b = 200
				light.brightness = 2
				light.decay = 1000
				light.size = 256
				light.dietime = CurTime() + 1

			end

		end

	end

	local ply = LocalPlayer()

	local on = ply:IsGhost() || ply:GetNet( "Flashlight" )

	flashlight = math.Approach( flashlight, on and 1 or 0, FrameTime() * 8 )

	if flashlight == 0 then

		if IsValid( light ) then

			light:Remove()

		end
	
		return

	end

	if !IsValid( light ) then

		light = ProjectedTexture()
		light:SetEnableShadows(true )
		light:SetTexture( "effects/flashlight/soft" )
		light:SetFarZ( 1024)
		light:SetColor( Color(255, 255, 200) )
	
	end

	local att = ply:GetAttachment(3) or ply:GetAttachment(1)
	att.Ang.p = 0

	light:SetPos( ply:IsGhost() && ply:EyePos() || ply:ShouldDrawLocalPlayer() && att.Pos + att.Ang:Forward() * 2 || ply:EyePos() - ply:GetForward() * 4 + ply:GetRight() * 4 - ply:GetUp() * 2 )
	light:SetAngles( ply:IsGhost() && ply:EyeAngles() || ply:ShouldDrawLocalPlayer() && att.Ang || ply:EyeAngles() )
	light:SetFOV( ply:IsGhost() && 179 || 65 - 20 * ( 1 - flashlight ) + ( ply:ShouldDrawLocalPlayer() && 20 || 0 ) )
	light:SetBrightness( ply:IsGhost() && 0.1 || flashlight * 2 )
	light:Update()

end)

local duck = 0
local feetang = Angle(0, 0, 0)
local sat_cache = false
local sat_build = 0

hook.Add("PostDrawEffects", "Arms", function()

	local ply = LocalPlayer()

	if ply:Team() != TEAM_PIGS then

		if IsValid( arms ) then

			arms:Remove()

		end

		return

	end

	if !IsValid(arms) then

		arms = ClientsideModel( ply:GetModel() )
		arms:SetNoDraw( true )

		arms:AddCallback( "BuildBonePositions", function()
			
			if IsValid( arms ) then

				for i = 0, arms:GetBoneCount() - 1 do

					local name = arms:GetBoneName(i)

					if string.find( name, "Head" ) || string.find( name, "Snout" ) then

						arms:ManipulateBoneScale(i, vector_origin)

					end

				end

			end

		end)

	end

	local sat = ply:GetNet( "HasSaturn" )

	duck = math.Approach( duck, ply:Crouching() && 1 || 0, FrameTime() * 8 )
	sat_build = math.Approach( sat_build, sat and 1 or 0, FrameTime() * 8 )

	if ply:ShouldDrawLocalPlayer() || !ply:Alive() then return end

	cam.Start3D(nil, nil, nil)

		cam.IgnoreZ(false)

			local pos, ang = EyePos(), EyeAngles()
			local ang2 = Angle(0, ang.y, 0)
			local moving = ply:GetVelocity():Length2D() > 1

			local diff = math.abs( math.NormalizeAngle( feetang.y - ang2.y ) ) + ( moving && 25 || 0 )
			if diff > ( 45 - sat_build * 45 ) || moving then
				feetang.y = math.ApproachAngle( feetang.y, ang2.y, FrameTime() * ( 128 + ( diff - 45 ) * 16 + ( diff > 70 and 200 or 0 ) or moving and 512 ) )
			end

			local ang2 = feetang
			local p = ply:GetPoseParameter( "move_yaw" )
			local m1, m2 = ply:GetPoseParameterRange( 1 )

			arms:SetSequence( ply:GetSequence() )
			arms:SetCycle( ply:GetCycle() )
			arms:SetPoseParameter( "move_yaw", math.Remap( p, 0, 1, m1, m2 ) + 20 * sat_build )

			arms:SetPos( EyePos() - ply:GetCurrentViewOffset() - ang2:Forward() * ( 18 + duck * 8 ) + ang2:Up() * ( ( duck * ( 10 + 2 ) ) + ( ply:IsGhost() && 10 || 4 ) ) )// pos + ang:Forward() * 64 + ang:Up() * -12)
			arms:SetAngles( ang2 - Angle( 0, sat_build * 20, 0 ) )

			arms:SetModel( ply:GetModel() )
			arms:SetSkin( ply:GetSkin() )
			arms:SetBodygroup( 1, ply:GetBodygroup(1) )
			arms:DrawModel()

			if sat_cache != sat then

				for i = 0, arms:GetBoneCount() - 1 do
					local name = arms:GetBoneName(i)
			
					if string.find( name, "R_" ) || string.find( name, "Rarm" ) then
						arms:ManipulateBoneScale( i, !sat and Vector( 1, 1, 1 ) || Vector( math.huge, math.huge, math.huge ))
					end
				end

				sat_cache = sat

			end

		cam.IgnoreZ(false)

	cam.End3D()

end)

local mats = {}

lightwarp = {}

function lightwarp.SetupMaterial( mat )
	
	if !mats[mat] then

		mats[mat] = Material( mat )

	end

	local material = mats[mat]

	material:SetTexture( "$lightwarptexture", "models/uch/warp" )
	material:SetTexture( "$bumpmap", "models/uch/flat2" )

	if material:GetFloat( "$phong" ) != 1 then return end

	material:SetFloat( "$phongexponent", 20 )
	material:SetFloat( "$phongboost", 0.3 )
	material:SetVector( "$phongfresnelranges", Vector( 0.3, 1, 8 ) )
	material:SetFloat( "$rimlight", 1 )
	material:SetFloat( "$rimlightexponent", 4 )
	material:SetFloat( "$rimlightboost", 2 )

end

function lightwarp.Set( arg )

	local type = type( arg )

	if type == "Entity" || type == "Player" || type == "CSEnt" then
		
		for _, mat in ipairs( arg:GetMaterials() ) do
			
			lightwarp.SetupMaterial( mat )

		end

	elseif type == "string" then

		lightwarp.SetupMaterial( arg )
		
	else

		ErrorNoHalt( "Attempted to call lightwarp.Set on invalid type! (" .. type .. ")")

	end

end

hook.Add( "Think", "Lightwarp", function()

	for _, ply in ipairs( player.GetAll() ) do
		
		local model = ply:GetModel()

		if ply.Model != model then
			
			lightwarp.Set( ply )

			if ply.CosmeticEquipment then

				for _, hat in ipairs( ply.CosmeticEquipment ) do
					
					if IsValid( hat ) then

						lightwarp.Set( hat )

					end

				end

			end

			ply.Model = model

		end

	end

	if !SETUPSATURN then
		
		local ent = ClientsideModel("models/uch/saturn.mdl")
		lightwarp.Set(ent)
		ent:Remove()

		SETUPSATURN = true

	end

end )