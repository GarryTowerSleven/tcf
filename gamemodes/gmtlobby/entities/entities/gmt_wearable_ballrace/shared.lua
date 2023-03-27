ENT.Type 			= "anim"
ENT.Base			= "base_anim"

ENT.RenderGroup 		= RENDERGROUP_TRANSLUCENT

ENT.Model				= Model("models/gmod_tower/BALL.mdl")
ENT.RollSound			= Sound("GModTower/balls/BallRoll.wav")

local novel = Vector(0,0,0)

function ENT:Initialize()
    self:SetCustomCollisionCheck( true )
end

hook.Add( "Move", "MoveBall", function( ply, movedata )

	if !IsEntity( ply:GetBallRaceBall() ) or !IsValid( ply:GetBallRaceBall() ) then return end

	movedata:SetForwardSpeed( 0 )
	movedata:SetSideSpeed( 0 )
	movedata:SetVelocity( novel )
	if SERVER then ply:SetGroundEntity( NULL ) end

	local ball = ply:GetBallRaceBall()
	if IsValid( ball ) then
		movedata:SetOrigin( ball:GetPos() )
	end

	return true

end )

hook.Add( "PlayerFootstep", "PlayerFootstepBall", function( ply, pos, foot, sound, volume, rf )

	if IsValid( ply:GetBallRaceBall() ) then

		return true

	end

end )

/*hook.Add( "ShouldCollide", "ShouldCollideBall", function( ent1, ent2 )

	if ent1:GetClass() == "gmt_wearable_ballrace" && string.sub( ent2:GetClass(), 1, 9 ) == "func_door" then
		return false
	end

	if ent1:GetClass() == "gmt_wearable_ballrace" && ent2:GetClass() == "gmt_teleporter" then return false end

	return true

end )*/

local meta = FindMetaTable("Player")

function meta:GetBallRaceBall()
	return self:GetDriving( "gmt_wearable_ballrace" )
end