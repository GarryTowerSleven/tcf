---------------------------------
util.AddNetworkString("JoinFriendCheck")
GTowerAdmins = {
	//"STEAM_0:0:71992617", -- Haina, praise be
	"STEAM_0:0:1384695", -- Kity
	"STEAM_0:1:124798129", -- Amgona
	//"STEAM_0:1:85508734", -- Breezy
	//"STEAM_0:1:57386100", -- Squibbus
	"STEAM_0:0:156132358", -- Basical
}

GTowerAdminPrivileged = {
}

GTowerSecretAdmin = {
	"STEAM_0:0:44458854", -- Bumpy
	"STEAM_0:1:39916544", -- Anomaladox
	"STEAM_0:0:38865393", -- Emma
	"STEAM_0:0:618033331", -- kity alt
}

GtowerAdmin = {}

function IsAdmin(steamid)
	return (GTowerAdmins and table.HasValue(GTowerAdmins, steamid))
		or (GTowerAdminPrivileged and table.HasValue(GTowerAdminPrivileged, steamid))
			or (GTowerSecretAdmin and table.HasValue(GTowerSecretAdmin, steamid))
end

concommand.Add("gmt_create",function(ply,cmd,args,str)

	if !args[1] then return end
	if !ply:IsAdmin() then return end

	if !util.IsValidModel(args[1]) then
		local ent = ents.Create(args[1])
		ent:SetPos(ply:GetEyeTrace().HitPos)
		ent:Spawn()
		AdminNotif.SendStaff( ply:Nick() .. " has created \"" .. ent:GetClass() .. "\" at: " .. string.FormatVector(ply:GetEyeTrace().HitPos) .. ".", nil, "GREEN", 2 )
		return 
	end

	local ent = ents.Create("prop_physics_multiplayer")

	ent:SetPos(ply:GetEyeTrace().HitPos)
	ent:SetModel(args[1])
	ent:Spawn()
	AdminNotif.SendStaff( ply:Nick() .. " has created \"" .. ent:GetClass() .. "\" (" .. args[1] .. ") at: " .. string.FormatVector(ply:GetEyeTrace().HitPos) .. ".", nil, "GREEN", 2 )
end)

