
-----------------------------------------------------
mcmdl = "models/player/mcsteve.mdl"

local function MinecraftSkinUpdated( ply, new )

	if CLIENT /*and old != new*/ then
		local skinname = new

			//if skinname and #skinname > 0 then
				ply:SetMinecraftSkin( skinname )
			//end

	end

end


function GetMCSkin(ply)
	MinecraftSkinUpdated( ply, ply:GetNWString("MinecraftSkin") )
end

net.Receive("minecraft_send_updates",function()

	local ID = net.ReadInt(16)
	local ent = ents.GetByIndex(ID)

	if IsValid(ent) then
		MinecraftSkinUpdated( ent, ent:GetNWString("MinecraftSkin") )
	end

end)

//plynet.Register( "String", "MinecraftSkin", { callback = MinecraftSkinUpdated } )
