if IsLobby && game.GetMap() == "gmt_lobby2_r7" then
    // Better Fog
    hook.Add("SetupSkyboxFog", "FogFix", function(scale)	
    	render.FogMode(MATERIAL_FOG_LINEAR)
    	render.FogStart(16341 * scale)
    	render.FogEnd(23170 * scale)
    	render.FogMaxDensity(0.9)
    
    	render.FogColor(0, 0, 3)
    
    	return true
    end)
end