concommand.Add( "gt_act", function(ply, command, args)
    if !ply:IsStaff() then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 5, command, args )
		end
		return
	end


    if #args < 1 then
		if GTowerHackers then
			GTowerHackers:NewAttemp( ply, 1, command, args )
		end
		return
	end

	if args[1] == "addent" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) && ply:IsAdmin() then

		local EntName = args[2]
		local EntTable = scripted_ents.GetList()[ EntName ]

		if !EntTable then
			return
		end

		if EntTable.t.SpawnFunction then
			local DropEnt = EntTable.t:SpawnFunction( ply, ply:GetEyeTrace() )

			if ( !DropEnd ) then return end

			if DropEnt.LoadRoom && type( DropEnt.LoadRoom ) == "function" then
				DropEnt:LoadRoom()
			end
		end

		return

	elseif args[1] == "rement" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) && ply:IsAdmin() then
		local Ent = ply:GetEyeTrace().Entity

		if IsValid( Ent ) && !Ent:IsPlayer() && Ent:GetClass() != "func_brush" then
			AdminNotif.SendStaff( ply:Nick() .. " has removed \"" .. Ent:GetClass() .. "\" at: " .. string.FormatVector(Ent:GetPos()) .. ".", nil, "RED", 2 )
			Ent:Remove()
		end

		return

	elseif args[1] == "physgun" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) && ply:IsAdmin() then

		if !ply:HasWeapon("weapon_physgun") then
			ply:Give("weapon_physgun")
		end

		return

	end

	if #args < 2 then
		return
	end


	//Player based answers
    local TargetPly = Entity( tonumber( args[2] ) )

    if TargetPly == nil then return end
    if !TargetPly:IsPlayer() then return end

	local ActionTable = {
		"ungagged",
		"gagged",
		"unmuted",
		"muted"	
	}

	local CommandActionMessage = function( Name1, Name2, Action )
		Name1 = string.SafeChatName( Name1 )
		
		GAMEMODE:ColorNotifyAll( Name1.." has "..Action.." "..Name2..".", Color(150, 35, 35, 255) )
	end

    if args[1] == "slay" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) && ply:IsAdmin() then

		AdminNotif.SendStaff( ply:Nick() .. " has slayed " .. TargetPly:NickID() .. ".", nil, "RED", 2 )
        TargetPly:Kill()

		elseif args[1] == "givemoney" && ply:IsAdmin() then
			
			player.GetByID(args[2]):AddMoney(tonumber(args[3]))

			local color = "GREEN"
			local givenName = player.GetByID(args[2]):NickID()
			if player.GetByID(args[2]) == ply then
				givenName = "themself"
			end
			local adminMsg = ply:Nick() .. " has given " .. givenName .. " " .. string.FormatNumber(tonumber(args[3])) .. " GMC."
			local userMessage = ply:Name() .. " has given you " .. string.FormatNumber(tonumber(args[3])) .. " GMC."
			if tonumber(args[3]) < 0 then
				color = "RED"
				adminMsg = ply:Nick() .. " has taken away " .. string.FormatNumber(tonumber(args[3])/-1) .. " GMC from " .. givenName .. "."
				userMessage = ply:Nick() .. " has taken away " .. string.FormatNumber(tonumber(args[3])/-1) .. " GMC from you."
			end

			AdminNotif.SendStaff( adminMsg, nil, color, 2 )
			if ply != player.GetByID(args[2]) then
				net.Start("AdminMessage")
					net.WriteEntity(nil)
					net.WriteString(userMessage)
				net.Send(player.GetByID(args[2]))
			end

		elseif args[1] == "gag" then

			local SanitizedName = string.SafeChatName(player.GetByID(args[2]):Name())

			if player.GetByID(args[2]):GetNWBool("GlobalGag") then
				ply:Msg2( SanitizedName .. " is no longer gagged for this session")
				player.GetByID(args[2]):SetNWBool("GlobalGag",false)
				CommandActionMessage( ply:Name(), SanitizedName, ActionTable[1] )
				AdminNotif.SendStaff( ply:Nick() .. " has ungagged " .. TargetPly:NickID() .. ".", nil, "GREEN", 3 )
				return
			end

			ply:Msg2( SanitizedName .. " is now gagged for this session")
			player.GetByID(args[2]):SetNWBool("GlobalGag",true)
			player.GetByID(args[2]):Msg2("You have been chat gagged. Your chat was not sent on the public channel.")
			CommandActionMessage( ply:Name(), SanitizedName, ActionTable[2] )
			AdminNotif.SendStaff( ply:Nick() .. " has gagged " .. TargetPly:NickID() .. ".", nil, "RED", 3 )

		elseif args[1] == "mute" then

			local SanitizedName = string.SafeChatName(player.GetByID(args[2]):Name())

			if player.GetByID(args[2]):GetNWBool("GlobalMute") then
				ply:Msg2( SanitizedName .. " is no longer muted for this session")
				player.GetByID(args[2]):SetNWBool("GlobalMute",false)
				CommandActionMessage( ply:Name(), SanitizedName, ActionTable[3] )
				AdminNotif.SendStaff( ply:Nick() .. " has unmuted " .. TargetPly:NickID() .. ".", nil, "GREEN", 3 )
				return
			end

			ply:Msg2(SanitizedName .. " is now muted for this session")
			player.GetByID(args[2]):SetNWBool("GlobalMute",true)

			CommandActionMessage( ply:Name(), SanitizedName, ActionTable[4] )
			AdminNotif.SendStaff( ply:Nick() .. " has muted " .. TargetPly:NickID() .. ".", nil, "RED", 3 )

		elseif args[1] == "revive" && ply:IsAdmin() then

				local RevPly = player.GetByID(args[2])

				AdminNotif.SendStaff( ply:Nick() .. " has revived " .. RevPly:NickID() .. ".", nil, "GREEN", 3 )

				RevPly:UnSpectate()

				local pos = RevPly:GetPos()
				local ang = RevPly:EyeAngles()

				RevPly:Spawn()

				RevPly:SetPos( pos )
				RevPly:SetEyeAngles( ang )

    elseif args[1] == "slap" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) && ply:IsAdmin() then

       /* local TargetLife = TargetPly:Health() - tonumber(args[3] or 5)

        if TargetLife <= 0 then

            TargetPly:Kill()

        else

            TargetPly:SetHealth( TargetLife )
            TargetPly:SetVelocity( VectorRand() * 2048 )

        end */

		TargetPly:TakeDamage( tonumber(args[3] or 5), ply, ply )

		if TargetPly:Alive() then
			 TargetPly:SetVelocity( VectorRand() * 2048 )
		end

	elseif args[1] == "money" && args[3] && ply:IsAdmin() then

		local Amount = tonumber( args[3] )
		if Amount == nil then Amount = 0 end

		local before = TargetPly:Money()
		local color = "GREEN"
		if Amount < before then
			color = "RED"
		end

		TargetPly:SetMoney( Amount )

		ply:Msg2( "You set " .. TargetPly:Name() .. "'s GMC to " .. string.FormatNumber(tonumber(Amount)) .. ". (Was " .. string.FormatNumber(tonumber(before)) .. ")" )

		if ply != TargetPly then
			AdminNotif.SendStaff( ply:Nick() .. " has set " .. TargetPly:NickID() .. "'s GMC to " .. string.FormatNumber(tonumber(Amount)) .. ". (Was " .. string.FormatNumber(tonumber(before)) .. ")", nil, color, 2 )
			net.Start("AdminMessage")
			net.WriteEntity(nil)
			net.WriteString(T("AdminSetMoney", ply:GetName(), string.FormatNumber(tonumber(Amount))))
			net.Send(TargetPly)
		else
			AdminNotif.SendStaff( ply:Nick() .. " has set their GMC to " .. string.FormatNumber(tonumber(Amount)) .. ". (Was " .. string.FormatNumber(tonumber(before)) .. ")", nil, color, 2 )
		end

    end

	hook.Call("AdminCommand", GAMEMODE, args, ply, TargetPly )

