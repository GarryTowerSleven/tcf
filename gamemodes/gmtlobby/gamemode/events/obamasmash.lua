local EVENT = {}

EVENT.Base = "BalloonPop"

EVENT.Entity = "gmt_minigame_obama"
EVENT.Weapon = "weapon_crowbar"

EVENT.Locations = {

    [ Location.GetIDByName( "Suites" ) ] = {
        limit = 50,
        pos = {
            min = Vector( 4911, -10543, 4100 ),
            max = Vector( 4184, -9816, 4100 ),    
        },
    },

    [ Location.GetIDByName( "Lobby" ) ] = {
        limit = 100,
        pos = {
            min = Vector( 344, -2125, 64 ),
            max = Vector( 1627, -968, 64 ),    
        },
    },

    [ Location.GetIDByName( "Entertainment Plaza" ) ] = {
        limit = 75,
        pos = {
            min = Vector( 675, 200, 50 ),
            max = Vector( 1175, 1600, 50 ),    
        },
    },

    [ Location.GetIDByName( "Gamemode Ports" ) ] = {
        limit = 50,
        pos = {
            min = Vector( 10000, 10260, 6657 ),
            max = Vector( 11020, 10985, 6657 ),    
        },
    },

}

EVENT.EntityLimit = 50

EVENT.MoneyOnSmash = 1

EVENT.ComboMax = 50
EVENT.ComboTime = 1

function EVENT:AddParticipant( ply )

    if not IsValid( ply ) then return end

    if self.Participants[ ply ] then return end
    self.Participants[ ply ] = true

    self:GiveWeapon( ply )

    ply._smashCombo = 0
    ply._smashLast = 0

end

function EVENT:RemoveParticipant( ply )

    if not IsValid( ply ) then return end

    if not self.Participants[ ply ] then return end
    self.Participants[ ply ] = nil

    ply:RemoveAllTempWeapons()

end

function EVENT:CreateEntity( pos )

    local near = ents.FindInSphere( pos, 64 )

    for _, v in ipairs( near ) do
        
        if IsValid( v ) then
            return
        end

    end

    local ent = ents.Create( self.Entity )

    ent:SetPos( pos )
    ent:DropToFloor()

    local trace = util.TraceEntity( {
        start = pos,
        endpos = pos,
        filter = ent
    }, ent )

    if trace.Hit then
        ent:Remove()
        return
    end
    
    ent._Event = true
    
    ent:SetAngles( Angle( 0, math.Rand( 0, 360 ), 0 ) )
    ent:Spawn()

    self.LastEntity = CurTime()

    table.insert( self.Entities, ent )

end

function EVENT:SpawnerThink()

    local smashers = self:ParticipantCount() or 0

    if smashers == 0 then
        return
    end

    local data = self.Locations[ self.ActiveLocation ]
    local limit = data.limit or 25

	limit = math.Clamp( math.Round( limit * ( smashers * .1 ) ), 5, limit ) // extreme dynamic obama calculations
	
    if table.Count( self.Entities ) < limit then

        if smashers >= 6 then
            self.EntityDelay = math.Clamp( 0.39 - ( smashers * 0.01 ), 0.05, 0.35)
        else
            self.EntityDelay = 0.5
        end

        if (self.LastEntity + self.EntityDelay) > CurTime() then return end
    
        local bounds = data.pos
        
        local pos = Vector(
            math.Rand( bounds.min.x, bounds.max.x ),
            math.Rand( bounds.min.y, bounds.max.y ),
            math.Rand( bounds.min.z, bounds.max.z )
        )

        self:CreateEntity( pos )

    end

end

function EVENT:Start()

    if CLIENT then
		return
	end

    local _, loc = table.Random( self.Locations )

    self.ActiveLocation = loc

    MsgT( "MiniObamaGameStart", Location.GetFriendlyName( self.ActiveLocation ) )

    for _, v in ipairs( Location.GetPlayersInLocation( self.ActiveLocation ) ) do
        self:AddParticipant( v )
    end

    if self.HookGroup then

        self.HookGroup:DisableHooks()
        self.HookGroup = nil
        
    end

    self.HookGroup = hookgroup.New()

    self.HookGroup:Add( "ObamaSmashed", "Event_" .. self.Name, function( ply, cutout )

        if not IsValid( ply ) then return end
        if not cutout._Event then return end

        if ply._smashLast + self.ComboTime > CurTime() then

            ply._smashCombo = (ply._smashCombo or 0) + 1

        else

            ply._smashCombo = 0

        end

        local money = math.Clamp( self.MoneyOnSmash + ply._smashCombo, self.MoneyOnSmash, self.ComboMax )
        money = math.Round( money )

        ply:GiveMoney( money )

        self.TotalMoney = self.TotalMoney + money

		local effectdata = EffectData()
		effectdata:SetOrigin( cutout:GetPos() + Vector(0,0,55) )
		effectdata:SetMagnitude( money )

		util.Effect( "gmt_money", effectdata )

        ply._smashLast = CurTime()

    end )

    self.HookGroup:Add( "Location", "Event_" .. self.Name, function( ply, loc )

        if loc == self.ActiveLocation then
            self:AddParticipant( ply )
        else
            self:RemoveParticipant( ply )
        end

    end )

    self.HookGroup:EnableHooks()
	
end

minievent.Register( "ObamaSmash", EVENT )