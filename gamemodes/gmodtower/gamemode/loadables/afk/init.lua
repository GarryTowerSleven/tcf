include("shared.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

module( "AntiAFK", package.seeall )

Time = 300
WarningTime = 30

// Placeholder
function ForceReset()
	return false
end

function Set( ply, afk )
	if ( ply:GetNet( "AFK" ) == afk ) then return end

	ply.AFK = afk
	ply:SetNet( "AFK", afk )
	ply._AFKTime = afk and CurTime() or nil

	Send( ply, afk, 0 )

	local trans = afk and "AfkBecome" or "AfkBack"
	GAMEMODE:ColorNotifyAll( T( trans, ply:GetName() ), Color( 200, 200, 200 ) )

	hook.Run( "PlayerAFK", ply, afk )
end

function Send( ply, afk, time )

	if ( not IsValid( ply ) ) then return end
	if ( afk and ply._AFKWarned ) then return end

	local id = afk and 0 or 1

	net.Start( "GTAfk" )

		net.WriteInt( id, 4 )

		if ( afk ) then
			net.WriteInt( CurTime() + ( time or WarningTime ), 32 )
		end

	net.Send( ply )

	ply._AFKWarned = afk

end

local meta = FindMetaTable( "Player" )
if ( not meta ) then return end

function meta:ResetAFKTimer()
	self._AFKTime = nil
end

function meta:SetAFK( afk )
	Set( self, afk )
end

if ChatCommands then
	ChatCommands.Register( "/afk", 10, function( ply )
		Send( ply, true, 0 )
		Set( ply, true )
	end )
end

timer.Create("CheckAfkKickerPlayerThink", 1.0, 0, function()

	if IsLobby then
		local MaxSlots = GetMaxSlots()
		--local Count = #player.GetAll()) --gatekeeper.GetNumClients()
		local Count = player.GetCount()
		
		if ( MaxSlots - Count <= 5 ) then
			ShouldKick = true
		else
			ShouldKick = false
		end
	end

end )

hook.Add( "PlayerThink", "AFKPlayerThink", function( ply )
	if ( TestingMode and TestingMode:GetBool() ) then return end
	if ( not IsValid( ply ) or ply:IsBot() ) then return end

	// Too abusable by macroers... Sorry
	/*if IsLobby then // only check eye trace in lobby, people get teleported around A Lot in gamemodes
		// check eye trace, could be a better place for this
		local eyetrace = ply:EyeAngles()

		if ( ply._LastEyeTrace != eyetrace ) then
			ply:ResetAFKTimer()
			ply._LastEyeTrace = eyetrace
		end
	end*/

	local curtime = CurTime()

	if ( not ply._AFKTime ) then
		local _time = Location.IsTheater( ply:Location() ) and Time * 2 or Time
		ply._AFKTime = CurTime() + _time
	end

	local timeleft = math.Clamp( ply._AFKTime - curtime, 0, ply._AFKTime )

	if ( timeleft > WarningTime ) then
		if ( ply._AFKWarned ) then
			ply._AFKWarned = false
			Send( ply, false )
		end

		Set( ply, false )
	end

	if ( timeleft <= WarningTime ) then
		Send( ply, true, timeleft )
	end

	if ( timeleft <= 0 ) then
		Set( ply, true )
	end
	
	if ply.AFK && !ply:IsStaff() then
		if IsLobby && ShouldKick then
			ply:Kick("You have been kicked to free slots due to being AFK while the server is near max players.")
		elseif !IsLobby then
			ply:Kick("You have been kicked for being AFK. Type 'retry' in console if you'd like to rejoin.")
		end
	end
end )

AFKButtons = {
	[KEY_ENTER] = true,
	[KEY_LALT] = true,
	[KEY_RALT] = true,
	[KEY_TAB] = true,
}

hook.Add( "PlayerButtonDown", "AFKKeyPress", function( ply, button )
	if ( AFKButtons[ button ] ) then return end
	if IsLobby then
		if ply._lastButton == button then
			if ply._AFKWarned or ply.AFK then
				ply._LastButtonWarn = ply._LastButtonWarn or CurTime()
				if ply._LastButtonWarn <= CurTime() then
					ply._LastButtonWarn = ply._LastButtonWarn + 3
					ply:Msg2("Please press a different button to cancel being AFK.")
				end
			end
		return end
		ply._lastButton = button
	end
	
	ply:ResetAFKTimer()
end )

hook.Add( "GTowerChat", "AFKChat", function( ply, text )
	if IsLobby then
		if ply._lastChat == text then 
			if ply._AFKWarned or ply.AFK then
				ply._LastChatWarn = ply._LastChatWarn or CurTime()
				if ply._LastChatWarn <= CurTime() then
					ply._LastChatWarn = ply._LastChatWarn + 3
					ply:Msg2("Please say something different to cancel being AFK.")
				end
			end
		return end
		ply._lastChat = text
	end
	ply:ResetAFKTimer()
end )

util.AddNetworkString( "GTAfk" )