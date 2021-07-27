
hook.Add("LoadAchievements", "LoadBasicAchi", function()

	local AchimentsFolder = Loadables.LoadablesFolder .. "achievement/achievements/"

	local Achievements = {
		'lobby',
		'pvpbattle',
		'holiday',
		'ballrace',
		'casino',
		'gourmetrace',
		'sourcekarts',
		'minigolf',
		'minigames',
		'virus',
		'milestones',
		'ultimatechimera',
		'zombiemassacre',
	}

	for _, v in pairs( Achievements ) do

		if SERVER then
			AddCSLuaFile( AchimentsFolder .. v .. ".lua" )
		end

		include( AchimentsFolder .. v .. ".lua" )
	end

end )
