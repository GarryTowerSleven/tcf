local htmldata = "<html><img src='%s' /></html>"

local meta = FindMetaTable( "Entity" )
if !meta then return end

local AllowSkins = CreateClientConVar( "gmt_minecraftskins", 1, true, false )
local rts = {}
local todo = {}
local txBackground = surface.GetTextureID( "models/weapons/v_toolgun/screen_bg" )
hook.Add("PreRender", "test", function()
    for _, t in ipairs(todo) do
        local mat = t[2]

        local params = {
            ["$basetexture"] = mat:GetString("$basetexture"),
            ["$alphatest"] = 1,
            ["$ignorez"] = 1
        }

        local skinname = string.format("!!!!!!!minecraftskin%s" .. math.random(999999999), SysTime())
        local newmat = CreateMaterial(skinname, "UnlitGeneric", params)
        newmat:SetInt("$flags", bit.bor(newmat:GetInt("$flags"), 32768))
        cam.Start2D()
        render.PushRenderTarget(rts[mat])
        render.Clear(255, 0, 0, 0)
        render.PopRenderTarget()
        cam.End2D()
        SW, SH = ScrW() / 64, ScrH() / 32
		surface.SetMaterial(newmat)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0, -newmat:Height(), newmat:Width(), newmat:Height())
		cam.Start2D()
		render.PushRenderTarget(rts[mat])
		render.Clear(255, 0, 0, 0)
		surface.SetMaterial(newmat)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(0, 0 or -(newmat:Height() * SH) / 2, newmat:Width() * SW, newmat:Height() * SH)
		// surface.DrawTexturedRect(0, -newmat:Height() / 1, newmat:Width() * SW, newmat:Height() * SH, 0, 0.5, 1, 1)
		render.SetMaterial(newmat)
		surface.SetDrawColor(color_white)
		surface.SetTexture(txBackground)
		// surface.DrawTexturedRect( 0, 0, 1024, 1024 )
		render.PopRenderTarget()
		cam.End2D()

        table.remove(todo, _)
    end
end)

local function SetSkin( ply, mat, uri )

	print( ply, mat, uri )

	if !IsValid(ply) then return end

	-- Verify valid skin size

	local w, h = mat:Width(), mat:Height()

	for i = 1, 8 do
		if w > 64 or h > 64 then
			w, h = w / 2, h / 2
		end
	end

	w = 64, 32

	rts[mat] = GetRenderTargetEx("SKIN" .. math.random(999999999999), 64, 32,
	RT_SIZE_NO_CHANGE,
	MATERIAL_RT_DEPTH_SEPARATE,
	bit.bor(1, 256),
	0,
	IMAGE_FORMAT_BGRA8888
)

	timer.Simple(0, function()
		table.insert(todo, {
			rts[mat],
			mat
		})
	end)

	if ( mat:Height() != 32 || mat:Width() != 64 ) then
		print( "Skin ('".. uri .. "') does not exist!" )
		// return
	end

	-- Create new material for the skin
	local params = {
			["$basetexture"] 	= rts[mat]:GetName() or mat:GetString( "$basetexture" ),
			["$nocull"] = 1,
			["$alphatest"] = 1
	}
	local skinname = string.format( "!minecraftskin%s%s" .. math.random(9999), tostring(ent), SysTime() )
	local newmat = CreateMaterial( skinname, "VertexLitGeneric", params )

	-- Update material for all players using the same uri
	for _, v in pairs( ents.GetAll() ) do 
		if v.MinecraftSkinURI == uri then

			v.MinecraftMat = newmat 

			if !v:IsPlayer() then
				v:SetNoDraw( true )
			end

		end 
	end

end

function meta:SetMinecraftSkin( uri )

	if !AllowSkins:GetBool() then return end
	if self:GetModel() != mcmdl then return end

	if #uri > 0 then

		self.MinecraftSkinURI = string.format( htmldata, uri )
		
		WebMat.Get( self.MinecraftSkinURI, function( mat, uri )
			SetSkin( self, mat, uri )
		end )

	else

		self.MinecraftSkinURI = nil
		self.MinecraftMat = nil

		-- Set non player entities to draw again, since we redraw them differently
		if !self:IsPlayer() then
			self:SetNoDraw( false )
		end

	end
end
