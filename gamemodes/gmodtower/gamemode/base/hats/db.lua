// aaaaaaaaaa get all hats from SQL

// get out if mysql is fuck
if !tmysql || SQL.getDB() == false then return end

GlobalHatOffsets = GlobalHatOffsets or {}
local function createHatTable()
    if ( table.Count( GlobalHatOffsets ) > 0 ) then
        return
    end

    MsgC(co_color, "[Hats] Generating Hats Table...\n")
    local hatsOffetsCount = 0
    SQL.getDB():Query("SELECT * FROM gm_hats", function( res )

        if res[1].status != true then
            MsgC(co_color2, "[Hats] MySQL error while obtaining hats: " .. tostring(res[1].error) .. "\n")
            return
        end

        for k,v in pairs(res[1].data) do
            if !GlobalHatOffsets[v.plymodel] then
                GlobalHatOffsets[v.plymodel] = {}
            end
            GlobalHatOffsets[v.plymodel][v.hat] = {v.id, v.vx, v.vy, v.vz, v.ap, v.ay, v.ar, v.scale}
            hatsOffetsCount = hatsOffetsCount + 1
        end

        MsgC(co_color, "[Hats] Hats Table created with a total of " .. hatsOffetsCount .. " entries!\n")

    end )
end

createHatTable()