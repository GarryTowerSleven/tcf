function GM:KeyPress( ply, key )
	
	if !ply:IsGhost() then

		self:SprintKeyPress( ply, key )

	end

	if SERVER then
	
		if ply:IsGhost() then // spectatingish.. this could probably be better??.. and was made better!
		
			if key == IN_ATTACK then
				
				local players = player.GetAll()
				local filteredplayers = {}
				
				for _, ply in ipairs(players) do // get a list of everyone who isnt a ghost
					if !ply:IsGhost() then
						table.insert(filteredplayers, ply)
					end
				end
				
				if #filteredplayers <= ply.Spec then ply.Spec = 0 end // restart the cycle
				
				ply.Spec = ply.Spec + 1 // increase who we're going to by 1
				
				specPly = filteredplayers[ply.Spec] // set the current spec ply
				
				ply:SetPos( specPly:GetPos() ) // lets go!
				
			end
		end

		if key == IN_ATTACK2 && ply:CanTaunt() then

			local t, num = "taunt", 1.1

			if ply:GetNet( "Rank" ) == 4 then
				t, num = "taunt2", 1
			end

			ply:Taunt( t, num )

		end

		if key == IN_USE || key == IN_ATTACK then

			ply.LastPressAttempt = ply.LastPressAttempt || 0

			if CurTime() < ply.LastPressAttempt then
				return
			end

			ply.LastPressAttempt = CurTime() + .1

			if ply:IsPig() then
				
				if ply:CanPressButton() then

					if CurTime() - globalnet.GetNet("RoundStart") <= 20 then
						ply:AddAchievement( ACHIEVEMENTS.UCHSPEEDRUN, 1 )
					end

					local uc = self:GetUC()
					uc:EmitSound( "UCH/chimera/button.wav", 80, math.random( 94, 105 ) )
					
					uc.Pressed = true
					uc.Presser = ply

					ply:RankUp()
					ply:SetNet( "PressedButton", true )
					ply:AddAchievement( ACHIEVEMENTS.UCHBUTTON, 1 )
					ply:AddAchievement( ACHIEVEMENTS.UCHMILESTONE3, 1 )
					
					if !ply:IsOnGround() then
						ply:SetAchievement( ACHIEVEMENTS.UCHAERIAL, 1 )
					end

					uc:Kill()

					ply:AddFrags( 1 )

				end
				
				if key == IN_ATTACK && ply:GetNet( "HasSaturn" ) && !ply:GetNet( "IsScared" ) && !ply:GetNet( "IsTaunting" ) then

					ply:EmitSound( "UCH/saturn/saturn_throw.wav", 80, 100 )
					ply:SetNet( "HasSaturn", false )
					ply.GrabTime = CurTime() + 0.5
					
					if IsValid( ply.HeldSaturn ) then
						ply.HeldSaturn:Remove()
					end

					local ent = ents.Create( "mr_saturn" )
					if IsValid( ent ) then
						ent:SetPos( ply:GetShootPos() + Vector( 10, 0, 0 ) )
						ent:SetOwner( ply )
						ent:SetPhysicsAttacker( ply ) 
						ent:Spawn()
						ent:Activate()
						ent.ShouldSpaz = true

						local phys = ent:GetPhysicsObject()
						if IsValid(phys) then
							phys:SetVelocity( ply:GetVelocity() + ( ply:GetAimVector() * 800 ) )
						end

					end
					
					//anim hack
					umsg.Start( "SwitchLight" )
						umsg.Entity( ply )
					umsg.End()

				end

			end

		end

		if ply:GetNet( "IsChimera" ) then
			self:UCKeyPress( ply, key )
		end
	
	else
		
		if !ply:IsGhost() && key == IN_ATTACK || key == IN_USE then
			LocalPlayer().XHairAlpha = 242
		end
		
	end

end

function GM:Move( ply, move )

	if !IsValid( ply ) then return end
		
	if ply:IsGhost() then
		
		local move = ply.GhostMove( move )
		return move
		
	else

		if ply:GetNet( "IsTaunting" ) || ply:GetNet( "IsBiting" ) || ply:GetNet( "IsRoaring" ) || ( ply:GetNet( "IsChimera" ) && !ply:Alive() ) then

			ply:SetLocalVelocity( Vector( 0, 0, 0 ) )
			
			/*if !ply.LockTauntAng then
				ply.LockTauntAng = ply:EyeAngles()
			end
			
			if ply:Alive() then
				ply:SetEyeAngles( ply.LockTauntAng )
			end*/
			
			return true

		else

			//ply.LockTauntAng = nil
			return self.BaseClass:Move( ply, move )

		end
		
	end
	
end

function GM:PlayerFootstep( ply, pos, foot, sound, volume, players )
	
	if ply:GetNet( "IsChimera" ) || ply:IsGhost() then
		return true
	end
	
end

function RestartAnimation( ply )
	
	ply:AnimRestartMainSequence()

	umsg.Start( "UC_RestartAnimation" )
		umsg.Entity( ply )
	umsg.End()
	
end

hook.Add( "UpdateAnimation", "PlayerTurn", function()

	for _, ply in ipairs( player.GetAll() ) do

		if ply:GetNet( "IsChimera" ) then
			
			local ang = ply:EyeAngles()

			ply.TurnAng = ply.TurnAng or ply:EyeAngles()
			ply.TurnAng.p = 0

			local diff = math.NormalizeAngle(ply.TurnAng.y - ang.y)
			diff = math.abs(diff)

			ply.TurnAng.y = math.ApproachAngle(ply.TurnAng.y, ang.y, FrameTime() * (8 + diff * 8))

			ply:SetRenderAngles( ply.TurnAng )

		end

	end

end )