ENT.Base			= "browser_base"
ENT.Type			= "anim"
ENT.PrintName		= "Radio"
ENT.Author			= "MacDGuy"
ENT.Contact			= ""
ENT.Purpose			= "For GMod Tower"
ENT.Instructions	= ""
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= "models/props/cs_office/radio.mdl"

GtowerPrecacheModel( ENT.Model )

/*hook.Add("LoadAchievements","AchiPokerFace", function ()

	GTowerAchievements:Add( ACHIEVEMENTS.SUITEPOKERFACE, {
		Name = "Poker Face� 2009",
		Description = "Play a song about poker faces.",
		Value = 1,
		Group = "Suite",
	})

end )*/
