module( "plynet", package.seeall )

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

function Register( nettype, name, nwtable )

    nwtable = nwtable or {}
    nwtable.nettype = string.lower( nettype )
    
    if not NWFunctions[ nwtable.nettype ] then
        ErrorNoHaltWithStack( "Invalid NW type! (" .. tostring( nwtable.nettype ) .. ")" )
        return
    end

    Vars[ name ] = nwtable

end

function Initialize( ply )

    for k, v in pairs( Vars ) do
        
        if SERVER then
            NWFunctions[ v.nettype ].set( ply, k, v.default or NetDefaults[ v.nettype ] )
        end

        if v.callback then
            
            ply:SetNWVarProxy( k, function( ent, name, old, new )
                if old == new then return end

                v.callback( ent, old, new, v )
            end )

        end

    end

    if DEBUG then
        LogPrint( "Initialized on: " .. tostring( ply ), nil, "PlayerNet" )
    end

    ply._NetInit = true
    hook.Run( "PlayerNetInitalized", ply )

end

hook.Add( "PlayerInitialSpawn", "SetupPlayerNet", Initialize )

if CLIENT then
    
    hook.Add( "PlayerSpawnClient", "ApplyLocalNet", function( ply )
    
        if ply != LocalPlayer() then return end

        Initialize( LocalPlayer() )
        
    end )

end

Register( "Int", "Money" )
Register( "String", "Role" )
Register( "String", "FakeName" )
Register( "Bool", "SecretAdmin" )
Register( "Entity", "DrivingObject" )


local meta = FindMetaTable( "Player" )

function meta:IsNetInitalized()
	return self._NetInit == true
end

function meta:SetNet( key, value )

    local var = Vars[ key ]
    if not var then
        ErrorNoHaltWithStack( "Var not in registry! (" .. tostring( key ) .. ")" )
        return
    end

    NWFunctions[ var.nettype ].set( self, key, value )

end

function meta:GetNet( key, fallback )

    local var = Vars[ key ]
    if not var then
        ErrorNoHaltWithStack( "Var not in registry! (" .. tostring( key ) .. ")" )
        return fallback
    end

    return NWFunctions[ var.nettype ].get( self, key, fallback )

end