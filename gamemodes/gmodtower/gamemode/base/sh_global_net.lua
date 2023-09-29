module( "globalnet", package.seeall )

DEBUG = false

Vars = Vars or {}
_GlobalNetwork = _GlobalNetwork or NULL
BacklogQueue = {}

local entmeta = FindMetaTable( "Entity" )

NWFunctions = NWFunctions or {

    ["string"]  = { set = entmeta.SetNWString, get = entmeta.GetNWString },
    ["int"]     = { set = entmeta.SetNWInt,    get = entmeta.GetNWInt },
    ["vector"]  = { set = entmeta.SetNWVector, get = entmeta.GetNWVector },
    ["angle"]   = { set = entmeta.SetNWAngle,  get = entmeta.GetNWAngle },
    ["float"]   = { set = entmeta.SetNWFloat,  get = entmeta.GetNWFloat },
    ["bool"]    = { set = entmeta.SetNWBool,   get = entmeta.GetNWBool },
    ["entity"]  = { set = entmeta.SetNWEntity, get = entmeta.GetNWEntity },

}

NetDefaults = {

    ["string"]  = "",
    ["int"]     = 0,
    ["vector"]  = vector_origin,
    ["angle"]   = angle_zero,
    ["float"]   = 0.0,
    ["bool"]    = false,
    ["entity"]  = NULL,

}

function GetGlobalNetworking()

	if IsValid( _GlobalNetwork ) then
		return _GlobalNetwork
	else
		return ents.FindByClass("gmt_global_network")[1]
	end

end

function Register( nettype, name, nwtable )

    nwtable = nwtable or {}
    nwtable.nettype = string.lower( nettype )
    
    if not NWFunctions[ nwtable.nettype ] then
        ErrorNoHaltWithStack( "Invalid NW type! (" .. tostring( nwtable.nettype ) .. ")" )
        return
    end

    Vars[ name ] = nwtable

end

function InitializeOn( ent )

    for k, v in pairs( Vars ) do
        
        if SERVER then
            local val = v.default or NetDefaults[ v.nettype ]

            if BacklogQueue[ k ] then
                val = BacklogQueue[ k ]
                BacklogQueue[ k ] = nil
            end

            NWFunctions[ v.nettype ].set( ent, k, val )
        end

        if v.callback then
            
            ent:SetNWVarProxy( k, function( ent, name, old, new )
                if old == new then return end

                v.callback( ent, old, new, v )
            end )

        end

    end

    _GlobalNetwork = ent

    LogPrint( "Initialized on: " .. tostring( ent ), nil, "GlobalNet" )

    hook.Run( "GlobalNetInitalized", ent )

end

function SetNet( key, value )

    local var = Vars[ key ]
    if not var then
        ErrorNoHaltWithStack( "Var not in registry! (" .. tostring( key ) .. ")" )
        return
    end


    if not IsValid( _GlobalNetwork ) then
		_GlobalNetwork = GetGlobalNetworking()
	end

	local network = _GlobalNetwork

    if not IsValid( network ) then
        -- ErrorNoHaltWithStack( "Globalnet entity not initalized!" )

        BacklogQueue[ key ] = value

        return
    end

    NWFunctions[ var.nettype ].set( network, key, value )

end

function GetNet( key, fallback )

    local var = Vars[ key ]
    if not var then
        ErrorNoHaltWithStack( "Var not in registry! (" .. tostring( key ) .. ")" )
        return fallback
    end


	if not IsValid( _GlobalNetwork ) then
		_GlobalNetwork = GetGlobalNetworking()
	end

	local network = _GlobalNetwork

    if not IsValid( network ) then
        ErrorNoHaltWithStack( "Globalnet entity not initalized!" )
        return
    end

    return NWFunctions[ var.nettype ].get( network, key, fallback )

end