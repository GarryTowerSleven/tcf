local meta = FindMetaTable( "Player" )
if !meta then
	return
end

local Roles =
{

	// Lead Omega Overlord Kitteh1337
	["STEAM_0:0:1384695"] = "Lead Developer",	// Kity
	
	// Developers
	["STEAM_0:0:38865393"] = "Developer",	// boXy
	["STEAM_0:1:39916544"] = "Developer",	// Anoma
	["STEAM_0:0:35652170"] = "Developer",	// Lead
	["STEAM_0:1:124798129"] = "Developer", 	// Amgona
	["STEAM_0:0:44458854"] = "Developer",	// Bumpy

	// Moderators
	["STEAM_0:1:72402171"] = "Moderator", 	// Umbre
	["STEAM_0:1:57386100"] = "Moderator", 	// Squibbus
	["STEAM_0:0:156132358"] = "Moderator", 	// Basical
	["STEAM_0:1:85508734"] = "Moderator", 	// Breezy

	// Pixeltail Games
	["STEAM_0:1:6044247"] = "PixelTail",	// MacDGuy
	["STEAM_0:0:32497992"] = "PixelTail",	// Caboose700
	["STEAM_0:1:11414156"] = "PixelTail",	// Lifeless
	["STEAM_0:1:21111851"] = "PixelTail",	// Will
	["STEAM_0:0:6807675"] = "PixelTail",	// Johanage
	["STEAM_0:0:72861849"] = "PixelTail",	// Madmijk
}

local function GetTitle( steamid )
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
	return ( GetTitle( self:SteamID() ) == "Owner" )
end

function meta:IsPrivAdmin()
	return self:IsUserGroup("privadmin") && self:IsAdmin()
end

function meta:IsSecretAdmin()
	return self:GetNWBool("SecretAdmin")
end

function meta:IsDeveloper()
	return GetTitle( self:SteamID() ) == "Developer"
end

function meta:IsModerator()
	return self:GetUserGroup() == "moderator"
end

function meta:IsStaff()
	return self:IsModerator() || self:IsAdmin()
end

function meta:IsTester()
	return false
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

	if GetTitle( self:SteamID() ) == "Lead Developer" then
		return returnFull(color_lead)
	end

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

	// So long, gay bowser
	/*if self:IsVIP() then
		return returnFull(color_vip)
	end*/

	return returnFull(default_color)
end

function meta:GetRespectName( nofriend )

	if not IsValid( self ) or self:IsHidden() then return end

	local title
	
	if self:IsVIP() then
		title = "VIP"
	end

	if ( GetTitle( self:SteamID() ) ) then
		title = GetTitle( self:SteamID() )
	end

	if self:IsSecretAdmin() then
		title = "VIP"
	end

	-- Show friend status
	if Friends and not nofriend then
		local relationship = Friends.GetRelationshipName( LocalPlayer(), self )
		if relationship then
			if title then
				title = title .. " and " .. relationship
			else
				title = relationship
			end
		end
	end

	return title

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

function meta:SetTransparent( bool )

	if bool then
		self:SetColorAll( Color(255, 255, 255, 35) )
	else
		if self._IsTransparent then
			self:SetColorAll( Color(255, 255, 255, 255) )
		end
	end

	self._IsTransparent = bool

end

function meta:IsTransparent()
	return self._IsTransparent
end

function meta:SetNoDrawAll( bool )

	self:SetNoDraw( bool )
	self:DrawShadow( bool )
	self._NoDraw = bool

	-- Hide weapons
	local weapon = self:GetActiveWeapon()
	if IsValid( weapon ) then
		weapon:SetNoDraw( bool )
	end

	-- Wearables (hats, etc.)
	if self.CosmeticEquipment then
		for k,v in pairs( self.CosmeticEquipment ) do
			if IsValid( v ) then
				v:SetNoDraw( bool )
				v:DrawShadow( bool )
			end
		end
	end

end

function meta:IsNoDrawAll()
	return self._NoDraw
end

function meta:HideLocalPlayers( bool, norender )

	if SERVER then return end

	for _, ply in pairs( Location.GetPlayersInLocation( self:Location() ) ) do
		if norender then
			ply:SetNoDrawAll( bool )
		else
			ply:SetTransparent( bool )
		end
	end

end

function meta:SetModel2( mdl )

	self:SetModel( mdl )

	//if Hats && SERVER then
	//	Hats.UpdateWearables( self )
	//end

end

function meta:IsCameraOut()
	if IsValid( self ) then
		return IsValid( self:GetActiveWeapon() ) && self:GetActiveWeapon():GetClass() == "gmt_camera"
	end
end

if SERVER then
	function meta:SetDriving( ent )
		--self:SetNet( "Driving", ent:EntIndex() )
		self:SetNet( "DrivingObject", ent )
	end
end

function meta:GetDriving( class )

	if self:IsBot() then return end

	local ent = self:GetNet("DrivingObject")
	if not IsValid( ent ) then return end

	if class and ent:GetClass() ~= class then return end

	return ent

	--[[local entindex = self:GetNet( "Driving" )
	if not entindex or entindex == 0 then return end

	local ent = Entity(entindex)
	if not IsValid( ent ) then return end

	if class then
		if ent:GetClass() == class then
			return ent
		else
			return nil
		end
	end

	return ent]]

end

function meta:ExitDriving()

	local ent = self:GetNet("DrivingObject")
	if not IsValid( ent ) then return end

	self:SetNet( "DrivingObject", nil )
	ent:Remove()

end