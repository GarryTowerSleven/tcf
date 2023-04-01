include('shared.lua')

net.Receive( "gmt_npc_money", function()

	Derma_StringRequest(
		"Who wanted money?",
		"Set the amount of GMC you want to get. (Max: 100,000)",
		"0",
		function( txt )

			net.Start( "gmt_npc_money" )
				net.WriteUInt( tonumber( txt ) or 0, 32 )
			net.SendToServer()

		end,
        function()

			net.Start( "gmt_npc_money" )
				net.WriteUInt( 0, 32 ) // just to let the server know we're not interested
			net.SendToServer()
            
        end,
		"GIVE ME THAT DOSH!",
		"Nah nevermind I'm good"
	)

end )

/*hook.Add( "OnEntityCreated", "VIPBones", function( ent ) 

	if ent:GetClass() == "gmt_npc_vip" then
		function ent.BuildBonePositions()
			BoneMod:ModBouncer( ent )
		end
	end

end )*/