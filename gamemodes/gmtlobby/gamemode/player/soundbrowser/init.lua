AddCSLuaFile("cl_init.lua")

local GTowerSound = {}

function GTowerSound:PlaySound(soundPath, volume, pitch, entity)

	if !IsValid( entity ) then
		return
	end
	 
	umsg.Start("GMTSoundPlay" )
		umsg.Entity(entity)
		umsg.String(soundPath)
		umsg.Short( math.Clamp(tonumber(volume) or 100, 1, 255) )
		umsg.Short( math.Clamp(tonumber(pitch) or 100, 1, 255) )
	umsg.End()

end

concommand.Add("gmt_emitsound", function(ply, cmd, args) --Allows an Admin to emit a sound to all the players around them.
		
		local Volume = tonumber( args[2] )
		local Pitch = tonumber( args[3] )
		
		if !Volume || !Pitch then
			return
		end
		
		if !( ply:IsStaff() || ClientSettings:Get( ply, "GTAllowEmitSound" ) ) then return end
				
		local entity = ply
		local PlayerName = ply:GetName()
		
		for _, v in ipairs( player.GetStaff() ) do --Temporary. Want to print in console to Admins about who is playing what sound.
			v:PrintMessage(HUD_PRINTCONSOLE, PlayerName .. " played: " .. args[1])
		end
		
		GTowerSound:PlaySound(args[1], Volume, Pitch, entity )
				
	end)
	
concommand.Add("gmt_stopsounds", function(ply, cmd, args)

		if !ply:IsSuperAdmin() then return end

		BroadcastLua("RunConsoleCommand('stopsound'); ClearSoundList()")
		for _, v in ipairs(player.GetAll()) do
			v:Msg2( T("AdminClrSounds", ply:GetName() ) )
		end
		
	end)