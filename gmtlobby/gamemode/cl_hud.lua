GTowerHUD = {}

table.uinsert( GtowerHudToHide, "CHudHealth" )
table.uinsert( GtowerHudToHide, "CHudAmmo" )
table.uinsert( GtowerHudToHide, "CHudSecondaryAmmo" )
table.uinsert( GtowerHudToHide, "CHudBattery" )

// draw the hud?
GTowerHUD.Enabled = CreateClientConVar( "gmt_hud", 1, true, false )
local HideBetaMessage = CreateClientConVar( "gmt_hidebetamsg", 0, true, false )

GTowerHUD.Notice = {
	Enabled = CreateClientConVar( "gmt_notice", 1, true, false ),
}

GTowerHUD.Style = CreateClientConVar( "gmt_hud_style", 0, true, false, nil, 0, 4 )

HUDStyle_Deluxe = false
HUDStyle_Lobby2 = false
HUDStyle_L2 = false
HUDStyle_Lobby1 = false
HUDStyle_Lobby1B = false
HUDStyle_Lobby1A = false
HUDStyle_Lobby1AB = false

local function cleanHud()
	hook.Remove( "Think", "GTowerHUDThink", GTowerHUD.Think )
	hook.Remove( "HUDPaint", "GTowerHUDPaint", GTowerHUD.Paint )
	hook.Remove( "HUDPaint", "VirDrawRadar" )

	HUDStyle_Deluxe = false
	HUDStyle_Lobby2 = false
	HUDStyle_L2 = false
	HUDStyle_Lobby1 = false
	HUDStyle_Lobby1B = false
	HUDStyle_Lobby1A = false
	HUDStyle_Lobby1AB = false
end

timer.Simple(1, function()
	initHud()
end)

cvars.AddChangeCallback("gmt_hud_style", function(_, _, newval)
	cleanHud()
	initHud()
end)

