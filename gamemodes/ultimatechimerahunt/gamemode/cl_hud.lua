include( "cl_targetid.lua" )

local sw, sh = ScrW(), ScrH()

local xhairtex = surface.GetTextureID( "UCH/hud_pig_crosshair" )
local glass = surface.GetTextureID( "UCH/ghost_glass" )
local saturn = surface.GetTextureID( "UCH/hud_saturn" )

local function TextSize( font, txt )
	surface.SetFont( font )
	local w, h = surface.GetTextSize( txt )
	return { w, h }
end

function GM:DrawNiceText( txt, font, x, y, clr, alignx, aligny, dis, alpha )
	
	local tbl = {
		pos = {
			[1] = x,
			[2] = y
		},
		color = clr,
		text = txt,
		font = font,
		xalign = alignx,
		yalign = aligny
	}

	draw.TextShadow( tbl, dis, alpha )
	
end

local function DrawNiceBox( x, y, w, h, clr, dis )

	local clr2 = Color( clr.r, clr.g, clr.b, clr.a * .5 )
	
	draw.RoundedBox( 4, x - dis, y - dis, w + ( dis * 2 ), h + ( dis * 2 ), clr )
	draw.RoundedBox( 2, x, y, w, h, clr2 )
	
end

local function DrawInfoBox( txt, x, y )
	
	local dis = ( y * .05 )
	local bob = math.sin((CurTime() * 4))
	
	y = ( y + ( dis * bob))
	
	local tsize = TextSize( "TargetID", txt )
	local tw, th = tsize[1], tsize[2]
	DrawNiceBox( x - ( tw * .6 ), y - ( th * .6 ), tw * 1.2, th * 1.2, Color( 10, 10, 10, 125 ), 4 )
	
	GAMEMODE:DrawNiceText( txt, "TargetID", x, y, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, 200 )
	
end

local function DrawCrosshair()

	local ply = LocalPlayer()
	if ply:GetNet("IsChimera") then return end
	
	local xalpha = 100
	
	ply.XHairAlpha = ( ply.XHairAlpha || xalpha )
	local alpha = ply.XHairAlpha
	
	if alpha != xalpha then
		ply.XHairAlpha = math.Approach( ply.XHairAlpha, xalpha, FrameTime() * 150 )
	end
	
	local rankcolor = ply:GetRankColor()
	local color = Color( rankcolor.r, rankcolor.g, rankcolor.b, alpha )
	
	surface.SetTexture( xhairtex )
	surface.SetDrawColor( color )
	surface.DrawTexturedRectRotated( sw * .5, sh * .5, sh * .04, sh * .04, 0 )
	
	if ply:IsGhost() && ply:GetNet("IsFancy") then

		surface.SetTexture( glass )
		surface.SetDrawColor( Color( 255, 255, 255, 160) )
		surface.DrawTexturedRectRotated( sw * .515, sh * .5, sh * .028, sh * .028, -12 )
		
	end

	/*if ply:IsPig() && ply:GetNet("HasSaturn") then

		surface.SetTexture( saturn )
		surface.SetDrawColor( Color( 255, 255, 255, 200 ) )
		surface.DrawTexturedRectRotated( sw * .520, sh * .5, sh * .028, sh * .028, -12 )
		
	end*/
	
end

local xx, yy, ww, hh = .28, .2725, .375, .12

local pigmat = Material( "UCH/hud/pighud_empty" )
local hudmat_3d = Material("models/uch/pigmask/pigmaskhud")
local hudmat_3d_flat = Material("models/uch/uchimera/chimerahud")
local ucmat = surface.GetTextureID( "UCH/hud/chimerahud_empty" )

local fps = 12
local fps_table = {
	["run"] = 16,
	pig = {
		["run"] = 20,
		["walk"] = 20,
		["taunt"] = 18,
		["taunt2"] = 18,
		["crawl"] = 18,
		["jump"] = 20
	}
}

local limit = CreateClientConVar( "gmt_uch_hud_fps", "1", true )

local crouch = 0
local crawl = 0

