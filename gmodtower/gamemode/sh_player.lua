---------------------------------
local meta = FindMetaTable( "Player" )
if !meta then
	return
end

function meta:IsPrivAdmin()
	return self:IsUserGroup("privadmin") or self:IsAdmin()
end

function meta:IsSecretAdmin()
	return self:IsUserGroup("secretadmin")
end

function meta:IsDeveloper()

	return self:IsUserGroup( "developer" ) || self:IsUserGroup( "superadmin" )

end

local Tester = {
	"STEAM_0:1:85513145", -- Dan
	"STEAM_0:1:57386100", -- Squibbus
	"STEAM_0:1:72402171", -- Umbre
	"STEAM_0:0:37654169", -- Pixel
	"STEAM_0:0:59511670", -- Souper Marilogi
	"STEAM_0:1:32372838", -- dward99
	"STEAM_0:0:67367129", -- Solid Snake
	"STEAM_0:1:157016146" -- Spydermann
}

local PixelFriends = {}

local Jameskii = {}

function meta:GetTitle()
	local Titles = {}
	Titles["STEAM_0:0:71992617"] = "Owner" // HAINA

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

local Lead = {}

local Admin = {}

local Mod = {
	"STEAM_0:1:85508734", -- Bman
	"STEAM_0:1:124798129" -- Amgona
}

local Developer = {
	"STEAM_0:0:1384695", -- Cat
	"STEAM_0:0:44458854", -- Bumpy
	"STEAM_0:1:39916544" -- Anoma
}

function meta:GetDisplayTextColor()
	if self:SteamID() == "STEAM_0:0:71992617" then
		return color_lead
	end
	return team.GetColor( self:Team() )
end

function meta:IsCameraOut()
	return IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetClass() == "gmt_camera"
end
