---------------------------------

hook.Add("LoadAchivements","AchiSeats", function ()
	GtowerAchivements:Add( ACHIVEMENTS.LONGSEATGETALIFE, {
		Name = "Get a Life",
		Description = "Sit for more than 5 hours.",
		Value = 5 * 60
		}
	)
end )

ChairOffsets = {}
ChairOffsets["models/props/de_inferno/furniture_couch02a.mdl"] = {
	Vector(7.6080, 0.2916, -5.1108)
}
ChairOffsets["models/fishy/furniture/piano_seat.mdl"] = {
	Vector(2.7427, 13.2392, 22)
}

ChairOffsets["models/gmod_tower/css_couch.mdl"] = {
                Vector(12.83425617218, -25.016822814941, 19.691375732422),
                Vector(11.887982368469, 0.47359153628349, 19.074829101563),
                Vector(11.508950233459, 26.898155212402, 18.528305053711),
}
ChairOffsets["models/props/cs_office/sofa.mdl"] = {
                Vector(12.83425617218, -25.016822814941, 19.691375732422),
                Vector(11.887982368469, 0.47359153628349, 19.074829101563),
                Vector(11.508950233459, 26.898155212402, 18.528305053711),
}
ChairOffsets["models/props/de_dust/hr_dust/dust_patio_set/dust_patio_chair.mdl"] = {
	Vector(0,5,22),
}
ChairOffsets["models/props/de_nuke/hr_nuke/nuke_chair/nuke_chair.mdl"] = {
	Vector(-4,0,18),
}
ChairOffsets["models/props/de_inferno/hr_i/inferno_chair/inferno_chair.mdl"] = {
	Vector(-1,0,20),
}
ChairOffsets["models/map_detail/condo_toilet.mdl"] = {
	Vector(-1,0,15),
}
ChairOffsets["models/props/de_nuke/hr_nuke/nuke_office_chair/nuke_office_chair.mdl"] = {
	Vector(1,0,20),
}
ChairOffsets["models/props_vtmb/sofa.mdl"] = {
	Vector(35, 5, 20),
	Vector(0, 4, 20),
	Vector(-35, 6, 20),
}
ChairOffsets["models/splayn/rp/lr/couch.mdl"] = {
                Vector(2.83425617218, -25.016822814941, 19.691375732422),
                Vector(1.887982368469, 0.47359153628349, 19.074829101563),
                Vector(1.508950233459, 26.898155212402, 18.528305053711),
}
ChairOffsets["models/pt/lobby/pt_couch.mdl"] = {
                Vector(2.83425617218, -20.016822814941, 15.691375732422),
                Vector(1.508950233459, 20.898155212402, 15.528305053711),
}
ChairOffsets["models/props/cs_office/sofa_chair.mdl"] = {
                Vector(7.77490234375, -0.62280207872391, 20.302822113037),
}
ChairOffsets["models/splayn/rp/lr/chair.mdl"] = {
                Vector(7.77490234375, -0.62280207872391, 20.302822113037),
}
ChairOffsets["models/props/de_tides/patio_chair2.mdl"] = {
                Vector(1.4963380098343, -1.5668944120407, 17.591537475586),
}
ChairOffsets["models/gmod_tower/medchair.mdl"] = {
                Vector(-2.4963380098343, 0.5668944120407, 17.591537475586),
}
ChairOffsets["models/gmod_tower/plazabooth.mdl"] = {
                Vector(26.779298782349, -48.443725585938, 17.575805664063),
                Vector(24.627443313599, -22.173582077026, 17.693496704102),
                Vector(24.728271484375, 4.1212167739868, 17.712997436523),
                Vector(24.429685592651, 29.835939407349, 17.069671630859),
                Vector(25.442136764526, 53.892211914063, 18.112731933594),
}
ChairOffsets["models/props_trainstation/traincar_seats001.mdl"] = {
                Vector(4.6150, 41.7277, 18.5313),
                Vector(4.7320, 14.4948, 18.5313),
                Vector(4.5561, -13.3913, 18.5313),
                Vector(5.4507, -40.9903, 18.5313)
}
ChairOffsets["models/gmod_tower/theater_seat.mdl"] = {
                Vector(0, -5, 23),
                --Vector(4.7320, 14.4948, 18.5313),
               -- Vector(4.5561, -13.3913, 18.5313),
               -- Vector(5.4507, -40.9903, 18.5313)
}
ChairOffsets["models/map_detail/beach_chair.mdl"] = {
	Vector(0, -12, 8),
}
ChairOffsets["models/map_detail/music_drumset_stool.mdl"] = {
	Vector(0, 0, 24)
}
ChairOffsets["models/map_detail/plaza_bench_metal.mdl"] = {
	Vector(3, 25, 5),
	Vector(3, 0, 5),
	Vector(3, -25, 5),
}
ChairOffsets["models/map_detail/station_bench.mdl"] = {
	Vector(3, 25, 0),
	Vector(3, 0, 0),
	Vector(3, -25, 0),
}
ChairOffsets["models/map_detail/lobby_cafechair.mdl"] = {
	Vector(0, 0, -5),
}
ChairOffsets["models/map_detail/sofa_lobby.mdl"] = {
	Vector(30, 0, 15),
	Vector(0, 0, 15),
	Vector(-30, 0, 15)
}
ChairOffsets["models/map_detail/chair_lobby.mdl"] = {
	Vector(0, 0, 15)
}
ChairOffsets["models/props_c17/chair02a.mdl"] = {
                Vector(16.809963226318, 5.6439781188965, 1.887882232666),
}
ChairOffsets["models/props_interiors/furniture_chair03a.mdl"] = {
                Vector(-2, 0, -2.5),
}
ChairOffsets["models/props_c17/chair_stool01a.mdl"] = {
                Vector(-0.4295127093792, -1.5806334018707, 35.876251220703),
}
ChairOffsets["models/props_vtmb/armchair.mdl"] = {
                Vector(-1.4295127093792, -2.5806334018707, 13.876251220703),
}
ChairOffsets["models/props/cs_militia/barstool01.mdl"] = {
                Vector(-0.72143560647964, 0.90307611227036, 33.387348175049),
}
ChairOffsets["models/props_interiors/furniture_chair01a.mdl"] = {
                Vector(0.46997031569481, -0.053411800414324, -1.7953878641129),
}
ChairOffsets["models/props/cs_militia/couch.mdl"] = {
                Vector(30.384033203125, 5.251708984375, 15.507431030273),
                Vector(0.44091796875, 4.386474609375, 16.095657348633),
                Vector(-31.472412109375, 6.045166015625, 16.215229034424),
}
ChairOffsets["models/props_c17/furnituretoilet001a.mdl"] = {
                Vector(0.90478515625, -0.208984375, -30.683263778687),
}
ChairOffsets["models/props/cs_office/chair_office.mdl"] = {
                Vector(2.5078778266907, 1.4323912858963, 14.806640625),
}
ChairOffsets["models/gmod_tower/stealth box/box.mdl"] = {
                Vector(-2.0869002342224, -10.265548706055, 37.816131591797),
}
ChairOffsets["models/props_c17/furniturechair001a.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, -6.69970703125),
}
ChairOffsets["models/gmod_tower/comfychair.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, 12.69970703125),
}
ChairOffsets["models/haxxer/me2_props/illusive_chair.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, 14.69970703125),
}
ChairOffsets["models/sunabouzu/lobby_chair.mdl"] = {
                Vector(5.30538135766983, 0.14535087347031, 25.69970703125),
}
ChairOffsets["models/props/de_tides/patio_chair.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, 20.69970703125),
}
ChairOffsets["models/props_vtmb/chairfancyhotel.mdl"] = {
                Vector(-1, 6, 18.69970703125),
}
ChairOffsets["models/props/de_inferno/chairantique.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, 12.69970703125),
}
ChairOffsets["models/haxxer/me2_props/reclining_chair.mdl"] = {
                Vector(0.30538135766983, 0.14535087347031, 12.69970703125),
}
ChairOffsets["models/props_c17/furniturearmchair001a.mdl"] = {
                Vector(25.30538135766983, 32.14535087347031, 15.69970703125),
}
ChairOffsets["models/gmod_tower/suitecouch.mdl"] = {
                Vector(2.5263111591339, -25.540681838989, 17.753444671631),
                Vector(2.563271522522, 0.83294534683228, 17.750255584717),
                Vector(1.3705009222031, 27.729253768921, 17.448686599731),
}
ChairOffsets["models/mirrorsedge/bench_wooden.mdl"] = {
                Vector(1, -25.540681838989, 13.753444671631),
                Vector(1, 0.83294534683228, 13.750255584717),
                Vector(1, 27.729253768921, 13.448686599731),
}
ChairOffsets["models/map_detail/plaza_bench.mdl"] = {
                Vector(1, -25.540681838989, 15.753444671631),
                Vector(1, 0.83294534683228, 15.750255584717),
                Vector(1, 27.729253768921, 15.448686599731),
}
ChairOffsets["models/map_detail/plaza_bench2.mdl"] = {
                Vector(1, -25.540681838989, 15.753444671631),
                Vector(1, 0.83294534683228, 15.750255584717),
                Vector(1, 27.729253768921, 15.448686599731),
}
ChairOffsets["models/props_combine/breenchair.mdl"] = {
                Vector(6.8169813156128, -2.8282260894775, 16.551658630371),
}
ChairOffsets["models/mirrorsedge/seat_blue2.mdl"] = {
                Vector(0, -3, 14),
}
ChairOffsets["models/mirrorsedge/seat_blue1.mdl"] = {
                Vector(0, -3, 14),
}
ChairOffsets["models/props_interiors/toilet.mdl"] = {
                Vector(25, 0, 15),
}
