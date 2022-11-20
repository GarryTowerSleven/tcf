
-----------------------------------------------------
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

local skinResult = {}

function checkSkin( username )

	local URL = "https://gmodtower.org/apps/minecraft/?skin=" .. username

	http.Fetch( URL,
	function( body, len, headers, code )
		skinResult = util.JSONToTable(body)
	end,
	function( error )

	end)

	timer.Simple( 3, function()
		//print( skinResult.status )

		if ( skinResult.status == "red" ) then
			LocalPlayer():ChatPrint( "Skin Error! : " .. skinResult.reason )
			result = false
		else
			result = true
		end
	end )

	return result
end

function MinecraftSendUpdatedSkin( text )
	
	if !isstring(text) then return end

	text = string.TrimLeft( text )
	text = string.TrimRight( text )

	-- Check if they set the same skin
	if string.lower( LocalPlayer():GetInfo( "cl_minecraftskin" ) ) == text then return end

	-- fok off if skin doesnt exist
	//if !checkSkin( text ) then print("dumbass") return end

	RunConsoleCommand( "cl_minecraftskin", text )

	if #text > 0 then

		net.Start("minecraft_skin_updated")
			net.WriteString(text)
		net.SendToServer()

	end

end