function AnimatePig( ply, velocity )

	local len2d = velocity:Length2D()

	if ply:OnGround() then

		if len2d > 0 then

			if ply:GetNet("IsSprinting") then
				ply.CalcSeqOverride = "run"
			else
				ply.CalcSeqOverride = "walk"
			end

			if ply:GetNet("IsScared") then
				ply.CalcSeqOverride = "run_scared"
			end

			if ply:Crouching() then
				ply.CalcSeqOverride = "crawl"
			end

		else

			if ply:GetNet("IsScared") then
				ply.CalcSeqOverride = "idle_scared"
			end

			if ply:Crouching() then
				ply.CalcSeqOverride = "crouchidle"
			end

		end

	else

		ply.CalcSeqOverride = "jump"

	end

	if ply:GetNet("IsTaunting") then

		local t = "taunt"

		if ply:GetNet("Rank") == RANK_COLONEL then
			t = "taunt2"
		end

		ply.CalcSeqOverride = t

	end
	
	if ply.Swimming then
		
		local vel = ply:GetVelocity()
		vel.z = 0
		
		if vel:Length() > 5 then
		
			ply.CalcSeqOverride = "swim"
			
		else
			
			ply.CalcSeqOverride = "swimidle"
			
		end
		
	end
	
	if ply.SwitchLight && !ply:GetNet("IsTaunting") then

		ply.SwitchLight = false
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_MELEE_ATTACK1, true )

	end
	
end

local function SwitchLight( um )

	local ply = um:ReadEntity()
	ply.SwitchLight = true

end
usermessage.Hook( "SwitchLight", SwitchLight )

function AnimateUC( ply, velocity )

	ply:PlaybackReset()
	
	local len2d = velocity:Length2D()
	
	if ply:OnGround() then
		
		if len2d > 0 then
		
			if ply:GetNet("IsSprinting") then		
				ply.CalcSeqOverride = "run"
			else
				ply.CalcSeqOverride = "walk"
			end
		
		end
		
	else
		
		if ply:CanDoubleJump() && ply:GetNet("DoubleJumpNum") < 1 then
			ply.CalcSeqOverride = "jump2"
		else
			ply.CalcSeqOverride = "jump3"
		end
		
	end
	
	if ply:GetNet("IsBiting") then
		ply.CalcSeqOverride = "bite"
	end

	if ply:GetNet("IsRoaring") then
		ply.CalcSeqOverride = "idle3"
	end

	if ply.TailSwipe then
		ply.TailSwipe = false
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_MELEE_ATTACK1, true )
	end
	
end

local function TailSwipe( um )
	local ply = um:ReadEntity()
	ply.TailSwipe = true
end
usermessage.Hook( "TailSwipe", TailSwipe )

function AnimateGhost( ply, velocity )

	local len2d = velocity:Length2D()
	
	local seq = "idle1"
	
	if len2d > 0 then

		if ply:GetNet("IsFancy") then
			seq = "walk2"
		else
			seq = "walk"
		end

	else

		if ply:GetNet("IsFancy") then
			seq = "idle2"
		end

	end

	ply.LastOogly = ply.LastOogly or 0
	ply.LastSippyCup = ply.LastSippyCup or 0

	if CurTime() >= ply.LastOogly then
		ply.LastOogly = CurTime() + math.Rand( 10, 20 )
		ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_GESTURE_RANGE_ATTACK2, true )
	end

	if ply:GetNet("IsFancy") && CurTime() >= ply.LastSippyCup then
		ply.LastSippyCup = CurTime() + math.Rand( 20, 40 )
		ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GESTURE_MELEE_ATTACK1, true )
	end

	if CLIENT then

		if ply.IsMicOpen then
			ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_GESTURE_RANGE_ATTACK1, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_JUMP, ACT_GESTURE_MELEE_ATTACK2, true )
		end

	end

	ply.CalcSeqOverride = seq

end