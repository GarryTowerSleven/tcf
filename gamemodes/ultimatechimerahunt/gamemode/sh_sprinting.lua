local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

local sprint_minimum = .2

function meta:CanRechargeSprint()

	if self:GetNet( "IsChimera" ) && ( !self:IsOnGround() || self:GetNet( "IsRoaring" ) || self:GetNet( "IsBiting" ) || self:GetNet( "IsStunned" ) ) then
		return false
	end

	if self:GetNet( "IsStunned" ) then
		return false
	end

	if self:GetNet( "IsScared" ) then
		return false
	end

	if !self.SprintCooldown && ( self:Alive() ) then
		return true
	end

	return false
	
end

function meta:CanSprint()
	
	if self:GetNet( "Sprint" ) <= 0 || self.Sprinting then
		return false
	end

	if self:GetNet( "IsTaunting" ) then
		return false
	end

	if self:GetNet( "IsChimera" ) && self:IsOnGround() && !self:GetNet( "IsRoaring" ) && !self:GetNet( "IsBiting" ) then
		return true
	end

	if self:GetNet( "IsScared" ) then
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
	
	if key != IN_SPEED || ply:GetNet( "Sprint" ) < sprint_minimum then
		return
	end
	
	if ply:CanSprint() then
		if SERVER then
			ply:SetNet( "IsSprinting", true )
		end
	end
	
end


if SERVER then

	hook.Add( "Think", "UC_SprintThink", function()

		for _, ply in ipairs( player.GetAll() ) do

			if !ply:Alive() then ply:SetNet( "IsSprinting", false ) continue end

			ply:SetNet( "Sprint", ply:GetNet( "Sprint", 1 ) )
			//if ply.IsChimera then ply.IsSprinting = false end

			if ply.SprintCooldown && ply.SprintCooldown < CurTime() then
				ply.SprintCooldown = nil
				ply:SetNet( "Sprint", 0.01 )
			end

			if ply:GetNet( "IsChimera" ) then
				ply:SetNet( "IsSprinting", ply:KeyDown( IN_SPEED ) && ply:MovementKeyDown() && ply:CanSprint() )
			end

			if ply:GetNet( "IsScared" ) then
				ply:UpdateSpeeds()
				continue
			end

			ply:HandleSprinting()

		end

	end )

	function meta:HandleSprinting()  //when they're actually sprinting

		if self:GetNet( "Sprint" ) <= 0 then //you're all out man!

			if !self.SprintCooldown then
				self.SprintCooldown = CurTime() + 1
			end

		end

		if self:GetNet( "IsSprinting" ) then

			local drain = GAMEMODE.SprintDrain

			if self:GetNet( "IsChimera" ) then
				drain = drain - .004

				if GAMEMODE:IsLastPigmasks() then
					drain = drain / 2
				end
			else
				drain = drain - ( .005 * ( self:GetNet( "Rank" ) / 4 ) )
			end

			self:SetNet( "Sprint", math.Clamp( self:GetNet( "Sprint" ) - drain, 0, 1 ) )

			if self:GetNet( "Sprint" ) <= 0 then //you're all out man!

				self:SetNet( "IsSprinting", false )

				self:SetupSpeeds()

				return

			end

		else

			if self:GetNet( "Sprint" ) < 1 && self:CanRechargeSprint() then

				local recharge = GAMEMODE.SprintRecharge

				if self:GetNet( "IsChimera" ) then
					recharge = recharge + .001
				else

					local num = .00075
					if self:Crouching() then
						num = .02
					end

					recharge = recharge + ( num * ( self:GetNet( "Rank" ) / 4 ) )

				end

				self:SetNet( "Sprint", math.Clamp( self:GetNet( "Sprint" ) + recharge, 0, 1 ) )

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

		if !ply:GetNet( "Sprint" ) || ( ply:Team() == TEAM_PIGS && !ply:Alive() ) then
			return
		end

		local mat = sprintbar
		local rankcolor = ply:GetRankColor()
		local r, g, b = rankcolor.r, rankcolor.g, rankcolor.b
	
		if ply:GetNet( "IsChimera" ) then
			mat = ucsprintbar
			r, g, b = 255, 255, 255
		end

		local a = ply.SprintBarAlpha
	
		local diff = math.abs( sprintSmooth - ply:GetNet( "Sprint", 1 ) )
		sprintSmooth = math.Approach( sprintSmooth, ply:GetNet( "Sprint", 1 ), FrameTime() * ( diff * 5 ) )

		draw.RoundedBox( 0, x, y, w, h, Color( 130, 130, 130, a ) )

		if !ply:GetNet( "IsChimera" ) then
			draw.RoundedBox( 0, x, y, ( w * sprint_minimum ), h, Color( 100, 100, 100, a ) )
		end
	
		surface.SetTexture( mat )
		surface.SetDrawColor( Color( r, g, b, a ) )
		surface.DrawTexturedRect( x, ( y + 1), ( w * sprintSmooth ), h )
	
		if sprintSmooth <= .02 || ply:GetNet( "IsScared" ) then
			local alpha = ( 100 + ( math.sin( CurTime() * 5 ) * 45 ) )
			draw.RoundedBox( 0, x, y, w, h, Color( 250, 0, 0, alpha ) )
		end

	end

end
