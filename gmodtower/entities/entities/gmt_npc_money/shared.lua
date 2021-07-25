ENT.Base			= "gmt_npc_base"
ENT.Type 			= "ai"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.PrintName = "Money Giver"

ENT.Model		= Model( "models/player/haroldlott.mdl" )
ENT.StoreID = GTowerStore.MONEY

ENT.AnimMale		= Model( "models/player/gmt_shared.mdl" )
ENT.AnimFemale		= Model( "models/player/gmt_shared.mdl" ) -- temp hack

function ENT:CanUse( ply )
	return true, "GIVE ME SOME GMC"
end