PlayerMeta = FindMetaTable( "Player" )

function PlayerMeta:RemoveUsedTNT()

	if self:HasWeapon( "weapon_tnt" ) then
		self:StripWeapon( "weapon_tnt" )

		if self:GetActiveWeapon() == "weapon_tnt" then
			self:ConCommand( "lastinv" )
		end

		self.TNTThrown = false
	end

end

function PlayerMeta:QuickUseAdrenaline()

	if !self:HasWeapon( "weapon_adrenaline" ) then return end
	
	local adrenaline = self:GetWeapon( "weapon_adrenaline" )
	if !IsValid( adrenaline ) || adrenaline.Used then
		return
	end

	self:SelectWeapon( "weapon_adrenaline" )

	ply.AdrenalineQuickUse = CurTime() + 0.15

end

function PlayerMeta:RemoveUsedAdrenaline()

	if self:HasWeapon( "weapon_adrenaline" ) then
		self:StripWeapon( "weapon_adrenaline" )
	end

end

function PlayerMeta:Adrenaline( state )

	if !IsValid( self ) then return end	

	if state then
		if SERVER then
			self:RemoveUsedAdrenaline()
			self:SetWalkSpeed( GAMEMODE.HumanSpeed + 350 )
			self:SetRunSpeed( GAMEMODE.HumanSpeed + 350 )
			self:ConCommand( "lastinv" )
		end

		self:EmitSound( "GModTower/virus/weapons/Adrenaline/use.wav" )
		self:EmitSound( "GModTower/virus/weapons/Adrenaline/heartbeat.wav" )

		local lastPlayer = team.GetPlayers( TEAM_PLAYERS )[ 1 ]

		if lastPlayer != self then
			PostEvent( self, "adrenaline_on" )
		end
		
		if SERVER && GAMEMODE:GetState() == STATE_PLAYING then
			if GAMEMODE.HasLastSurvivor && self == lastPlayer then
				self:SetAchievement( ACHIEVEMENTS.VIRUSOVERDOSE, 1 )
			end

			self:AddAchievement( ACHIEVEMENTS.VIRUSDRUGGIE, 1 )
			self:AddAchievement( ACHIEVEMENTS.VIRUSMILESTONE2, 1 )
		end

		self.AdrenalineEffects = CurTime() + 0.5
		self.AdrenalineStop = CurTime() + 10
	else
		if SERVER then
			self:ResetSpeeds()
		end
		
		self:SetDSP( 1 )

		local lastPlayer = team.GetPlayers( TEAM_PLAYERS )[ 1 ]
		if lastPlayer != self then
			PostEvent( self, "adrenaline_off" )
		end
	end

end

function PlayerMeta:ResetSpeeds()
	self:SetWalkSpeed( GAMEMODE.HumanSpeed )
	self:SetRunSpeed( GAMEMODE.HumanSpeed )
end

hook.Add( "PlayerTick", "AdrenalineThink", function( ply, mv )

	if ply.AdrenalineStart != nil then
		if ply.AdrenalineStart < CurTime() then
			ply.AdrenalineStart = nil
			ply:Adrenaline( true )
		end
	end

	if ply.AdrenalineEffects != nil then
		if ply.AdrenalineEffects < CurTime() then
			ply.AdrenalineEffects = nil
			ply:SetDSP( 6 )
		end
	end

	if ply.AdrenalineStop != nil then
		if ply.AdrenalineStop < CurTime() then
			ply.AdrenalineStop = nil
			ply:Adrenaline( false )
		end
	end

	if ply.AdrenalineQuickUse != nil then
		if ply.AdrenalineQuickUse < CurTime() then
			ply.AdrenalineQuickUse = nil
			if IsValid( ply:GetActiveWeapon() ) then
				ply:GetActiveWeapon():PrimaryAttack()
			end
		end
	end

end )