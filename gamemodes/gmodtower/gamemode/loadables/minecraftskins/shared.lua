mcmdl = "models/player/mcsteve.mdl"

local function MinecraftSkinUpdated( ply, old, new )

	if CLIENT then

		local skinname = new

		-- Add the minecraft url only if there's actual text - else it'll reset to steve
		if skinname and #skinname > 0 then
			http.Fetch("https://gtower.net/apps/minecraft/?skin=" .. skinname, function(str)
				if str then
					ply:SetMinecraftSkin(str)
				end
			end)
			
		end

	end

end

if CLIENT then
	net.Receive( "minecraft_skin_update", function( len, ply )
		local ply = net.ReadEntity()
	
		if ( !IsValid( ply ) ) then return end
	
		local old = net.ReadString()
		local new = net.ReadString()

		if ply.OldSkin == new then return end

		ply.OldSkin = new
	
		MinecraftSkinUpdated( ply, old, new )
	end )
end

plynet.Register( "String", "MCSkinName", {
	callback = MinecraftSkinUpdated
} )