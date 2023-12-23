AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

module( "Spawner", package.seeall )

/*PositionDev = {}

concommand.Add( "gmt_bucket_add", function( ply )

    local pos = ply:GetPos()

    table.uinsert( PositionDev, Vector( math.Round( pos.x, 5 ), math.Round( pos.y, 5 ), math.Round( pos.z, 5 ) ) )

end )

concommand.Add( "gmt_bucket_print", function( ply )

    for _, v in ipairs( PositionDev ) do
        print( Format( "\tVector(%s, %s, %s),", tostring( math.Round( v.x, 2 ) ), tostring( math.Round( v.y, 2 ) ), tostring( math.Round( v.z, 2 ) ) ) )
    end

end )*/

Enabled = IsHoliday
EnabledConvar = CreateConVar( "gmt_spawner_enabled", "1" )

cvars.AddChangeCallback( "gmt_spawner_enabled", function( _, old, new )

    if tobool( new ) == tobool( old ) then return end

    if tobool( new ) == true then
        Enabled = true

        Initalize()
    else
        Enabled = false
        NextTime = -1

        if Active then
            End()
        end
    end

end, "SpawnerChange" )

Active = Active or false

Entities = Entities or {}
SpawnEntity = IsHalloween and "gmt_item_candybucket" or "gmt_item_present"
EntityLimit = 25

NextTime = NextTime or -1
StartTime = StartTime or 0
NextDelay = 60 * math.random( 15, 30 )
ActiveLength = 60 * 3
LastSpawn = 0
NextSpawn = { 8, 15 }
Rarity = Rarity || {}

Positions = {
    Vector(303.9, 2454.8, 192.03),
    Vector(3395.9, 2236.97, 56.03),
    Vector(3006.89, 3178.22, 16.03),
    Vector(125.84, 239.03, 192.03),
    Vector(1529.22, -442.08, 0.03),
    Vector(336.55, -446.77, 0.03),
    Vector(1826.36, -1430.53, 768.03),
    Vector(23.42, -1505.2, 768.03),
    Vector(938.83, -791.21, 768.03),
    Vector(933.48, -2292.71, 768.03),
    Vector(1922.37, -2225.92, 2560.03),
    Vector(-77.86, -618.04, 2560.03),
    Vector(-322.53, -933.33, 2558.03),
    Vector(1009.68, -2952.25, 2560.03),
    Vector(-53.45, -3484.96, 2560.03),
    Vector(44.3, -2892.71, 3280.03),
    Vector(1149.11, -2920.37, 3280.03),
    Vector(931.6, -1463.15, 3248.03),
    Vector(519.08, -2270.55, 2.03),
    Vector(1335.18, -2274.08, 2.03),
    Vector(1806.48, -1806.17, 0.03),
    Vector(65.76, -1793.79, 0.03),
    Vector(209.18, -941.25, 0.03),
    Vector(1708.61, -882.27, 0.03),
    Vector(1543.44, 2448.17, 192.03),
    Vector(1784.78, 2002.03, 192.03),
    Vector(75.35, 1999.57, 192.03),
    Vector(-68.93, 1873.5, 192.03),
    Vector(3203.53, 591.98, 192.03),
    Vector(-796.07, 582.87, -15.97),
    Vector(1863.32, 346.56, -15.97),
    Vector(-516.97, -1282.24, 32.03),
    Vector(2910.56, -1474.01, 0.03),
    Vector(5969.67, -10176.94, 4096.03),
    Vector(4480.15, -10175.7, 4096.03),
    Vector(3086.48, -10024.88, 4096.03),
    Vector(12073.03, 10624.94, 6656.03),
    Vector(9935.42, 10623.12, 6656.03),
    Vector(10513.61, 11650.85, 7015.03),
    Vector(10511.83, 9596.34, 7015.03),
    Vector(729.88, -2957.83, -127.97),
    Vector(1113.06, -2957.27, -127.97),
	Vector(928, -1285, 3288.03),
	Vector(928, -1659, 3288.03),
	Vector(-10758.41, 9806.86, -39.97),
	Vector(-11510.6, 9978.95, -69.19),
	Vector(-11045.93, 11328.98, -63.97),
	Vector(-8772.15, 11258.7, -119.97),
	Vector(-8499.69, 11258.7, -119.97),
	Vector(-10571.81, 9803.77, -63.97),
}

function Initialize()

    NextTime = CurTime() + NextDelay

    LogPrint( "Initialized.", nil, "Spawner" )

end

hook.Add( "Initialize", "SpawnerInit", Initialize )

hook.Add( "PlayerInitialSpawn", "SpawnerRarity", function(ply)

    Rarity[ply:SteamID64()] = Rarity[ply:SteamID64()] || 1

end )

local meta = FindMetaTable( "Player" )

function meta:GetRarity()

    return Rarity[self:SteamID64()]

end

function meta:SetRarity( rarity )

    Rarity[self:SteamID64()] = math.Clamp( rarity, 0, 1 )

end

function Start()

    Active = true
    StartTime = CurTime()

    if IsChristmas then

        BroadcastLua( [[ surface.PlaySound( "player/sleigh_bells/tf_xmas_sleigh_bells_20.wav" ) ]] )
        GTowerChat.AddChat( "Presents have appeared around the tower!", Color( 208, 251, 255), "Server" )

        for i = 1, 4 do
            
            LastSpawn = 0
            Think()

        end

        return

    end

    GTowerChat.AddChat( T( "SpawnerHalloweenStart" ), Color( 255, 140, 0, 255 ), "Server" )

end

function End()

    NextTime = CurTime() + NextDelay
    Active = false

    Cleanup()

    if IsChristmas then

        GTowerChat.AddChat( "The presents have disappeared...", Color( 208, 251, 255), "Server" )

        return

    end

    GTowerChat.AddChat( T( "SpawnerHalloweenEnd" ), Color( 255, 140, 0, 255 ), "Server" )

end

function Cleanup()

    for _, v in ipairs( Entities ) do
        v:Remove()
    end

end

function Think()

    if not EnabledConvar:GetBool() then return end
    if not Enabled then return end

    if not Active then
        
        if ( NextTime != -1 and CurTime() >= NextTime ) then
            Start()
        end
        
        return
    end

    // spawner
    if StartTime + ActiveLength <= CurTime() then
        End()
        return
    end

    for _, v in ipairs( Entities ) do
        
        if not IsValid( v ) then
            table.RemoveByValue( Entities, v )
        end

    end

    if table.Count( Entities ) >= EntityLimit then return end

    local pos = table.Random( Positions )

    for _, v in ipairs( ents.FindInSphere( pos, 25 ) ) do

        if v:GetClass() == SpawnEntity then
            return
        end

    end

    if LastSpawn > CurTime() then return end

    for _, ply in ipairs( player.GetAll() ) do
        
        ply:SetRarity( ply:GetRarity() + 0.1 )

    end

    LastSpawn = CurTime() + math.random( NextSpawn[1], NextSpawn[2] )

    local ent = ents.Create( SpawnEntity )
    ent:SetPos( pos )
    ent:Spawn()

    table.uinsert( Entities, ent )

    if IsChristmas then

        sound.Play( "misc/jingle_bells/jingle_bells_nm_0" .. math.random( 5 ) .. ".wav", pos, 70 )

    end

end

hook.Add( "Think", "HolidaySpawnerThink", Think )