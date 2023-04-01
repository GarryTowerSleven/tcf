GTowerLanguage = {}
local Lang = 1

local LangTable = {}
local LangNames = {}

function GTowerLanguage.AddLang(id, Fullname)

	LangTable[id] = {}
	LangNames[id] = FullName

end

function GTowerLanguage.AddWord(id, key, word)
	LangTable[id][ key ] = word
end

function GetTranslation(name, ...)

	local args = {...}
	local str = LangTable[ Lang ][ name ]
	
	if str == nil then
		str = LangTable[ 1 ][ name ] // look for english
		
		if str == nil and TestingMode:GetBool() then
			
			Msg("Error: Translation of '".. tostring(name) .."' not  found!\n")
			return ""
			
		end
	end
	
	if #args > 0 && str then
		str = string.gsub( str, "{(%d+)}", 
			function(s) return args[ tonumber(s) ] or "{"..s.."}" end
		)
	end    
	
	return str

end
T = GetTranslation


local LangFiles = {"english"}
for _, v in pairs( LangFiles ) do

	if SERVER then
		AddCSLuaFile(  v ..".lua" )
	end
		
	include(  v ..".lua" )

end