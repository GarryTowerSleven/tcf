---------------------------------
local meta = FindMetaTable( "Player" )
if !meta then
	return
end

local Roles =
{
	// Developers
	["STEAM_0:0:1384695"] = "Developer",	// Kity
	["STEAM_0:0:38865393"] = "Developer",	// boXy
	["STEAM_0:1:39916544"] = "Developer",	// Anoma
	["STEAM_0:0:35652170"] = "Developer",	// Lead
	["STEAM_0:1:124798129"] = "Developer", // Amgona
	["STEAM_0:0:44458854"] = "Developer",	// Bumpy

	// Moderators
	["STEAM_0:1:72402171"] = "Moderator", // Umbre
	["STEAM_0:1:57386100"] = "Moderator", // Squibbus
	["STEAM_0:1:85508734"] = "Moderator", // Breezy

	// Pixeltail Games
	["STEAM_0:1:6044247"] = "PixelTail",	// MacDGuy
	["STEAM_0:0:32497992"] = "PixelTail",	// Caboose700
	["STEAM_0:1:11414156"] = "PixelTail",	// Lifeless
	["STEAM_0:1:21111851"] = "PixelTail",	// Will
	["STEAM_0:0:6807675"] = "PixelTail",	// Johanage
	["STEAM_0:0:72861849"] = "PixelTail",	// Madmijk
}

local function GetRole( steamid )
	return Roles[steamid]
end

function meta:IsHidden()
	if IsValid( self ) then
		local fakename = self:GetNWString( "FakeName" )
		if fakename then
			return self:GetNWString( "FakeName" ) != ""
		end
	end
	return false
end

function meta:IsOwner()
	return ( GetRole( self:SteamID() ) == "Owner" )
end

function meta:IsPrivAdmin()
	return self:IsUserGroup("privadmin") && self:IsAdmin()
end

function meta:IsSecretAdmin()
	return self:GetNWBool("SecretAdmin")
end

function meta:IsDeveloper()
	return GetRole( self:SteamID() ) == "Developer"
end

function meta:IsModerator()
	return self:GetUserGroup() == "moderator"
end

function meta:IsStaff()
	return self:IsModerator() || self:IsAdmin()
end

// for googoog
function IsStaff(steamid)
	return IsAdmin(steamid) or GetRole(steamid) == "Moderator" // TODO: Fuck you
end

function meta:IsTester()
	return false
end

function meta:GetTitle()
	if self:IsHidden() then return end

	local title

	title = GetRole( self:SteamID() )

	local relationship = CheckRelationshipCache(self)

	if relationship != "" then
		
		if title then
			title = title .. " and " .. relationship
		else
			title = relationship
		end

	end

	if self:IsVIP() and not self:IsHidden() and not ( self:IsAdmin() || self:IsModerator() ) then
		title = "VIP"
	end
	
	return title
end

local color_lead = Color(248, 18, 128, 255)
local color_admin = Color(255, 100, 100, 255)
local color_mod = Color(255, 150, 75, 255)
local color_developer = Color(255, 100, 100, 255) // cool green 125, 177, 30
local color_vip = Color(185, 100, 255, 255)
local color_pink = Color(255, 166, 241, 255)
local color_tester = Color(122, 178, 342, 255 )
local color_pixeltail = Color( 216, 31, 42, 255 )

local function returnFull(c)
	return Color( c.r, c.g, c.b, 255 )
end

function meta:GetDisplayTextColor()

	local default_color = team.GetColor( self:Team() )

	if self:IsHidden() then return returnFull(default_color) end

	/*if GetRole( self:SteamID() ) == "Lead Developer" then
		return returnFull(color_lead)
	end*/

	if self:IsDeveloper() then
		return returnFull(color_developer) //color_developer
	end

	if self:IsModerator() then
		return returnFull(color_mod)
	end

	if self:IsAdmin() && !self:GetNWBool("SecretAdmin") then
		return returnFull(color_admin)
	end

	if self:IsTester() then
		return returnFull(color_tester)
	end

	if self.IsVIP && self:IsVIP() then
		return returnFull(color_vip)
	end

	return returnFull(default_color)
end

function meta:Name()
	if !IsValid( self ) then return "" end
	if self:IsBot() then return self:Nick() end
	if self:IsHidden() then
		return self:GetNWString( "FakeName" )
	end

	return self:Nick()
end

function meta:GetName()
	return self:Name()
end

function meta:NickID()
    if !IsValid(self) then return "" end
    return self:Nick() .. " [" .. self:SteamID() .. "]" 
end

local function SendJoinLeaveMessage( ply, type, color )
	local admins, nonAdmins = player.GetStaff()

	local msgNormal = T( type, ply:Nick() )
	local msgAdmin = msgNormal .. " [".. ply:SteamID() .. "]"
	local typeid = GTowerChat.GetChatEnum( "Join/Leave" )

	-- Regular players
	net.Start( "ChatSrv" )
		net.WriteInt(typeid, GTowerChat.TypeBits)
		net.WriteString( msgNormal )
		net.WriteColor( color or Color( 255, 255, 255 ) )
	net.Send(nonAdmins)

	-- Admin players
	net.Start( "ChatSrv" )
		net.WriteInt(typeid, GTowerChat.TypeBits)
		net.WriteString( msgAdmin )
		net.WriteColor( color or Color( 255, 255, 255 ) )
	net.Send(admins)
end

function meta:Joined()
	SendJoinLeaveMessage( self, "JoinLobby", Color( 65, 115, 200, 255 ) )
end

function meta:Left()
	SendJoinLeaveMessage( self, "LeaveLobby", Color( 100, 100, 100, 255 ) )
end

// This is different from the default SetColor as it sets color on the wearables as well
function meta:SetColorAll( color )

	self:SetColor( color )

	if color.a < 255 then
		self:SetRenderMode( RENDERMODE_TRANSALPHA )
	else
		self:SetRenderMode( RENDERMODE_NORMAL )
	end

	// Now equipment
	if !self.CosmeticEquipment then return end

	for k,v in pairs( self.CosmeticEquipment ) do

		if IsValid( v ) then

			v:SetColor( color )

			if color.a < 255 then
				v:SetRenderMode( RENDERMODE_TRANSALPHA )
			else
				v:SetRenderMode( RENDERMODE_NORMAL )
			end

		end

	end

end

function meta:IsCameraOut()
	if IsValid( self ) then
		return IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetClass() == "gmt_camera"
	end
end
