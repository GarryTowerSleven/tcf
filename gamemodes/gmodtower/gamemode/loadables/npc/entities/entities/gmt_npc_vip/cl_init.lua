include('shared.lua')

ENT.NPCExpression = "blank"

ENT.Offset = -3.5
ENT.Hat = "models/gmod_tower/aviators.mdl"
ENT.HatOffset = {
	Pos = Vector( -1.25, 0, -3 ),
	Ang = Angle( 0, 0, 0 ),
	Scale = .9,
}

/*hook.Add( "OnEntityCreated", "VIPBones", function( ent ) 

	if ent:GetClass() == "gmt_npc_vip" then
		function ent.BuildBonePositions()
			BoneMod:ModBouncer( ent )
		end
	end

end )*/