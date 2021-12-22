local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

local sprint_minimum = .2

function meta:CanRechargeSprint()

	if self:GetNWBool( "IsChimera" ) && self:IsOnGround() && !self:GetNWBool( "IsRoaring" ) && !self:GetNWBool( "IsBiting" ) && !self:GetNWBool( "IsStunned" ) then
		return true
	end

	if self:GetNWBool( "IsStunned" ) then
		return false
	end

	if self:GetNWBool( "IsScared" ) then
		return false
	end

	if !self.SprintCooldown && ( self:Alive() && !self:GetNWBool( "IsChimera" ) ) then
		return true
	end

	return false
	
end

function meta:CanSprint()
	
	if self:GetNWFloat( "Sprint" ) <= 0 || self.Sprinting then
		return false
	end

	if self:GetNWBool( "IsTaunting" ) then
		return false
	end

	if self:GetNWBool( "IsChimera" ) && self:IsOnGround() && !self:GetNWBool( "IsRoaring" ) && !self:GetNWBool( "IsBiting" ) then
		return true
	end

	if self:GetNWBool( "IsScared" ) then
		return false
	end

	if !self:IsOnGround() then
		return false
	end

	if SERVER && !self:IsMoving() then
		return false
	end

	return true
	
end


function GM:SprintKeyPress( ply, key ) //pigs sprint
	
	if key != IN_SPEED || ply:GetNWFloat( "Sprint" ) < sprint_minimum then
		return
	end
	
	if ply:CanSprint() then
		ply:SetNWBool( "IsSprinting", true )
	end
	
end


if SERVER then

	hook.Add( "Think", "UC_SprintThink", function()

		for _, ply in ipairs( player.GetAll() ) do

			if !ply:Alive() then ply:SetNWBool( "IsSprinting", false ) continue end

			ply:SetNWFloat( "Sprint", ply:GetNWFloat( "Sprint", 1 ) )
			//if ply.IsChimera then ply.IsSprinting = false end

			if ply.SprintCooldown && ply.SprintCooldown < CurTime() then
				ply.SprintCooldown = nil
			end

			if ply:GetNWBool( "IsChimera" ) then
				ply:SetNWBool( "IsSprinting", ply:KeyDown( IN_SPEED ) && ply:MovementKeyDown() && ply:CanSprint() )
			end

			if ply:GetNWBool( "IsScared" ) then
				ply:UpdateSpeeds()
				continue
			end

			ply:HandleSprinting()

		end

	end )

	function meta:HandleSprinting()  //when they're actually sprinting

		if self:GetNWBool( "IsSprinting" ) then

			local drain = GAMEMODE.SprintDrain

			if self:GetNWBool( "IsChimera" ) then
				drain = drain - .004

				if GAMEMODE:IsLastPigmasks() then
					drain = drain / 2
				end
			else
				drain = drain - ( .005 * ( self:GetNWInt( "Rank" ) / 4 ) )
			end

			self:SetNWFloat( "Sprint", math.Clamp( self:GetNWFloat( "Sprint" ) - drain, 0, 1 ) )

			if self:GetNWFloat( "Sprint" ) <= 0 then //you're all out man!

				self:SetNWBool( "IsSprinting", false )

				if !self.SprintCooldown then
					self.SprintCooldown = CurTime() + 1
				end

				self:SetupSpeeds()

				return

			end

		else

			if self:GetNWFloat( "Sprint" ) < 1 && self:CanRechargeSprint() then

				local recharge = GAMEMODE.SprintRecharge

				if self:GetNWBool( "IsChimera" ) then
					recharge = recharge + .001
				else

					local num = .00075
					if self:Crouching() then
						num = .02
					end

					recharge = recharge + ( num * ( self:GetNWInt( "Rank" ) / 4 ) )

				end

				self:SetNWFloat( "Sprint", math.Clamp( self:GetNWFloat( "Sprint" ) + recharge, 0, 1 ) )

			end

		end

		self:UpdateSpeeds()

	end

else

	local sprintbar = surface.GetTextureID( "UCH/hud_sprint_bar" )
	local ucsprintbar = surface.GetTextureID( "UCH/hud_sprint_bar_UC" )

	local sw, sh = ScrW(), ScrH()
	local sprintSmooth = 0

	function GM:DrawSprintBar( x, y, w, h )

		local ply = LocalPlayer()

		if !ply:GetNWFloat( "Sprint" ) || ( ply:Team() == TEAM_PIGS && !ply:Alive() ) then
			return
		end

		local mat = sprintbar
		local rankcolor = ply:GetRankColor()
		local r, g, b = rankcolor.r, rankcolor.g, rankcolor.b
	
		if ply:GetNWBool( "IsChimera" ) then
			mat = ucsprintbar
			r, g, b = 255, 255, 255
		end

		local a = ply.SprintBarAlpha
	
		local diff = math.abs( sprintSmooth - ply:GetNWFloat( "Sprint", 1 ) )
		sprintSmooth = math.Approach( sprintSmooth, ply:GetNWFloat( "Sprint", 1 ), FrameTime() * ( diff * 5 ) )

		draw.RoundedBox( 0, x, y, w, h, Color( 130, 130, 130, a ) )

		if !ply:GetNWBool( "IsChimera" ) then
			draw.RoundedBox( 0, x, y, ( w * sprint_minimum ), h, Color( 100, 100, 100, a ) )
		end
	
		surface.SetTexture( mat )
		surface.SetDrawColor( Color( r, g, b, a ) )
		surface.DrawTexturedRect( x, ( y + 1), ( w * sprintSmooth ), h )
	
		if sprintSmooth <= .02 || ply:GetNWBool( "IsScared" ) then
			local alpha = ( 100 + ( math.sin( CurTime() * 5 ) * 45 ) )
			draw.RoundedBox( 0, x, y, w, h, Color( 250, 0, 0, alpha ) )
		end

	end

end
