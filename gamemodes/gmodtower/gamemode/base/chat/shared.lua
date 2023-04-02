GTowerChat.Bubble = "models/extras/info_speech.mdl"
GTowerChat.TypeBits = 6
GTowerChat.ChatGroups = { 
	[1] = "Server", 
	[2] = "Group", 
	[3] = "Local", 
	[4] = "Theater", 
	[5] = "Join/Leave", 
	[6] = "Emotes",
	[7] = "Duels",
}

function GTowerChat.GetChatEnum( typestr )

	if not GTowerChat.ChatGroups then return end

	for k,v in ipairs( GTowerChat.ChatGroups ) do
		if v == typestr then
			return k
		end
	end

end

local function PlayerBubble( ply, old, new )
	if SERVER then return end
	if !IsValid( ply ) then return end

	if new then
		ply:StartChatBubble()
	else
		ply:EndChatBubble()
	end

end

plynet.Register( "Bool", "Chatting", { callback = PlayerBubble } )