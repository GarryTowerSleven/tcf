module( "globalnet", package.seeall )

hook.Add( "InitPostEntity", "CreateGlobalNetwork", function()

    local ent = ents.Create( "gmt_global_network" )
    ent:Spawn()

    globalnet.InitializeOn( ent )

end )