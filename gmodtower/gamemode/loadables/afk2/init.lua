include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

util.AddNetworkString("GTAfk")
util.AddNetworkString("ResetAFK")

AFKTime = 60
AFKWarnTime = 15

if engine.ActiveGamemode() == "gmtlobby" then
	AFKTime = 360
	AFKWarnTime = 30
end

function SendAFK(warn,ply,time)
	if warn then
		net.Start( "GTAfk" )
		net.WriteInt( 0, 4 )
		net.WriteInt( CurTime() + time , 32 )
		net.Send(ply)
	else
		net.Start( "GTAfk" )
		net.WriteInt( 1, 4 )
		net.Send(ply)
	end
end

ChatCommands.Register( "/afk", 60, function( ply )
	ply.AFK = true
	ply.AFKWarned = true
	ply.AfkTime = (CurTime())
	ply:SetNWBool("AFK",true)
	net.Start( "GTAfk" )
	net.WriteInt( 0, 4 )
	net.WriteInt( CurTime() , 32 )
	net.Send(ply)

	local SanitizedName = stringmod.SafeChatName(ply:Name())

	GAMEMODE:ColorNotifyAll( T("AfkBecome", SanitizedName ), Color(200, 200, 200, 255) )

	return ""
end )

hook.Add("Think","GTAfkThink",function()
	for k,v in pairs(player.GetAll()) do
		if !v.AfkTime then
			v.AFK = false
			v.AFKWarned = false
			v.AfkTime = (CurTime() + AFKTime)
		end

		if (CurTime() > v.AfkTime - AFKWarnTime) and !v.AFKWarned then
			v.AFKWarned = true
			SendAFK(true,v, AFKWarnTime)
		elseif !(CurTime() > v.AfkTime - AFKWarnTime) and v.AFKWarned then
			v.AFKWarned = false
			SendAFK(false,v)
		else
			--v.AFKWarned = false
		end

		if (CurTime() > v.AfkTime) then
			if !v.AFK then
				v.AFK = true
				v:SetNWBool("AFK",true)
				hook.Run("GTAfk",true,v)

				local SanitizedName = stringmod.SafeChatName(v:Name())

				GAMEMODE:ColorNotifyAll( T("AfkBecome", SanitizedName ), Color(200, 200, 200, 255) )

				if engine.ActiveGamemode() == "gmtlobby" and !v:IsAdmin() then
					if (game.MaxPlayers() - player.GetCount()) < 5 then
						v:Kick("AFK")
					end
				end
			end
		else
			if v.AFK then
				v.AFK = false
				v:SetNWBool("AFK",false)
				hook.Run("GTAfk",false,v)

				local SanitizedName = stringmod.SafeChatName(v:Name())

				GAMEMODE:ColorNotifyAll( T("AfkBack", SanitizedName ), Color(200, 200, 200, 255) )
			end
		end

	end
end)

hook.Add( "KeyPress", "GTAfkKeys", function( ply, key )
	if ( key == IN_JUMP ) then
		ply.Jumps = (ply.Jumps or 0) + 1
		if ply.Jumps > 2 then return end
	else
		ply.Jumps = 0
	end

	if ( key == IN_ATTACK or key == IN_ATTACK2 ) then return end

	ply.AfkTime = (CurTime() + AFKTime)

end )

hook.Add( "PlayerSay", "GTAfkChats", function( ply )
	ply.AfkTime = (CurTime() + AFKTime)
end )
