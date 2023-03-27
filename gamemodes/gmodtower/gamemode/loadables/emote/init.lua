
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
}

function GetGrammar( name )
	return Grammar[name]
end

Commands = {
	[1] = {"wave", "wave", 3},
	[2] = {"beckon", "becon", 4},
	[3] = {"bow", "bow", 3},
	[4] = {"group", "group", 1},
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

concommand.Add("gmt_emoteend", function(ply)
		ply:SetNWBool("Emoting",false)
		ply:SetNWBool("Sitting",false)
		ply:SetNWBool("Laying",false)
		ply:SetNWBool("Lounging",false)
end)

for _, emote in pairs(Commands) do
	local emoteName = emote[1]
	local Action 	= emote[2]
	local Duration	= emote[3]
	
	if emoteName == "sit" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
		if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
		ply:SetNWBool("Emoting",true)
		ply:SetNWBool("Sitting",true)

		for _, v in ipairs( Location.GetPlayersInLocation( ply:Location() ) ) do
			v:SendLua([[GTowerChat.Chat:AddText("]]..ply:Name()..[[ ]]..GetGrammar(emoteName)..[[", Color(150, 150, 150, 255))]])
		end

		return ""
		end )
	elseif emoteName == "lay" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
		if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
		ply:SetNWBool("Emoting",true)
		ply:SetNWBool("Laying",true)

		for _, v in ipairs( Location.GetPlayersInLocation( ply:Location() ) ) do
			v:SendLua([[GTowerChat.Chat:AddText("]]..ply:Name()..[[ ]]..GetGrammar(emoteName)..[[", Color(150, 150, 150, 255))]])
		end

		return ""
		end )
	elseif emoteName == "lounge" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
		if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
		ply:SetNWBool("Emoting",true)
		ply:SetNWBool("Lounging",true)

		for _, v in ipairs( Location.GetPlayersInLocation( ply:Location() ) ) do
			v:SendLua([[GTowerChat.Chat:AddText("]]..ply:Name()..[[ ]]..GetGrammar(emoteName)..[[", Color(150, 150, 150, 255))]])
		end

		return ""
		end )
	elseif emoteName == "suicide" then
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )
		if !ply:Alive() then return end
		ply:Kill()

		for _, v in ipairs( Location.GetPlayersInLocation( ply:Location() ) ) do
			v:SendLua([[GTowerChat.Chat:AddText("]]..ply:Name()..[[ ]]..GetGrammar(emoteName)..[[", Color(150, 150, 150, 255))]])
		end

		return ""
		end )
	else
		ChatCommands.Register( "/" .. emoteName, 5, function( ply )

		local vel = ply:GetVelocity() -- is this shoddy, yeah..

		if !ply:OnGround() || ply:GetNWBool("Emoting") then return end
		ply:SetVelocity(vel:GetNegated())
		ply:SetNWBool("Emoting",true)

		ply:SetNWString("EmoteName",emoteName)

		net.Start("EmoteAct")
			net.WriteString(Action)
		net.Send(ply)

		if ply:GetModel() == "models/player/hatman.mdl" && emoteName == "dance" then
		
			if !Location.IsTheater( ply.Location ) && !Location.IsNightclub( ply.Location ) && !ply:Location().CondoID then
		
				ply.DanceSND = CreateSound( ply, "misc/halloween/hwn_dance_loop.wav" )
				ply.DanceSND:PlayEx( 80, 100 )
			
			end
		end

		timer.Simple(Duration, function()
			if IsValid(ply) then 
				ply:SetNWBool("Emoting",false) 
				if ply.DanceSND then ply.DanceSND:FadeOut(1) end
			end
		end)

		for _, v in ipairs( Location.GetPlayersInLocation( ply:Location() ) ) do
			v:SendLua([[GTowerChat.Chat:AddText("]]..ply:Name()..[[ ]]..GetGrammar(emoteName)..[[", Color(150, 150, 150, 255))]])
		end

		return ""
		end )
	end

end
