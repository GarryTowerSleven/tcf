include( 'shared.lua' )
include( 'cl_meta.lua' )

CreateClientConVar( "cl_minecraftskin", "", true, true )

hook.Add( "PrePlayerDraw", "MinecraftSkin", function(ply)

	if ply:GetModel() == mcmdl and ply.MinecraftMat then
		render.ModelMaterialOverride(ply.MinecraftMat)
	end

end )

hook.Add( "PostPlayerDraw", "MinecraftSkin", function( ply )

	if ply:GetModel() == mcmdl and ply.MinecraftMat then
		render.ModelMaterialOverride()
	end

end )


function MinecraftSendUpdatedSkin( text )

	if !isstring(text) then return end

	text = string.TrimLeft( text )
	text = string.TrimRight( text )

	-- Check if they set the same skin
	if LocalPlayer():GetInfo( "cl_minecraftskin" ) == text then return end

	RunConsoleCommand( "cl_minecraftskin", text )

	if #text > 0 then

		net.Start("minecraft_skin_updated")
			net.WriteString(text)
		net.SendToServer()

	end

end