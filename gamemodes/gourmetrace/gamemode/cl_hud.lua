--surface.CreateFont( "AlphaFridgeMagnets ", ScreenScale( 18 ), 500, true, false, "GR_time" )
--surface.CreateFont( "AlphaFridgeMagnets ", ScreenScale( 24 ), 500, true, false, "GR_time_large" )
surface.CreateFont( "GR_time", { font = "Kirby Classic", size = ScreenScale( 18 ), weight = 500, antialias = true, additive = false } )
surface.CreateFont( "GR_time_large", { font = "Kirby Classic", size = ScreenScale( 24 ), weight = 500, antialias = true, additive = false } )
surface.CreateFont( "GR_score", { font = "Apple Kid Regular", size = ScreenScale( 30 ), weight = 500, antialias = true, additive = false } )
surface.CreateFont( "PowerupTitle", { font = "Bebas Neue", size = 100, weight = 100 } )

local hud_timer = Material("gmod_tower/gourmetrace/hud/hud_timer")
local hud_finish = Material("gmod_tower/gourmetrace/hud/hud_finish")
local hud_score = Material("gmod_tower/gourmetrace/hud/hud_score")

// Powerups
local hud_none = Material("gmod_tower/gourmetrace/hud/powerups/hud_none")
local hud_bomb = Material("gmod_tower/gourmetrace/hud/powerups/hud_bomb")
local hud_boomerang = Material("gmod_tower/gourmetrace/hud/powerups/hud_boomerang")
local hud_frost = Material("gmod_tower/gourmetrace/hud/powerups/hud_frost")
local hud_spikes = Material("gmod_tower/gourmetrace/hud/powerups/hud_spikes")
local hud_star = Material("gmod_tower/gourmetrace/hud/powerups/hud_star")

local timeout = false
local ShowPowerup = false

local dots = "."

timer.Create("DotTimer",1,0,function()
	if dots == "." then dots = ".."
	elseif dots == ".." then dots = "..."
	elseif dots == "..." then dots = "." end
end)

local expand = 10
local EndLife = 0
local PuName = ""

function GM:HUDPaint()

	self:PaintRounds()
	self:PaintTimer()

	if expand < 10 then
		expand = expand + 0.2
	end

	surface.SetDrawColor(25,25,25,math.max( (EndLife-CurTime()) * 255, 0 ))
	surface.DrawRect(

		ScrW()/2 + (75/2) * (1-11),

		ScrH()/5 + (10/2) * (1-expand),

		75 * expand,

		10 * expand)
		draw.DrawText("YOU GOT "..PuName,"PowerupTitle",ScrW()/2,ScrH()/5 + (10/2) * (1-expand),Color( 255, 255, 255, math.max( (EndLife-CurTime()) * 255, 0 ) ),1)

end

function GM:PaintRounds()

	local CurRound = GetGlobalInt("Round")
	local MaxRound = GAMEMODE.NumRounds

	// Font doesn't support slashes and spaces are too big
	local SmallSpace = " " --1/6 em space, 2 times as small as a normal space.
	local RoundText = tostring("ROUND " .. CurRound .. SmallSpace .. "I" .. SmallSpace .. MaxRound)

	draw.NiceText( RoundText,
	"GR_time",
	25,
	25,
	Color( 255, 255, 255, 255 ),
	TEXT_ALIGN_LEFT,
	TEXT_ALIGN_LEFT,
	3,
	150)

end

