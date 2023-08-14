table.uinsert( HudToHide, "CHudCrosshair" )
table.uinsert( HudToHide, "CHudHealth" )
table.uinsert( HudToHide, "CHudAmmo" )
table.uinsert( HudToHide, "CHudSecondaryAmmo" )
table.uinsert( HudToHide, "CHudBattery" )
table.uinsert( HudToHide, "CHudZoom" )

GTowerHUD = GTowerHUD or {}

// draw the hud?
GTowerHUD.Enabled = CreateClientConVar( "gmt_hud", 1, true, false )
local HideBetaMessage = CreateClientConVar( "gmt_hidebetamsg", 0, true, false )

GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
}

timer.Simple(1, function()
	initHud()
end)

function initHud()

	// because native weapons don't have a way of giving us a max clip count
	// we need to cache the highest values we see
	GTowerHUD.MaxAmmo = {}

	GTowerHUD.Info = {
		Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
		Texture = surface.GetTextureID( "gmod_tower/lobby/hud/mainhud" ),
		TextureWidth = 256,
		TextureHeight = 128,
		X = 8,
		Y = ScrH() - 140,
		Height = 70,
		Width = 250,
		OffHeight = 48,
		BGColor = Color( 255, 255, 255, 255 )
	}

	if IsChristmasMap() then
		GTowerHUD.Info.Texture = surface.GetTextureID( "gmod_tower/lobby/hud/mainhud_christmas" )
	end
	
	if IsHalloweenMap() then
		GTowerHUD.Info.Texture = surface.GetTextureID( "gmod_tower/lobby/hud/mainhud_halloween" )
	end

	-- Crosshair
	GTowerHUD.Crosshair = {
		Enabled = CreateClientConVar( "gmt_hud_crosshair", 1, true, false ),
		AlwaysOn = CreateClientConVar( "gmt_hud_crosshair_always", 1, true, false ),
		Action = CreateClientConVar( "gmt_hud_crosshair_action", 1, true, false ),
		ThreeD = CreateClientConVar( "gmt_hud_crosshair_3d", 1, true, false ),
		Material = Material( "sprites/powerup_effects" ),
		Size = 4,
		MaxSize = 16,
	}

	-- Money
	GTowerHUD.Money = {
		LastAmount = 0,
		Amount = 0, -- this is approached
		Font = "GTowerHUDMainLarge",
	}

	-- Location
	GTowerHUD.Location = {
		Enabled = CreateClientConVar( "gmt_hud_location", 1, true, false ),
		Font = "GTowerHUDMainSmall",
	}

	-- Ammo
	GTowerHUD.Ammo = {
		Enabled = CreateClientConVar( "gmt_hud_ammo", 1, true, false ),
		Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammo" ),
		Width = 256,
		Height = 256,
		MainFont =  "GTowerhuge",
		SecondaryFont = "GTowerbigbold",
	}

	-- Ammo bar
	GTowerHUD.AmmoBar = {
		Texture = surface.GetTextureID( "gmod_tower/lobby/hud/ammobar" ),
		Width = 130 - 4,
		Height = 130 - 4,
		CurrentRotation = 0, -- approached in think
		TargetRotation = 0, -- updated in draw
	}

	-- Lobby 1 Health
	GTowerHUD.Health = {
		Texture = surface.GetTextureID( "gmod_tower/lobby/hud/bar" ),
		Size = 0, -- this is changed in the think, because it's approached
		Height = 12,
		Font = "GTowerHUDMainSmall",
		MaxSize = GTowerHUD.Info.Width - 43,
		EnabledY = GTowerHUD.Info.Y + GTowerHUD.Info.Height - 8 - (12*2),
		DisabledY = GTowerHUD.Info.Y + GTowerHUD.Info.Height + 6,
		CurY = GTowerHUD.Info.Y + GTowerHUD.Info.Height + 6, -- approached in think
	}

	-- Location Change Notice
	GTowerHUD.LocationChangeNotice = {
		Enabled = CreateClientConVar( "gmt_location_notice", 1, true, false ),
		Alpha = 0,
	}

	// this is required for client notifications
	function GetAmmoYPos()

		if IsValid( LocalPlayer():GetActiveWeapon() ) then
			return ScrH() - 200
		end

	    return ScrH() - 70

	end

	function GTowerHUD.DrawCrosshair()

		if !GTowerHUD.Crosshair.Enabled:GetBool() then return end

		if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return end

		local wep = LocalPlayer():GetActiveWeapon()

		if IsValid(wep) and (wep.DoDrawCrosshair and wep:DoDrawCrosshair() == true || !wep.DrawCrosshair || wep.DrawHUDCrosshair) then return end

		local ent = GAMEMODE:PlayerUseTrace( LocalPlayer() )

		if !GTowerHUD.Crosshair.AlwaysOn:GetBool() && !IsValid( ent ) && !CanPlayerUse( ent ) then return end

		// no crosshair if using condOS or mapboard
		if /*LocalPlayer().UsingPanel or*/ IsValid( ent ) and ( ent:GetClass() == "gmt_mapboard" ) then
			return
		end

		local w, h = ScrW() / 2, ScrH() / 2

		if GTowerHUD.Crosshair.ThreeD:GetBool() then
			local p = EyePos() + LocalPlayer():EyeAngles():Forward()
			p = p:ToScreen()
			w, h = math.Round(p.x), math.Round(p.y)
		end
		
		local color = Color( 255, 255, 255 )
		local x = 0

		-- Draw Use message
		if GTowerHUD.Crosshair.Action:GetBool() and IsValid( ent ) and CanPlayerUse( ent ) then
			GTowerHUD.DrawUseMessage( ent, x, w, h )
		end

		surface.SetMaterial( GTowerHUD.Crosshair.Material )

		local size = ScreenScale( 12 )
		local radius = size / 2

		surface.SetDrawColor( color.r, color.g, color.b, 150 )
		surface.DrawTexturedRect( w - radius, h - radius, size, size )

	end

	// util func to cache unknown max clip values
	function GTowerHUD.GetMaxAmmo( wepName, clip )

		// if we haven't cached it, or it's larger
		if !GTowerHUD.MaxAmmo[ wepName ] || clip > GTowerHUD.MaxAmmo[ wepName ] then
			GTowerHUD.MaxAmmo[ wepName ] = clip
			return clip
		end

		return GTowerHUD.MaxAmmo[ wepName ]
	end


	local mLastAmount = 0
	local mAmount = 0
	local gradientUp = surface.GetTextureID( "VGUI/gradient_up" )

	function GTowerHUD.DrawInfo()

		if !GTowerHUD.Info.Enabled:GetBool() then return end
		if hook.Call( "DisableHUD", GAMEMODE, ply ) then return end

		surface.SetTexture( GTowerHUD.Info.Texture )
		surface.SetDrawColor( GTowerHUD.Info.BGColor )
		surface.DrawTexturedRect( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.TextureWidth, GTowerHUD.Info.TextureHeight )

		-- Ease money
		if GTowerHUD.Money.LastAmount != Money() then
			GTowerHUD.Money.LastAmount = Money()
		end

		if GTowerHUD.Money.Amount != Money() then
			local diffMoney = GTowerHUD.Money.Amount - GTowerHUD.Money.LastAmount
			local increaseAmount = math.ceil( math.abs( diffMoney * .1 ) )
			GTowerHUD.Money.Amount = math.Approach( GTowerHUD.Money.Amount, Money(), increaseAmount )
		end

		-- GMC
		surface.SetFont( GTowerHUD.Money.Font )

		local money = string.FormatNumber( GTowerHUD.Money.Amount )

		local mTextW, mTextH = surface.GetTextSize( money )

		local mTextX = GTowerHUD.Info.X + 110
		local mTextY = GTowerHUD.Info.Y + 75 - ( mTextH / 2 )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.SetTextPos( mTextX, mTextY )
		surface.DrawText( money )
		
		-- Location
		local location = Location.GetFriendlyName( LocalPlayer():Location() ) or "Unknown"

		if GTowerHUD.Location.Enabled:GetBool() then
			local location = string.upper( location )
				
			surface.SetFont( GTowerHUD.Location.Font )
			local mTextW, mTextH = surface.GetTextSize( location )
			local mTextX = GTowerHUD.Info.X + 91
			local mTextY = GTowerHUD.Info.Y + 103 - ( mTextH / 2 )

			draw.SimpleText( location, GTowerHUD.Location.Font, mTextX, mTextY, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end
	end

	function GTowerHUD.DrawUseMessage( ent, x, w, h )

		if ent:GetClass() != "gmt_multiserver" then return end

		if not IsValid( ent ) then return end

		local use, nokey = CanPlayerUse( ent )
		if not use then return end

		if use then
			local message = string.upper( use )
			if !nokey then
				message = "USE TO " .. message
			end
			draw.SimpleText( message, GTowerHUD.Location.Font, w + 8, h - 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		end

	end

	function GTowerHUD.DrawNotice( title, message )

		if !GTowerHUD.Notice.Enabled:GetBool() then return end
	
		-- Handle notice
		local w, h = ScrW() / 2, ScrH() / 2
		h = ( h * 2 ) - 150
	
		-- Draw gradient boxes
		--draw.GradientBox( w - 512, h, 256, 110, 0, Color( 0, 0, 0, 0 ), Color( 0, 0, 0, 230 ) )
		--draw.GradientBox( w + 256, h, 256, 110, 0, Color( 0, 0, 0, 230 ), Color( 0, 0, 0, 0 ) )
		surface.SetDrawColor( 0, 0, 0, 230 )
		surface.DrawRect( w - 512, h, 1024, 130 )
	
		-- Draw title
		draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )
	
		-- Draw text
		draw.DrawText( message or "", "GTowerHudCSubText", w, h + 30, Color( 255, 255, 255, 255 ), 1 )
	
	end

	function GTowerHUD.DrawHealth()

		if !Dueling.IsDueling(LocalPlayer()) then return end

		// Lobby 1 Health
		local health = LocalPlayer():Health()
		if health < 0 then health = 0 end
			
		local healthX = GTowerHUD.Info.X + 50
		local healthY = GTowerHUD.Info.Y + 35

		surface.SetDrawColor( 20, 103, 36, 255 )
		surface.DrawRect( healthX, healthY - 2, GTowerHUD.Health.MaxSize - 1, GTowerHUD.Health.Height + 4 )

		local ratio = 1 - ( GTowerHUD.Health.Size / GTowerHUD.Health.MaxSize )
		local oppred = 200 - ratio * math.sin( CurTime() * ratio * 3 ) * 55 + ( 1 - ratio ) * 55

		surface.SetTexture( GTowerHUD.Health.Texture )
		surface.SetDrawColor( 255, oppred, oppred, 255 )
		surface.DrawTexturedRect( healthX, healthY, GTowerHUD.Health.Size, GTowerHUD.Health.Height )

		surface.SetFont( GTowerHUD.Health.Font )

		local HealthSub = 255 - ( 1 - ( health / 100 ) ) * 100
		local hTextW, hTextH = surface.GetTextSize( health )
		local hTextX = healthX + ( GTowerHUD.Health.MaxSize / 2 ) - ( hTextW / 2 )
		local hTextY = healthY + ( GTowerHUD.Health.Height / 2 ) - ( hTextH / 2 )

		surface.SetTextColor( 255, HealthSub, HealthSub, 255 )
		surface.SetTextPos( hTextX, hTextY )
		surface.DrawText( health )

	end

	function GTowerHUD.DrawAmmo()

		if !GTowerHUD.Ammo.Enabled:GetBool() then return end

		local weapon = LocalPlayer():GetActiveWeapon()

		if !IsValid( weapon ) then return end

		local name = weapon:GetPrintName()
		
		//self.Ply.UsesLeft is FUCKED. HUG THIS.
		if name == "Confetti!" || name == "Streamer!" || name == "Firework Rocket" || name == "Fists" then return end // FIX THIS EVENTUALLY??? I DONT KNOW
		
		local currentMag = weapon:Clip1()
		local currentMax = 100 // default max
		local currentAmmoType = weapon:GetPrimaryAmmoType()
		local currentAmmoLeft = LocalPlayer():GetAmmoCount( currentAmmoType )

		if weapon.Primary then
			currentMax = weapon.Primary.ClipSize
		else
			currentMax = GTowerHUD.GetMaxAmmo( name, currentMag )
		end

		if !currentMag || currentMag == -1 then return end //there's no ammo
		if currentMag <= 0 && currentAmmoLeft <= 0 then return end  //we're out of ammo - don't display this

		local ammoX = ScrW() - 160
		local ammoY = ScrH() - 160

		local ammoBarX = ammoX + ( 130 / 2 ) + 8
		local ammoBarY = ammoY + ( 130 / 2 ) + 6
		local ammoBarRot = 180 - ( ( currentMag / ( currentMax or 1 ) ) * 180 )

		GTowerHUD.AmmoBar.TargetRotation = ammoBarRot

		surface.SetDrawColor( 255, 255, 255, 255 )

		surface.SetTexture( GTowerHUD.AmmoBar.Texture )
		surface.DrawTexturedRectRotated( ammoBarX, ammoBarY, GTowerHUD.AmmoBar.Width, GTowerHUD.AmmoBar.Height, GTowerHUD.AmmoBar.CurrentRotation )

		surface.SetTexture( GTowerHUD.Ammo.Texture )
		surface.DrawTexturedRect( ammoX, ammoY, GTowerHUD.Ammo.Width, GTowerHUD.Ammo.Height )

		// draw ammo text
		// draw how much current ammo we have
		surface.SetFont( GTowerHUD.Ammo.MainFont )

		local curMagW, curMagH = surface.GetTextSize( currentMag )
		local curMagX, curMagY = ammoBarX - ( curMagW / 2 ), ammoBarY - ( curMagH / 2 )

		surface.SetTextPos( curMagX + 3, curMagY + 3 )
		surface.SetTextColor( 0, 0, 0, 40 )
		surface.DrawText( currentMag )

		surface.SetTextPos( curMagX, curMagY )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.DrawText( currentMag )

		// draw how much the mag can contain/how much ammo is left
		surface.SetFont( GTowerHUD.Ammo.SecondaryFont )

		local fullMagW, fullMagH = surface.GetTextSize( currentAmmoLeft )
		local fullMagX, fullMagY = ammoX + 91 + ( 62 / 2 ) - ( fullMagW / 2 ), ammoY + 87 + ( 62 / 2 ) - ( fullMagH / 2 )

		surface.SetTextPos( fullMagX + 3, fullMagY + 3 )
		surface.SetTextColor( 0, 0, 0, 40 )
		surface.DrawText( currentAmmoLeft )

		surface.SetTextPos( fullMagX, fullMagY )
		surface.SetTextColor( 255, 255, 255, 255 )
		surface.DrawText( currentAmmoLeft )

	end

	local MsgTime = CurTime()
	local MsgState = true

	function GTowerHUD.ShouldDraw()
		if !IsValid( LocalPlayer() ) then return false end
	
		if not hook.Run( "GTowerHUDShouldDraw" ) then return false end
	
		if LocalPlayer():GetNWBool( "InLimbo" ) then return false end
		
		if !GTowerHUD.Enabled:GetBool() then return false end
		

		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid( weapon ) && weapon:GetClass() == "gmt_camera" then return false end
	
		return true
	end

	function GTowerHUD.Paint()

		if Location.Is( LocalPlayer():Location(), "secret_entrance" ) then
			local dist = LocalPlayer():GetPos():Distance(Vector(2550, 5009, -780))
			GTowerHUD.DrawStatic( math.Clamp(255 - (dist/3),0,200) )
		end

		if !GTowerHUD.ShouldDraw() then return end

		jetpack.JetpackFuelDraw( GTowerHUD.Info.X, GTowerHUD.Info.Y + 48, GTowerHUD.Info.Width, GTowerHUD.Info.Height + 1 )
		
		GTowerHUD.DrawHealth()
		GTowerHUD.DrawInfo()

		hook.Call( "GTowerHUDPaint", GAMEMODE )

		GTowerHUD.DrawAmmo()
		--GTowerHUD.DrawNotice()
		--GTowerHUD.DrawNews()
		GTowerHUD.DrawCrosshair()

		--[[if !( HideBetaMessage:GetBool() and LocalPlayer():IsAdmin()  ) then
			draw.SimpleShadowText( "This game is still a work in progress, this beta may not represent the final quality of the product.", "GTowerHudCSubText", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
			draw.SimpleShadowText( "Follow us at http://www.gmtower.org/", "GTowerHudCSubText", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
		end]]

		--[[if LocalPlayer():GetNWBool("MinigameOn") then
			GTowerHUD.MinigameHUD()
		end]]
	end

	local hud_icon_clock = Material( "gmod_tower/balls/hud_icon_clock" )
	surface.CreateFont( "BallFont", { font = "Coolvetica", size = 48, weight = 200 } )

	--[[function GTowerHUD.MinigameHUD()
		local TimeLeft = (GetGlobalFloat("MinigameRoundTime") - CurTime())
		local TimeString = string.FormattedTime( TimeLeft, "%02i:%02i" )

		draw.DrawText("- MINIGAME -","GTowerSkyMsgSmall",24,0,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
		draw.DrawText( TimeString, "VoteTitle", 4 + 80, 60, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		draw.DrawText("- SCORE -","GTowerSkyMsgSmall",16,ScrH()/2-52,Color( 255, 255, 255, 255 ),TEXT_ALIGN_LEFT)
		draw.DrawText( LocalPlayer():GetNWInt("MinigameScore"), "VoteTitle", 16, ScrH()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )

		surface.SetMaterial(GTowerIcons2.GetIcon("time"))
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(0,52,80,80)
	end]]

	local hud_icon_clock = Material( "gmod_tower/balls/hud_icon_clock" )
	surface.CreateFont( "BallFont", { font = "Coolvetica", size = 48, weight = 200 } )

	function GTowerHUD.Think()

	  if !LocalPlayer():Alive() then GTowerMainGui.HideMenus() end

	  // Health
	  if !IsValid( LocalPlayer() ) then return end

		// to calculate health bar size approach value
		local health = LocalPlayer():Health()
		local healthValue = health * ( GTowerHUD.Health.MaxSize / 100 )
		local healthSize = math.Clamp( healthValue, 0, GTowerHUD.Health.MaxSize )

		if healthSize != GTowerHUD.Health.Size then
			GTowerHUD.Health.Size = math.Approach(
				GTowerHUD.Health.Size,
				healthSize,
				( math.abs( GTowerHUD.Health.Size - healthSize ) + 1 ) * 3 * FrameTime()
			)
		end

		if GTowerHUD.AmmoBar.CurrentRotation != GTowerHUD.AmmoBar.TargetRotation then

			GTowerHUD.AmmoBar.CurrentRotation = math.Approach(
				GTowerHUD.AmmoBar.CurrentRotation,
				GTowerHUD.AmmoBar.TargetRotation,
				( math.abs( GTowerHUD.AmmoBar.CurrentRotation - GTowerHUD.AmmoBar.TargetRotation ) + 1 ) * 3 * FrameTime()
			)

		end

	end


	hook.Add( "Think", "GTowerHUDThink", GTowerHUD.Think )
	hook.Add( "HUDPaint", "GTowerHUDPaint", GTowerHUD.Paint )

	function GAMEMODE:GTowerHUDShouldDraw()
		return true
	end

	-----------------------------------------------------

	if SERVER then return end

	local Radar = {}



	Radar.AlphaScale = 0.6



	Radar.PlayerColor = Color( 240, 240, 240, 255 )

	Radar.FriendlyColor = Color( 255, 20, 20, 255 )

	Radar.NPCColor = Color( 255, 200, 20, 255 )



	Radar.Radius = 1250



	//local RadarVirus = surface.GetTextureID( "gmod_tower/virus/hud_infected_radar" )

	local RadarHuman = surface.GetTextureID( "gmod_tower/virus/hud_survivor_radar" )





	local ColorAScale = function( col, scale )

		return Color( col.r, col.g, col.b, col.a * math.pow( 1 - scale, 2 ) )

	end



	function DrawRadar()


		--if hook.Call( "DisableRadar", GAMEMODE, LocalPlayer() ) then return end

		--if LocalPlayer():GetSetting(29 --[["GTAllowVirusHUD"]]) != true then return end

		if LocalPlayer():GetNWBool("InLimbo") then return end
		if !LocalPlayer():GetNWBool("VirusRadar") then return end

		Radar.w = 256

		Radar.h = 128

		Radar.x = ScrW() - Radar.w - 32

		Radar.y = 32



		surface.SetTexture( RadarHuman )

		surface.SetDrawColor( 255, 255, 255, 255 )

		surface.DrawTexturedRect( Radar.x, Radar.y, 256, 128 )



		for _, ply in pairs( player.GetAll() ) do

			DrawBlip( ply, Radar.PlayerColor )

		end



		for _, npc in pairs( ents.FindByClass( "gmt_npc_*" ) ) do

			DrawBlip( npc, Radar.NPCColor )

		end



		/*for _, npc in pairs( ents.GetAll() ) do

			DrawBlip( npc, Radar.EnemyColor )

		end*/



	end



	function DrawBlip( ent, color )



		if !IsValid( ent ) || LocalPlayer() == ent then return end



		local vdiff = ent:GetPos() - LocalPlayer():GetPos()

		if vdiff:Length() > Radar.Radius then return end



		local cx = Radar.x + Radar.w / 2

		local cy = Radar.y + Radar.h / 2



		local px = ( vdiff.x / Radar.Radius )

		local py = ( vdiff.y / Radar.Radius )



		local z = math.sqrt( px * px + py * py )

		local phi = math.rad( math.deg( math.atan2( px, py ) ) - math.deg( math.atan2( LocalPlayer():GetAimVector().x, LocalPlayer():GetAimVector().y ) ) - 90 )

		px = math.cos( phi ) * z

		py = math.sin( phi ) * z



		draw.RoundedBox( 4, ( cx + px * Radar.w / 2 - 4 ), cy + py * Radar.h / 2 - 4, 8, 8, ColorAScale( color, z ) )

		//draw.RoundedBox( 4, ( cx + px * Radar.w / 2 - 4 ), cy + py * Radar.h / 2 - 4, 8, 8, ColorAScale( color, 1 - z ) )



	end



	hook.Add( "HUDPaint", "VirDrawRadar", DrawRadar )
end