GM.MapAdjustments = {}

GM.MapAdjustments["gmt_ballracer_facile02"] = function()
	for k,v in pairs(ents.FindByClass("repeller")) do
		if v.Radius == 500 then
			v.Radius = 412
		end
	end
end

function GM:RunMapAdjustments()
	local map = game.GetMap()
	
	if GAMEMODE.MapAdjustments[map] then
		print("[Map Adjustments] Adjusting map...")
		
		GAMEMODE.MapAdjustments[map]()
	end
end