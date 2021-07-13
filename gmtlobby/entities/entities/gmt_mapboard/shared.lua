
-----------------------------------------------------
ENT.Type = "anim"

ENT.Base = "base_anim"

ENT.PrintName		= "Map Board"

ENT.Spawnable		= true

ENT.AdminSpawnable 	= true



ENT.Model = Model( "models/map_detail/billboard.mdl" )



--CHEATING CHEATING CHEATING!!!!

ENT.DelayTime = 0.0 --how long until the screen begins to fade

ENT.FadeTime = 0.25 --how long it takes to fade completely

ENT.WaitTime = 0.1 --period for it to stay completely black



ENT.Lookup = {

	["South Stores"] = {Vector(-173.994415, -906.414063, -607.968750), Angle(0.0, -90.0, 0.0)},

	["North Stores"] = {Vector(-183.083115, 919.489197, -607.968750), Angle(0.0, 90.0, 0.0)},

	["Gamemode Ports"] = {Vector(4786.731934, -5022.201660, -831.968750), Angle(0.0, 0.0, 0.0)},

	["Tower Condos"] = {Vector(-1998.334717, 1266.882202, 15047.031250), Angle(0.0, 0.0, 0.0)},

	["Theatre"] = {Vector(3822.897217, 3565.729248, -831.968750), Angle(0.0, -135.0, 0.0)},

	["Pulse Nightclub"] = {Vector(1573.140137, -5079.358887, -2559.968750), Angle(0.0, 0.0, 0.0)},

	["Tower Casino"] = {Vector(2404.9399, -10555.799, -2559), Angle(0.0, -90.0, 0.0)},

	["Transit Station"] = {Vector(7128.774414, 102, -1023.968750), Angle(0.0, -90.0, 0.0)},

	["Boardwalk"] = {Vector(-2500.774414, 0, -831.968750), Angle(0.0, 0.0, 0.0)},

	["Sweet Suites"] = {Vector(-1119.052490, 123, -831.968750), Angle(0.0, -90.0, 0.0)},

	//["Arcade"] = {Vector(10046.82324,2 -1794.755371, 8688.031250), Angle( 0, 90, 0 )},
	//["Trivia"] = {Vector(7973.235352, -2135.462646, 8944.031250), Angle( 0, 90, 0 )},
	//["Tower Garden"] = {Vector(6790.8364257813, 1317.8966064453, -607.96875), Angle(0, -90, 0)},
	//["Smoothie Bar"] = {Vector(-177.35861206055, 888.43981933594, -671.96875), Angle(0, 90, 0)},
	//["Basical's Goods"] = {Vector(-1119.9777832031, 137.43188476563, -895.96875), Angle(0, -90, 0)}
}