function GM:PaintTimer()

	local TimeLeft = self:GetTimeLeft()
	local ElapsedTime = string.FormattedTime( TimeLeft, "%02i:%02i" )

	if TimeLeft < 0 then return end

	local x, y = ( ScrW() / 2 ), ( ( ScrH() - ScrH() ) + 50 )

	if self:GetGameState() == STATE_WARMUP then
		x = ScrW() / 2
		y = ScrH() / 2
	end

	local timerX, timerY = (ScrW() / 2) - 195, 5

	surface.SetMaterial(hud_timer)
	surface.SetDrawColor(255,255,255,255)
	if self:GetGameState() != STATE_WARMUP then
		surface.DrawTexturedRect(timerX, timerY,400,100)
	end

		if self:GetGameState() == STATE_PLAYING then
			surface.SetMaterial(hud_finish)
			surface.SetDrawColor(255,255,255,100)
			surface.DrawTexturedRectUV( 0, ScrH()-(186/1.25), ScrW(), 100, 0, 0, ScrW()/100, 1 )

			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(hud_score)
			surface.DrawTexturedRect(ScrW()/2-(288/2),ScrH()-186,288,186)
		end

		if self:GetTimeLeft() <= 31 and self:GetGameState() == STATE_PLAYING then
			draw.SimpleText( ElapsedTime, "GR_time", x, y, Color( 250, 50, 50, 255 ), 1, 1 )
		elseif self:GetGameState() == STATE_WARMUP then

			surface.SetDrawColor(15,15,15,200)
			surface.DrawRect(0, ScrH()/2-50, ScrW(), 100)

			draw.NiceText( "GET READY",
			"GR_time_large",
			x,
			y,
			Color( 255, 255, 255, 255 ),
			TEXT_ALIGN_CENTER,
			TEXT_ALIGN_CENTER,
			4,
			225)
		else
			draw.SimpleText( ElapsedTime, "GR_time", x, y, Color( 200, 200, 200, 255 ), 1, 1 )
		end

	local PowerupHUD = {
		["weapon_bomb"] = hud_bomb,
		["weapon_boomerang"] = hud_boomerang,
		["weapon_frost"] = hud_frost,
		["weapon_spike"] = hud_spikes,
		["warpstar"] = hud_star
	}


	if self:GetGameState() == STATE_PLAYING then

		local points = LocalPlayer():GetNWInt("Points")
		local powerup = LocalPlayer():GetNWString("Powerup")

		if ( PowerupHUD[ powerup ] ) then
			surface.SetMaterial(PowerupHUD[ powerup ])
			surface.DrawTexturedRect(ScrW()/8-(341/2),ScrH()-141*1.2,341,141)
		else
			surface.SetMaterial(hud_none)
			surface.DrawTexturedRect(ScrW()/8-(341/2),ScrH()-141*1.2,341,141)
		end

		if points and points != 0 then
			draw.SimpleText( LocalPlayer():GetNWInt("Points"), "GR_score", ScrW()/2,ScrH()-(186/2), Color( 255, 75, 75, 255 ), 1, 1 )
		else
			draw.SimpleText( dots, "GR_score", ScrW()/2,ScrH()-(186/2), Color( 255, 75, 75, 255 ), 1, 1 )
		end

	end

end

function GM:PaintRank()
end

function GM:PaintPosition()
end

function GM:PaintFood()
end

function GM:PaintCinematic()
end

local hide = {
	["CHudWeaponSelection"] = true,
	["CHudSecondaryAmmo"] = true
}

hook.Add( "HUDShouldDraw", "HideGrHUD", function( name )
	if ( hide[ name ] ) then return false end
end )

local function WarpStar_On( mul, time )
	local layer = postman.NewColorLayer()
	layer.brightness = 0
	layer.contrast = 1
	layer.color = 1.25
	layer.addr = 1
	layer.addg = 1
	layer.addb = 1
	postman.FadeColorIn( "WarpStar_on", layer, .8 )
end
AddPostEvent( "warpstar_on", WarpStar_On )

local function WarpStar_Off( mul, time )
	postman.ForceColorFade( "WarpStar_on" )
	postman.FadeColorOut( "WarpStar_on", 1 )
end
AddPostEvent( "warpstar_off", WarpStar_Off )

net.Receive("PowerupGet", function()
	local ply = net.ReadEntity()
	local pu = net.ReadString()

	if LocalPlayer() != ply then return end

	PuName = pu
	expand = 0
	EndLife = CurTime() + 4

end)

net.Receive("ShowReadyScreen",function()

	/*if GetGlobalBool("NoReadyScreen") then return end

	if timeout == true then return end
	timeout = true
	local mat = vgui.Create( "Material", BGPanel )
	mat:SetPos( 0 - ScrW(), 0 )
	mat:SetSize( ScrW(), ScrH() )
	mat:SetZPos(-5)
	mat:MoveToBack()
	mat:SetMaterial( "gmod_tower/gourmetrace/hud/hud_ready" )

	timer.Simple(30,function()
		timeout = false
	end)

	mat:MoveTo(0,0,1,0,-1,function()
		timer.Simple(3,function()
			mat:MoveTo(0 + ScrW(),0,1,0,-1,function()
				mat:Remove()
			end)
		end)
	end)*/

end)
