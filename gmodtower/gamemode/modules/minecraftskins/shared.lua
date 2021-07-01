
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

// Name Tag

if CLIENT then

	local convar = CreateClientConVar( "gmt_minecraft_names", 1, true, false )
	local enabled = convar:GetBool()

	local convar2 = CreateClientConVar( "gmt_minecraft_local", 1, true, false )
	local localenabled = convar2:GetBool()

	cvars.AddChangeCallback("gmt_minecraft_names", function(_, _, newval)
		enabled = convar:GetBool()
	end)

	cvars.AddChangeCallback("gmt_minecraft_local", function(_, _, newval)
		localenabled = convar2:GetBool()
	end)


	surface.CreateFont( "Minecraft", {
		font = "Minecraftia", --  Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 50,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = false,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
	
	hook.Add("PostDrawTranslucentRenderables", "TEST", function()

		if !enabled then return end
	
		for k,ply in pairs( player.GetAll() ) do

			if ply:GetModel() != mcmdl then return end
			if !localenabled && ply == LocalPlayer() then return end

			if LocalPlayer():GetPos():Distance( ply:GetPos() ) >= 2048 then return end

			local BGAlpha = 65
			local TEXTAlpha = 255

			if ply:OnGround() && ply:Crouching() then
				//BGAlpha = 65
				TEXTAlpha = 65
			end
			
			local ang = EyeAngles()
			local pos = ply:WorldSpaceCenter()
	
			local name = ply:Nick()
	
			local Head = ply:LookupBone( "ValveBiped.Bip01_Head1" )
			local HEADpos, HEADang = ply:GetBonePosition( Head )
	
			local pos = Vector( pos.x, pos.y, HEADpos.z + ( 37 * ply:GetModelScale() ) )
	
			ang:RotateAroundAxis( ang:Forward(), 90 )
			ang:RotateAroundAxis( ang:Right(), 90 )
	
			local padX = 10
			local padY = -10

			local scale = math.Clamp( 0.20 * ply:GetModelScale(), 0.01, 0.5 )
	
			cam.Start3D2D( pos, ang, scale )
				surface.SetFont( "Minecraft" )
				local w, h = surface.GetTextSize( name )
	
				//surface.SetDrawColor( Color( 0, 0, 0, 60 ) )
				surface.SetDrawColor( Color( 0, 0, 0, BGAlpha ) )
				surface.DrawRect( 0 - (w/2) - (padX/2), 0 - (h/2) - (padY/2), w + padX, h + padY - 5 )
	
				draw.SimpleText( name, "Minecraft", 0, 0, Color( 255, 255, 255, TEXTAlpha ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			cam.End3D2D()
	
		end
	
	end )

end