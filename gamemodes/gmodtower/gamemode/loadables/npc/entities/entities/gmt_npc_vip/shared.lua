ENT.Base			= "gmt_npc_base"
ENT.Type 			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true

ENT.Model		= Model( "models/Humans/GMTsui1/Female_01.mdl" )
ENT.StoreId 	= GTowerStore.VIP

ENT.AnimMale		= Model( "models/player/gmt_shared.mdl" )
ENT.AnimFemale		= Model( "models/player/gmt_shared.mdl" ) -- temp hack

function ENT:CanUse( ply )
	if ply.IsVIP and ply:IsVIP() then
		return true, "TALK"
	else
		return false, "SORRY, DONOR ONLY"
	end
end