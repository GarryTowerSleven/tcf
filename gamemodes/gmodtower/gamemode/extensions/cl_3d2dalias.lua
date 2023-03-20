local alias = CreateClientConVar( "gmt_3d2d_filtering", "1", true, false, "Enable filtering of 3D2D panels.", 0, 1 )
local enabled = enabled or alias:GetBool()

cvars.AddChangeCallback( "gmt_3d2d_filtering", function( _, old, new )
    enabled = tobool( new ) or false
end )

local _Start3D2D = _Start3D2D or cam.Start3D2D
local _End3D2D = _End3D2D or cam.End3D2D

function cam.Start3D2D( ... )
    _Start3D2D( ... )
    if ( not enabled ) then
        render.PushFilterMag( TEXFILTER.NONE )
    end
end

function cam.End3D2D( ... )
    if ( not enabled ) then
        render.PopFilterMag()
    end
    _End3D2D( ... )
end