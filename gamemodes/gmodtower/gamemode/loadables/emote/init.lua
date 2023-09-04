
include( "shared.lua" )

AddCSLuaFile( "cl_init.lua")
AddCSLuaFile( "cl_emotes.lua")
AddCSLuaFile( "shared.lua" )

util.AddNetworkString( "EmoteAct" )

--concommand.Add("gmt_endemote", function(ply, cmd, args)
	--idk
--end)

hook.Add( "PlayerShouldTaunt", "DisableTaunts", function( ply )
  if ply:GetNWBool("Emoting") then
    return true
  end

  return false
end )

local Grammar = {
	["agree"] = "agrees.",
	["beckon"] = "beckons.",
	["bow"] = "bows.",
	["disagree"] = "disagrees.",
	["group"] = "signals to group.",
	["no"] = "signals to halt.",
	["dance"] = "dances.",
	["sexydance"] = "dances sexily.",
	["sit"] = "sits.",
	["wave"] = "waves.",
	["yes"] = "signals to go forwards.",
	["taunt"] = "taunts.",
	["cheer"] = "cheers.",
	["flail"] = "flails.",
	["laugh"] = "laughs.",
	["suicide"] = "couldn't handle life anymore.",
	["lay"] = "lays down.",
	["robot"] = "does the robot.",
	["lounge"] = "lounges around.",
	["dancesync"] = "is lost to the music.",
}

function GetGrammar( name )
	return Grammar[name]
end

Commands = {
	[1] = {"wave", "wave", 3},
	[2] = {"beckon", "becon", 4},
	[3] = {"bow", "bow", 3},
	[4] = {"group", "group", 1.6},
	[5] = {"agree", "agree", 3},
	[6] = {"disagree", "disagree", 3},
	[7] = {"dance", "dance", 9},
	[8] = {"sexydance", "muscle", 13},
	[9] = {"robot", "robot", 11},
	[10] = {"no", "halt", 1.2},
	[11] = {"yes", "forward", 1},
	[12] = {"taunt", "pers", 2},
	[13] = {"cheer", "cheer", 2.5},
	[14] = {"flail", "zombie", 2.5},
	[15] = {"laugh", "laugh", 6},
	[16] = {"suicide", "", 0},
	[17] = {"lay", "", 0},
	[18] = {"sit", "", 0},
	[19] = {"lounge", "", 0},
}

table.insert(Commands, 10, {"dancesync", "dancesync", 1})

concommand.Add( "gmt_emoteend", function(ply)
	StopAllEmotes( ply )
end )

function StopAllEmotes( ply )
	ply:SetNWBool("Emoting",false)
	ply:SetNWBool("Sitting",false)
	ply:SetNWBool("Laying",false)
	ply:SetNWBool("Lounging",false)
end

function DoEmoteChat( ply, emote )
	if ( not IsValid( ply ) ) then return end

	local grammar = GetGrammar( emote ) or nil
	if ( not grammar ) then return end

	local message = ply:GetName() .. " " .. grammar

	GTowerChat.AddChat(
		message,
		Color( 150, 150, 150, 255 ),
		"Emotes",
		Location.GetPlayersInLocation( ply:Location() )
	)
end

ChatCommands.Register("/me", 1, function(ply, msg)
	msg = string.Split(msg, " ")
	msg = table.concat(msg, " ", 2)
	msg = GTowerChat.FilterText( msg )
	GTowerChat.AddChat(
		ply:Nick() .. " " .. (msg or nil),
		Color( 150, 150, 150, 255 ),
		"Emotes"
	//	Location.GetPlayersInLocation( ply:Location() )
	)
end)

hook.Add("PlayerThink", "Taunting", function(ply)
	if ply:GetNWBool("Emoting") && !ply:IsOnGround() then
		StopAllEmotes(ply)
	end

	if ply:GetNWBool("dancing") && ply:GetModel() == "models/player/miku.mdl" then
		if !ply.DanceSND or !ply.DanceSNDTime or ply.DanceSNDTime < CurTime() then
			if ply.DanceSND then
				ply.DanceSND:FadeOut(1)
			end
			
			local mp = Location.GetMediaPlayersInLocation(ply:Location())
			mp = mp[1] and mp[1]._Media

			if !mp && !Location.IsTheater( Location.Find(ply:GetPos()) ) && !Location.IsGroup( Location.Find(ply:GetPos()), "suite" ) && !Location.IsGroup( Location.Find(ply:GetPos()), "partysuite" ) then
				local rand = math.random(18)
				if rand < 9 then
					rand = "0" .. rand
				end
				local snd = "gmodtower/lobby/mikuclock/mikuclock_song" .. rand .. ".mp3"
				ply.DanceSND = CreateSound( ply, snd )
				ply.DanceSND:SetSoundLevel(65)
				ply.DanceSND:PlayEx( .75, 100 )

				ply.DanceSNDTime = CurTime() + SoundDuration(snd) - 1
			end
		end
	elseif ply.DanceSNDTime and ply.DanceSNDTime > CurTime() then
		if ply.DanceSND then
			ply.DanceSND:FadeOut(1)
		end

		ply.DanceSNDTime = 0
	end
end)

