if IsLobby && game.GetMap() == "gmt_lobby2_r7" then
    // Better Fog
    hook.Add( "SetupSkyboxFog", "FogFix", function(scale)	
    	render.FogMode(MATERIAL_FOG_LINEAR)
    	render.FogStart(16341 * scale)
    	render.FogEnd(23170 * scale)
    	render.FogMaxDensity(0.9)
    
    	render.FogColor(0, 1, 3)
    
    	return true
    end )

	hook.Add( "LocalFullyJoined", "WaterFix", function()
		local water = Material( "maps/gmt_lobby2_r7/gmod_tower/common/lobby2_water_-11712_928_-14064" )
		local water_clear = Material( "maps/gmt_lobby2_r7/gmod_tower/common/lobby2_water_clear_-11712_928_-14064" )

		if ( water ) then
			water:SetVector( "$fogcolor", Vector( 0, 0, 0 ) )
		end

		if ( water_clear ) then
			water_clear:SetVector( "$fogcolor", Vector( 0, 0, 0 ) )
			water_clear:SetFloat( "$fogend", 1024.0 )
		end
	end )
end