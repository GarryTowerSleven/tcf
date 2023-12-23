local EVENT = {}

EVENT.BattleType = "Snowball Fight"

EVENT.MinLength = 60 * 2
EVENT.MaxLength = 60 * 3

EVENT.Weapon = "weapon_snowball"

EVENT.ActiveLocation = nil
EVENT.ActiveSpawns = nil
EVENT.Locations = {

    [ Location.GetIDByName( "Entertainment Plaza" ) ] = {
        spawns = {
            { pos = Vector( 1105, 1507, 165 ), ang = Angle( 20, -112.5, 0 ) },
            { pos = Vector( 750, 1502, 165 ), ang = Angle( 20, -55.5, 0 ) },

            { pos = Vector( 666, 894.5, 165 ), ang = Angle( 20, 0, 0 ) },
            { pos = Vector( 1226, 894.5, 165 ), ang = Angle( 20, 180, 0 ) },

            { pos = Vector( 1105, 275, 165 ), ang = Angle( 20, 130, 0 ) },
            { pos = Vector( 750, 267, 165 ), ang = Angle( 20, 53, 0 ) },

            { pos = Vector( 923, 900, 385 ), ang = Angle( 45, 90, 0 ) },
        },
    },

}

EVENT.Participants = {}

EVENT.MoneyOnKill = 10
EVENT.TotalMoney = 0

function EVENT:GiveWeapon( ply )

    if ply:Location() != self.ActiveLocation then return end

    local snow = ply:GiveTempWeapon( self.Weapon, nil, function() return not (self and self:IsValid()) end, self.ActiveLocation )

    if IsValid( snow ) then

        snow.Death = true

    end
    
end

function EVENT:AddParticipant( ply )

    if not IsValid( ply ) then return end

    if self.Participants[ ply ] then return end
    self.Participants[ ply ] = true

    self:GiveWeapon( ply )

end

function EVENT:RemoveParticipant( ply )

    if not IsValid( ply ) then return end

    if not self.Participants[ ply ] then return end
    self.Participants[ ply ] = nil

    ply:RemoveAllTempWeapons()

end

function EVENT:PlayerDeath( victim, attacker )
    
    if not self.Participants[ victim ] then return end

    if attacker != victim and IsValid( attacker ) and attacker:IsPlayer() then

        attacker:AddMoney( self.MoneyOnKill, nil, nil, nil, "EventSnowballFight" )

        self.TotalMoney = self.TotalMoney + self.MoneyOnKill

    end

end

function EVENT:PlayerSpawn( ply )

    if self.Participants[ ply ] then

        local spawn = table.Random( self.ActiveSpawns )
        
        ply:SetPos( spawn.pos )
        ply:SetEyeAngles( spawn.ang )

		ply:SetVelocity( VectorRand() * 300 )
		
        self:GiveWeapon( ply )

    end

end

function EVENT:Think()

    for k, v in pairs( self.Participants ) do
        
        if not IsValid( k ) then
            self.Participants[ k ] = nil
        end

    end

end

function EVENT:Start()

	if CLIENT then
		return
	end
    
    local data, loc = table.Random( self.Locations )

    self.ActiveLocation = loc
    self.ActiveSpawns = data.spawns
	
	MsgT( "MiniBattleGameStart", string.lower( self.BattleType ), Location.GetFriendlyName( loc ) )

    for _, v in ipairs( Location.GetPlayersInLocation( self.ActiveLocation ) ) do
        self:AddParticipant( v )
    end

    if self.HookGroup then

        self.HookGroup:DisableHooks()
        self.HookGroup = nil
        
    end

    self.HookGroup = hookgroup.New()

    self.HookGroup:Add( "Location", "Event_" .. self.Name, function( ply, loc )

        if loc == self.ActiveLocation then
            
            self:AddParticipant( ply )

        else
        
            self:RemoveParticipant( ply )

        end

    end )

    self.HookGroup:Add( "PlayerDeath", "Event_" .. self.Name, function( victim, inflictor, attacker )

        self:PlayerDeath( victim, attacker )

    end )

    self.HookGroup:Add( "PlayerSpawn", "Event_" .. self.Name, function( ply )

        self:PlayerSpawn( ply )

    end )

    self.HookGroup:Add( "PlayerShouldTakeDamage", "Event_" .. self.Name, function( ply, attacker )

        if self.Participants[ ply ] then
            return true
        end

    end )

    self.HookGroup:EnableHooks()
	
	if !IsValid( FlyingText ) then
		FlyingText = ents.Create("gmt_skymsg")
		FlyingText:KeyValue( "text", "Snowball Fight!" )
		FlyingText:Spawn()
	end

	FlyingText:SetPos( Vector(938.531250, 1505.062500, 409.437500) )
	
end

function EVENT:End()

    if CLIENT then
		return
	end

    if self.TotalMoney > 0 then
        MsgT( "MiniTotal", string.FormatNumber( self.TotalMoney ) )
    end

    self.ActiveLocation = nil
    self.ActiveSpawns = nil

    self.Participants = {}
    self.TotalMoney = 0

    if self.HookGroup then

        self.HookGroup:DisableHooks()
        self.HookGroup = nil

    end

	if IsValid( FlyingText ) then
		FlyingText:Remove()
		FlyingText = nil
	end
	
end

minievent.Register( "SnowballFight", EVENT )