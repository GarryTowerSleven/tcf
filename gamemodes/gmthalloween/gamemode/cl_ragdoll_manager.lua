
module( "ragdollmanager", package.seeall )

LifeTimeConvar = CreateClientConVar( "gmt_ragdoll_lifetime", "120", true, false, nil )
FadeoutConvar = CreateClientConVar( "gmt_ragdoll_fadeout", "1", true, false, nil, 0, 1 )

Entities = Entities or {}

local function Lifetime()
    return LifeTimeConvar:GetInt()
end

local function ShouldFade()
    return FadeoutConvar:GetBool()
end

function Add( ent )

    if not IsValid( ent ) then return end

    ent._CreationTime = CurTime()
    table.uinsert( Entities, ent )

end

function Remove( ent )

    table.RemoveByValue( Entities, ent )

    if IsValid( ent ) then
        ent._Removing = true

        if ShouldFade() then

            ent:SetSaveValue( "m_bFadingOut", true )
            timer.Simple( 1, function() if IsValid( ent ) and ent.Remove then ent:Remove() end end )
    
        else
        
            ent:Remove()

        end
    end
    
end

function Think()

    local lifetime = Lifetime()
    if lifetime < 0 then return end

    for _, v in ipairs( Entities ) do

        if not IsValid( v ) or v == NULL then
            Remove( v )
            return
        end
        
        if not v._CreationTime then
            v._CreationTime = CurTime()
        end

        if v._CreationTime + lifetime <= CurTime() and not v._Removing then
            Remove( v )
        end

    end

end

hook.Add( "Think", "RagdollManager", Think )

hook.Add( "CreateClientsideRagdoll", "RagdollManager", function( ent, ragdoll )

    if ent.IsPlayer and ent:IsPlayer() then return end

    Add( ragdoll )

end )
