AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

ENT.Sequence = "pose_standing_01"

ENT.MoneyValue = 500
ENT.CoolDown = 10

function ENT:Use( ply )
	if ( ply._MoneyCooldown && ply._MoneyCooldown > CurTime() ) then
		ply:Msg2( "Whoa, slow down there! You already got some dosh!" )
		return
	end

	ply:AddMoney( self.MoneyValue )
	ply._MoneyCooldown = CurTime() + self.CoolDown

	/*if ( ply._MoneyCooldown && ply._MoneyCooldown > CurTime() ) then
		ply:Msg2( "Timeout." )
		return
	end*/
end