function initHud()

	// i love elseif statements
	if GTowerHUD.Style:GetInt() == 0 then
		HUDStyle_Deluxe = true
		HUDStyle_L2 = true
	elseif GTowerHUD.Style:GetInt() == 1 then
		HUDStyle_Lobby2 = true
		HUDStyle_L2 = true
	elseif GTowerHUD.Style:GetInt() == 2 then
		HUDStyle_Lobby1 = true
	elseif GTowerHUD.Style:GetInt() == 3 then
		HUDStyle_Lobby1B = true
		HUDStyle_Lobby1AB = true
	elseif GTowerHUD.Style:GetInt() == 4 then
		HUDStyle_Lobby1A = true
		HUDStyle_Lobby1AB = true
	end

	// because native weapons don't have a way of giving us a max clip count
	// we need to cache the highest values we see
	GTowerHUD.MaxAmmo = {}

	if HUDStyle_Deluxe then
		HUDBackground = Material( "gmod_tower/hud/bg_gradient_deluxe2.png", "unlightsmooth" )
		HUDLogo = Material( "gmod_tower/hud/logo_flat_deluxe.png", "unlightsmooth" )
		HUDBGColor = Color( 155, 155, 155, 200 )
		if IsHalloweenMap() then
			HUDBackground = Material( "gmod_tower/hud/bg_gradient_deluxe_h.png", "unlightsmooth" )
			HUDLogo = Material( "gmod_tower/hud/logo_flat_deluxe_h.png", "unlightsmooth" )
		end
	end

	// Lobby 2
	if HUDStyle_Lobby2 then
		HUDBackground = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" )
		HUDLogo = GTowerIcons2.GetIcon("gmt")
		HUDBGColor = Color( 0, 0, 0, 200 )
	end

	if HUDStyle_Lobby2 or HUDStyle_Deluxe then
		GTowerHUD.Info = {
			Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
			Texture = HUDLogo,
			TextureWidth = 64,
			TextureHeight = 64,
			X = 10,
			Y = ScrH() - 90,
			Height = 70,
			Width = 250,
			OffHeight = 48,
			Background = HUDBackground,
			BGColor = HUDBGColor
		}
	elseif HUDStyle_Lobby1 then
		GTowerHUD.Info = {
			Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
			//Texture = surface.GetTextureID( "gmod_tower/lobby/hud/mainhud" ),
			Texture = Material( "gmod_tower/lobby/hud/mainhud" ),
			TextureWidth = 256,
			TextureHeight = 128,
			X = 8,
			Y = ScrH() - 140,
			Height = 70,
			Width = 250,
			OffHeight = 48,
			Background = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" ),
			BGColor = Color( 255, 255, 255, 255 )
		}

		if IsChristmasMap() then
			GTowerHUD.Info.Texture = Material("gmod_tower/lobby/hud/mainhud_christmas")
		end
	
		if IsHalloweenMap() then
			GTowerHUD.Info.Texture = Material("gmod_tower/lobby/hud/mainhud_halloween")
		end
	elseif HUDStyle_Lobby1AB then
		GTowerHUD.Info = {
			Enabled = CreateClientConVar( "gmt_hud_info", 1, true, false ),
			Texture = Material( "gmod_tower/lobby/hud/legacy/main" ),
			TextureWidth = 256,
			TextureHeight = 128,
			X = 0,
			Y = ScrH() - 125,
			Height = 70,
			Width = 250,
			OffHeight = 48,
			Background = Material( "gmod_tower/hud/bg_gradient.png", "unlightsmooth" ),
			BGColor = Color( 255, 255, 255, 255 )
		}

		if HUDStyle_Lobby1A then
			GTowerHUD.Info.Texture = Material("gmod_tower/lobby/hud/legacy/health")
		end

		if IsChristmasMap() && HUDStyle_Lobby1B then
			GTowerHUD.Info.Texture = Material("gmod_tower/lobby/hud/legacy/main_winter")
		end

		if IsHalloweenMap() && HUDStyle_Lobby1B then
			GTowerHUD.Info.Texture = Material("gmod_tower/lobby/hud/legacy/main_halloween")
		end
	end

	-- Crosshair
	GTowerHUD.Crosshair = {
		Enabled = CreateClientConVar( "gmt_hud_crosshair", 1, true, false ),
		AlwaysOn = CreateClientConVar( "gmt_hud_crosshair_always", 1, true, false ),
		Action = CreateClientConVar( "gmt_hud_crosshair_action", 0, true, false ),
		Material = Material( "gmod_tower/hud/crosshair.png" ),
		Size = 4,
		MaxSize = 16,
	}

	if !HUDStyle_L2 then
		GTowerHUD.Crosshair.Material = Material( "sprites/powerup_effects" )
	end

	-- Money
	GTowerHUD.Money = {
		LastAmount = 0,
		Amount = 0, -- this is approached
		Font = "GTowerHUDMainLarge",
	}

	if HUDStyle_Lobby1AB then
		GTowerHUD.Money.Font = "Gtowerbigbold"
	end

	-- Location
	GTowerHUD.Location = {
		Enabled = CreateClientConVar( "gmt_hud_location", 1, true, false ),
		Font = "GTowerHUDMainSmall",
	}

	if HUDStyle_Lobby1AB then
		GTowerHUD.Location.Font = "Gtowerbiglocation"
	end

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

	if HUDStyle_Lobby1AB then
		GTowerHUD.Health.Height = 20
		GTowerHUD.Health.MaxSize = 150
		GTowerHUD.Health.Font = "Gtowerbig"

		if HUDStyle_Lobby1B && IsChristmasMap() then
			GTowerHUD.Health.Texture = surface.GetTextureID( "gmod_tower/lobby/hud/bar_christmas" )
		elseif HUDStyle_Lobby1B && IsHalloweenMap() then
			GTowerHUD.Health.Texture = surface.GetTextureID( "gmod_tower/lobby/hud/bar_halloween" )
		end
	end

	-- Location Change Notice
	GTowerHUD.LocationChangeNotice = {
		Enabled = CreateClientConVar( "gmt_location_notice", 1, true, false ),
		Alpha = 0,
	}

	if GTowerHUD.VolumeSlider then GTowerHUD.VolumeSlider:Remove() GTowerHUD.VolumeSlider = nil end
	GTowerHUD.VolumeSlider = vgui.Create( "DNumSlider2" )
	GTowerHUD.VolumeSlider:SetMinMax( 0, 1 )
	GTowerHUD.VolumeSlider:SetDecimals( 3 )
	GTowerHUD.VolumeSlider:SetConVar( "mediaplayer_volume" )
	GTowerHUD.VolumeSlider:SetSliderColor( Color( 200, 200, 200, 200 ) )
	GTowerHUD.VolumeSlider:SetWidth( GTowerHUD.Info.Width - 44 )
	GTowerHUD.VolumeSlider:SetPos( GTowerHUD.Info.X + 16 + 4, GTowerHUD.Info.Y - 24 )
	GTowerHUD.VolumeSlider:SetVisible( false )

	function GTowerHUD.DrawVolumeIcon()

		if !HUDStyle_L2 then return end

		local x, y = GTowerHUD.Info.X, GTowerHUD.Info.Y - 32 - 4

		local showVolume = false

		for _, mp in pairs(MediaPlayer.GetAll()) do
			if mp:IsPlaying() then
				showVolume = true
			end
		end

		if showVolume then
			surface.SetDrawColor( GTowerHUD.Info.BGColor )
			surface.SetMaterial( GTowerHUD.Info.Background )
			surface.DrawTexturedRect( 0, GTowerHUD.VolumeSlider.y - 6, GTowerHUD.Info.Width, GTowerHUD.VolumeSlider:GetTall() + 6 )

			surface.SetDrawColor( Color( 255, 255, 255 ) )
			surface.SetMaterial( GTowerIcons2.GetIcon("volume16") )
			surface.DrawTexturedRect( x, y+11, 16, 16 )
		end

		GTowerHUD.VolumeSlider:SetVisible(showVolume)

	end

	// this is required for client notifications
	function GetAmmoYPos()

		if IsValid( LocalPlayer():GetActiveWeapon() ) then
			return ScrH() - 200
		end

	    return ScrH() - 70

	end

	function GTowerHUD.DrawCrosshair()

		if LocalPlayer():ShouldDrawLocalPlayer() || !LocalPlayer():Alive() then return end

		local ent = GAMEMODE:PlayerUseTrace( LocalPlayer() )

		if !GTowerHUD.Crosshair.AlwaysOn:GetBool() && !IsValid( ent ) && !CanPlayerUse( ent ) then return end

		// no crosshair if using condOS or mapboard
		if LocalPlayer().UsingPanel or IsValid( ent ) and ( ent:GetClass() == "gmt_mapboard" ) then
			return
		end

		local w, h = ScrW() / 2, ScrH() / 2
		local color = Color( 255, 255, 255 )
		local x = 0

		-- Draw Use message
		
		if GTowerHUD.Crosshair.Action:GetBool() and IsValid( ent ) and CanPlayerUse( ent ) then
			GTowerHUD.DrawUseMessage( ent, x, w, h )
			if HUDStyle_L2 then return end
		end

		surface.SetMaterial( GTowerHUD.Crosshair.Material )

		if HUDStyle_L2 then
			local size = GTowerHUD.Crosshair.Size
			surface.SetDrawColor( color.r, color.g, color.b, 100 )
			surface.DrawTexturedRect( w - size/2, h - size/2, size, size )
		else
			local size = ScreenScale( 12 )
			local radius = size / 2

			surface.SetDrawColor( color.r, color.g, color.b, 150 )
			surface.DrawTexturedRect( w - radius, h - radius, size, size )
		end

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

		if HUDStyle_L2 then
			surface.SetMaterial( GTowerHUD.Info.Background )
			surface.SetDrawColor( GTowerHUD.Info.BGColor )
			surface.DrawTexturedRect( 0, GTowerHUD.Info.Y-2, GTowerHUD.Info.Width, GTowerHUD.Info.TextureHeight+4 )

			surface.SetMaterial( GTowerHUD.Info.Texture )
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.DrawTexturedRect( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.TextureWidth, GTowerHUD.Info.TextureHeight )
		else 
			surface.SetMaterial( GTowerHUD.Info.Texture )
			surface.SetDrawColor( GTowerHUD.Info.BGColor )
			surface.DrawTexturedRect( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.TextureWidth, GTowerHUD.Info.TextureHeight )
		end

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

		local x = GTowerHUD.Info.X + 75
		local y = GTowerHUD.Info.Y + 22

		if HUDStyle_L2 then
			local money = string.FormatNumber( GTowerHUD.Money.Amount )
			local tw, th = surface.GetTextSize( money )

			draw.SimpleShadowText( money, GTowerHUD.Money.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
			draw.SimpleShadowText( "GMC", GTowerHUD.Location.Font, x + tw + 4, y + 6, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
		elseif HUDStyle_Lobby1 then
			local money = string.FormatNumber( GTowerHUD.Money.Amount )

			local mTextW, mTextH = surface.GetTextSize( money )

			local mTextX = GTowerHUD.Info.X + 110
			local mTextY = GTowerHUD.Info.Y + 75 - ( mTextH / 2 )
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( mTextX, mTextY )
			surface.DrawText( money )
		elseif HUDStyle_Lobby1AB then
			local money = GTowerHUD.Money.Amount

			local mTextX = GTowerHUD.Info.X + 93
			local mTextY = GTowerHUD.Info.Y + 53
			surface.SetTextColor( 255, 255, 255, 255 )
			surface.SetTextPos( mTextX, mTextY )
			surface.DrawText( money )
		end
		
		-- Location
		local location = Location.GetFriendlyName( LocalPlayer():Location() ) or "Unknown"

		if GTowerHUD.Location.Enabled:GetBool() then
			if HUDStyle_L2 then
				local location = string.upper( location )

				y = y + 24
				draw.SimpleShadowText( location, GTowerHUD.Location.Font, x, y, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )
			elseif HUDStyle_Lobby1 then
				local location = string.upper( location )
				
				surface.SetFont( GTowerHUD.Location.Font )
				local mTextW, mTextH = surface.GetTextSize( location )
				local mTextX = GTowerHUD.Info.X + 91
				local mTextY = GTowerHUD.Info.Y + 103 - ( mTextH / 2 )

				draw.SimpleText( location, GTowerHUD.Location.Font, mTextX, mTextY, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			elseif HUDStyle_Lobby1AB then
				surface.SetFont( GTowerHUD.Location.Font )
				local w, h = surface.GetTextSize( location )

				local x = ( ScrW() / 2 ) - ( w / 2 )
				local y = ScrH() - h

				local bgColor = Color( 0, 139, 239, 100 )
				if HUDStyle_Lobby1A then
					bgColor = Color( 0, 0, 0, 100 )
				end

				// Background
				draw.RoundedBox( 6, x - 10, y, w + 20, h + 10, bgColor )

				// Texty
				draw.SimpleText( location, GTowerHUD.Location.Font, (ScrW() / 2) - (w / 2), ScrH() - h, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
			end
		end

		-- Condo
		local locid = LocalPlayer().GRoomId
	  	if HUDStyle_L2 && locid && locid != 0 then
			GTowerHUD.DrawExtraInfo( GTowerIcons2.GetIcon("condo"), "#" .. tostring(locid) )
	  	end

	end

	function GTowerHUD.DrawExtraInfo( icon, text, iconSize )

		local x = GTowerHUD.Info.X - 10
		local y = GTowerHUD.Info.Y + GTowerHUD.Info.TextureHeight + 4
		local tall = 20

		iconSize = iconSize or 32

		surface.SetDrawColor( GTowerHUD.Info.BGColor )
		surface.SetMaterial( GTowerHUD.Info.Background )
		surface.DrawTexturedRect( 0, y, GTowerHUD.Info.Width, tall )

		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( icon )
		surface.DrawTexturedRect( x, y + ( ( tall /2 ) - ( iconSize /2 ) ), iconSize, iconSize )

		draw.SimpleShadowText( text, "GTowerHUDMainSmall2", x+iconSize, y+10, color_white, color_black, TEXT_ALIGN_LEFT, 1, 1 )

	end

	function GTowerHUD.DrawUseMessage( ent, x, w, h )

		if HUDStyle_Lobby1AB then return end
		if HUDStyle_Lobby1 && ent:GetClass() != "gmt_multiserver" then return end

		if not IsValid( ent ) then return end

		local use, nokey = CanPlayerUse( ent )
		if not use then return end

		if use then

			if HUDStyle_Lobby1 then
				local message = "USE TO " .. string.upper( use )
				draw.SimpleText( message, GTowerHUD.Location.Font, w + 8, h - 8, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT )
				return
			end

			surface.SetFont( "GTowerHUDMain" )
			local tw, th = surface.GetTextSize(use)
			local offset = -(tw/2)

			if not nokey then

				local usekey = string.upper( input.LookupBinding( 'use' ) or "e" )

				surface.SetFont( "GTowerHUDMainLarge" )
				tw, th = surface.GetTextSize(usekey)
				tw = math.max(tw+8,th)
				offset = tw/2

				surface.SetDrawColor( 0, 0, 0, 200 )
				surface.DrawRect( w + x - tw/2, h - th/2 + 2, tw, th )

				draw.SimpleText( usekey, "GTowerHUDMainLarge", w + x, h - th/2, Color( 255, 255, 255, 255 ), 1 )

			end

			draw.SimpleShadowText( use, "GTowerHUDMain", w + x + 4 + offset, h, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), TEXT_ALIGN_LEFT, 1, 1 )

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
		surface.DrawRect( w - 512, h, 1024, 110 )
	
		-- Draw title
		draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )
	
		-- Draw text
		draw.DrawText( message or "", "GTowerHudCSubText", w, h + 30, Color( 255, 255, 255, 255 ), 1 )
	
	end

	function GTowerHUD.DrawShutdownNotice( title, message )

		-- Handle notice
		local w, h = ScrW() / 2, ScrH() / 2
		h = ( h * 2 ) - 150
	
		surface.SetDrawColor( 0, 0, 0, 230 )
		surface.DrawRect( w - 512, h, 1024, 110 )
	
		-- Draw title
		draw.SimpleText( title, "GTowerHudCText", w, h + 20, Color( 255, 255, 255, 255 ), 1, 1 )
	
		-- Draw text
		draw.DrawText( message or "", "GTowerHudCSubText", w, h + 30, Color( 255, 255, 255, 255 ), 1 )
	
	end

	function GTowerHUD.DrawHealth()

		// i dont see why not
		if !HUDStyle_Lobby1AB && !IsDueling(LocalPlayer()) && !Location.Is( LocalPlayer():Location(), "duelarena" ) then return end

		// Lobby 1 Health
		if !HUDStyle_L2 then

			local health = LocalPlayer():Health()
			if health < 0 then health = 0 end
			
			local healthX = GTowerHUD.Info.X + 50
			local healthY = GTowerHUD.Info.Y + 35

			if HUDStyle_Lobby1AB then
				healthX = GTowerHUD.Info.X + 69
				healthY = GTowerHUD.Info.Y + 81
			end

			if !HUDStyle_Lobby1AB then
				surface.SetDrawColor( 20, 103, 36, 255 )
				surface.DrawRect( healthX, healthY - 2, GTowerHUD.Health.MaxSize - 1, GTowerHUD.Health.Height + 4 )
			end

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

		if !HUDStyle_L2 then return end

		local w = GTowerHUD.Info.Width
		local h = 8
		local x = 0 --GTowerHUD.Info.X - 6
		local y = GTowerHUD.Info.Y - h - 6
		local iconSize = 32
		local health = LocalPlayer():Health()
		if health < 0 then health = 0 end
		local maxHealth = 100
		if IsDueling( LocalPlayer() ) then
			maxHealth = 300
		end
		local percent = ( health / maxHealth )
		local ratio = 1 - ( percent )
		local oppred = 200 - ratio * math.sin( CurTime() * ratio * 3 ) * 55 + ( 1 - ratio ) * 55

		-- Gradient background
		surface.SetDrawColor( GTowerHUD.Info.BGColor )
		surface.SetMaterial( GTowerHUD.Info.Background )
		surface.DrawTexturedRect( 0, y-10, w, 20 )

		-- Draw heart
		surface.SetDrawColor( 255, 255, 255 )
		surface.SetMaterial( GTowerIcons2.GetIcon("heart") )
		surface.DrawTexturedRect( x, y-16, iconSize, iconSize )

		-- Draw background
		surface.SetDrawColor( 80, 80, 80, 200 )
		surface.DrawRect( x+iconSize, y-4, w, h )

		-- Draw health bar
		surface.SetDrawColor( 255, 255, 255, 255 )
		draw.RectFillBorder( x+iconSize, y-4, w, h, 1, percent, Color( 125, 125, 125, 0 ), Color( 255, oppred, oppred ) )

	end

	function GTowerHUD.DrawAmmo()

		if !GTowerHUD.Ammo.Enabled:GetBool() then return end

		local weapon = LocalPlayer():GetActiveWeapon()

		if !IsValid( weapon ) then return end

		local name = weapon:GetPrintName()

		local currentMag = weapon:Clip1()
		local currentMax = 100 // default max
		local currentAmmoType = weapon:GetPrimaryAmmoType()
		local currentAmmoLeft = LocalPlayer():GetAmmoCount( currentAmmoType )

		// if we have uses, lets override the clip
		if LocalPlayer().UsesLeft != -1 then
			currentMag = LocalPlayer().UsesLeft
			currentMax = LocalPlayer().MaxUses
			currentAmmoLeft = currentMax
		else
			if weapon.Primary then
				currentMax = weapon.Primary.ClipSize
			else
				currentMax = GTowerHUD.GetMaxAmmo( name, currentMag )
			end
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

	function GTowerHUD.Paint()

		if !GTowerHUD.Enabled:GetBool() then return end

		// disable hud for camera swep
		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid( weapon ) && weapon:GetClass() == "gmt_camera" then return end

		// shit shit shit
		/*if ActiveJetpack && ActiveJetpack:IsValid() then
			jetpack.JetpackFuelDraw( GTowerHUD.Info.X, GTowerHUD.Info.Y, GTowerHUD.Info.Width, GTowerHUD.Info.Height-4 )
		end*/
		
		if HUDStyle_L2 then
			GTowerHUD.DrawHealth()
		end
		GTowerHUD.DrawInfo()
		if !HUDStyle_L2 then
			GTowerHUD.DrawHealth()
		end
		GTowerHUD.DrawVolumeIcon()

		GTowerHUD.DrawAmmo()
		--GTowerHUD.DrawNotice()
		--GTowerHUD.DrawNews()
		GTowerHUD.DrawCrosshair()

		--[[if !( HideBetaMessage:GetBool() and LocalPlayer():IsAdmin()  ) then
			draw.SimpleShadowText( "This game is still a work in progress, this beta may not represent the final quality of the product.", "GTowerHudCSubText", ScrW()/2, ScrH() - 50, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
			draw.SimpleShadowText( "Follow us at http://www.gmtower.org/", "GTowerHudCSubText", ScrW()/2, ScrH() - 25, Color( 255, 255, 255, 255 ), Color( 0, 0, 0, 230 ), 1, 1, 1 )
		end]]

	end

	local hud_icon_clock = Material( "gmod_tower/balls/hud_icon_clock" )
	surface.CreateFont( "BallFont", { font = "Coolvetica", size = 48, weight = 200 } )

	function GTowerHUD.Think()

	  if !LocalPlayer():Alive() then GtowerMainGui:GtowerHideMenus() end

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