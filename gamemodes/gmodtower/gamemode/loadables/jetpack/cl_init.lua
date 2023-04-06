include("shared.lua")

CreateConVar( "cl_jetpacktexture", "", { FCVAR_ARCHIVE, FCVAR_USERINFO }, "Path to string for custom jetpack exhaust texture" )

local hook = hook
local surface = surface
local LocalPlayer, _G = LocalPlayer, _G
local ScrH = ScrH
local math, FrameTime = math, FrameTime

module("jetpack")

function GetJetpack( ply )
	if ActiveJetpack && ActiveJetpack:IsValid() then
		return ActiveJetpack
	end
end

local jetX = 250 + 25 - 10 // approached
local jetAlpha = 0

local lastActive = UnPredictedCurTime()

function JetpackFuelDraw( x, y, w, h )

	local JetPack = GetJetpack()
	local Amount = LocalPlayer():GetNet( "JetpackFuelRemaining" ) /*LocalPlayer()._DisplayFuelAmount*/ or 0

	if JetPack && !JetPack.JetpackHideFuel && Amount < 1 then

		// Toggle on
		jetX = math.Approach( jetX, x + w + 6, FrameTime() * 30 )
		jetAlpha = math.Approach( jetAlpha, 255, FrameTime() * 1000 )

		lastActive = UnPredictedCurTime()

	else

		if ( lastActive + .5 < UnPredictedCurTime() ) then
			// Toggle off
			if jetX != ( x + w - 5 ) then
				jetX = math.Approach( jetX, x + w - 5, FrameTime() * 30 )
				jetAlpha = math.Approach( jetAlpha, 0, FrameTime() * 1000 )
			else
				return // Don't draw anymore
			end
		end


	end

	local jetY = y
	local width = 10
	draw.RectFillBorder( jetX, jetY, width, h, 2, Amount, Color( 55, 85, 115, jetAlpha ), Color( 255, 255, 255, jetAlpha ), true )

end