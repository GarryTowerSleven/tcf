local EVENT = {}

EVENT.MinLength = 60 * 2
EVENT.MaxLength = 60 * 3

EVENT.Entity = "gmt_minigame_balloon"
EVENT.Weapon = "weapon_crossbow"

EVENT.ActiveLocation = nil
EVENT.Locations = {

    [ Location.GetIDByName( "Lobby" ) ] = {
        pos = {
            min = Vector( 160, -2060, 300 ),
            max = Vector( 1695, -888, 600 ),    
        },
        maxheight = 3020,
    },

}

EVENT.Translation = "MiniBalloonGameStart"

EVENT.Participants = {}

EVENT.Entities = {}
EVENT.EntityLifetime = 60
EVENT.EntityLimit = 25
EVENT.EntityDelay = .5

EVENT.LastEntity = 0

EVENT.MoneyOnPop = 75
EVENT.DistFactor = 2200
EVENT.TotalMoney = 0

function EVENT:GiveWeapon( ply )

    if ply:Location() != self.ActiveLocation then return end

    ply:GiveTempWeapon( self.Weapon, 999, function() return not (self and self:IsValid()) end, self.ActiveLocation )

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

function EVENT:ParticipantCount()

    return table.Count( self.Participants )

end

function EVENT:CreateEntity( pos, lifetime )

    local ent = ents.Create( self.Entity )

    ent:SetPos( pos )
    ent:SetColor( colorutil.GetRandomColor() )

    ent._Event = true
    
    ent._CreationTime = CurTime()
    ent._LifeTime = lifetime or self.EntityLifetime
    
    ent:Spawn()

    ent:SetForce( math.Rand( 12, 15 ) )

    self.LastEntity = CurTime()

    table.insert( self.Entities, ent )

end

function EVENT:SpawnerThink()

    local poppers = self:ParticipantCount() or 0

    if poppers == 0 then
        return
    end

    if self.EntityLifetime > 0 then

        for k, v in pairs( self.Entities ) do

            if not IsValid( v ) then
                table.remove( self.Entities, k )
                continue
            end

            if v._CreationTime and (v._CreationTime + v._LifeTime) < CurTime() then
                v:Remove()
            elseif ( self.Locations[ self.ActiveLocation ] and self.Locations[ self.ActiveLocation ].maxheight and self.Locations[ self.ActiveLocation ].maxheight < v:GetPos().z ) then
                v:Remove()
            end

        end

    end

    if table.Count( self.Entities ) < self.EntityLimit then

        self.EntityDelay = math.Clamp( 1 - ( .1 * (poppers - 1) ), 0.5, 1 )

        if (self.LastEntity + self.EntityDelay) > CurTime() then return end
    
        local bounds = self.Locations[ self.ActiveLocation ].pos
        
        local pos = Vector(
            math.Rand( bounds.min.x, bounds.max.x ),
            math.Rand( bounds.min.y, bounds.max.y ),
            math.Rand( bounds.min.z, bounds.max.z )
        )

        self:CreateEntity( pos )

    end

end

function EVENT:Think()

    if CLIENT then
		return
	end

    for k, v in pairs( self.Participants ) do
        
        if not IsValid( k ) then
            self.Participants[ k ] = nil
        end

    end

    for k, v in pairs( self.Entities ) do
        
        if not IsValid( v ) then
            table.remove( self.Entities, k )
        end

    end

    self:SpawnerThink()

end

function EVENT:Start()

    if CLIENT then
		return
	end

    local _, loc = table.Random( self.Locations )

    self.ActiveLocation = loc

    MsgT( self.Translation, Location.GetFriendlyName( self.ActiveLocation ) )

    for _, v in ipairs( Location.GetPlayersInLocation( self.ActiveLocation ) ) do
        self:AddParticipant( v )
    end

    if self.HookGroup then

        self.HookGroup:DisableHooks()
        self.HookGroup = nil
        
    end

    self.HookGroup = hookgroup.New()

    self.HookGroup:Add( "BalloonPopped", "Event_" .. self.Name, function( ply, balloon )

        if not IsValid( ply ) then return end
        if not balloon._Event then return end

        local dist = math.Clamp( balloon:GetPos().z - ply:GetPos().z, 0, self.DistFactor )
        local money = math.Clamp( self.MoneyOnPop * ( dist / self.DistFactor ), 10, self.MoneyOnPop ) / 10

        money = math.Round( money )

        ply:GiveMoney( money, nil, nil, true )

        self.TotalMoney = self.TotalMoney + money

        ply:AddAchievement( ACHIEVEMENTS.MGPOPPER, 1 )

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

function EVENT:End()

    if CLIENT then
        return
    end

    for _, v in pairs( self.Entities ) do
        v:Remove()
    end

    if self.TotalMoney > 0 then
        MsgT( "MiniTotal", string.FormatNumber( self.TotalMoney ) )
    end
    
    self.ActiveLocation = nil
    self.Participants = {}
    self.Entities = {}

    if self.HookGroup then

        self.HookGroup:DisableHooks()
        self.HookGroup = nil

    end
	
end

minievent.Register( "BalloonPop", EVENT )