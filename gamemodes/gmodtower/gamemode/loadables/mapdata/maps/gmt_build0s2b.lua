module( "MapData", package.seeall )

-- ents to remove
local begone = {
    ["gmt_radio"] = true,
    ["gmt_multiserver"] = true,
}

local function MapFixes()
    -- remove unneeded ents
    for _, ent in ipairs(ents.GetAll()) do
        if begone[ent:GetClass()] then
            ent:Remove()
        end
    end

    -- remove all shops
    for _, npc in ipairs( ents.FindByClass("gmt_npc_*") ) do
        npc:Remove()
    end

    -- remove fake sk skymsg
    for _, ent in ipairs( ents.FindInRealSphere( Vector( 10784, 8600, 6912 ), 10 ) ) do
        if ent:GetClass() == "gmt_skymsg" then
            ent:Remove()
        end
    end

    -- TEMP: remove suite lamp
    for _, v in ipairs( ents.FindByClass("prop_physics") ) do
        if ( v:GetModel() == "models/gmod_tower/suite_lamptakenfromhl2.mdl" ) then
            //local pos, ang = v:GetPos(), v:GetAngles()
            v:Remove()

            //AddEntity( "gmt_room_lamp", pos, ang )
        end
    end

    -- dev hq fan
    for _, v in ipairs( ents.FindByClass("func_rotating") ) do
        if ( v:GetPos() == Vector( -260, -1168, 128 ) ) then
            for _, vv in ipairs( ents.FindByClass("prop_physics") ) do
                if ( vv:GetModel() == "models/props_mining/fanblade01.mdl" ) then
                    vv:SetParent( v )
                end
            end
        end
    end

    -- fix suite 17 door handles
    for _, door in ipairs( ents.FindByClass("func_door_rotating") ) do
        if ( door:GetPos() == Vector( 4351.5, -8913, 4151.5 ) ) then
            for _, handle in ipairs( ents.FindInRealSphere( door:GetPos(), 50 ) ) do
                if ( string.StartsWith( handle:GetModel(), "models/props/cs_office/doorknob" ) ) then
                    handle:SetParent( door )
                end
            end
        end
    end
end

