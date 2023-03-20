local htmldata = "data:text/html,<html><img src='%s' /></html>"

local meta = FindMetaTable( "Entity" )
if !meta then return end

local AllowSkins = CreateClientConVar( "gmt_minecraftskins", 1, true, false )

local function SetSkin( ply, mat, uri )

	print( ply, mat, uri )

	if !IsValid(ply) then return end

	-- Verify valid skin size
	if ( mat:Height() != 32 || mat:Width() != 64 ) then
		print( "Skin ('".. uri .. "') does not exist!" )
		return
	end

	-- Create new material for the skin
	local params = {
			["$basetexture"] 	= mat:GetString( "$basetexture" ),
			["$alphatest"] 		= 1,
			["$nocull"] 		= 1,
			["$model"] 			= 1
	}
	local skinname = string.format( "minecraftskin%s%s", tostring(ent), SysTime() )
	local newmat = CreateMaterial( skinname, "VertexLitGeneric", params )

	print( newmat )

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
