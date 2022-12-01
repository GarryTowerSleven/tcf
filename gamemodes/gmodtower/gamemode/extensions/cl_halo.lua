module( "halo", package.seeall )

ConVar = CreateClientConVar( "gmt_halo_budget", "0", true, falsae, nil, 0, 1 )

Budget = ConVar:GetBool() or false

cvars.AddChangeCallback( "gmt_halo_budget", function( _, _, new )
    Budget = tobool( new ) or false
end, "halobudget_change" )

_Add = _Add or Add

function Add( ... )
    if ( Budget ) then
        local args = { ... }

        //outline.SetRenderType( OUTLINE_RENDERTYPE_BEFORE_VM )
        return outline.Add( args[1] or NULL, args[2] or color_white, OUTLINE_MODE_VISIBLE )
    else
        return _Add( ... )
    end
end