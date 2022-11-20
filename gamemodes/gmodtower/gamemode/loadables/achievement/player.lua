
local meta = FindMetaTable("Player")

if !meta then
	ErrorNoHalt("ERROR: Could not find Player meta table!")
	return
end

function meta:SetAchievement( id, value, add )

	if !self._Achievements then
		//ErrorNoHalt("Attention: Setting achievement: " .. id .. " before the player was loaded.\n")
		return
	end

	local Achievement = GTowerAchievements:Get( id )

	if !Achievement then
		ErrorNoHalt("Attention: Setting achievement: " .. id .. " that does not exist.\n")
		return
	end

	local OldValue = self._Achievements[ id ]

	if Achievement.BitValue == true && add then

		if add > Achievement.Value || add < 0 then
			Msg("ERROR: Achievement ".. Achievement.Name .." Adding bit bigger than Achievement.Value\n")
			return
		end

		local ActualValue = math.pow( 2, add )

		self._Achievements[ id ] = bit.bor( OldValue or 0, ActualValue )

		//Msg("Adding value: " .. ActualValue .. " ("..add..")\n")
		//Msg("ActualValue value: " .. self._Achievements[ id ] .. " (".. self:GetAchievement( id ) ..")\n")
		//Msg("\t" .. table.concat( bit.tobits( self._Achievements[ id ] ), ",") .. "\n")

	else

		if add then
			value = value + add
		end

		self._Achievements[ id ] = math.Clamp( value, 0, Achievement.Value )
	end


	if OldValue != self._Achievements[ id ] && self:GetAchievement( id ) == Achievement.Value then
		umsg.Start( "GTAchWin", self )
			umsg.Short( id )
		umsg.End()

		local sfx = EffectData()
			sfx:SetOrigin( self:GetPos() )
		util.Effect( "confetti", sfx, true, true )

		self:EmitSound( "GModTower/music/award.wav", 100, 100 )
		self:AddMoney( ( Achievement.GMC or 500 ) )

		local SanitizedName = string.SafeChatName(self:Name())

		GAMEMODE:ColorNotifyAll( SanitizedName.." earned the achievement "..Achievement.Name, Color( 255, 200, 0, 255 ) )

		hook.Call("Achievement", GAMEMODE, self, id )
	end
end

function meta:GetAchievement( id, raw )

	if !self._Achievements then
		ErrorNoHalt("Attention: Getting achievement: " .. id .. " before the player was loaded.\n")
		ErrorNoHalt( debug.traceback() )
		return 0
	end

	local Achievement = GTowerAchievements:Get( id )
	if Achievement && Achievement.BitValue == true && self._Achievements[ id ] then
		if raw != true then
			local PlyVal = bit.tobits( self._Achievements[ id ] )
			local Value = 0

			for _, v in pairs( PlyVal ) do
				if v == 1 then
					Value = Value + 1
				end
			end

			return Value

		end
	end

	return self._Achievements[ id ] or 0

end

function meta:AddAchievement( id, value )

	self:SetAchievement( id, self:GetAchievement( id ), value )

	return

end

function meta:Achived( id )
	local Achievement = GTowerAchievements:Get( id )

	if Achievement then
		return self:GetAchievement( id ) == Achievement.Value
	end
end

function meta:AchievementLoaded()
	return self._Achievements != nil
end
