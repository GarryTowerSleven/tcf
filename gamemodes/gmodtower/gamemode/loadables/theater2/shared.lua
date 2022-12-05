GTowerTheater = GTowerTheater or {}
GTowerTheater.theaters = GTowerTheater.theaters or {}
GTowerTheater.data = GTowerTheater.data or {}
GTowerTheater.data = GTowerTheater.data or {}

if CLIENT then
    GTowerTheater.PreviewsEnabled = CreateClientConVar( "gmt_theater_previews", 1, true, false, nil, 0, 1 )
end

function GTowerTheater:Add( name )
    if !name then return end

    table.uinsert( GTowerTheater.theaters, name )

    GTowerTheater.data[name] = {}

    GTowerTheater.data[name].thumb = 0
    GTowerTheater.data[name]._lastThumb = 0
    GTowerTheater.data[name].thumbMat = 0
    GTowerTheater.data[name].title = 0
    GTowerTheater.data[name]._lastTitle = 0
end

GTowerTheater:Add( "theater1" )
GTowerTheater:Add( "theater2" )

local delay = 1
local lastCheck = 0
hook.Add( "Think", "TheaterUpdater", function()

    if SERVER then return end // unneeded currently, works though
    if CLIENT && !GTowerTheater.PreviewsEnabled:GetBool() then return end
    if CLIENT && !Location.IsGroup( LocalPlayer():Location(), "plaza" ) then return end
    
    if CurTime() < lastCheck then return end
    lastCheck = CurTime() + delay
    
    for _, th in pairs( GTowerTheater.theaters ) do
        local thumb = GetGlobalString( "TheaterThumb_" .. tostring(th), "0" )
        local title = GetGlobalString( "TheaterTitle_" .. tostring(th), "0" )

        if GTowerTheater.data[tostring(th)].thumb != thumb then
            GTowerTheater.data[tostring(th)].thumb = thumb or 0
            GTowerTheater.data[tostring(th)]._lastThumb = thumb or 0

            if CLIENT then
                if thumb == 0 then
                    GTowerTheater.data[tostring(th)].thumbMat = 0
                else
                    CasinoKit.getRemoteMaterial(thumb, function(mat)
                        GTowerTheater.data[tostring(th)].thumbMat = mat
                    end)
                end
            end

            hook.Call( "TheaterUpdate", GAMEMODE, tostring(th), title or 0, thumb or 0 )
        end

        if GTowerTheater.data[tostring(th)].title != title then
            GTowerTheater.data[tostring(th)].title = title or 0
            GTowerTheater.data[tostring(th)]._lastTitle = title or 0

            hook.Call( "TheaterUpdate", GAMEMODE, tostring(th), title or 0, thumb or 0 )
        end
    end

end )