function GM:DrawHUD()
	
	local ply = LocalPlayer()
	local mat = pigmat

	local color = ply:GetRankColor()
	PAYOUT_COLOR = {Color(color.r * 0.65, color.g * 0.65, color.b * 0.65), color}

	local c = ply:Team() == TEAM_CHIMERA

	if !ply:IsGhost() && ( !IsValid( model ) || model.Entity:GetModel() == ply:GetModel() ) then

		c = string.find( ply:GetModel(), "chimera" )

		if !IsValid( model ) then

			model = vgui.Create( "DModelPanel" )
			model:SetModel(ply:GetModel())
			model.Entity:SetMaterial( c && "models/uch/uchimera/chimerahud" || "models/uch/pigmask/pigmaskhud" )

			local h = ( sh * ( c and 0.12 || .14 ) )
			model:SetSize( h, h )

			if c then

				model.Entity:SetBodygroup(1, 1)

			end

			model.Cycle = 0
			model.FPS = 0

			model.LayoutEntity = function( _, ent )
				
				local cycle = ply:GetCycle()
				local name = ply:GetSequenceName(ply:GetSequence())

				local fps = !c && fps_table["pig"][name] || fps_table[name] or fps
				fps = 1 / fps

				if name == "idle" || name == "crouchidle" then

					_.Cycle = 0.5

				elseif _.FPS < SysTime() then

					_.Cycle = cycle
					_.FPS = SysTime() + fps

				end


				if limit:GetBool() then

					cycle = _.Cycle

				end

				if ent:GetSequence() != ply:GetSequence() then
					// ent:ResetSequence( 0 or ply:GetSequence() )
					ent:SetSequence(ply:GetSequence())
				end
				
				//ent:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, ply:GetSequence(), cycle, true)
				ent:SetModel("models/error.mdl")
				ent:SetModel(ply:GetModel())
				ent:SetSequence(ply:GetSequence())
				ent:SetCycle( cycle )
				ent:SetBodygroup( 2, ply:GetBodygroup( 2 ) )
			
			end

			model:SetFOV( c && 95 || 80 )
			model:SetCamPos( Vector( c && 64 || 32, c and -128 or -84, c && 32 || 32 ) )
			model:SetLookAt( Vector( c and 10 or 0, 0, 64 ) )
			model:SetPaintedManually( true )

		end

	else
		
		if IsValid( model ) then

			model:Remove()

		end

	end

	if c then
		
		mat = ucmat

		local h = ( sh * .285 )
		local w = ( h * 2 )
		
		local x, y = ( sw * -.0385), ( sh * .732 )
		
		local spx, spy = ( x + ( w * .285)), ( y + ( h * .58))
		local spw, sph = ( w * .505), ( h * .145 )
		self:DrawSprintBar( spx, spy, spw, sph )
		
		local rrx, rry = ( x + ( w * .2825)), ( y + ( h * .43))
		local rrw, rrh = ( w * .3775), ( h * .115 )
		self:DrawRoarMeter( rrx, rry, rrw, rrh )
		
		local tsx, tsy = ( x + ( w * .28)), ( y + ( h * .2725))
		local tsw, tsh = ( w * .375), ( h * .12 )
		self:DrawSwipeMeter( tsx, tsy, tsw, tsh )
		
		surface.SetTexture( ucmat )
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
		surface.DrawTexturedRect( x, y, w, h )

		hudmat_3d_flat:SetVector( "$color2", (Vector(78, 20, 50) / 255) * 3.5 )
		
		model:SetPos( 0, spy - sph * 1.1 )
		model:PaintManual()

	elseif !ply:IsGhost() then
		
		local h = ( sh * .14 )
		local w = ( h * 4 )
		
		local x, y = ( sw * -.035), ( sh * .85 )
		
		local spx, spy = ( x + ( w * .286)), ( y + ( h * .35))
		local spw, sph = ( w * .51), ( h * .275 )
		self:DrawSprintBar( spx, spy, spw, sph )

		local color = ply:GetRankColorSat()

		color = color:ToVector()

		if ply:GetNet("Rank") == RANK_ENSIGN then
			color = (Vector(255, 124, 160) / 255) * 1.4
		elseif ply:GetNet("Rank") == RANK_COLONEL then
			color = Vector(2, 2, 2)
		end

		surface.SetMaterial( pigmat )
		pigmat:SetVector( "$color2", color )
		hudmat_3d:SetVector( "$color2", color )
		surface.SetDrawColor( color_white || Color( color.r, color.g, color.b ) )
		surface.DrawTexturedRect( x, y, w, h )

		local name = ply:GetSequenceName(ply:GetSequence())
		local crawl = name == "crawl" && 1 || 0
		local crouch = name == "crouchidle" && 1 || crawl

		model:SetPos( 0, y )
		model:SetLookAt( Vector( 4 * crouch + 4 * crawl, 0, 32 - 0 * crouch - 8 * crawl ) )
		model:SetCamPos( Vector( 32, -84, 32 + 8 * crawl ) )
		model:SetFOV( 80 + 4 * crawl )
		model:PaintManual()

	end
	
	
end

local teeth = Material("uch/teeth.png")
local bite = 0

function GM:DrawBite()

	local w = 256

	bite = math.Approach(bite, LocalPlayer():Alive() && LocalPlayer():IsFrozen() && 1 || 0, FrameTime() * 8)

	if bite == 0 then return end

	local amount = ScrW() / w

	local y = Lerp(bite, -w, ScrH() * 0.5 * bite)
	y = math.Round(y)
	draw.RoundedBox(0, 0, y - ScrH() * 0.5, ScrW(), ScrH() * 0.5, color_black)
	draw.RoundedBox(0, 0, ScrH() - y, ScrW(), ScrH() * 0.5, color_black)

	surface.SetMaterial(teeth)
	surface.SetDrawColor(color_black)

	for i = 0, amount do
		surface.DrawTexturedRectRotated(w * i + w / 2, y + w, w, w * 2, 180)
		surface.DrawTexturedRectRotated(w * i, ScrH() - y - w, w, w * 2, 0)
	end
	
end

function GM:HUDPaint()
	
	local ply = LocalPlayer()

	local txt = nil
	
	if self:GetState() == STATE_WAITING then
		
		txt = "Waiting for players..."

	end

	if txt then
		DrawInfoBox( txt, sw * .5, sh * .185 )
	end

	if ( ( ply:Alive() && ply:Team() == TEAM_PIGS ) || ply:IsGhost() ) && !ply:GetNet("IsTaunting") && !ply:GetNet("IsScared") then
		DrawCrosshair()
	end
	
	self:DrawHUD()
	self:DrawKillNotices()
	self:DrawTargetID()
	self:DrawRoundTime()
	self:DrawSaturn()
	self:DrawBite()

end

local HiddenHud = { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudCrosshair", "CHudWeapon", "CHudChat" }
function GM:HUDShouldDraw(  name  )

	for _, v in ipairs(  HiddenHud  ) do
		if name == v then return false end
	end
	
	return true
end