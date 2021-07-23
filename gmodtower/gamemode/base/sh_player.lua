---------------------------------
local meta = FindMetaTable( "Player" )
if !meta then
	return
end

local Owner = {}

function IsOwner(steamid)
	return ( Owner and table.HasValue(Owner, steamid) )
end

local Developer = {
}

local Admin = {
	"STEAM_0:0:1384695", -- Cat
	"STEAM_0:1:30473979", -- Nano
	"STEAM_0:1:124798129" -- Amgona
}

local Mod = {
	"STEAM_0:1:85508734", -- Bman
}

local Tester = {
	"STEAM_0:1:85513145", -- Dan
	"STEAM_0:1:57386100", -- Squibbus
	"STEAM_0:1:72402171", -- Umbre
	"STEAM_0:0:37654169", -- Pixel
	"STEAM_0:0:59511670", -- Souper Marilogi
	"STEAM_0:1:32372838", -- dward99
	"STEAM_0:0:67367129", -- Solid Snake
	"STEAM_0:1:157016146", -- Spydermann
	"STEAM_0:1:51961500", -- Gamizard
	"STEAM_0:0:193442077", -- Nyantendo
	"STEAM_0:0:603700165", -- Anomaladox Alt
	"STEAM_0:0:72050508"   -- Glypherson
}

function IsTester(steamid)
	return ( Tester and table.HasValue(Tester, steamid) )
end

local PixelTail = {
	"STEAM_0:1:19359297", -- Wergulz, GMT Artist
	"STEAM_0:1:11414156", -- Lifeless, GMT Mapper
	"STEAM_0:0:25019928", -- Matt, GMT Mapper
	"STEAM_0:1:18712009", -- Foohy, GMT Programmer
	"STEAM_0:1:5893683", -- Zak, GMT Programmer
	"STEAM_0:1:15862026", -- Sam, GMT/Mediaplayer Programmer
	"STEAM_0:1:6044247", -- MacDGuy, Owner of PixelTail
	"STEAM_0:0:6807675", -- Johanna
	"STEAM_0:0:18456733", -- Noodleneck
	"STEAM_0:1:8932293", -- Massaki
	"STEAM_0:0:4872668" -- Plasma
}

local Jameskii = {}

function meta:IsPrivAdmin()
	return self:IsUserGroup("privadmin") or self:IsAdmin()
end

function meta:IsSecretAdmin()
	return self:IsUserGroup("secretadmin")
end

function meta:IsDeveloper()

	return self:IsUserGroup( "developer" ) || self:IsUserGroup( "superadmin" )

end

function meta:GetTitle()
	local Titles = {}

	for k, v in pairs(PixelTail) do
		Titles[v] = "Original GMT Staff"
	end

	for k, v in pairs(Owner) do
		Titles[v] = "Lead Developer"
	end

	for k, v in pairs(Developer) do
		Titles[v] = "Developer"
	end

	for k, v in pairs(Admin) do
		Titles[v] = "Admin"
	end

	for k, v in pairs(Mod) do
		Titles[v] = "Moderator"
	end

	for k, v in pairs(Tester) do
		Titles[v] = "Tester"
	end

	if Titles[self:SteamID()] then return Titles[self:SteamID()] end
end

local color_admin = Color(255, 100, 100, 255)
local color_lead = Color(248, 18, 128, 255)
local color_mod = Color(255, 128, 0, 255)
local color_developer = Color(125, 177, 30, 255)
local color_vip = Color(185, 100, 255, 255)
local color_pink = Color(255, 166, 241, 255)
local color_tester = Color(122, 178, 342, 255 )
local color_pixeltail = Color( 216, 31, 42, 255 )
local color_jameskii = Color( 0, 255, 255, 255 )

function meta:GetDisplayTextColor()
	if table.HasValue(PixelTail, self:SteamID()) then
		return color_pixeltail
	elseif table.HasValue(Owner, self:SteamID()) then
		return color_owner
	elseif table.HasValue(Developer, self:SteamID()) then
		return color_developer
	elseif table.HasValue(Admin, self:SteamID()) then
		return color_admin
	elseif table.HasValue(Mod, self:SteamID()) then
		return color_mod
	elseif table.HasValue(Tester, self:SteamID()) then
		return color_tester
	end

	return team.GetColor(self:Team())
end

function meta:IsCameraOut()
	return IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetClass() == "gmt_camera"
end
