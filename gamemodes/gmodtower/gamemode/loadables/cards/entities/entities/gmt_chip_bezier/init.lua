AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function CreateChipBezier( startpos, target, amount, begin )

    if not startpos or not IsValid( target or NULL ) or not amount then return end

    local ent = ents.Create( "gmt_chip_bezier" )

    if IsValid( ent ) then

        if IsEntity( startpos ) and IsValid( startpos ) then
            startpos = startpos:GetPos()
        end

        ent:SetPos( startpos )
        ent.GoalEntity = target
    
        ent.ModelCount = amount
        
        ent:Spawn()
        ent:Activate()

        if begin or false then
            ent:Begin()
        end

        return ent
            
    end

    return NULL

end