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

hook.Add( "PlayerSay", "LogChat", function( ply, text, team )
	
	if not IsValid( ply ) then return end
	if not Database.IsConnected() then return end

	local data = {
		ply = ply:DatabaseID(),
		// name = Database.Escape( ply:Nick(), true ),
		message = Database.Escape( text, true ),
		srvid = "'" .. GTowerServers:GetServerId() .. "'",
	}

	Database.Query( "INSERT INTO `gm_chat` " .. Database.CreateInsertQuery( data ) .. ";" )

end )

concommand.Add( "gmt_chat", function( ply, cmd, args )
	local chatting = tobool( args[1] or false ) or false

	ply:SetNet( "Chatting", chatting )
end )

hook.Add( "KeyPress", "UnHaxChat", function(ply, key)
	if ( ply:GetNet( "Chatting" ) ) then
		ply:SetNet( "Chatting", false )
	end
end )

local wordfilter = {
	{ "fucking", "hugging" },
	{ "fuckin", "huggin" },
	{ "fucked", "hugged" },
	{ "fucker", "hugger" },
	{ "fuck", "hug" },
	{ "shitting", "smithing" },
	{ "shitter", "smither" },
	{ "shitty", "smithy" },
	{ "shit", "smith" },
	{ "fag", "frag" },
	{ "nigger", "racist" },
	{ "nigga", "racist" },
	{ "tetris", "blockles" },
	{ "yiff", "pencil push" },
	{ "rabbit", "wabbit" },
	{ "bieber", "beaver" },
	{ "kek", "gun" },
	{ " ͡° ͜ʖ ͡°", "no" },

	{ "cunt", "friend" },
	
	{ "tranny", "transmission" },
	{ "trannies", "transmissions" },
	
	{ "retard", "muppet" },
}

function GTowerChat.FilterText( text )
	for k, v in pairs( wordfilter ) do
		local chatFiltered = text
		local chatlower = string.lower(text)

		if string.find( chatlower, v[1] ) then
			while string.find( chatlower, v[1] ) do
				local s, e = string.find( chatlower, v[1] )
				local censored
				if v[2] then
					censored = v[2]
				else
					censored = string.sub( v[1], 0, 1 ) .. string.rep( "*", #v[1] - 1 )
				end
				chatFiltered = string.sub( chatFiltered, 0, s-1 ) .. censored .. string.sub( chatFiltered, e+1 )
				chatlower = string.sub( chatlower, 0, s-1 ) .. censored .. string.sub( chatlower, e+1 )
			end
		end

		text = chatFiltered
	end

	return text
end

// Local Chat
concommand.Add("say2", function( ply, cmd, args )
	local type = args[1] or nil
	if ( not type ) then return end

	local message = args[2] or nil
	if ( not message or string.Trim( message ) == "" ) then return end

	ply:Chat( message, type )
end)

hook.Add( "PlayerCanSeePlayersChat", "GTChatHookLocal", function( text, team, listener, speaker )

	if speaker:GetNWBool("GlobalGag") then return false end

end )

hook.Add( "PlayerSay", "GTChatHook", function( ply, text, teamchat )
	local _rawtext = text
	
	hook.Run( "GTCommands", ply, text )
	
	if string.StartWith( text, "/" ) then
		return ""
	end
	
	local spam, reason = GTowerChat.CheckSpam( ply, text )
	if spam then
		ply:Msg2( reason )
		return ""
	end

	ply:Chat( text, teamchat and "Group" or "Server" )

	return ""
end )

function GTowerChat.CheckSpam(pl, msg)
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
	"donut","nipple","penis","boobies","wooters",
	"popcat","domo","invisible","jackalope","chupicabra",
	"explode","qwerty","mingebag","kurplunk","apple","lazy",
	"moar","boar","scrotum","garry","chad","brandon","jinto",
	"foszor","mario","lugi","donkey kong","jackass","yoshi",
	"thar","bubble bobble","lego","viagra","spam","lag","wtf",
	"squiggle","giggle","google","yahoo","disney","steam","dunce",
	"testicle","tickle","sushi","explosive diarrhea",
	"blarg","huzzah","earrape", "ufo","alien","cup o noodle","meatball",
	"dingdong","ding","dong","twinkey","mule","stool","toilet",
	"roofie","bunghole","indian","bull sperm","ass wrinkle",
	"gadar","radar","boobiefart","humperstien","yoddle","circus",
	"plumber","weenie","huge knockers","dilbert","frog","boogie",
	"snotrocket","hippofartomus","Jessica Alba","poptart","pringles",
	"asscrackers","vodka","whiskey","beer","barney","hax","slappy",
	"merbil","meese","geese","tiggly","miggly","shmerbil","smuckers",
	"poopcat","beesechurger","tardy","#$@#$","&*#$@#","@!","crapple",
	"mudkipz","seaking","fluffy","emo","indiana jones","privates",
	"nuttsack","buttfuck","ass","fuck","dick","pussy","damn",
	"weaksauce","poker face","poker","face","sex","anime","irrelephant","buntcag","bouchedag",
	"porn","mail","azuisleet","voided","voidy","rabbit","bunny","frankenstien","money",
	"shnoz","groin","gayben","gaben","foobama","obama","ACTA","tool","RIAA","MPAA",
	"piracy","weenis","auntymay","how r u hi","nerd","fishing",

	"troll","2012","tony stark","robert downey jr","multidimensional","quantum space", "frank sinatra", "helpmepleasegod",
	"daytona","lumpin","ron paul","beesechurger","kony 2012","goon","wambam","donate","friday",
	
	"tim sweeney",
}

