local meta = FindMetaTable( "Player" )
if !meta then
	Msg("ALERT! Could not hook Player Meta Table\n")
	return
end

local sprint_minimum = .2

function meta:CanRechargeSprint()

	self.SprintCooldown = self.SprintCooldown or 0
	local cooldown = self.SprintCooldown

	return ( ( !self:GetNWBool("IsChimera") && CurTime() >= cooldown ) || ( self:GetNWBool("IsChimera") && self:IsOnGround() && !self:GetNWBool("IsRoaring") && !self:GetNWBool("IsBiting") && !self:GetNWBool("IsStunned") ) && !self:KeyDown( IN_SPEED ) )

end

function meta:CanSprint()

	if (self:GetNWFloat("Sprint") > 0 && self:IsOnGround()) then

		if (self:GetNWBool("IsTaunting") || self:GetNWBool("IsScared") || self:GetNWBool("IsRoaring") || self:GetNWBool("IsBiting")) then
			return false
		else
			return true
		end

		if self:Team() == TEAM_PIGS && !self:GetNWBool("IsSprintting") then
			return true
		end

		return false

	end

	return false

end


function GM:SprintKeyPress( ply, key ) //pigs sprint

	if (key != IN_SPEED || ply:GetNWFloat("Sprint") < sprint_minimum) then
		return
	end

	if ply:CanSprint() then
		ply:SetNWBool("IsSprintting",true)
	end

end


if SERVER then

	function meta:HandleSprinting()  //when they're actually sprinting

		if self:GetNWBool("IsSprintting") then

			local drain = GAMEMODE.SprintDrain

			if self:GetNWBool("IsChimera") then
				drain = drain - .0075
			else
				--drain = drain - ( .000000025 * ( self:GetNWInt("Rank") / 4 ) )
				drain = (drain - (.005 * (self:GetNWInt("Rank") / 4)));
			end

			self:SetNWFloat("Sprint",self:GetNWFloat("Sprint")-drain)

			if self:GetNWFloat("Sprint") <= 0 then //you're all out man!

				self:SetNWBool("IsSprintting",false)

				if CurTime() > self.SprintCooldown then
					self.SprintCooldown = CurTime() + 2
				end

				self:SetupSpeeds()

				return

			end
		end

		if (!self:GetNWBool("IsSprintting") && self:GetNWFloat("Sprint") < 1 && self:CanRechargeSprint()) then

			local recharge = GAMEMODE.SprintRecharge

			if self:GetNWBool("IsChimera") then
				recharge = recharge + .00005
			else

				local num = .00075
				if self:Crouching() then
					num = .02
				end

				recharge = recharge + ( num * ( self:GetNWInt("Rank") / 4 ) )

			end

			local clamp = math.Clamp( self:GetNWFloat("Sprint") + recharge, 0, 1 )
			self:SetNWFloat("Sprint",clamp)

		end

		self:UpdateSpeeds()

	end

	hook.Add( "Think", "UC_SprintThink", function()

		for _, ply in ipairs( player.GetAll() ) do

			if !ply:Alive() then ply:SetNWBool("IsSprintting",false) continue end

			ply:SetNWFloat("Sprint",ply:GetNWFloat("Sprint",1))
			if ply:GetNWBool("IsChimera") then ply:SetNWBool("IsSprintting",false) end

			ply.SprintCooldown = ply.SprintCooldown or 0

			if ply:GetNWBool("IsChimera") || !ply:GetNWBool("IsSprintting") then
				ply:SetNWBool("IsSprintting",ply:KeyDown( IN_SPEED ) && ply:MovementKeyDown() && ply:CanSprint() && ply:IsOnGround() && ply:IsMoving())
			end

			if ply:GetNWBool("IsScared") then
				ply:UpdateSpeeds()
				continue
			end

			ply:HandleSprinting()

		end

	end )

else

	local sprintbar = surface.GetTextureID( "UCH/hud_sprint_bar" )
	local ucsprintbar = surface.GetTextureID( "UCH/hud_sprint_bar_UC" )

	local sw, sh = ScrW(), ScrH()

	function GM:DrawSprintBar( x, y, w, h )

		local ply = LocalPlayer()

		if ( !ply:GetNWFloat("Sprint") && !ply:GetNWBool("IsScared") ) || ( ply:Team() == TEAM_PIGS && !ply:Alive() ) then
			return
		end

		local mat = sprintbar
		local rankcolor = ply:GetRankColor()
		local r, g, b = rankcolor.r, rankcolor.g, rankcolor.b

		if ply:GetNWBool("IsChimera") then
			mat = ucsprintbar
			r, g, b = 255, 255, 255
		end

		local a = ply.SprintBarAlpha

		ply.SprintMeterSmooth = ply.SprintMeterSmooth || ply:GetNWFloat("Sprint")

		local diff = math.abs( ply.SprintMeterSmooth - ply:GetNWFloat("Sprint") )

		ply.SprintMeterSmooth = math.Approach( ply.SprintMeterSmooth, ply:GetNWFloat("Sprint"), FrameTime() * ( diff * 5 ) )

		draw.RoundedBox( 0, x, y, w, h, Color( 130, 130, 130, a ) )

		if !ply:GetNWBool("IsChimera") then
			draw.RoundedBox( 0, x, y, ( w * sprint_minimum ), h, Color( 100, 100, 100, a ) )
		end

		surface.SetTexture( mat )
		surface.SetDrawColor( Color( r, g, b, a ) )
		surface.DrawTexturedRect( x, ( y + 1), ( w * ply.SprintMeterSmooth ), h )

		if ply.SprintMeterSmooth <= .02 || ply:GetNWBool("IsScared") then
			local alpha = ( 100 + ( math.sin( CurTime() * 5 ) * 45 ) )
			draw.RoundedBox( 0, x, y, w, h, Color( 250, 0, 0, alpha ) )
		end

	end

end
