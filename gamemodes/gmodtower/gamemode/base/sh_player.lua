local meta = FindMetaTable( "Player" )
if !meta then
	return
end

function meta:GetRole()
	return self:GetNWString( "Role" )
end

function meta:IsHidden()
	/*if IsValid( self ) then
		local fakename = self:GetNet( "FakeName" )
		if fakename then
			return self:GetNet( "FakeName" ) != ""
		end
	end*/
	return false
end

function meta:IsOwner()
	return self:GetRole() == "Owner"
end

function meta:IsLeadDeveloper()
	return self:GetRole() == "Lead Developer"
end

function meta:IsSecretAdmin()
	return self:GetNet( "SecretAdmin" )
end

function meta:IsDeveloper()
	return self:GetRole() == "Developer"
end

function meta:IsModerator()
	return self:IsUserGroup( "moderator" )
end

function meta:IsStaff()
	return self:IsAdmin() or self:IsModerator()
end

function meta:IsContributor()
	return self:GetRole() == "Contributor"
end

function meta:IsPixelTail()
	return self:GetRole() == "PixelTail"
end

local color_lead		= Color( 248,  18, 128 )
local color_developer	= Color( 255, 100, 100 )
local color_mod			= Color( 255, 150,  75 )
local color_admin		= Color( 125, 177,  30 )
local color_contributor	= Color( 122, 178, 255 )
local color_pixeltail	= Color( 216,  31,  42 )
local color_default		= team.GetColor( TEAM_UNASSIGNED )

function meta:GetDisplayTextColor()

	if self:IsHidden() then
		return color_default
	end

	if self:IsLeadDeveloper() then
		return color_lead
	end

	if self:IsDeveloper() then
		return color_developer
	end

	if self:IsModerator() then
		return color_mod
	end

	if self:IsAdmin() && not self:IsSecretAdmin() then
		return color_admin
	end

	if self:IsContributor() then
		return color_contributor
	end

	if self:IsPixelTail() then
		return color_pixeltail
	end

	return color_default

end

function meta:GetRespectName( nofriend )

	if not IsValid( self ) then return end

	local title
	
	if self:IsVIP() then
		title = "VIP"
	end

	if self:IsModerator() then
		title = "Moderator"
	end

	if self:IsAdmin() then
		title = "Admin"
	end

	if ( self:GetRole() and self:GetRole() != "" ) then
		title = self:GetRole()
	end

	if self:IsSecretAdmin() or self:IsHidden() then
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
		return self:GetNet( "FakeName" )
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