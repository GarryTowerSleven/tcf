
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("playermeta.lua")
include("shared.lua")
include("playermeta.lua")

function ENT:KeyValue(key,val)
    if key == "skyname" then self:SetSkyboxName(val) end
    if key == "skyscale" then self:SetSkyboxScale(val) end
end

hook.Add( "SetupPlayerVisibility", "CondoCrapIntoPVS", function( pPlayer, pViewEntity )
	-- Adds any view entity

  //if pPlayer:Location().CondoID then

		//for k,v in pairs( ents.FindByClass("gmt_skycam") ) do
		//	AddOriginToPVS( v:GetPos() )
		//end

  //end

  if pPlayer:Location() == 30 then

		for k,v in pairs( ents.FindByClass("gmt_duelcamera") ) do
			AddOriginToPVS( v:GetPos() )
		end

  end

  if pPlayer:Location() == 64 then

		for k,v in pairs( ents.FindByClass("gmt_monorail") ) do
			AddOriginToPVS( v:GetPos() )
		end

  end

end )

/*
	self:NetworkVar( "String", 0, "SkyboxName" )



	-- Skybox scale, or how much to offset the camera to player movement

	self:NetworkVar("Float", 0, "SkyboxScale")



	-- The new origin relative to the player.

	-- If the player's position is exactly at this position, the skybox will have no offset

	self:NetworkVar("Vector", 0, "MoveOrigin")



	-- The mode to override the skybox with

	self:NetworkVar("Int", 0, "Mode")

*/
