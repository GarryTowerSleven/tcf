AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.StartTime = nil
ENT.LifeTime = 10

util.AddNetworkString( ENT.NetString )

function ENT:Initialize()

    self:DrawShadow( false )

    self.StartTime = CurTime()

end

function ENT:Begin()

    self._NetworkDelay = CurTime() + .25
    self._ToSend = true
    
end

function ENT:Start()

    self:Network()

    self.StartTime = CurTime()
    self.LifeTime = self.Approach + self.Duration

end

function ENT:Network()

    net.Start( self.NetString )
        net.WriteEntity( self )
        net.WriteEntity( self.GoalEntity )

        net.WriteVector( self.GoalOffset )

        net.WriteString( self.ModelString )
        net.WriteUInt( math.Clamp( self.ModelCount, 1, 255 ), 8 )

        net.WriteBool( self.Sound != nil )
        if self.Sound != nil then
            net.WriteString( self.Sound )
            net.WriteUInt( self.SoundVolume, 7 )
        end

        net.WriteFloat( self.Duration )
        net.WriteFloat( self.Approach )
        net.WriteFloat( self.RandomPos )
        net.WriteUInt( self.SpinSpeed, 8 )
    net.Broadcast()
    
end

function ENT:Think()

    if self._ToSend and self._NetworkDelay < CurTime() then

        if IsValid( self.GoalEntity ) and self.ModelCount >= 1 then
            self:Start()
        else
            self:Remove()    
        end

        self._ToSend = false
    
    end

    if ( self.StartTime + self.LifeTime ) < CurTime() then

        self:Remove()

    end

end

/*
    Example Model Bezier Structure

    {
        pos = ply:GetPos(),                     // Starting position
        goal_entity = npc,                      // Entity to goto

        model = "models/gmt_money/one.mdl",     // Model
        count = 50,                             // Amount of models
            
        sound = "gmodtower/misc/money.wav",     // Sound to play upon model arriving at target
        sound_volume = 75,                      // Volume of sound above

        approach = 0.5,                         // Time to approach target
        duration = 2.5,                         // Time to finish after approach
        random_position = 50,                   // Random spread to spawn around starting pos
        spin = 100,                             // Speed of spin

        begin = true,                           // Begin bezier upon creation
    }
*/
function CreateModelBezier( data )

    if not data.pos or not IsValid( data.goal_entity or NULL ) or not data.model then return end

    local ent = ents.Create( "gmt_model_bezier" )

    if IsValid( ent ) then

        if IsEntity( data.pos ) and IsValid( data.pos ) then
            data.pos = data.pos:GetPos()
        end

        ent:SetPos( data.pos )
        ent.GoalEntity = data.goal_entity
    
        ent.ModelString = data.model
        ent.ModelCount = data.count
    
        ent.Sound = data.sound
        ent.SoundVolume = data.sound_volume
    
        ent.Approach = data.approach
        ent.Duration = data.duration
        ent.RandomPos = data.random_position
        ent.SpinSpeed = data.spin
        
        ent:Spawn()
        ent:Activate()

        if data.begin then
            ent:Begin()
        end

        return ent
            
    end

    return NULL

end