
local RespawnTime = ( 60 * 15 )

local MerchPlaces = {
  { Vector( 1368.255005, 931.885620, -671.968750 ),   Angle( 0.000, 135.660, 0.000) },
  { Vector( 660.731201, -586.471191, -671.864441 ),   Angle( 0.000, -90.000, 0.000) },
  { Vector( 5380.198730, 2410.458252, -895.765503 ),  Angle( 0.000, 180.660, 0.000) },
  { Vector( 3014.729736, -3104.293213, -894.367981 ), Angle( 0.000, 90.000, 0.000) },
  { Vector( -6434.196289, 2997.284424, -895.804321 ), Angle( 0.000, -90.000, 0.000) },
  { Vector( -623.772217, -1369.533325, -671.542847 ), Angle( 0.000, 46.870, 0.000) },
  { Vector( 1451.998291, -1131.559692, -671.968750 ), Angle( 0.000, 137.145, 0.000) },
  { Vector( 662.123657, 582.220886, -671.509644 ),    Angle( 0.000, 81.475, 0.000) },
  { Vector( 2991.084717, 3000.905273, -895.205444 ),  Angle( 0.000, -88.605, 0.000) },
  { Vector( 5383.101563, -2409.311279, -895.863831 ), Angle( 0.000, -180.880, 0.000) },
  { Vector( 5440.457520, 219.455307, -895.561890 ),   Angle( 0.000, -43.625, 0.000) }
}

CurMerchant = NULL
LastMerchantPos = nil

local function SpawnActualMerchant( num )
  local ent = ents.Create( "gmt_npc_merchant" )
  ent:SetPos( MerchPlaces[ num ][1] )
  ent:SetAngles( MerchPlaces[ num ][2] )
  ent:Spawn()

  CurMerchant = ent

end

function SpawnRandomMerchant()
  if IsValid(CurMerchant) then
    local vPoint = CurMerchant:GetPos()
    local effectdata = EffectData()
    effectdata:SetOrigin( vPoint )
    util.Effect( "gmt_adminsmoke_effect", effectdata, true, true )

    LastMerchantPos = CurMerchant:GetPos()
    CurMerchant:Remove()
  end

  local RandMerch = math.random( 1, #MerchPlaces )

  if LastMerchantPos == nil then
    SpawnActualMerchant( RandMerch )
  else

    if MerchPlaces[ RandMerch ][1] == LastMerchantPos then
      if ( #MerchPlaces <= ( RandMerch + 1 ) ) then
        SpawnActualMerchant( ( RandMerch + 1 ) )
      else
        SpawnActualMerchant( ( RandMerch - 1 ) )
      end
    else
      SpawnActualMerchant( RandMerch )
    end

  end

  //SendMessageToPlayers( "MerchantMove", GTowerLocation:GetName( GTowerLocation:FindPlacePos(CurMerchant:GetPos()) ) )
end

hook.Add("InitPostEntity","Lobby2MerchantSpawn",function()

  if IsValid(CurMerchant) then return end

  SpawnRandomMerchant()

  timer.Create( "SpawnNewMerchant", RespawnTime, 0, SpawnRandomMerchant )

end)