// shit to add to the lobe
local function MapAdds()

    // boards
    CreateBoard( Vector(1418,-3833,-216), Angle(0,0,0), 1 )
    CreateBoard( Vector(1416.84375,-3581.8125,-216), Angle(0,0,0), 3 )
    CreateBoard( Vector(927.1875,-3325.53125,-84), Angle(0,0,0), 4 )
    CreateBoard( Vector(439,-3727,-216), Angle(0,180,0), 1 )
    CreateBoard( Vector(439.09375,-3580.75,-216), Angle(0,180,0), 2 )

    // shops
    AddEntity( "gmt_npc_merchant", Vector(-10464,9828,-64), Angle(0,-90,0) )
    AddEntity( "gmt_npc_bar", Vector(-8854.75,10922.1875,-119), Angle(0,0,0) )
    AddEntity( "gmt_npc_vip", Vector(165.90625,-2042.78125,0), Angle(0,45,0) )
    AddEntity( "gmt_npc_souvenir", Vector(2336,1556,216), Angle(0,180,0) )
    AddEntity( "gmt_npc_posters", Vector(2335.96875,1643.96875,216), Angle(0,180,0) )
    AddEntity( "gmt_npc_toys", Vector(2340,1594,217), Angle(0,180,0) )
    AddEntity( "gmt_npc_duel", Vector(2448,184,192), Angle(0,90,0) )
    AddEntity( "gmt_npc_casinochips", Vector(2713,375,192), Angle(0,180,0) )
    AddEntity( "gmt_npc_hat", Vector(1895.96875,608,-12), Angle(0,180,0) )
    AddEntity( "gmt_npc_models", Vector(1895.96875,540,-12), Angle(0,180,0) )
    AddEntity( "gmt_npc_pet", Vector(1890,823,-14), Angle(0,-135,0) )
    AddEntity( "gmt_npc_suitesell", Vector(-318,824,-16), Angle(0,-90,0) )
    AddEntity( "gmt_npc_building", Vector(-354.3125,840.125,-8), Angle(0,-90,0) )
    AddEntity( "gmt_npc_food", Vector(-512,548,192), Angle(0,0,0) )
    AddEntity( "gmt_npc_electronic", Vector(-705.96875,1660,216), Angle(0,0,0) )
    AddEntity( "gmt_npc_music", Vector(-709,1568,221), Angle(0,0,0) )
    AddEntity( "gmt_npc_bar", Vector(2751.96875,2832,16), Angle(0,-90,0) )
    AddEntity( "gmt_npc_pvpbattle", Vector(9917,10052,6657), Angle(0,-45,0) )
    AddEntity( "gmt_npc_ballracer", Vector(9912,11624,6656), Angle(0,-45,0) )
    AddEntity( "gmt_npc_roomlady", Vector(4579.5625,-10144,4097), Angle(0,0,0) )
    AddEntity( "gmt_npc_suitesell", Vector(3651.96875,-10748,4088), Angle(0,90,0) )
    AddEntity( "gmt_npc_building", Vector(3708,-9600,4088), Angle(0,-90,0) )

	// Trunk furniture store
	AddEntity( "gmt_trunk", Vector(-34.3125, 765.5625, 34.5000), Angle(0, -65.840218, 0) )

    // lobby webboard (changelog)
    AddEntity( "gmt_webboard", Vector(1640.75,-963.8125,5.21875), Angle(0,-135,0) )

    // Lobby Piano
    AddEntity( "gmt_piano", Vector(1836, -1273, 0), Angle(0, 180 ,0) )

    // Arcade Checkers
    for _, v in ipairs( ents.FindByClass( "gmt_tictactoe" ) ) do
        if ( v:GetPos().x == -1392 or v:GetPos().x == -1390 ) then
            local pos, ang = v:GetPos(), v:GetAngles()
            v:Remove()

            AddEntity( "gmt_game_checkers", pos, ang )
        end
    end

    // multiservers
    -- ballrace
    AddMultiServer( Vector(9681,11408,6700.375), Angle(0,0,0), 4 )
    -- pvpbattle
    AddMultiServer( Vector(9681,9840,6700.375), Angle(0,0,0), 5 )
    -- virus
    AddMultiServer( Vector(11347.96875,11412.875,6701), Angle(0,180,0), 6 )
    -- ultimatechimerahunt
    AddMultiServer( Vector(9696,11960.15625,6701), Angle(0,0,0), 7 )
    -- zombiemassacre
    AddMultiServer( Vector(11240,11977.15625,6701), Angle(0,180,0), 8 )
    -- minigolf
    AddMultiServer( Vector(10244.53125,8639.28125,6701), Angle(0,90,0), 14 )
    -- sourcekarts
    AddMultiServer( Vector(9696,9300,6701), Angle(0,0,0), 16 )

    // jukeboxes
    -- casino
    AddEntity( "gmt_jukebox", Vector(2366, 1039, 192), Angle(0,-90,0) )

    // casino
    -- poker
    AddEntity( "gmt_casino_poker", Vector(2851,598,192), Angle(0,180,0) )
    AddEntity( "gmt_casino_poker", Vector(2859,840,192), Angle(0,180,0) )
    AddEntity( "gmt_casino_poker", Vector(2950,840,192), Angle(0,0,0) )
    AddEntity( "gmt_casino_poker", Vector(2950,351,192), Angle(0,0,0) )
    AddEntity( "gmt_casino_poker", Vector(2859,351,192), Angle(0,180,0) )
    AddEntity( "gmt_casino_poker", Vector(2947,598,192), Angle(0,0,0) )

	-- video poker
	AddEntity( "gmt_casino_videopoker", Vector(2258,324,192), Angle(0,0,0) )
	AddEntity( "gmt_casino_videopoker", Vector(2258,356,192), Angle(0,0,0) )
	AddEntity( "gmt_casino_videopoker", Vector(2258,828,192), Angle(0,0,0) )
	AddEntity( "gmt_casino_videopoker", Vector(2258,860,192), Angle(0,0,0) )

	-- spinners
	AddEntity( "gmt_casino_spinner", Vector(2670,1260,260), Angle(0,-90,0) )
	AddEntity( "gmt_casino_spinner", Vector(2470,1260,260), Angle(0,-90,0) )
	AddEntity( "gmt_casino_spinner", Vector(2270,1260,260), Angle(0,-90,0) )
	AddEntity( "gmt_casino_spinner", Vector(2070,1260,260), Angle(0,-90,0) )

	-- seats
	AddSeat( "models/props/cs_office/sofa_chair.mdl", Vector(2015,1115,208), Angle(0,30,0), 0 )
	AddSeat( "models/props/cs_office/sofa_chair.mdl", Vector(2720,1115,208), Angle(0,130,0), 0 )
end

hook.Add( "InitPostEntity", "MapDataAdd", function()
    MapFixes()
    MapAdds()
end )