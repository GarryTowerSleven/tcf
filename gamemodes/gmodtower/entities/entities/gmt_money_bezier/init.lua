AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Network()

    net.Start( self.NetString )
        net.WriteEntity( self )
        net.WriteEntity( self.GoalEntity )
        net.WriteUInt( math.Clamp( self.ModelCount, 1, 150 ), 8 )

        net.WriteVector( self.GoalOffset )
        net.WriteFloat( self.RandomPos )
    net.Broadcast()
    
end

function CreateMoneyBezier( startpos, target, amount, begin, randompos, offset )

    if not startpos or not IsValid( target or NULL ) or not amount then return end

    local ent = ents.Create( "gmt_money_bezier" )

    if IsValid( ent ) then

        if IsEntity( startpos ) and IsValid( startpos ) then
            startpos = startpos:GetPos()
        end

        ent:SetPos( startpos )
        ent.GoalEntity = target
    
        ent.ModelCount = math.ceil( amount / 6 )

        ent.RandomPos = randompos or ent.RandomPos
        ent.GoalOffset = offset or ent.GoalOffset
        
        ent:Spawn()
        ent:Activate()

        if begin or false then
            ent:Begin()
        end

        return ent
            
    end

    return NULL

end