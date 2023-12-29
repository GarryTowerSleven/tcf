ENT.Base			= "gmt_npc_base"
ENT.Type 			= "anim"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.PrintName 		= "Money Giver"

ENT.Model		= Model( "models/player/haroldlott.mdl" )
ENT.StoreId 	= GTowerStore.MONEY

ENT.AnimMale	= Model( "models/player/haroldlott.mdl" ) -- Bonemerge Fix

function ENT:CanUse( ply )
	/*if ply:GetNWBool("MoneyNpcTimeout") then
		return false, "YOU'VE ALREADY GOTTEN SOME DOSH! PLEASE WAIT!"
	end*/

	return true, "GIVE ME SOME GMC"
end