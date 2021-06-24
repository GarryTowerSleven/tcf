
-----------------------------------------------------
include( "shared.lua" )

local MyNumber = 0
local Target = 0
local LastThink = 0
local ChangeRate = 1

function ENT:Draw()

	-- Only draw in the duel arena
	if GTowerLocation:FindPlacePos( LocalPlayer():GetPos() ) == 30 then

	end
end
