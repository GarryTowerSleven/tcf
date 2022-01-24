
hook.Add("SQLStartColumns", "SQLSelectHat", function()
	SQLColumn.Init( {
		["column"] = "hat",
		["update"] = function( ply )
			return GTowerHats:GetHat( ply, 1 )
		end,
		["defaultvalue"] = function( ply )
			GTowerHats:SetHat( ply, 0, 1 )
		end,
		["onupdate"] = function( ply, val )
			//Timer for next frame because store data has not yet loaded
			timer.Simple( 0.0, function() GTowerHats.SetHat( GTowerHats, ply, val, 1 ) end)
		end
	} )
end )

hook.Add("SQLStartColumns", "SQLSelectFaceHat", function()
	SQLColumn.Init( {
		["column"] = "faceHat",
		["update"] = function( ply )
			return GTowerHats:GetHat( ply, 2 )
		end,
		["defaultvalue"] = function( ply )
			GTowerHats:SetHat( ply, 0, 2 )
		end,
		["onupdate"] = function( ply, val )
			//Timer for next frame because store data has not yet loaded
			timer.Simple( 0.0, function() GTowerHats.SetHat( GTowerHats, ply, val, 2 ) end)
		end
	} )
end )

concommand.Add("gmt_sethat", function( ply, cmd, args )

	if hook.Call( "CanUpateHat", GAMEMODE, ply ) == true || GTowerHats:Admin( ply ) then
		local Return = GTowerHats:SetHat( ply, args[1], args[2] )
		
		if Return then
			ply:Msg2( Return, "hat" )
		end
	end

end )


function GTowerHats:SetHat( ply, hat, hatSlot )
	if !IsValid(ply) then return end

	if !hat then
		hat = 0
	end

	if GAMEMODE.NoHats then return end

	if hatSlot then hatSlot = tonumber(hatSlot) end

	local function isFace() return hatSlot == SLOT_FACE end

	//if self.DEBUG then
	//	Msg("Setting " .. ply:Name() .. " hat to: " .. tostring( hat ) .. "\n")
	//	Msg( debug.traceback() )
	//end

	if string.len( hat ) > 3 then //If it is too big, it msut be a string
		hat = self:GetHatByName( string.Trim( hat ) )
	else
		hat = tonumber( hat )
	end

	if self.DEBUG then Msg( tostring( ply ) .. " chaning to hat " .. tostring(hat) .. "\n") end

	local HatTbl = self.Hats[ hat ]
	local LastHat

	if isFace() then LastHat = ply.PlayerFaceHat else LastHat = ply.PlayerHat end

	if hat == 0 || !HatTbl then
		if isFace() then ply.PlayerFaceHat = 0 else ply.PlayerHat = 0 end
		if self.DEBUG then Msg("Hat not found with id ".. hat .. "\n") end
	else
		if isFace() then ply.PlayerFaceHat = hat else ply.PlayerHat = hat end

		local StoreId = GTowerStore:GetItemByName( HatTbl.unique_Name )

		if !StoreId || ply:GetLevel( StoreId ) == 0 then
			if !(ply:IsAdmin() && hat == 11) then
				if isFace() then ply.PlayerFaceHat = 0 else ply.PlayerHat = 0 end
				if self.DEBUG then Msg("Player does not have the right to wear the hat" .. hat .. "\n") end
			end
		end
	end

	if (isFace() && LastHat == ply.PlayerFaceHat && !replacing) or (!isFace() && LastHat == ply.PlayerHat && !replacing) then
		return
	end

	if (isFace() && ply.PlayerFaceHat == 0) then
		ply:RemoveHat(isFace())
		return T("HatFaceNone")
	elseif (!isFace() && ply.PlayerHat == 0) then
		ply:RemoveHat(isFace())
		return T("HatNone")
	end

	if self.DEBUG then Msg( tostring( ply ) .. " is using hat " .. hat .. "\n") end

	--ply:ReplaceHat( HatTbl.model, ply.PlayerHat )

	if isFace() then
		//ply:ReplaceHat( HatTbl.model, ply.PlayerFaceHat, hatSlot )
		ply:ReplaceHat( HatTbl.unique_Name, HatTbl.model, ply.PlayerFaceHat, hatSlot )
	else
		//ply:ReplaceHat( HatTbl.model, ply.PlayerHat, hatSlot )
		ply:ReplaceHat( HatTbl.unique_Name, HatTbl.model, ply.PlayerHat, hatSlot )
	end

	if HatTbl.ModelSkin then
		if isFace() then
			ply.FaceHat:SetSkin( HatTbl.ModelSkin )
		else
			ply.Hat:SetSkin( HatTbl.ModelSkin )
		end
	end

	return T("HatUpdated",HatTbl.Name)

end

function GTowerHats:GetHat( ply, hatSlot )
	if GAMEMODE.NoHats then return nil end //DO NOT ALLOW HATS TO BE SET

	if hatSlot == SLOT_FACE then
		return ply.PlayerFaceHat
	else
		return ply.PlayerHat
	end
end

// for respawning the hats when a player respawns IE game.CleanUpMap in pvpbattle
hook.Add("PlayerSpawn", "PlayerRecreateHat", function(ply)
	if ply.PlayerHat then
		GTowerHats:SetHat(ply, ply.PlayerHat, true)
	end
end)