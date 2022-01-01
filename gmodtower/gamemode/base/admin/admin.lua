---------------------------------
util.AddNetworkString("JoinFriendCheck")
GTowerAdmins = {
	//"STEAM_0:0:71992617", -- Haina, praise be
	"STEAM_0:0:1384695", -- Kity
	"STEAM_0:1:124798129", -- Amgona
	"STEAM_0:1:85508734", -- Breezy
	"STEAM_0:1:57386100", -- Squibbus
	"STEAM_0:0:156132358", -- Basical
}

GTowerAdminPrivileged = {
}

GTowerSecretAdmin = {
	"STEAM_0:0:44458854", -- Bumpy
	"STEAM_0:1:39916544", -- Anomaladox
}

GtowerAdmin = {}

function IsAdmin(steamid)
	return (GTowerAdmins and table.HasValue(GTowerAdmins, steamid))
		or (GTowerAdminPrivileged and table.HasValue(GTowerAdminPrivileged, steamid))
			or (GTowerSecretAdmin and table.HasValue(GTowerSecretAdmin, steamid))
end

concommand.Add("gmt_create",function(ply,cmd,args,str)

	if !ply:IsAdmin() then return end

	if !util.IsValidModel(args[1]) then
		local ent = ents.Create(args[1])
		ent:SetPos(ply:GetEyeTrace().HitPos)
		ent:Spawn()
	end

	local ent = ents.Create("prop_physics_multiplayer")

	ent:SetPos(ply:GetEyeTrace().HitPos)
	ent:SetModel(args[1])
	ent:Spawn()

end)

concommand.Add( "gt_act", function(ply, command, args)
    if !ply:IsAdmin() then
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

	if args[1] == "addent" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) && ply:IsSuperAdmin() then

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

	elseif args[1] == "rement" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) then
		local Ent = ply:GetEyeTrace().Entity

		if IsValid( Ent ) && !Ent:IsPlayer() && Ent:GetClass() != "func_brush" then
			Ent:Remove()
		end

		return

	elseif args[1] == "physgun" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) then

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

    if args[1] == "slay" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) then

        TargetPly:Kill()

		elseif args[1] == "givemoney" then

			player.GetByID(args[2]):AddMoney(tonumber(args[3]))

			if ply != TargetPly then
				net.Start("AdminMessage")
					net.WriteEntity(nil)
					net.WriteString(ply:Name().." gave you "..tonumber(args[3]).." GMC")
				net.Send(player.GetByID(args[2]))
			end

		elseif args[1] == "gag" then

			local SanitizedName = string.SafeChatName(player.GetByID(args[2]):Name())

			if player.GetByID(args[2]):GetNWBool("GlobalGag") then
				ply:Msg2( SanitizedName .. " is no longer gagged for this session")
				player.GetByID(args[2]):SetNWBool("GlobalGag",false)
				CommandActionMessage( ply:Name(), SanitizedName, ActionTable[1] )
				return
			end

			ply:Msg2( SanitizedName .. " is now gagged for this session")
			player.GetByID(args[2]):SetNWBool("GlobalGag",true)
			player.GetByID(args[2]):Msg2("You have been chat gagged. Your chat was not sent on the public channel.")
			CommandActionMessage( ply:Name(), SanitizedName, ActionTable[2] )

		elseif args[1] == "mute" then

			local SanitizedName = string.SafeChatName(player.GetByID(args[2]):Name())

			if player.GetByID(args[2]):GetNWBool("GlobalMute") then
				ply:Msg2( SanitizedName .. " is no longer muted for this session")
				player.GetByID(args[2]):SetNWBool("GlobalMute",false)
				CommandActionMessage( ply:Name(), SanitizedName, ActionTable[3] )
				return
			end

			ply:Msg2(SanitizedName .. " is now muted for this session")
			player.GetByID(args[2]):SetNWBool("GlobalMute",true)

			CommandActionMessage( ply:Name(), SanitizedName, ActionTable[4] )

		elseif args[1] == "revive" then

				local RevPly = player.GetByID(args[2])

				RevPly:UnSpectate()

				local pos = RevPly:GetPos()
				local ang = RevPly:EyeAngles()

				RevPly:Spawn()

				RevPly:SetPos( pos )
				RevPly:SetEyeAngles( ang )

    elseif args[1] == "slap" && !hook.Call("DisableAdminCommand", GAMEMODE, args[1]) then

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

	elseif args[1] == "money" && args[3] then

		local Amount = tonumber( args[3] )
		if Amount == nil then Amount = 0 end

		TargetPly:SetMoney( Amount )

		ply:Msg2( "You set \"" .. TargetPly:Name() .. "\"'s money to " .. Amount .. "." )

		if ply != TargetPly then
				net.Start("AdminMessage")
				net.WriteEntity(nil)
				net.WriteString(T("AdminSetMoney", ply:GetName(), Amount))
				net.Send(TargetPly)
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
				for _, hat in pairs( GTowerHats.Hats ) do
					if v:GetModel() == hat.model then
						ply:MsgI("hat", "HatUpdated",hat.Name)
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

	if ply.ActiveDuel then
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

		MsgC( Color( 255, 255 ,0), ply:Nick() .. " is running lua: " )
		MsgC( Color( 255, 255 ,0), Lua .. "\n" )

		AdminLog( ply:Nick() .. " has ran lua. See server console for details.", Color( 255, 255 ,0) )

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
	if !ply:IsAdmin() then return end

	net.Start("AdminWarnMessage")
	net.WriteEntity(ply)
	net.WriteEntity(player.GetByID(args[1]))
	net.WriteString(args[2])
	net.Broadcast()

end)

util.AddNetworkString("AdminWarnMessage")


concommand.Add("gmt_quitplayer", function( ply, cmd, args )
	if args[1] && ply:IsAdmin() then
		player.GetBySteamID64(args[1]):SendLua( "LocalPlayer():ConCommand('gamemenucommand quit')" )
	end
end )