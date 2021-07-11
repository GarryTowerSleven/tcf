---------------------------------
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function BallRacer:OpenStore( ply )
	GTowerStore:OpenStore( ply, 5 )
end

hook.Add("PlayerLevel", "Geometrically", function( ply )

	if GtowerAchivements && !ply:Achived( ACHIVEMENTS.GEOMETRICALLY ) then

		ply:SetAchivement( ACHIVEMENTS.GEOMETRICALLY , ply:GetLevel("BallRacerCube") + ply:GetLevel("BallRacerIcosahedron") + ply:GetLevel("BallRacerCatBall") + ply:GetLevel("BallRacerBomb") + ply:GetLevel("BallRacerGeo") + ply:GetLevel("BallRacerSoccerBall") + ply:GetLevel("BallRacerSpikedd") )

	end

end )