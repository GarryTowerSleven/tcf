---------------------------------
module( "GTowerItems", package.seeall )

ModelItems = ModelItems or {}

local ITEMExtraFunc = {}

if CLIENT then

	/*CreateConVar( "gmt_playermodel_hands", "1", { FCVAR_ARCHIVE, FCVAR_USERINFO } )

	cvars.AddChangeCallback("gmt_playermodel_hands", function()
		 RunConsoleCommand("gmt_updateplayermodel")
	end)*/
	
	local Look, Cam = Vector(0,0,60), Vector(60,0,60)
	function ITEMExtraFunc:GetRenderPos()
		return Look, Cam
	end
	
	function ITEMExtraFunc:ExtraMenuItems( Menu )
		table.insert( Menu, {
			["Name"] = "Set As Yourself",
			["function"] = function()
				Msg2(T("PlayerModelUpdated"))
				RunConsoleCommand( "gmt_playermodel", self.ModelName .. "-" .. self.ModelSkinId ) 
				RunConsoleCommand( "gmt_updateplayermodel" )
			end
		} )
		
		if self.ModelName == "steve" then

		table.insert( Menu, {

			[ "Name" ] = "Set Skin",

			[ "function" ] = function()

				Derma_StringRequest(

					"Blockdude Skin",

					//"Please enter a valid Minecraft user account to use as your skin. This is case sensative. \nWarning: Using explicit skins is bannable.",
					"Please enter a valid Minecraft user account to use as your skin. Using explicit skins is bannable.",

					LocalPlayer():GetInfo( "cl_minecraftskin" ) or "",

					function(text) MinecraftSendUpdatedSkin( string.lower( text ) ) end

				)

			end

		} )
		
		end

	end
else
	
	function ITEMExtraFunc:OnUse()
		
		if self.Ply:Alive() && !self.Ply:InVehicle() then
			
			if GTowerModels.Get( self.Ply ) != self.ModelUseSize then
				self.Ply._PlyModelOverRide = { player_manager.TranslatePlayerModel( self.ModelName ) , self.ModelSkinId}
			else
				self.Ply:SetModel( player_manager.TranslatePlayerModel( self.ModelName ) )
				self.Ply:SetSkin( self.ModelSkinId )
				self.Ply:SetupHands()
			end
			
			local Size = self.ModelUseSize
			
			if self.Ply:GetModel() == "models/player/digi.mdl" && self.Ply:GetSkin() > 0 then
				Size = 1.0
			end
			
			GTowerModels.Set( self.Ply , Size  ) 	
		end
		
		return true
	end


end

function ITEMExtraFunc:IsMyEnt( ent )
	return ent:GetModel() == self.Model && tonumber(ent:GetSkin()) == self.ModelSkinId
end

function PrepareItemModel( ITEM )	
	
	ITEM.CanEntCreate = false
	ITEM.ModelSkinId = ITEM.ModelSkinId or 0
	
	if ITEM.ModelUseSize then
		ITEM.CanUse = true
		if SERVER then
			ITEM.OnUse = ITEMExtraFunc.OnUse
		end
	end
	
	if SERVER then
		ITEM.OnDrop = EmptyFunction
	else
		ITEM.GetRenderPos = ITEMExtraFunc.GetRenderPos
		ITEM.ExtraMenuItems = ITEMExtraFunc.ExtraMenuItems
	end
	
	ITEM.IsMyEnt = ITEMExtraFunc.IsMyEnt
	
	if ITEM.AlwaysAllowModel == true || GAMEMODE.AllowSpecialModels == true then
		ModelItems[ ITEM.ModelName .. "-" .. ITEM.ModelSkinId ] = ITEM
	end
	
end