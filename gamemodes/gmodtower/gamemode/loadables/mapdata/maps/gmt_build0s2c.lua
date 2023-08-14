module( "MapData", package.seeall )

-- ents to remove
local begone = {
    ["gmt_multiserver"] = true,
}

local function MapFixes()
    -- remove unneeded ents
    for _, ent in ipairs(ents.GetAll()) do
        if begone[ent:GetClass()] then
            ent:Remove()
        end
    end

    -- remove fake sk skymsg
    for _, ent in ipairs( ents.FindInRealSphere( Vector( 10784, 8600, 6912 ), 10 ) ) do
        if ent:GetClass() == "gmt_skymsg" then
            ent:Remove()
        end
    end
end

// shit to add to the lobe
local function MapAdds()

    // boards
    CreateBoard( Vector(1418,-3833,-216), Angle(0,0,0), 1 )
    CreateBoard( Vector(1416.84375,-3581.8125,-216), Angle(0,0,0), 3 )
    CreateBoard( Vector(927.1875,-3325.53125,-84), Angle(0,0,0), 4 )
	CreateBoard( Vector(927.1875,-3180.53125,-100), Angle(0,0,0), 5 )
    CreateBoard( Vector(439,-3727,-216), Angle(0,180,0), 1 )
    CreateBoard( Vector(439.09375,-3580.75,-216), Angle(0,180,0), 2 )

    // shops

    AddEntity( "gmt_npc_vip", Vector(165.90625,-2042.78125,0), Angle(0,45,0) )
    AddEntity( "gmt_npc_duel", Vector(2448,184,192), Angle(0,90,0) )
    AddEntity( "gmt_npc_casinochips", Vector(2713,375,192), Angle(0,180,0) )
    AddEntity( "gmt_npc_pet", Vector(1890,823,-14), Angle(0,-135,0) )
    AddEntity( "gmt_npc_roomlady", Vector(4579.5625,-10144,4097), Angle(0,0,0) )
	
    // lobby webboard (changelog)
    AddEntity( "gmt_webboard", Vector(1640.75,-963.8125,5.21875), Angle(0,-135,0) )

    // Lobby Piano
    AddEntity( "gmt_piano", Vector(1836, -1215, 0), Angle(0, 180 ,0) )

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