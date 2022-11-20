ENT.Base			= "browser_base"
ENT.Type			= "anim"
ENT.PrintName		= "Arcade Cabinet"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= Model( "models/gmod_tower/arcadecab.mdl" )

//This is the ID to start with, since "Generic Game" is not a game, start a 2
/*ENT.StartId = 2

ENT.AchiCount = #ENT.GameIDs - ENT.StartId + 1
local Count = ENT.AchiCount*/

function ENT:CanUse( ply )
	return true, "PLAY"
end