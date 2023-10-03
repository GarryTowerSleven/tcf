local EVENT = {}

EVENT.Base = "ChainsawBattle"

EVENT.BattleType = "Fist Fight"

EVENT.Weapon = "weapon_fist"

EVENT.HookGroup = hookgroup.New()

EVENT.Locations = {

    [ Location.GetIDByName( "Bar" ) ] = {
        spawns = {
            { pos = Vector( 2557, 2295, 85 ), ang = Angle( 0, 45, 0 ) },

            { pos = Vector( 2730, 2723.5, 85 ), ang = Angle( 0, -45, 0 ) },

            { pos = Vector( 3336, 2357.5, 85 ), ang = Angle( 0, 145, 0 ) },

            { pos = Vector( 3021, 2896, 85 ), ang = Angle( 0, -105, 0 ) },

            { pos = Vector( 3258.5, 2744.5, 112 ), ang = Angle( 10, -163, 0 ) },
        },
    },

}

EVENT.MoneyOnKill = 5

minievent.Register( "FistFight", EVENT )