local meta = FindMetaTable( "Player" )
if !meta then
	return
end

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

function meta:SetDriving( ent )
    self:SetNet( "DrivingObject", ent )
end

function meta:ExitDriving()
	local ent = self:GetNet("DrivingObject")
	if not IsValid( ent ) then return end

	self:SetNet( "DrivingObject", nil )
	ent:Remove()
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
end

function meta:SafeTeleport( pos, ang, eyeangles )
    if ( not pos ) then return end

    self:ExitAll()

	local velocity = self:GetVelocity()

	self:SetVelocity( velocity:GetNegated() )

    self:SetPos( pos )
    self:SetAngles( ang or self:GetAngles() )
    self:SetAngles( eyeangles or self:EyeAngles() )
end