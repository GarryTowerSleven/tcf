if SERVER then
	AddCSLuaFile( "shared.lua" )

	function SWEP:Deploy()
		self:GetOwner():DrawViewModel( false )
	end

	function SWEP:DoRotateThink() end
else
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= false
end

SWEP.PrintName		= "Camera"	
SWEP.Base			= "weapon_base"
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/MaxOfS2D/camera.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.ShootSound				= "NPC_CScanner.TakePhoto"

SWEP.CameraZoom				= 80
SWEP.Roll					= 0

function SWEP:Initialize()
	self:SetWeaponHoldType( "camera" )
end

function SWEP:Precache()
	util.PrecacheSound( self.ShootSound )
end

function SWEP:Reload()

	self:GetOwner():SetFOV( 80, 0 )
	self.CameraZoom = 80
	self.Roll = 0

end

function SWEP:DoShootEffect()

	// self:EmitSound( self.ShootSound, 75, 60	)
	self:EmitSound("npc/scanner/scanner_photo1.wav", 75, 60)
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 )
	
	local vPos = self:GetOwner():GetShootPos()
	local vForward = self:GetOwner():GetAimVector()

	local trace = {}
		trace.start = vPos
		trace.endpos = vPos + vForward * 256
		trace.filter = self:GetOwner()

	tr = util.TraceLine( trace )

	local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos )
	util.Effect( "camera_flash", effectdata, true )
	
end

local PHOTO = false

local function getXYWH()
	return ScrW() / 8, ScrH() / 8, ScrW() / 1.333, ScrH() / 1.333, ScrW() / 2, ScrH() / 2
end

local ring

