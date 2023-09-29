module( "globalnet", package.seeall )

DEBUG = false

Vars = Vars or {}

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

function GetEntity()
    return game.GetWorld()
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

function Initialize( ent )

    for k, v in pairs( Vars ) do
        
        if SERVER then
            NWFunctions[ v.nettype ].set( ent, k, v.default or NetDefaults[ v.nettype ] )
        end

        if v.callback then
            
            ent:SetNWVarProxy( k, function( ent, name, old, new )
                if old == new then return end

                v.callback( ent, old, new, v )
            end )

        end

    end

    LogPrint( "Initialized on: " .. tostring( ent ), nil, "GlobalNet" )

    hook.Run( "GlobalNetInitalized", ent )

end

hook.Add( "InitPostEntity", "SetupGlobalnet", function()

    Initialize( GetEntity() )

end )

function SetNet( key, value )

    local ent = GetEntity()

    if ent == NULL then
        ErrorNoHaltWithStack( "Globalnet entity not initalized!" )
        return
    end

    local var = Vars[ key ]
    if not var then
        ErrorNoHaltWithStack( "Var not in registry! (" .. tostring( key ) .. ")" )
        return
    end

    NWFunctions[ var.nettype ].set( ent, key, value )

end

function GetNet( key, fallback )

    local ent = GetEntity()

    if ent == NULL then
        ErrorNoHaltWithStack( "Globalnet entity not initalized!" )
        return
    end
    
    local var = Vars[ key ]
    if not var then
        ErrorNoHaltWithStack( "Var not in registry! (" .. tostring( key ) .. ")" )
        return fallback
    end

    return NWFunctions[ var.nettype ].get( ent, key, fallback )

end