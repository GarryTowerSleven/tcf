---------------------------------
ENT.Base		= "browser_base"
ENT.Type		= "anim"
ENT.PrintName	= "Arcade Cabinet Retro"
ENT.Contact		= ""
ENT.Purpose		= "For GMod Tower"
ENT.Instructions	= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model		= "models/gmod_tower/arcadecab_retro.mdl"

//GtowerPrecacheModel( ENT.Model )

ENT.GameIDs		= { "Galaga",
				"Asteroids",
				"Donkey Kong",
				"Final Fight",
				"Ghosts and Goblins",
				"Puzzle Bobble",
				"Raiden",
				"Rick Dangerous",
				"KungFu",
				"Prince of Persia",
				"River City Ransom",
			}

function ENT:CanUse( ply )
		return true, "PLAY"
end