hook.Add("PostRender", "test", function()
	if PHOTO then
		local x2, y2, w2, h2 = getXYWH()
		DRAWING = true
		local data = render.Capture( {
			format = "jpeg",

			x = 0, y = 0, w = ScrW(), h = ScrH(),
			quality = 100
		} )
		DRAWING = false
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), color_black)
	
		local id = CurTime()
		file.Write( "image" .. id .. ".png", data )
		PHOTO = false

		local photo = vgui.Create("DPanel")
		photo:SetSize(ScrW(), ScrH())
		photo.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_black)
		end
		local flash = vgui.Create("DPanel", photo)
		flash.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_black)
		end
		flash:Dock(FILL)
		flash:AlphaTo(0, 0.01, 0.7)

		hook.Add("CalcView", "test", function()
		local mat = Material("../data/image" .. id .. ".png")
		mat:Recompute()
		photo.Paint = function(self, w, h)
			draw.RoundedBox(0, 0, 0, w, h, color_black)

			surface.SetMaterial(mat)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(0, 0, w, h)
		end



		local ply = LocalPlayer()
		local w, h = ScrW(), ScrH()
	
		local found = {}
	
		local t = 0.7

		timer.Simple(t, function()
			RunConsoleCommand("jpeg")
		end)

		local types = {
			[0] = {
				"NO GENRE",
				Color(200, 200, 200)
			},
			[1] = {
				"PARTY",
				Color(255, 255, 0)
			},
			[2] = {
				"BRUTALITY",
				Color(255, 0, 0)
			},
			[3] = {
				"EROTICA",
				Color(255, 100, 100)
			}
		}

		local valid = {
			["gmt_visualizer_obama"] = 1,
			["gmt_mrsaturn"] = 2,
			["models/gmod_tower/sunshrine.mdl"] = 3
		}
		for _, ply in ipairs(ents.GetAll()) do
			if !ply:IsPlayer() and !valid[ply:GetModel()] and !valid[ply:GetClass()] and ply.Base ~= "gmt_npc_base" then continue end
			if util.TraceLine({
				start = LocalPlayer():EyePos(),
			endpos = ply:EyePos(), filter = LocalPlayer()
			}).HitWorld then continue end
			if ply == LocalPlayer() then continue end

			local ss = string.Split(ply:GetModel(), "/")
			local name = ply.Nick and ply:Nick() or string.StripExtension(ss[#ss])
			local type = valid[ply:GetModel()] or valid[ply:GetClass()] or 0
			if ply:GetNWBool("Dancing") or string.find(ply:GetSequence(), "taunt") then
				type = 1
			elseif ply.GetActiveWeapon and IsValid(ply:GetActiveWeapon()) && ply:GetActiveWeapon():GetHoldType() ~= "normal" then
				type = 2
			end
			table.insert(found, {ply:GetAttachment(1) and ply:GetAttachment(1).Pos or ply.EyePos and ply:EyePos():Distance(ply:GetPos()) > 0 and ply:EyePos() or ply:WorldSpaceCenter(), type, name or ply.Nick and ply:Nick() or ply:GetClass()})
		end

		local rating = 1000
		local panels = {}
		local valid = {}
		local remove = 0
		local pp = 0

		for _, f in ipairs(found) do
			local p = f[1]
			local p2 = p
			p = p:ToScreen()
			if p.x < x2 or p.x > x2 + w2 or p.y < y2 or p.y < y2 or p.y > y2 + h2 then remove = remove + 1 continue end
			_ = _ - remove
			local pnl = vgui.Create("DPanel", photo)
			local dis = p2:Distance(LocalPlayer():EyePos())
			local zoom = LocalPlayer():GetActiveWeapon().CameraZoom - 80
			zoom = zoom / (120 - 80)
			local s = ScrW() / 24 - dis * 0.1
			s = s * (1 + -zoom)
			pnl:SetSize(ScrW(), math.max(s, 24))
			pnl:SetPos(p.x - pnl:GetTall() / 2, p.y - pnl:GetTall() / 2)

			if f[2] ~= 0 then
				if !valid[f[2]] then
					valid[f[2]] = 1
				else
					valid[f[2]] = valid[f[2]] + 1
				end
			end

			local type = types[f[2]]

			pnl:Hide()
			table.insert(panels, pnl)

			t = t + math.max(0.6 - (#found * 0.1), 0.1)

			local r = rating
			local d2 = dis * (1 + zoom)
			rating = rating - (d2 < 200 and d2 > -400 and -400 or d2 > 400 and 200 or -200)
			r = rating - r

			r = math.floor(Lerp(dis/ 400, 200, 20))
			timer.Simple(t, function()
				surface.PlaySound("friends/message.wav")
				pnl:Show()
				pp = pp + r
				local pp = vgui.Create("DLabel", photo)
				pp:SetText(r)
				pp:SetSize(640, 480)
				pp:SetPos(x2 + w2 - 40 - w2 / 2, y2 + 40 + _ * 40)
				pp:SetFont("GTowerHUDMainLarge")
				pp:SetColor(type[2])
				pp:SetText("")
				pp.Text = f[3] .. "              " .. r
				pp.Paint = function(self, w, h)
					draw.SimpleTextOutlined(self.Text or self:GetText(), self:GetFont(), 640, 0, self:GetColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
				end
			end)


				pnl.Paint = function(self, w, h)
					// draw.RoundedBox(0, 0, 0, w, h, (p:Distance(LocalPlayer():GetPos()) < 400 and Color(128, 255, 0) or Color(160, 160, 160)))
					surface.SetTexture(ring)
					local color = type[2] or r > 0 and Color(128, 255, 0) or Color(164, 164, 164)
					surface.SetDrawColor(color_black)
					surface.DrawTexturedRect(-4, -4, h + 8, h + 8)
					surface.SetDrawColor(color)
					surface.DrawTexturedRect(0, 0, h, h)
					draw.SimpleTextOutlined("<", "GTowerHUDMainLarge", h, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, Color(color.r / 2, color.g / 2, color.b / 2, 64))
				end
		end

		local total = vgui.Create("DLabel", photo)
		total:SetPos(x2 + w2 - 40 - w2 / 2, y2)
		total:SetSize(640, 480)
		total:SetFont("GTowerHUDMainLarge")
		total:SetText("")
		total:SetAlpha(0)

		total.Think = function(self)
			if pp > 0 then
				total:SetAlpha(255)
			end
			self.Text = "TOTAL:     " .. pp .. " PP"
		end

		total.Paint = function(self, w, h)
			draw.SimpleTextOutlined(self.Text or self:GetText(), self:GetFont(), 640, 0, self:GetColor(), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, color_black)
		end

		local type = 0
		local max = 0
		for _, m in pairs(valid) do
			if m > max then
				type = _
				max = m
			end
		end
		type = types[type]
		local rated = rating >= 1400 and "FANTASTIC!!" or rating > 1000 and "NICE!" or ""
		local color = type[2] or rated == "NICE!" and Color(128, 255, 0) or Color(169, 169, 169)

		// t = t + 0.4

		timer.Simple(t, function()
			surface.PlaySound("friends/friend_join.wav")

			local nice = vgui.Create("DPanel", photo)
			nice:SetSize(w, h / 2)
			nice:Center()
			local _, y = nice:GetPos()
			nice:SetPos(w, y)
			nice:MoveTo(0, y, 0.2, 0, 0.4)
			nice.Paint = function(self, w, h)
				draw.SimpleTextOutlined(rated or "NICE!", "GTowerHUDMainLarge", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				//draw.SimpleText("NO GENRE", "GTowerHUDMainLarge", w / 2, h / 1.8, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local oldnice = nice
			local nice = vgui.Create("DPanel", photo)
			nice:SetSize(w, h / 2)
			nice:Center()
			local _, y = nice:GetPos()
			nice:SetPos(-w, y)
			nice:MoveTo(0, y, 0.2, 0, 0.4)
			nice.Paint = function(self, w, h)
				//draw.SimpleText(rated or "NICE!", "GTowerHUDMainLarge", w / 2, h / 2, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleTextOutlined(type[1] or "NO GENRE", "GTowerHUDMainLarge", w / 2, h / 1.8, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end

			photo:AlphaTo(0, 1, 2, function() photo:Remove() end)
			timer.Simple(2, function()
				nice:MoveTo(w, y, 0.2, 0, -0.4)
				oldnice:MoveTo(-w, y, 0.2, 0, -0.4)
			end)

			timer.Simple(2, function()

				file.Delete("image" .. id .. ".png")
			end)
		end)
		hook.Remove("CalcView", "test")
	end)
	end
end)

function NICESHOT()


	PHOTO = true
	
end

function SWEP:PrimaryAttack()

	self:DoShootEffect()

	self:SetNextPrimaryFire(CurTime() + 8)

	if !CLIENT || !IsFirstTimePredicted() then return end
	
	PHOTO = true
	// PICTURE = true
	// self:GetOwner():ConCommand( "jpeg" )
	// render.CapturePixels()
	timer.Simple(0.1, function()
		// NICESHOT()
	end)
end

function SWEP:SecondaryAttack() end

function SWEP:Think()

	local cmd = self:GetOwner():GetCurrentCommand()
	
	self.LastThink = self.LastThink or 0
	local fDelta = (CurTime() - self.LastThink)
	self.LastThink = CurTime()

	self:DoZoomThink( cmd, fDelta )
	self:DoRotateThink( cmd, fDelta )

end

function SWEP:DoZoomThink( cmd, fDelta )

	// Right held down
	if SERVER then return end
	if ( !self:GetOwner():KeyDown( IN_ATTACK2 ) ) then return end
	
	self.CameraZoom = math.Clamp( self.CameraZoom + cmd:GetMouseY() * 3 * fDelta, 5, 80 )
	
	self:GetOwner():SetFOV( self.CameraZoom, 0 )

end

function SWEP:CanSecondaryAttack()
	return true
end

if SERVER then return end

function SWEP:FreezeMovement()

	if ( self.m_fFreezeMovement ) then
	
		if ( self.m_fFreezeMovement > RealTime() ) then return true end
	
		self.m_fFreezeMovement = nil
	
	end

	// Don't aim if we're holding the right mouse button
	if ( self:GetOwner():KeyDown( IN_ATTACK2 ) || self:GetOwner():KeyReleased( IN_ATTACK2 ) ) then return true end
	return false
	
end

function SWEP:CalcView( ply, origin, angles, fov )

	if ( self.Roll != 0 ) then
		angles.Roll = self.Roll
	end

	if (!self.TrackEntity || !self.TrackEntity:IsValid()) then return origin, angles, fov end
	
	local AimPos = self.TrackEntity:GetPos()
	
	self.LastAngles = self.LastAngles or angles
	
	if ( self.TrackOffset ) then
	
		// local Distance = AimPos:Distance( self:GetOwner():GetShootPos() )
	
		AimPos = AimPos + Vector(0,0,1) * self.TrackOffset.y * 256
		AimPos = AimPos + self.LastAngles:Right() * self.TrackOffset.x * 256
	
	end
	
	local AimNormal = AimPos - self:GetOwner():GetShootPos()
	AimNormal = AimNormal:GetNormal()
	
	angles = AimNormal:Angle() //LerpAngle( 0.1, self.LastAngles, AimNormal:Angle() )

	// Setting the eye angles here makes it so the player is actually aiming in this direction
	// Rather than just making their screen render in this direction.
	self:GetOwner():SetEyeAngles( Angle( angles.Pitch, angles.Yaw, 0 ) )
	
	self.LastAngles = angles
	
	if ( self.Roll != 0 ) then
		angles.Roll = self.Roll
	end
	
	return origin, angles, fov
	
end

function SWEP:DoRotateThink( cmd, fDelta )
	if SERVER then return end

	// Think isn't frame rate independant on the client.
	// It gets called more per frame in single player than multiplayer
	// So we will have to make it frame rate independant ourselves

	// Right held down
	if ( self:GetOwner():KeyDown( IN_ATTACK2 ) ) then

		self.Roll = self.Roll + cmd:GetMouseX() * 0.5 * fDelta
		
	end
	
	// Right released
	if ( self:GetOwner():KeyReleased( IN_ATTACK2 ) ) then

		// This stops the camera suddenly jumping when you release zoom
		self.m_fFreezeMovement = RealTime() + 0.1
		
	end

	// We are tracking an entity. Trace mouse movement for offsetting.
	if ( self.TrackEntity && self.TrackEntity != NULL && !self:GetOwner():KeyDown( IN_ATTACK2 ) ) then
	
		self.TrackOffset = self.TrackOffset or Vector(0,0,0)
		
		local cmd = self:GetOwner():GetCurrentCommand()
		self.TrackOffset.x = math.Clamp( self.TrackOffset.x + cmd:GetMouseX() * 0.005 * fDelta, -0.5, 0.5 )
		self.TrackOffset.y = math.Clamp( self.TrackOffset.y - cmd:GetMouseY() * 0.005 * fDelta, -0.5, 0.5 )
	
	end

	// If we're pressing use scan for an entity to track.
	if ( self:GetOwner():KeyDown( IN_USE ) && !self.TrackEntity ) then
	
		self.TrackEntity = self:GetOwner():GetEyeTrace().Entity
		if ( self.TrackEntity && !self.TrackEntity:IsValid() ) then
		
			self.TrackEntity = nil
			self.LastAngles = nil
			self.TrackOffset = nil
		
		end
	
	end
	
	// Released use. Stop tracking.
	if ( self:GetOwner():KeyReleased( IN_USE ) ) then
	
		self.TrackEntity = nil
		self.LastAngles = nil
		self.TrackOffset = nil
	
	end
	
	// Reload isn't called on the client, so fire it off here.
	if ( self:GetOwner():KeyPressed( IN_RELOAD ) ) then
	
		self:Reload()
	
	end

end

function SWEP:TranslateFOV( current_fov )
	
	return self.CameraZoom

end

function SWEP:AdjustMouseSensitivity()

	if ( self:GetOwner():KeyDown( IN_ATTACK2 )  ) then return 1 end

	return 1 * ( self.CameraZoom / 80 )
	
end

ring = surface.GetTextureID("effects/select_ring")
function SWEP:DrawHUD()

	local s = 8
	/*draw.RoundedBox(0, 0, 0, ScrW() / s, ScrH(), color_black)
	draw.RoundedBox(0, 0, 0, ScrW(), ScrH() / s, color_black)
	draw.RoundedBox(0, ScrW() - ScrW() / s, 0, ScrW() / s, ScrH(), color_black)
	draw.RoundedBox(0, 0, ScrH() - ScrH() / s, ScrW(), ScrH() / s, color_black)*/

	local x2, y2, w2, h2 = getXYWH()
	// draw.RoundedBox(0, x2, y2, w2, h2, color_white)

	if PHOTO then LocalPlayer():ScreenFade(SCREENFADE.IN, color_black, 0.1, 0.1) return end
	draw.RoundedBox(0, x2, y2, w2, 4, color_white)
	draw.RoundedBox(0, x2, y2, 4, h2, color_white)
	draw.RoundedBox(0, x2 + w2 - 4, y2, 4, h2, color_white)
	draw.RoundedBox(0, x2, y2 + h2 - 4, w2, 4, color_white)

	if self:GetNextPrimaryFire() > CurTime() then
		draw.SimpleText("RECHARGING", "DermaLarge", ScrW() / 2, ScrH() / 1.4, Color(255, 0, 0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if true or !self:GetOwner():IsAdmin() then return end
	if PICTURE then return end
	//local function TakePicture()
	//	render.CapturePixels()
	//end

	// Draw
	local function DrawScreenPixels( spacing, scale, offsetX, offsetY )

		render.CapturePixels()

		local spacing = spacing or 30
		local scale = scale or .3
		local size = spacing * scale

		for x=0, ScrW(), spacing do
			for y=0, ScrH(), spacing do

				local r, g, b = render.ReadPixel( x, y )
				
				surface.SetDrawColor( r, g, b, 255 )
				surface.DrawRect( offsetX + x*scale, offsetY + y*scale, size, size )

			end
		end

	end

	//DrawScreenPixels( 10, .5, ScrW() / 2 * .5, ScrH() / 2 * .5 )

	local DEBUG = true

	// Determines if they're properly in the frame
	local function IsInFrame( size, max, min, col )

		local x1, x2, y1, y2 = max.x, min.x, min.y, max.y
	
		local frame = size or ScreenScale( 50 )
		local frameWidth = ( ScrW() - ( frame * 2 ) )
		local frameHeight = ( ScrH() - ( frame * 2 ) )

		x1 = Lerp(0.5, x1, x2)
		y1 = Lerp(0.5, y1, y2)

		if DEBUG then
			surface.SetDrawColor( 255, 255, 255, 25 )
			surface.DrawRect( frame, frame, ( ScrW() - ( frame * 2 ) ), ( ScrH() - ( frame * 2 ) ) )
			local p1, p2 = {
				Vector(min.x, min.y) + Vector(0, 0), Vector(min.x, min.y) + Vector(0, 0) + Vector(frame, frame)
			}
			local a = LerpVector(0.5, p1[1], p1[2])
			draw.RoundedBox(0, x1 - frame / 2, y1 - frame / 2, frame, frame, col or color_white)
		end

		local function inBounds( min, max, offset, size )
			return ( min > offset && max > offset && min < ( size + offset ) && max < ( size + offset ) )
		end

		return inBounds( x1, x2, frame, frameWidth ) && inBounds( y1, y2, frame, frameHeight )

	end

	// Returns if we can actually see them in the shot!
	local function InShot( ent, max, min )

		// Framing
		if !IsInFrame( ScreenScale( 50 ), max, min ) then
			return false
		end

		// Dist
		if LocalPlayer():GetPos():Distance( ent:GetPos() ) > 1024 then
			return false
		end

		// Trace
		local tr = util.TraceLine( { 
			start = LocalPlayer():EyePos(), 
			endpos = util.GetCenterPos( ent ), 
			filter = LocalPlayer()
		} )

		if tr.HitWorld then
			return false
		end

		return true

	end

	// Draws a camera ranking
	local function ShowCameraRank( text, x, y, ent, color )

		color = color or Color( 255, 255, 255 )

		local dist = LocalPlayer():GetPos():Distance( ent:GetPos() )
		local ringSize = 100 - ( dist * .1 )
		surface.SetDrawColor( color )
		surface.SetTexture( ring )
		surface.DrawTexturedRect( x - ( ringSize / 2 ), y - ( ringSize / 2 ), ringSize, ringSize )

		draw.SimpleText( text, "GTowerHUDMainLarge", x + ( ringSize / 2 ) + 5, y - 20, color )

	end

	local function GetScrRender( ent )

		local min, max = ent:GetRenderBounds()
		local pos = ent:GetPos()
		min = pos + min
		max = pos + max

		local center = ent:EyePos() or util.GetCenterPos( ent )
		if !center then return end
		local centerScr = center:ToScreen()

		local minScr = min:ToScreen()
		local maxScr = max:ToScreen()

		if DEBUG then
			surface.SetFont( "DebugFixed" )
			surface.DrawRect( minScr.x, maxScr.y, maxScr.x - minScr.x, minScr.y - maxScr.y )
			surface.DrawRect( maxScr.x, minScr.y, minScr.x - maxScr.x, maxScr.y - minScr.y )

			local function drawXY( x, y, name )
				surface.SetTextPos( x, y )
				surface.DrawText( name .. " X: " .. x .. " Y: " .. y )
			end

			drawXY( maxScr.x, maxScr.y, "max" )
			drawXY( minScr.x, minScr.y, "min" )
		end

		return minScr, maxScr, centerScr

	end

	for _, ply in pairs( ents.FindByClass( "player" ) ) do

		if ply == LocalPlayer() then continue end

		// Get screen render positions...
		local minScr, maxScr, centerScr = GetScrRender( ply )

		if !minScr || !maxScr || !centerScr then continue end

		// They're in the shot!
		if InShot( ply, maxScr, minScr ) then
			local distance = ply:GetPos():Distance(EyePos())

			if IsInFrame( ScreenScale( 64 ), maxScr, minScr, Color(5, 215, 5, 64) ) and distance < 400 then
				ShowCameraRank( "EXCELLENT FRAMING", centerScr.x, centerScr.y, ply, Color( 5, 215, 5, 255 ) )
			elseif IsInFrame( ScreenScale( 80 ), maxScr, minScr ) and distance < 400 then
				ShowCameraRank( "NICE FRAMING", centerScr.x, centerScr.y, ply, Color( 250, 90, 220, 255 ) )
			elseif distance < 800 then
				ShowCameraRank( "OKAY FRAMING", centerScr.x, centerScr.y, ply, Color( 110, 110, 110, 255) )
			end

		end

	end

end