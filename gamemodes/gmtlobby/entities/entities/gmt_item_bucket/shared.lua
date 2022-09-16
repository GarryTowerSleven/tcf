
-----------------------------------------------------
ENT.Type 		= "anim"
ENT.Base 		= "base_entity"

ENT.PrintName	= "Present"
ENT.Model 		= Model("models/gmod_tower/halloween_candybucket.mdl")
ENT.SoundOpen = Sound("gmodtower/inventory/use_candy.wav")
ENT.SoundCollect = Sound("misc/halloween/spell_pickup.wav")

function ENT:CanUse( ply )

		if !IsValid(ply:GetActiveWeapon()) || ply:GetActiveWeapon():GetClass() != "gmt_tracker" then return end

		local time = ply:GetNWFloat("NextBucket")
		if time > CurTime() then
			return false, "WAIT " .. math.ceil(time - CurTime()) .. " SECONDS"
		else
			return true, "COLLECT"
		end
end