for _, emote in pairs(Commands) do
	local emoteName = emote[1]
	local Action 	= emote[2]
	local Duration	= emote[3]
	
	if emoteName == "dancesync" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
			if ( hook.Run( "DisableEmotes", ply ) ) then return end

			if ply:GetNWBool("Emoting") then return end
			if ply:GetNWBool("Dancing") then ply:ConCommand("syncdance") return end
			
			ply:ConCommand("syncdance")
			
			DoEmoteChat( ply, emoteName )
			
			return ""
		end)
	elseif emoteName == "sit" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
			if ( hook.Run( "DisableEmotes", ply ) ) then return end

			if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
			ply:SetNWBool("Emoting",true)
			ply:SetNWBool("Sitting",true)

			DoEmoteChat( ply, emoteName )

			return ""
		end )
	elseif emoteName == "lay" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
			if ( hook.Run( "DisableEmotes", ply ) ) then return end

			if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
			ply:SetNWBool("Emoting",true)
			ply:SetNWBool("Laying",true)

			DoEmoteChat( ply, emoteName )

			return ""
		end )
	elseif emoteName == "lounge" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
			if ( hook.Run( "DisableEmotes", ply ) ) then return end

			if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
			ply:SetNWBool("Emoting",true)
			ply:SetNWBool("Lounging",true)

			DoEmoteChat( ply, emoteName )

			return ""
		end )
	elseif emoteName == "suicide" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
			if ( hook.Run( "DisableEmotes", ply ) ) then return end

			if !ply:Alive() then return end
			ply:Kill()

			DoEmoteChat( ply, emoteName )

			return ""
		end )
	else
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
			if ( hook.Run( "DisableEmotes", ply ) ) then return end

			if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
			ply:SetAbsVelocity( Vector(0,0,0) )
			ply:SetNWBool("Emoting",true)

			ply:SetNWString("EmoteName",emoteName)

			net.Start("EmoteAct")
				net.WriteString(Action)
			net.Send(ply)

			local mp = Location.GetMediaPlayer(ply:Location())

			if !IsValid(mp) || !mp:GetMediaPlayer() || !mp:GetMediaPlayer()._Media then
				if ply:GetModel() == "models/player/hatman.mdl" && emoteName == "dance" then
				
					if !Location.IsTheater( Location.Find(ply:GetPos()) ) && !Location.IsGroup( Location.Find(ply:GetPos()), "suite" ) && !Location.IsGroup( Location.Find(ply:GetPos()), "partysuite" ) then
				
						ply.DanceSND = CreateSound( ply, "misc/halloween/hwn_dance_loop.wav" )
						ply.DanceSND:PlayEx( .5, 100 )
					
					end
				elseif ply:GetModel() == "models/player/miku.mdl" && emoteName == "dance" then
					if !Location.IsTheater( Location.Find(ply:GetPos()) ) && !Location.IsGroup( Location.Find(ply:GetPos()), "suite" ) && !Location.IsGroup( Location.Find(ply:GetPos()), "partysuite" ) then
				
						ply.DanceSND = CreateSound( ply, "gmodtower/lobby/mikuclock/mikuclock_song0" .. math.random(9) .. ".mp3" )
						ply.DanceSND:SetSoundLevel(65)
						ply.DanceSND:PlayEx( .75, 100 )

					end
				end
			end

			timer.Simple(Duration, function()
				if IsValid(ply) then 
					ply:SetNWBool("Emoting",false) 
					if ply.DanceSND then ply.DanceSND:FadeOut(1) end
				end
			end)

			if emoteName == "laugh" then
				voicelines.Emit(ply, "Laughs")
			elseif emoteName == "cheer" then
				voicelines.Emit(ply, "Cheers")
			elseif emoteName == "flail" then
				voicelines.Emit(ply, "Flails")
			end

			DoEmoteChat( ply, emoteName )

			return ""
		end )
	end

end
