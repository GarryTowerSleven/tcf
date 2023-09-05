AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

local BaseClass = baseclass.Get( "mediaplayer_base" )

// blehhhhh
hook.Add( "MediaPlayerAddListener", "MPOnSound", function( mp, ply )
    if ( not IsValid( mp ) ) then return end
    if ( mp:GetType() != "suitetv" ) then return end

    local ent = mp.Entity or NULL 
    if ( not IsValid( ent ) ) then return end

    ent:PlaySound( ply, true )
end )

hook.Add( "MediaPlayerRemoveListener", "MPOffSound", function( mp, ply )
    if ( not IsValid( mp ) ) then return end
    if ( mp:GetType() != "suitetv" ) then return end

    local ent = mp.Entity or NULL 
    if ( not IsValid( ent ) ) then return end

    ent:PlaySound( ply, false )
end )

function ENT:PlaySound( ply, on )
    if ( not IsValid( ply ) ) then return end
    
    self:EmitSoundToPlayer( ply, on and self.SoundOn or self.SoundOff )
end

function ENT:SetupMediaPlayer( mp )

    mp:on( "mediaChanged", function( media )
        local thumbnail = media && media:Thumbnail() or ""

        self:SetThumbnail( thumbnail )
    end )

end
