ENT.Base = "base_point"
ENT.Type = "point"

ENT.Classes = {
    "gmt_halloween_npc_zombie",
    "gmt_halloween_npc_spider",
    "gmt_halloween_npc_mutant",
}

ENT.Entities = {}
ENT.Limit = 1
ENT.Delay = 10
ENT.LastSpawn = nil

function ENT:Think()

    for k, v in ipairs( self.Entities ) do
        if not IsValid( v ) then
            table.remove( self.Entities, k )
        end
    end

    if ( table.Count( self.Entities ) < self.Limit ) then
        self.LastSpawn = self.LastSpawn or CurTime()
        self:SpawnEnemy()
    end

    self:NextThink( CurTime() + 2.5 )

end

function ENT:CanSpawn()

    if ( self.LastSpawn and self.LastSpawn + self.Delay > CurTime() ) then
        return false
    end

    return GAMEMODE:IsValidSpawn( self )

end

function ENT:SpawnEnemy()

    if not self:CanSpawn() then return end

    local class = table.Random( self.Classes )
    if not class then return end

    local ent = ents.Create( class )
    
    ent:SetPos( self:GetPos() )
    ent:SetAngles( self:GetAngles() )

    ent:Spawn()

    self.LastSpawn = nil
    
    table.uinsert( self.Entities, ent )

end