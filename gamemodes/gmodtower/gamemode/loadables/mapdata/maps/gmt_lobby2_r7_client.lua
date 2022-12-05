// Better Fog
hook.Add( "SetupSkyboxFog", "FogFix", function(scale)	
    render.FogMode( MATERIAL_FOG_LINEAR )
    render.FogStart( 20000 * scale )
    render.FogEnd( 25000 * scale )
    render.FogMaxDensity( .75 )

    render.FogColor( 0, 1, 2 )

    return true
end )

// Water Fix
hook.Add( "LocalFullyJoined", "WaterFix", function()
    local water = Material( "maps/gmt_lobby2_r7/gmod_tower/common/lobby2_water_-11712_928_-14064" )
    local water_clear = Material( "maps/gmt_lobby2_r7/gmod_tower/common/lobby2_water_clear_-11712_928_-14064" )
    local water_waves = Material( "gmod_tower/lobby/waves" )

    if ( water ) then
        water:SetVector( "$fogcolor", Vector( 0, 0, 0 ) )
    end

    if ( water_clear ) then
        water_clear:SetVector( "$fogcolor", Vector( 25/255, 50/255, 70/255 ) )
        water_clear:SetFloat( "$fogend", 1024.0 )
    end

    if ( water_waves ) then
        water_waves:SetFloat( "$alpha", 0.4 )
    end
end )