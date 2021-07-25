---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

util.AddNetworkString("NPCCasino")

concommand.Add( "gmt_casino_chips_cash", function( ply, cmd, args )

	if ply:PokerChips() > 0 then
		ply:MsgI( "chips", "PokerChipSpent", string.FormatNumber(ply:PokerChips()) )
		ply:AddMoney( ply:PokerChips()*Cards.ChipCost )
		ply:SetPokerChips(0)
	end

end )

concommand.Add( "gmt_casino_chips_buy", function( ply, cmd, args )
	
	if (args[1] == nil || tonumber(args[1])) == 0 then return end
	
	local cost = (tonumber(args[1])*Cards.ChipCost)
	local chips = tonumber(args[1])

	if ply:Money() >= cost then
		ply:AddMoney( -cost, false )
		ply:GivePokerChips( chips, ply.ChipSeller, ply )
	else
		ply:MsgI( "chips", "PokerCannotAffordChips" )
	end
	
end )

function ENT:AcceptInput( name, activator, ply )
	
    if name == "Use" && ply:IsPlayer() && ply:KeyDownLast(IN_USE) == false then

		ply.ChipSeller = self

		timer.Simple( 0.0, function()
			net.Start("NPCCasino")
			net.Send(ply)
		end)


    end

end
