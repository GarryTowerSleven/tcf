local EVENT = {}

EVENT.Base = "ChainsawBattle"

EVENT.BattleType = "Fist Fight"

EVENT.Weapon = "weapon_fist"

EVENT.HookGroup = hookgroup.New()

EVENT.Locations = {

    [ Location.GetIDByName( "Bar" ) ] = {
        spawns = {
            { pos = Vector( 2557, 2295, 85 ), ang = Angle( 0, 45, 0 ) },

            { pos = Vector( 2730, 2723.5, 85 ), ang = Angle( 0, -45, 0 ) },

            { pos = Vector( 3336, 2357.5, 85 ), ang = Angle( 0, 145, 0 ) },

            { pos = Vector( 3021, 2896, 85 ), ang = Angle( 0, -105, 0 ) },

            { pos = Vector( 3258.5, 2744.5, 112 ), ang = Angle( 10, -163, 0 ) },
        },
    },

}

EVENT.MoneyOnKill = 5

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
	
end

function EVENT:PlayerDeath( victim, attacker )
    
    if not self.Participants[ victim ] then return end

    if attacker != victim and IsValid( attacker ) and attacker:IsPlayer() then

		attacker:AddMoney( self.MoneyOnKill, nil, nil, nil, "EventFistFight" )
		attacker:AddAchievement( ACHIEVEMENTS.MGFIGHTER, 1 )

        self.TotalMoney = self.TotalMoney + self.MoneyOnKill

    end

end

minievent.Register( "FistFight", EVENT )