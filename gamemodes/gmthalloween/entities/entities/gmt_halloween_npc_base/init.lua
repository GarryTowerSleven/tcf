AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local STATE_IDLE = 0
local STATE_CHASE = 1

ENT.Model = "models/gmod_tower/obamacutout.mdl"

ENT.EnemyHealth = 40
ENT.Damage = 20
ENT.SwingTime = 0.75
ENT.AttackRange = 40
ENT.AttackSize = 25
ENT.AttackHeight = 50
ENT.Speed = 180

ENT.AttackSequence = nil
ENT.AttackSequenceSpeed = 1

ENT.State = STATE_IDLE

ENT.SearchRange = 350
ENT.AggroRange = 512

ENT.SoundDelay = 0.75
ENT.LastSound = 0

ENT._InWorld = true
ENT._InWorldTime = nil

function ENT:Initialize()

    if istable( self.Model ) then
        self:SetModel( table.Random( self.Model ) )
    else
        self:SetModel( self.Model )
    end

    // local min, max = self:GetCollisionBounds()
    // print( self, min, max )

    if self.CollisionBounds then
        
        self:SetCollisionBounds( self.CollisionBounds.min, self.CollisionBounds.max )

    end

    // PrintTable( self:GetSequenceList() )

    self:SetMaxHealth( self.EnemyHealth )
    self:SetHealth( self.EnemyHealth )

    timer.Simple( .25, function()

        if IsValid( self ) then
            self.InitialPosition = self:GetPos()
        end
        
    end )

end

function ENT:OnKilled( dmginfo )

    self:DoSound( self.DieSound, true )

    local zOffset = 0

    if self.CollisionBounds then
        zOffset = self.CollisionBounds.max.z / 2
    end

    local eff = EffectData()
        eff:SetOrigin( self:GetPos() + Vector( 0, 0, zOffset ) )
    util.Effect( "ghost_die", eff, true, true )

    local attacker = dmginfo:GetAttacker()

    if IsValid( attacker ) and attacker:IsPlayer() then
        
        net.Start( "HalloweenNPCKilled", true )
        net.Send( attacker )

		attacker:AddAchievement( ACHIEVEMENTS.HALLOWEENGHOST, 1 )
        attacker:GiveMoney( 25 )
    end

    // self:BecomeRagdoll( dmginfo )
    self:Remove()

end

function ENT:GetFromVagueObject( object )

    if not object then return nil end

    if istable( object ) then
        return table.Random( object )
    else
        return object
    end

    return nil

end

function ENT:DoSound( snd, important )

    important = important == nil and false or important
    if not important and self.LastSound + self.SoundDelay > CurTime() then return end

    snd = self:GetFromVagueObject( snd )
    if not snd then return end

    self:EmitSound( snd )

    self.LastSound = CurTime()

end

function ENT:OnTakeDamage( dmginfo )

    local attacker = dmginfo:GetAttacker()
    if ( IsValid( attacker ) and attacker:IsPlayer() ) then
        self:SetEnemy( attacker )
    end

    self:DoSound( self.PainSound )

end

function ENT:SetState( state )
    self.State = state
end

function ENT:GetState()
    return self.State
end

function ENT:SetEnemy( ent )
	self.Enemy = ent
end

function ENT:GetEnemy()
    self:SearchForEnemy()
	return self.Enemy
end

function ENT:ClearEnemy()
    self:SetEnemy( nil )
    self:SetState( STATE_IDLE )
end

function ENT:CheckEnemy()

    local enemy = self:GetEnemy()
    if not IsValid( enemy ) or not enemy:IsPlayer() then self:ClearEnemy() return false end

    if ( not enemy:Alive() or self:GetRangeTo( enemy ) > self.AggroRange ) then
        self:ClearEnemy()
        return false
    end

    return true

end

function ENT:SearchForEnemy()

    for _, v in ipairs( ents.FindInSphere( self:GetPos(), self.SearchRange ) ) do
        if v:IsPlayer() then
            self:SetEnemy( v )
            return true
        end
    end

    self:ClearEnemy()
    return false

end

local CHASE_FAILED = 0
local CHASE_STUCK = 1
local CHASE_OK = 2
function ENT:ChaseEnemy()

    if ( not self:CheckEnemy() ) then return CHASE_FAILED end
    local enemy = self:GetEnemy()

    local path = Path( "Chase" )
    path:SetMinLookAheadDistance( 300 )
    path:SetGoalTolerance( 20 )
    path:Compute( self, enemy:GetPos() )

    if not IsValid( path ) then return CHASE_FAILED end

    while ( path:IsValid() and self:CheckEnemy() ) do

        if ( path:GetAge() > 0.1 ) then
            path:Compute( self, enemy:GetPos() )
        end

        if ( self:GetRangeTo( enemy ) <= (self.AttackRange - 5) and self:IsAbleToSee( enemy, 5 ) ) then

            self.loco:FaceTowards( enemy:GetPos() )

            self:Swing()
            self:StartActivity( ACT_RUN )

        end
        
        path:Update( self )

        if ( true ) then path:Draw() end

        if ( self.loco:IsStuck() ) then
            self:HandleStuck()
			return CHASE_STUCK
		end

        coroutine.yield()

    end

    return CHASE_OK
    
