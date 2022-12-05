//This is basically a more broad version of fakeself
//It gives greater control of the clientside model, 
//which makes it useful if you want to do any drastic changes not only the localplayer

module( "fakeclientmodel", package.seeall )

hook.Add( "OverrideHatEntity", "OverrideHatFake", function( ply ) 

	if IsValid( ply.TubeFakePlayer ) then
		return ply.TubeFakePlayer
	end

end )

function CreateFake( ply )

	local ent = ClientsideModel( ply:GetTranslatedModel(), RENDER_GROUP_OPAQUE_ENTITY )
	ent:SetNoDraw( true ) // We're rendering this in post
	ent:SetPlayerProperties( ply )

	return ent

end

function UpdateFakeAnimation( ply, ent, groundSpeed )

	// Check for model change
	if ent:GetModel() != ply:GetTranslatedModel() then
		ent:SetModel( ply:GetTranslatedModel() )
	end

	// Update properties (material/skin/color)
	ent:SetPlayerProperties( ply )

	local vel = ply:GetVelocity():Length2D()

	// Handle playback rate
	local playRate = 1
	if vel > 0.5 then
		if groundSpeed < 0.001 then
			playRate = 0.01
		else
			playRate = vel / groundSpeed
			playRate = math.Clamp( playRate, 0.01, 10 )
		end
	end
	ent:SetPlaybackRate( math.Clamp(playRate, 0.1, 2) )

	// Fixup frame advance
	if !ent.LastTick then ent.LastTick = CurTime() end
	ent:FrameAdvance( CurTime() - ent.LastTick )
	ent.LastTick = CurTime()

	// Update current sequence
	local seq = ply:GetSequence()
	if ent.LastSeq != seq then
		ent.LastSeq = seq
		ent:ResetSequence( seq ) -- If the player changes sequences, change the legs too
	end

	// Breathing!
	local breathScale = .5
	if !ent.NextBreath then ent.NextBreath = CurTime() end
	if ent.NextBreath <= CurTime() then -- Only update every cycle, should stop MOST of the jittering
		ent.NextBreath = CurTime() + 1.95 / breathScale
		ent:SetPoseParameter( "breathing", breathScale )
	end


	// Head movement
	if !ent.BodyAngle then ent.BodyAngle = 0 end

	local aim = ply:EyeAngles()
	if seq != ent:LookupSequence( "idle_all_01" ) then
		ent.BodyAngle = aim.y
	else
		local diff = math.NormalizeAngle( aim.y - ent.BodyAngle )
		local abs = math.abs( diff )
		if abs > 45 then
			local norm = math.Clamp( diff, -1, 1 )
			ent.BodyAngle = math.NormalizeAngle( ent.BodyAngle + ( diff - 45 * norm ) )
		end
	end

	local HeadYaw = math.NormalizeAngle( aim.y - ent.BodyAngle )
	ent:SetAngles( Angle( 0, ent.BodyAngle, 0 ) )

	ent:SetPoseParameter( "head_pitch", math.Clamp( aim.p - 40, -19, 20 ) )
	ent:SetPoseParameter( "body_pitch", -aim.p )
	ent:SetPoseParameter( "head_yaw", HeadYaw )

	// Movement pose parameters
	ent:SetPoseParameter( "move_x", ( ply:GetPoseParameter( "move_x" ) * 2 ) - 1 ) -- Translate the walk x direction
	ent:SetPoseParameter( "move_y", ( ply:GetPoseParameter( "move_y" ) * 2 ) - 1 ) -- Translate the walk y direction
	ent:SetPoseParameter( "move_yaw", ( ply:GetPoseParameter( "move_yaw" ) * 360 ) - 180 ) -- Translate the walk direction
	ent:SetPoseParameter( "body_yaw", ( ply:GetPoseParameter( "body_yaw" ) * 180 ) - 90 ) -- Translate the body yaw
	ent:SetPoseParameter( "spine_yaw",( ply:GetPoseParameter( "spine_yaw" ) * 180 ) - 90 ) -- Translate the spine yaw

end

function Draw( ent, renderPos, renderAng, modelScale )
	ent:SetNoDraw(false)
	// We don't want them wibbly wobbling
	renderAng.p = 0

	ent:SetRenderOrigin( renderPos )
	ent:SetRenderAngles( renderAng )
	ent:SetupBones()
	ent:SetModelScale( modelScale, 0 )
	ent:DrawModel()
	ent:SetNoDraw(true)
end