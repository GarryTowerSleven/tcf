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

local Tester = {}

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

local Mod = {}

local Developer = {}

function meta:GetDisplayTextColor()
	if self:SteamID() == "STEAM_0:0:71992617" then
		return color_lead
	end
	return team.GetColor( self:Team() )
end

function meta:IsCameraOut()
	return IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetClass() == "gmt_camera"
end
