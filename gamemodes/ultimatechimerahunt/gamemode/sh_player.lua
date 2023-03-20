function GM:KeyPress( ply, key )
	
	if !ply:GetNWBool( "IsGhost" ) then

		self:SprintKeyPress( ply, key )

	end

	if SERVER then

		if key == IN_ATTACK2 && ply:CanTaunt() then

			local t, num = "taunt", 1.1

			if ply:GetNWInt( "Rank" ) == 4 then
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

					if CurTime() - GetGlobalFloat("RoundStart") <= 20 then
						ply:AddAchievement( ACHIEVEMENTS.UCHSPEEDRUN, 1 )
					end

					local uc = self:GetUC()
					uc:EmitSound( "UCH/chimera/button.wav", 80, math.random( 94, 105 ) )
					
					uc.Pressed = true
					uc.Presser = ply

					ply:RankUp()
					ply:AddAchievement( ACHIEVEMENTS.UCHBUTTON, 1 )
					ply:AddAchievement( ACHIEVEMENTS.UCHMILESTONE3, 1 )
					
					if !ply:IsOnGround() then
						ply:SetAchievement( ACHIEVEMENTS.UCHAERIAL, 1 )
					end

					uc:Kill()

					ply:AddFrags( 1 )

				end
				
				if key == IN_ATTACK && ply:GetNWBool( "HasSaturn" ) && !ply:GetNWBool( "IsScared" ) && !ply:GetNWBool( "IsTaunting" ) then

					ply:EmitSound( "UCH/saturn/saturn_throw.wav", 80, 100 )
					ply:SetNWBool( "HasSaturn", false )
					ply.GrabTime = CurTime() + 0.1
					
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

		if ply:GetNWBool( "IsChimera" ) then
			self:UCKeyPress( ply, key )
		end
	
	else
		
		if !ply:GetNWBool( "IsGhost" ) && key == IN_ATTACK || key == IN_USE then
			LocalPlayer().XHairAlpha = 242
		end
		
	end

end

function GM:Move( ply, move )

	if !IsValid( ply ) then return end
		
	if ply:GetNWBool( "IsGhost" ) then
		
		local move = ply.GhostMove( move )
		return move
		
	else

		if ply:GetNWBool( "IsTaunting" ) || ply:GetNWBool( "IsBiting" ) || ply:GetNWBool( "IsRoaring" ) || ( ply:GetNWBool( "IsChimera" ) && !ply:Alive() ) then

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
	
	if ply:GetNWBool( "IsChimera" ) || ply:GetNWBool( "IsGhost" ) then
		return true
	end
	
end

function RestartAnimation( ply )
	
	ply:AnimRestartMainSequence()

	umsg.Start( "UC_RestartAnimation" )
		umsg.Entity( ply )
	umsg.End()
	
end