end )

hook.Add("PlayerInitialSpawn", "GTowerCheckAdmin", function(ply)

	if table.HasValue(GTowerAdmins, ply:SteamID()) || game.SinglePlayer() then
		ply:SetUserGroup( "superadmin" )
	elseif table.HasValue(GTowerAdminPrivileged, ply:SteamID()) then
		ply:SetUserGroup( "privadmin" )
	elseif table.HasValue( GTowerSecretAdmin, ply:SteamID()) then
		ply:SetUserGroup( "superadmin" )
		ply:SetNWBool( "SecretAdmin", true )
	end

end )

hook.Add( "PlayerFullyJoined", "JoinedMessage", function(ply)
	if IsLobby then
		ply:Joined()

		if ply:GetNWBool("IsNewPlayer") then
			ply:MsgI("gmtsmall", "LobbyWelcomeNew" )
		else
			ply:MsgI("gmtsmall", "LobbyWelcome",ply:Name() )
		end
	
		if ply.CosmeticEquipment then
	
			for k,v in pairs( ply.CosmeticEquipment ) do
				if v:GetNWString("HatName") then
					local hat = GTowerHats:GetHatByName(v:GetNWString("HatName"))
					if hat then
						hat = GTowerHats.Hats[hat].Name or "Unknown"
						ply:MsgI("hat", "HatUpdated", hat)
					end
				end
			end
		end
	end

	net.Start("JoinFriendCheck")
		net.WriteEntity(ply)
	net.Broadcast()
end)

