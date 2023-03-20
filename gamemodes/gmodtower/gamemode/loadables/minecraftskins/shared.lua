mcmdl = "models/player/mcsteve.mdl"

local function MinecraftSkinUpdated( ply, old, new )

	if CLIENT and old != new then

		local skinname = new

		-- Add the minecraft url only if there's actual text - else it'll reset to steve
		if skinname and #skinname > 0 then
			skinname = string.format( "http://cats.lmao.com/minecraft/?skin=%s", skinname )
		end

		if skinname then
			ply:SetMinecraftSkin( skinname )
		end

	end

end

if CLIENT then
	net.Receive( "minecraft_skin_update", function( len, ply )
		local ply = net.ReadEntity()
	
		if ( !IsValid( ply ) ) then return end
	
		local old = net.ReadString()
		local new = net.ReadString()
	
		MinecraftSkinUpdated( ply, old, new )
	end )
end

-- plynet.Register( "String", "MinecraftSkin", { callback = MinecraftSkinUpdated } )