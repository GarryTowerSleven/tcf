---------------------------------
util.AddNetworkString("ChatBubble")
util.AddNetworkString("ColorNotify")

AddCSLuaFile("cl_autocomplete.lua")
AddCSLuaFile("richformat.lua")
AddCSLuaFile("cl_richtext.lua")
AddCSLuaFile("cl_maingui.lua")
AddCSLuaFile("cl_chatbubble.lua")
AddCSLuaFile("cl_emotes.lua")
AddCSLuaFile("cl_settings.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

GTowerChat = {}

include("shared.lua")
include("adminchat.lua")
include("sqllog.lua")

function PlayerBubble(ply, enable)
	net.Start("ChatBubble")
	net.WriteEntity(ply)
	net.WriteBool(enable)
	net.Broadcast()
end

concommand.Add("gmt_chat", function( ply, cmd, args )
	local chatting = tobool( args[1] )
	ply.Chatting = chatting

	if ply.Chatting then PlayerBubble( ply, true ) else PlayerBubble( ply, false ) end

	// second arg is true if a hack was detected
	if ( !tobool( args[ 2 ] ) ) then return end

	if ( ply.NextHackCheck && ply.NextHackCheck >= CurTime() ) then return end

	local name = SQL.getDB():Escape( ply:GetName() )
	local serverId = GetConVarNumber( "gmt_srvid" ) or 99

	local query = "REPLACE INTO gm_hackerlog ( SteamID, Name, ServerID ) " ..
		"VALUES ( '" .. ply:SteamID() .. "' , '" .. name .. "', " .. tostring( serverId ) .. " );"

	SQL.getDB():Query( query, function( arg, result, query, error )
	end )

	ply.NextHackCheck = CurTime() + ( 60 * 10 ) // allow the next check in 10 mins
end)

--[[hook.Add("KeyPress", "UnHaxChat", function(ply, key)
	if ply.Chatting then
		ply.Chatting = false
	end
end)]]--

local wordfilter = {
	fuck		= "hug",
	slap		= "kick",
	punch		= "ban",
	nigger		= "racist",
	nigga		= "racist",
	fag			= "log",
	furry		= "coat hanger",
	tetris		= "blockles",
	abuse		= "kill me",
	aboose		= "kill me please~",
	abose		= "kill me now",
	abusive		= "kill me i'm a bug~",
	abusing		= "letting me live",
	baconbot	= "bacon and eggs",
	serenity	= "titanic",
	shit		= "smith",
	bieber		= "beaver",
	yiff		= "pencil push",
	rabbit		= "wabbit",
	catbot    = "catboy",
}

concommand.Add("say2", function(ply, cmd, args)
	local type = args[1]

	local chat = table.concat(args, " ", 2)
	ply:ConCommand("say (Local) "..chat)
end)

hook.Add( "PlayerCanSeePlayersChat", "GTChatHookLocal", function( text, team, listener, speaker )

	if speaker:GetNWBool("GlobalGag") then return false end

	if string.StartWith( text, "(Local)" ) then
		if (GTowerLocation:GetPlyLocation(listener) == GTowerLocation:GetPlyLocation(speaker)) then return true else return false end
	else
		return true
	end

end )

hook.Add( "PlayerSay", "GTChatHook", function( ply, chat, toall, type )
	local type = type or "Server"

	local spam, reason = GAMEMODE:CheckSpam(ply, chat)

	hook.Run("GTCommands", ply, chat)

	if ply:IsAdmin() then
		if ( string.sub( string.lower(chat), 1, 2 ) == "!l" ) then
			me = ply
			RunString(string.sub( chat, 4 ),"GTChatLua")
			return ''
		end
	end

	if string.StartWith(chat,"/") then
		return ''
	end

	if spam then
		ply:Msg2(reason)
		return ""
	end

	if !ply:GetSetting( "GTAllowAllTalk" ) and !ply:IsAdmin() then
		for k,v in pairs(wordfilter) do
			chat = string.Replace(chat, k, v)
		end
	end

	local newchat = GAMEMODE:DrunkSay(ply, chat, toall)
	if newchat then
		chat = newchat
	end

	if IsValid(ply.Hat) && ply.Hat:GetModel() == "models/gmod_tower/catears.mdl" && #chat >= 5 then
		chat = chat .. " ~nyan"
	end

	if IsValid(ply.Hat) && ply.Hat:GetModel() == "models/gmod_tower/toetohat.mdl" && #chat >= 5 then
		chat = chat .. " ~etoeto"
	end

	local rp = nil

	if !toall && ply.HasGroup && ply:HasGroup() then
		type = "Group"
		local Group = ply:GetGroup()
		rp = Group:GetRP()
	elseif toall then
		type = "Local"
	end

	/*if rp then
		local typeid = 1

		for k,v in pairs(GTowerChat.ChatGroups) do
			if v == type then
				typeid = k
			end
		end

		umsg.Start("Chat2", rp)
			umsg.Char(typeid)
			umsg.Entity(ply)
			umsg.String(chat)
		umsg.End()
		return ""
	end*/

	return chat
end )

function GM:CheckSpam(pl, msg)
	local lastmsg = pl.lastmsg or ""
	local count = pl.spamcount or 0
	local msgaverage = pl.msgaverage or 0
	local lastmsgtime = pl.lastmsgtime or 0

	pl.lastmsg = string.lower(msg)
	pl.lastmsgtime = CurTime()

	if lastmsg == msg then
		pl.spamcount = count + 1
	else
		pl.spamcount = 0
	end

	if pl.spamcount >= 2 && !pl:IsAdmin() then
		return true, "You're repeating yourself"
	end

	pl.msgaverage = (msgaverage + math.Clamp(CurTime() - lastmsgtime, 0, 2)) / 2

	if pl.msgaverage < 1 && !pl:IsAdmin() then
		return true, "Slow down"
	end

	return false
end

local random_words = {
	"monkey","fart","banana","waffle","pancake","gerbil",
	"tree","sammich","jeebus","pickle","lumpin","cracker",
	"elephant","llama","egor","taco","humpy","dumpy","eggo",
	"funky","hanky","panky","elmer","popsicle","disco",
	"donut","nipple","penis","boobies","wooters","buttsecks",
	"popcat","domo","invisible","jackalope","chupicabra",
	"explode","qwerty","mingebag","kurplunk","apple","lazy",
	"moar","boar","scrotum","garry","chad","brandon","jinto",
	"foszor","mario","lugi","donkey kong","jackass","yoshi",
	"thar","bubble bobble","lego","viagra","spam","lag","wtf",
	"squiggle","giggle","google","yahoo","disney","steam","dunce",
	"testicle","tickle","sushi","erection","explosive diarrhea",
	"buttplug","assrape","earrape","blarg","huzzah","retard",
	"midget","dwarf","ufo","alien","cup o noodle","meatball",
	"dingdong","ding","dong","twinkey","mule","stool","toilet",
	"digimon","roofie","bunghole","indian","bull sperm","ass wrinkle",
	"gadar","radar","boobiefart","humperstien","yoddle","circus",
	"plumber","weenie","huge knockers","dilbert","frog","boogie",
	"snotrocket","hippofartomus","Jessica Alba","poptart","pringles",
	"asscrackers","vodka","whiskey","beer","barney","hax","slappy",
	"merbil","meese","geese","tiggly","miggly","shmerbil","smuckers",
	"poopcat","beesechurger","tardy","#$@#$","&*#$@#","@!","crapple",
	"mudkipz","seaking","fluffy","emo","indiana jones","privates",
	"nuttsack","buttfuck","ass","fuck","dick","pussy","damn",
	"weaksauce","poker face","poker","face","sex","furry","yiff",
	"anime","hentai","weeaboo","otaku","irrelephant","buntcag","bouchedag",
	"porn","mail","azuisleet","voided","rabbit","bunny","frankenstien","money",
	"shnoz","groin","gayben","gaben","foobama","obama","ACTA","tool","RIAA","MPAA",
	"piracy","weenis","auntymay","how r u hi","nerd","voidy","fishing"
}

function GM:DrunkSay(pl, text, team)

	if pl:IsAdmin() then
		return
	end

	local bal = pl.BAL
	if( bal <= 5 ) then

		return;

	end

	// blow up our chat into words.
	local words = string.Explode( " ", text );

	if ( bal > 20 ) then

		// swap out some words.
		local amt = math.Clamp( ( #words / 3 ) * ( bal / 100 ), 1, 10 );

		// count
		for i = 1, amt do

			// find two words
			local a = math.random( 1, #words );
			local b = math.random( 1, #words );

			// swap them out
			local aword = words[ a ];
			local bword = words[ b ];
			words[ a ] = bword;
			words[ b ] = aword;

		end
	end

	if ( bal > 35 ) then

		// inject words
		local amt = math.Clamp( ( #words / 6 ) * ( bal / 100 ), 1, 10 );

		for i = 1, amt do

			// grab a random word
			local num = math.random( 1, #random_words );
			local pos = math.random( 1, #words );
			local word = random_words[ num ];

			for k, v in pairs( wordfilter ) do
				word = string.Replace( word, k, v )
			end

			// add it
			table.insert( words, pos, word );

		end

	end

	// letters we want to slur.
	local letters = {

		"a", "e", "i", "o",
		"u", "y", "z", "s"

	};

	// slur!
	for i = 1, #words do

		// extract word
		local word = words[ i ];

		// grab each letter
		for j = 1, #word do

			// grab letter
			local letter = string.sub( word, j, j );

			// should we slur it?
			if ( table.HasValue( letters, letter:lower() ) && math.random( 1, 3 ) == 1 ) then

				// repeat it
				local slur = math.ceil( ( bal / 100 ) * math.random( 2, 5 ) );
				local first = string.sub( word, 1, j - 1 );
				local last = string.sub( word, j + 1 );
				word = first .. string.rep( letter, slur ) .. last;

			end

		end

		// put the word back in
		words[ i ] = word;

	end

	// done
	return table.concat( words, " " );

end

function GM:ColorNotifyAll(message,color)
	net.Start( "ColorNotify" )
		net.WriteString( message) 
		net.WriteColor( color )
	net.Broadcast()
end

function GM:ColorNotifyPlayer(ply,message,color)
	net.Start( "ColorNotify" )
		net.WriteString( message ) 
		net.WriteColor( color )
	net.Send(ply)
end
