function GM:PlayerDeath( ply, wep, killer )

	self:DoKillNotice( ply )

	ply:AddDeaths( 1 )
	ply:SetNet( "Flashlight", false )

	if ply:Team() == TEAM_PIGS then

		ply.IsDead = true // to set as ghost on next spawn
		ply.DeadPos = ply:GetPos()

		if !ply:GetNet("IsPancake") then
			ply:CreateRagdoll()
		end
		
		if ply:GetNet("IsTaunting") then
			ply:StopTaunting()
		end

		/*if ply:FlashlightIsOn() then
			ply:Flashlight()
		end*/
		
		if ply:GetNet("HasSaturn") then
		
			ply:StripSaturn()
			ply:SetNet("HasSaturn",false)

		end

		if ply:GetNet("IsPancake") then

			local color = ply:GetRankColor()
			local r, g, b = color.r, color.g, color.b
			local effectdata = EffectData()
				effectdata:SetOrigin( ply:GetPos() )
				effectdata:SetStart( Vector( r, g, b ) )
				effectdata:SetFlags( 1 )
			util.Effect( "piggy_pop", effectdata )
	
			ply:SetNet("IsPancake",false)
		end

		if team.AlivePigs() > 0 then
			self:AddTime( self.OverTimeAdd )
		end

		/*ply.DeathTime = 0
		ply.NextSecond = CurTime() + 1*/
		timer.Simple( 3, function()
			
			if !IsValid(ply) then return end
			
			if !ply:GetNet("IsChimera") && !ply:IsGhost() then
				local ang = ply:EyeAngles()
				ply:Spawn()
				ply:SetEyeAngles(ang)
			end

		end )

	end

	if ply:GetNet("IsChimera") then
		ply:SetMaterial( "models/uch/uchimera/stgnewporkultimatechimera_body2" )
		ply:CreateBirdProp()
		ply:CreateRagdoll()
	end

	self:CheckGame( ply )

end

function GM:PlayerDeathThink( ply )

	if ply:GetNet("IsChimera") then
		return false
    end

end

function GM:PlayerDisconnected( ply )

	if !self:IsPlaying() then return end

	self:CheckGame( ply )
	
end

function GM:PlayerSwitchFlashlight( ply, SwitchOn )

	if !ply:IsAdmin() then
		if !ply.FlashLightTime then ply.FlashLightTime = 0 end
		if ply.FlashLightTime > CurTime() then return false end
			
		ply.FlashLightTime = CurTime() + 1
	end

	if ply:Team() == TEAM_PIGS then
		umsg.Start( "SwitchLight" )
			umsg.Entity( ply )
		umsg.End()

		local light = ply:GetNet( "Flashlight" )

		ply:SetNet( "Flashlight", !light )
		ply:EmitSound( "vo/taunts/engy/taunt_engineer_lounge_button_press.mp3", 70, light and 130 or 140, 1, CHAN_WEAPON )
	end

    return false // ply:Team() == TEAM_PIGS

end

function GM:CanPlayerSuicide( ply ) return false end

function GM:PlayerUse( ply, ent )
	
	if ply:IsGhost() then
		return false
	end

	return true
	
end

function GM:EntityTakeDamage( ent, dmg )
	
	//local amount = dmg:GetDamage()
	
	return true
	
	//Wtf is the purpose of this??
	/* if IsValid( ent ) && ent:IsPlayer() then

		if ent:GetNet("IsChimera") || ent:IsGhost() || ( ent:Health() - amount ) <= 0 then
			
			if ent:GetNet("IsChimera") && amount > 100 then
				ent:Kill()
			end

			if ent:Alive() && !ent:GetNet("IsChimera") && ( ( ent:Health() - amount ) <= 0 ) then
				ent:Kill()
			end
			
			dmg:ScaleDamage( 0 )

		end
		
		if ent:IsPig() then
			dmg:ScaleDamage( 0 )
		end

		local inflictor = dmg:GetInflictor()
		if IsValid(inflictor) && inflictor:GetClass() == "mr_saturn" then
			return true
		end

	end */ 
	
end

function GM:PlayerDeathSound() return true end

function GM:GetFallDamage( ply, vel )
	
	if ply:IsGhost() then
		return false
	end

	if ply:GetNet("IsChimera") then
		return false
	end
	
end


function GM:PlayerDisconnected( ply )
	
	if ply:IsBot() || #player.GetBots() > 0 then return end

	//Everyone left, end the game.
	local total = player.GetAll()
	if #total < 1 then
		self:EndServer()
		return
	end
	
	self:CheckGame( ply )

end

function GM:PlayerSetModel( ply ) end

hook.Add( "PlayerThink", "UC_PiggyNoise", function( ply )

	if ply:IsPig() then
		ply:MakePiggyNoises()
	end

end )