end

function ENT:HandleStuck()

    print( self, "stuck" )

    self:SetPos( self.InitialPosition )
    self.loco:ClearStuck()

end

function ENT:Swing()

    local enemy = self:GetEnemy()
    if not IsValid( enemy ) then return end

    self:DoSound( self.AttackSound, true )

    self._SwingStart = CurTime()

    local sequence = self:GetFromVagueObject( self.AttackSequence )
    if not sequence then return end

    self:PlaySequenceAndWait( sequence, self.AttackSequenceSpeed )
    coroutine.yield()

end

function ENT:Attack()

    self:DoSound( self.SwingSound, true )

    self._SwingStart = nil

    local tr = util.TraceHull( {
        start = self:GetPos() + Vector( 0, 0, self.AttackHeight ),
	    endpos = self:GetPos() + Vector( 0, 0, self.AttackHeight ) + ( self:GetForward() * self.AttackRange ),
	    filter = self,
        mins = Vector( -self.AttackSize, -self.AttackSize, -self.AttackSize ),
	    maxs = Vector( self.AttackSize, self.AttackSize, self.AttackSize ),
	    mask = MASK_SHOT_HULL
    } )

    local lua = string.format( [[debugoverlay.SweptBox( Vector(%s,%s,%s), Vector(%s,%s,%s), Vector(%s,%s,%s), Vector(%s,%s,%s), Angle(%s,%s,%s), 5 )]],
        tr.StartPos.x, tr.StartPos.y, tr.StartPos.z,
        tr.HitPos.x, tr.HitPos.y, tr.HitPos.z,
        -self.AttackSize, -self.AttackSize, -self.AttackSize,
        self.AttackSize, self.AttackSize, self.AttackSize,
        0, 0, 0 )

    BroadcastLua( lua )

    if tr.Entity and IsValid( tr.Entity ) and tr.Entity:IsPlayer() then
        // hit player

        local dmg = DamageInfo()
        dmg:SetDamage( self.Damage )
        dmg:SetAttacker( self )
        dmg:SetReportedPosition( self:GetPos() )
        dmg:SetDamageType( DMG_SLASH )

        tr.Entity:TakeDamageInfo( dmg )

        self:DoSound( self.HitSound, true )

    elseif tr.HitWorld then

        self:DoSound( self.HitWorldSound, true )

    else
        // miss

    end

end

function ENT:Think()

    self._InWorld = self:IsInWorld()

    if ( not self._InWorld ) then
        if ( not self._InWorldTime ) then
            self._InWorldTime = CurTime()
        end

        if ( self._InWorldTime + 5 <= CurTime() ) then
            print( "Out of bounds! Removing!", self )
            self:Remove()    
        end
    elseif ( self._InWorld and self._InWorldTime ) then
        self._InWorldTime = nil
    end

    if self._SwingStart and self._SwingStart + self.SwingTime < CurTime() then
        self:Attack()
    end

end

function ENT:RunBehaviour()

    while ( true ) do
        
        local state = self:GetState()

        if ( state == STATE_IDLE ) then

            if ( IsValid( self:GetEnemy() ) ) then
                self:DoSound( self.AlertSound, true )
                self:SetState( STATE_CHASE )
            end

            if ( self.InitialPosition and self:GetRangeTo( self.InitialPosition ) > 64 ) then
                self:StartActivity( ACT_RUN )

                self:MoveToPos( self.InitialPosition, { lookahead = 256, tolerance = 64, draw = true } )
                coroutine.yield()
            end

            self:StartActivity( ACT_IDLE )
            
        elseif ( state == STATE_CHASE ) then

            if ( self:CheckEnemy() ) then
            
                local enemy = self:GetEnemy()
 
                self.loco:FaceTowards( enemy:GetPos() )
                self:StartActivity( ACT_RUN )
                self.loco:SetDesiredSpeed( self.Speed )
                self.loco:SetAcceleration( 900 )
    
                self:ChaseEnemy()
    
                self.loco:SetAcceleration( self.Speed - 50 )
                self:StartActivity( ACT_IDLE )    

            end
                    
        end

        coroutine.wait( .5 )

    end

end

util.AddNetworkString( "HalloweenNPCKilled" )