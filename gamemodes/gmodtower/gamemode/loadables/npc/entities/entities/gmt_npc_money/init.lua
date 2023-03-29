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
	end

	net.Start( "gmt_npc_money" )
	net.Send( ply )*/
end

/*net.Receive( "gmt_npc_money", function( len, ply )
	local npc = ents.FindByClass( "gmt_npc_money" )[1]
	if ( not IsValid( npc ) ) then return end

	if ( IsValid( ply ) && ply:GetPos():Distance( npc:GetPos() ) < 512 ) then
		if ( ply._MoneyCooldown && ply._MoneyCooldown > CurTime() ) then return end

		local amount = math.Clamp( net.ReadUInt( 32 ) or 0, 0, 100000 )
		if ( amount < 1 ) then return end

		ply:AddMoney( amount )
		ply._MoneyCooldown = CurTime() + npc.CoolDown
	end
end )*/

util.AddNetworkString( "gmt_npc_money" )