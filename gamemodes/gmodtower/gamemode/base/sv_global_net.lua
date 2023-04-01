module( "globalnet", package.seeall )

_Backlog = {}

function SetNet( name, value )
    if ( not IsValid( _GlobalNetwork ) ) then
        _GlobalNetwork = GetGlobalNetworking()
    end

    local network = _GlobalNetwork

    if IsValid( network ) and network.dt then
        if ( network.dt[name] ~= value ) then
            local var = GetByName( name )
            if ( var && var.callback ) then
                network:CallDTVarProxies( var.nettype, var.id, value )
            end
        end

        network.dt[name] = value
    else
        _Backlog[ name ] = value
        if DEBUG then
            LogPrint( string.format( "Entity not found! Can't set '%s'", name ), color_red, "globalnet" )
            debug.Trace()
        end
    end
end

hook.Add( "InitPostEntity", "CreateGlobalNetwork", function()
    local ent = ents.Create( "gmt_global_network" )
    ent:Spawn()

    _GlobalNetwork = GetGlobalNetworking()

    hook.Call( "GlobalNetInitalized", GAMEMODE, _GlobalNetwork )

    // ehhhh
    if ( _Backlog ) then
        for k, v in pairs( _Backlog ) do
            SetNet( k, v )
        end

        _Backlog = {}
    end

    LogPrint( "Initalized: " .. tostring( _GlobalNetwork ), nil, "globalnet" )
end )