function GTowerChat.DrunkSay( text, bal )

	local bal = bal or 20

	if ( bal <= 5 ) then
		return text
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
				word = string.Replace( word, v[1], v[2] )
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

function GM:ColorNotifyAll( message, color, type )
	GTowerChat.AddChat( message, color, type )
end

function GM:ColorNotifyPlayer( ply, message, color, type )
	GTowerChat.AddChat( message, color, type, ply )
end

function GTowerChat.AddChat( message, color, type, recipients )
	if ( not message ) then return end
	
	local typeid = GTowerChat.GetChatEnum( type or "Server" )
	if ( not typeid ) then return end

	net.Start( "ChatSrv" )
		net.WriteInt( typeid, GTowerChat.TypeBits )
		net.WriteString( message )
		net.WriteColor( color or color_white )
	if ( recipients ) then
		net.Send( recipients )
	else
		net.Broadcast()
	end
end

local meta = FindMetaTable( "Player" )
if ( not meta ) then return end

function meta:Chat( text, type, hidden )
	if ( not IsValid( self ) ) then return end
	if ( not text or string.Trim( text or "" ) == "" ) then return end

	if self._Gagged then
		self:ChatPrint( T( "ChatGagged" ) )
		return
	end

	if ( not IsLobby ) then
		type = "Server"
	end

	local recipients

	if ( Location && type == "Server" && Location.IsTheater( self:Location() or 0 ) ) then
		type = "Theater"
	end
	
	if ( Location && type == "Local" ) then
		recipients = Location.GetPlayersInLocation( self:Location() or 0 )
	end

	if ( type == "Group" ) then
		if ( not self.HasGroup or not self:HasGroup() ) then
			return
		end

		recipients = self:GetGroup():GetPlayers() or {}
	end
	
	local typeid = GTowerChat.GetChatEnum( type or "Server" )
	if ( not typeid ) then return end

	// Give to console
	LogPrint( Format( "%s (%s): %s", self:GetName(), type, text ), nil, "Chat" )

	if ( not self:GetSetting( "GTIgnoreChatFilters" ) ) then
		// Swear Filter
		text = GTowerChat.FilterText( text )
	
		// Drunk
		text = GTowerChat.DrunkSay( text, self:GetNet( "BAL" ) or 0 )
	
		// Hat Text
		if ( #text >= 5 ) then
			if ( Hats.IsWearing( self, "hatcatear" ) ) then
				text = text .. " ~nyan"
			end
		
			if ( Hats.IsWearing( self, "CatEarsAlternative" ) ) then
				text = text .. " ~meow"
			end
				
			if ( Hats.IsWearing( self, "CatBeanie" ) ) then
				text = text .. " ~mrow"
			end
			
			if ( Hats.IsWearing( self, "toetohat" ) ) then
				text = text .. " ~etoeto"
			end
		end
	end


	net.Start( "ChatPly" )
		net.WriteInt( typeid, GTowerChat.TypeBits )
		net.WriteEntity( self )
		net.WriteString( text )
		net.WriteBool( hidden or false )
	if ( recipients ) then
		net.Send( recipients )
	else
		net.Broadcast()
	end

	hook.Call( "GTowerChat", GAMEMODE, self, text, typeid, recipients, hidden )
end

util.AddNetworkString( "ChatSrv" )
util.AddNetworkString( "ChatPly" )