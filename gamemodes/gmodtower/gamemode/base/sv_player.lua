/*
    Roles
*/

PlayerRoles = {

    // Lead Dev
    ["STEAM_0:0:1384695"]   = "Lead Developer",	// kity
	
	// Developers
	["STEAM_0:1:39916544"]  = "Developer",	// Anoma
	["STEAM_0:1:124798129"] = "Developer", 	// Amgona
	["STEAM_0:0:44458854"]  = "Developer",	// Bumpy
    ["STEAM_0:0:241528576"] = "Developer",  // Scienti[-]
	
	// Contributor
	["STEAM_0:0:193442077"] = "Contributor", // Nyantendo
	["STEAM_0:1:95941298"]  = "Contributor", // Pipedream
	["STEAM_0:0:90689651"]  = "Contributor", // Sonop / hELLO
	["STEAM_0:1:97372299"]  = "Contributor", // NotGaylien
	
	// Pixeltail Games
	["STEAM_0:1:6044247"]   = "PixelTail",	// MacDGuy
	["STEAM_0:0:32497992"]  = "PixelTail",	// Caboose700
	["STEAM_0:1:11414156"]  = "PixelTail",	// Lifeless
	["STEAM_0:1:21111851"]  = "PixelTail",	// Will
	["STEAM_0:0:6807675"]   = "PixelTail",	// Johanage
	["STEAM_0:0:72861849"]  = "PixelTail",	// Madmijk

}

function GetPlayerRole( steamid )
    return PlayerRoles[ steamid ] or nil
end

hook.Add( "PlayerNetInitalized", "ApplyRoles", function( ply )

    local role = GetPlayerRole( ply:SteamID() )
    if not role then return end

    ply:SetNet( "Role", role )

end )

local meta = FindMetaTable( "Player" )
if !meta then return end

/*
    Money
*/

function meta:Money()
    return self:GetNet( "Money" ) or 0
end

function meta:SetMoney( amount )
	return self:SetNet( "Money", math.Clamp( tonumber( amount ), -2147483648, 2147483647 ) )
end

function meta:AddMoney( amount, nonotify, beziersource )

	if amount == 0 then return end

	if amount < 0 then
		self:TakeMoney( amount, nonotify )
		return
	end

	self:SetMoney( self:Money() + amount )

	if not nonotify then
		local pitch = Lerp( math.Clamp( amount, 0, 500 ) / 500, 90, 160 )

		self:MsgT( "MoneyEarned", string.FormatNumber( amount ) )
		self:EmitSound( "gmodtower/misc/gmc_earn.wav", 50, pitch )

		CreateMoneyBezier( beziersource or self, self, amount, true )
	end

end

function meta:TakeMoney( amount, nonotify, beziertarget )

	if amount == 0 then return end

    if self:Money() <= 0 then return end

	amount = math.abs( amount )

	self:SetMoney( math.max(self:Money() - amount, 0) )

	if not nonotify then
		local pitch = Lerp( math.Clamp( amount, 0, 500 ) / 500, 160, 90 )

		self:MsgT( "MoneySpent", string.FormatNumber( amount ) )
		self:EmitSound( "gmodtower/misc/gmc_lose.wav", 50, math.ceil( pitch ) )

		if beziertarget then
			CreateMoneyBezier( util.GetCenterPos( self ), beziertarget, amount, true, 20 )
		end
	end

end

function meta:GiveMoney( amount, nosend, beziersource )
	self:AddMoney( amount, nosend, beziersource )
end

function meta:Afford( price )
    return self:Money() >= price
end

/*
    Join/Leave Messages
*/


hook.Add( "PlayerSpawnClient", "JoinMessages", function( ply )

    if not IsLobby then return end

    ply:Joined()

    if ply._NewPlayer then
        ply:MsgI( "gmtsmall", "LobbyWelcomeNew" )
    else
        ply:MsgI( "gmtsmall", "LobbyWelcome", ply:GetName() )
    end

end )

hook.Add( "PlayerDisconnected", "LeaveMessages", function( ply )

    if not IsLobby then return end
    if ply.HideRedir then return end

    ply:Left()

end )

/*
    Driving / Whatever
*/

function meta:SetDriving( ent )
    self:SetNet( "DrivingObject", ent )
end

function meta:ExitDriving()
	local ent = self:GetNet("DrivingObject")
	if not IsValid( ent ) then return end

	self:SetNet( "DrivingObject", nil )
	ent:Remove()

    self:ReParentCosmetics()
end

function meta:StopEmoting()
    if ( not StopAllEmotes ) then return end
    StopAllEmotes( self )
end

function meta:ExitAll()
	self:ExitDriving()

    // instruments
    for _, v in ipairs( ents.GetAll() ) do
        if ( v:GetClass() == "gmt_piano" or v:GetClass() == "gmt_instrument_drums" ) then
            if ( v.Owner == self ) then
                v:RemoveOwner()
            end
        end
    end

	// golfball
	if ( IsValid( self.GolfBall ) ) then
		self.Teleport = true
		self.GolfBall:Remove()
	end

    // Exit Tetris
    if ( self.InTetris ) then
        for _, v in ipairs( ents.FindByClass( "gmt_tetris" ) ) do
            if ( v:GetOwner() == self ) then
                v:EndGame()
            end
        end
    end

    // Last Restort, casino machines
    self:ExitVehicle()

    // fix cosmetics
    self:ReParentCosmetics()
end

function meta:SafeTeleport( pos, ang, eyeangles )
    if ( not pos ) then return end

    self:StopEmoting()
    self:ExitAll()

	local velocity = self:GetVelocity()

	self:SetVelocity( velocity:GetNegated() )

    self:SetPos( pos )
    self:SetAngles( ang or self:GetAngles() )
    self:SetEyeAngles( eyeangles or self:EyeAngles() )
end

/*
    Misc
*/

function meta:CanSpray()
    return self.GetSetting and not self:GetSetting( "GTAllowSpray" )
end

function meta:ResetSpeeds()
    local player_class = player_manager.GetPlayerClass( self ) or "player_gmt"
    local base = baseclass.Get( player_class )

    self:SetWalkSpeed( base.WalkSpeed or 200 )
    self:SetRunSpeed( base.RunSpeed or 320 )
    self:SetSlowWalkSpeed( base.SlowWalkSpeed or 100 )
end