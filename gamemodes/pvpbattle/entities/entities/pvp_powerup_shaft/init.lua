AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

ENT.ActiveTime = 22

function ENT:PowerUpOn( ply )

	ply.Shaft = true
	ply:SetColor( Color(255, 0, 255, 255) )
	ply:SetWalkSpeed( 250 )
	ply:SetRunSpeed( 150 )
	PostEvent( ply, "pushaft_on" )

	if not Hats then return end

	local hat, _ = Hats.GetWearables( ply )

	ply._SavedHat = hat
	ply:SetHat( "hatpimphat", Hats.SLOT_HEAD, true )

end

function ENT:PowerUpOff( ply )

	ply.Shaft = nil
	ply:SetColor( Color(255, 255, 255, 255) )
	ply:SetWalkSpeed( 450 )
	ply:SetRunSpeed( 450 )
	PostEvent( ply, "pushaft_off" )

	if ply._SavedHat then
		ply:SetHatID( ply._SavedHat or 0, Hats.SLOT_HEAD, true )
	end
	
end

/*function ShaftProtect( ply, inflictor, attacker, amount, dmginfo )
	if !ply.PowerUp then return end

	if ply:Health() > amount then
		amount = 0
		return true
	else
		return false
	end
end*/

hook.Add( "EntityTakeDamage", "ShaftProtect", function( ply, dmginfo )
	if ply:GetNet("PowerUp") == 0 then return end
	if !ply.Shaft then return end

	local attacker = dmginfo:GetAttacker()
	
	SendDeathNote( attacker, ply, 0, false )
	
	return true
end )