hook.Add("PlayerDisconnected","LeaveMessage",function(ply)
	/*if ply.HasResetData then
		local SanitizedName = string.SafeChatName(ply:Name())
		GAMEMODE:ColorNotifyAll( SanitizedName.." has reset their data and left the tower.", Color(100, 100, 100, 255) )
		return
	end*/

	if IsLobby then
		if ply.HideRedir then return end
		ply:Left()
	end

	if Dueling.IsDueling( ply ) then
		local Timestamp = os.time()
		local TimeString = os.date( "%H:%M:%S - %d/%m/%Y" , Timestamp )
		SQLLog( 'duel', ply:Nick() .. " has left the game during a duel. (" .. TimeString .. ")" )
	end
end)

function GetAdminRP()

	local rp = RecipientFilter()

	for _, ply in ipairs( player.GetAll() ) do
		if ply:IsAdmin() then rp:AddPlayer( ply ) end
	end

	return rp

end

// Increasing security, maybe someday it will be safe to bring these back

concommand.Add("gmt_runlua", function( ply, cmd, args )

	if ply:IsAdmin() then

		local Lua = table.concat( args, " ")

		AdminNotif.SendStaff( ply:Nick() .. " has ran lua. See console for details.", nil, "YELLOW", 1 )
		AdminLog.PrintStaff( tostring(Lua), "YELLOW" )

		//kityPrint( ply:Nick() .. " has ran LUA", Color(255,255,0) )
		kityPrint( tostring(Lua), Color(255,255,0) )

		RunString("function GmtRunLua() " .. Lua .. " end ")

		local B, retrn = SafeCall( GmtRunLua )

		--ply:Msg2( tostring(retrn) )

	end

end )


concommand.Add("gmt_svrunlua", function( ply, cmd, args )

	if ply:IsAdmin() then

		local Lua = table.concat( args, " ")

		RunString("function GmtRunLua() " .. Lua .. " end ")

		local B, retrn = SafeCall( GmtRunLua )

		if type( retrn ) == "table" then
			retrn = table.ToNiceString( retrn )
		end

		ply:Msg2( tostring(retrn) )

	end

end )

concommand.Add("gmt_sendlua", function( ply, cmd, args )
	if ply:IsAdmin() then

		AdminNotif.SendStaff( ply:Nick() .. " has sent lua to all players. See console for details.", nil, "YELLOW", 1 )
		AdminLog.PrintStaff( tostring(Lua), "YELLOW" )

		kityPrint( ply:Nick() .. " has sent lua to all players.", Color(255,255,0) )
		kityPrint( tostring(Lua), Color(255,255,0) )

		BroadcastLua( table.concat( args, " ")  )
	end
end )

concommand.Add("gmt_cvar", function( ply, cmd, args )
	if ply:IsAdmin() then

		local Cvar = args[1]

		if args[2] then
			RunConsoleCommand(Cvar , args[2] )
		else
			ply:Msg2( Cvar .. " = " .. GetConVarString( Cvar ) )
		end

	end

end )

concommand.Add( "gmt_warn", function( ply, cmd, args )
	if !ply:IsStaff() then return end
	if !args[1] || !args[2] then return end
	if !IsValid(player.GetByID(args[1])) then return end

	net.Start("AdminWarn")
		net.WriteString(args[2])
	net.Send(player.GetByID(args[1]))

	AdminNotif.SendStaff( ply:Nick() .. " has warned " .. player.GetByID(args[1]):NickID() .. " for: " .. args[2] .. ".", nil, "RED", 2 )
end)

util.AddNetworkString("AdminWarn")

// we probably should remove this before release
concommand.Add("gmt_quitplayer", function( ply, cmd, args )
	if args[1] && tonumber(args[1]) && ply:IsAdmin() then
		if ents.GetByIndex(args[1]) && ents.GetByIndex(args[1]):IsPlayer() then
			AdminNotif.SendAdmins( ply:Nick() .. " has FORCEQUIT " .. ents.GetByIndex(args[1]):NickID(), 20, "RED", 1 )
			ents.GetByIndex(args[1]):SendLua( "LocalPlayer():ConCommand('gamemenucommand quit')" )
		end
	end
end )