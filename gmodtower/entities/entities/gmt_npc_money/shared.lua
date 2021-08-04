ENT.Base			= "gmt_npc_base"
ENT.Type 			= "ai"
ENT.PrintName 		= "Money Giver"

ENT.Model		= Model( "models/player/haroldlott.mdl" )
ENT.StoreID = GTowerStore.MONEY

ENT.AnimMale		= Model( "models/player/gmt_shared.mdl" )
ENT.AnimFemale		= Model( "models/player/gmt_shared.mdl" ) -- temp hack

function ENT:CanUse( ply )
	if ply:GetNWBool("MoneyNpcTimeout") then
		return false, "YOU'VE ALREADY GOTTEN SOME DOSH! PLEASE WAIT!"
	end

	return true, "GIVE ME SOME GMC"
end