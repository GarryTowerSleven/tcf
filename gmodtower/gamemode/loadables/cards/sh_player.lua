
-----------------------------------------------------
if SERVER then



	util.AddNetworkString( "ClientTest" )



	concommand.Add( "stress", function( ply, cmd, args )





		if !ply:IsAdmin() then return end



		local t = args[1]



		MsgN( "Stressing " .. t )



		for i=1, t do



			net.Start( "ClientTest" )

				net.WriteEntity( ply )

				net.WriteInt( i, 4 )

				net.WriteTable( player.GetAll() )

			net.Send( player.GetAll() )



		end



	end )



else // CLIENT



	net.Receive( "ClientTest", function( length, ply )



		MsgN( net.ReadEntity(), net.ReadInt(4) )

		PrintTable( net.ReadTable() )



	end )



end







local meta = FindMetaTable("Player")



if SERVER then

	function meta:GivePokerChips( amount, from, to )



		amount = math.floor( amount )

		to = to or self

		from = from or self



		self:SetPokerChips( self:PokerChips() + amount )



		if amount > 0 then //earned

			self:MsgI( "chips", "PokerChipEarned", stringmod.FormatNumber( amount ) )

		elseif amount < 0 then //lost

			self:MsgI( "chips", "PokerChipSpent", stringmod.FormatNumber( math.abs( amount ) ) )

		end



		local ent = ents.Create("gmt_chip_bezier")

		if IsValid( ent ) then

			ent:SetPos( from:GetPos() + Vector( 0, 0, 64 ) )

			ent.GoalEntity = to

			ent.GMC = math.abs( amount )

			ent.RandPosAmount = 5

			ent:Spawn()

			ent:Activate()

			ent:Begin()

		end



	end



	function meta:SetPokerChips( amount )
		
		self.GTPChips = math.Clamp( tonumber( amount ), 0, 2147483647 ) // math.pow( 2, 31 )  - 1  -- only allow 31 bits of numbers!
		self:SetSetting( "GTPChips", amount )

	end

end



function meta:PokerChips()

	return self:GetSetting( "GTPChips" )

end



function meta:AffordPokerChips( price )

	return self:PokerChips() >= price

end