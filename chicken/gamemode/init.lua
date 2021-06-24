include("shared.lua")

function GM:PlayerInitialSpawn( ply )
   ply:SetWalkSpeed(100)
   ply:SetRunSpeed(100)
end

function GM:PlayerSetModel( ply )
   ply:SetModel( "models/headcrabclassic.mdl" )
end
