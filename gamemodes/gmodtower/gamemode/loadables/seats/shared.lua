module( "seats", package.seeall )

ChairOffsets = {
	["models/props/de_inferno/furniture_couch02a.mdl"] = {
		{ Pos = Vector(7.6080, 0.2916, -5.1108) },
	},
	["models/fishy/furniture/piano_seat.mdl"] = {
		{ Pos = Vector(2.7427, 13.2392, 22) },
	},
	["models/gmod_tower/css_couch.mdl"] = {
		{ Pos = Vector(12.83425617218, -25.016822814941, 19.691375732422) },
		{ Pos = Vector(11.887982368469, 0.47359153628349, 19.074829101563) },
		{ Pos = Vector(11.508950233459, 26.898155212402, 18.528305053711) },
	},
	["models/props/cs_office/sofa.mdl"] = {
		{ Pos = Vector(12.83425617218, -25.016822814941, 19.691375732422) },
		{ Pos = Vector(11.887982368469, 0.47359153628349, 19.074829101563) },
		{ Pos = Vector(11.508950233459, 26.898155212402, 18.528305053711) },
	},
	["models/props/cs_office/sofa_chair.mdl"] = {
		{ Pos = Vector(7.77490234375, -0.62280207872391, 20.302822113037) },
	},
	["models/props/de_tides/patio_chair2.mdl"] = {
		{ Pos = Vector(1.4963380098343, -1.5668944120407, 17.591537475586), Ang = Angle(0, 180, 0) },
	},
	["models/gmod_tower/plazabooth.mdl"] = {
		{ Pos = Vector(26.779298782349, -48.443725585938, 17.575805664063) },
		{ Pos = Vector(24.627443313599, -22.173582077026, 17.693496704102) },
		{ Pos = Vector(24.728271484375, 4.1212167739868, 17.712997436523) },
		{ Pos = Vector(24.429685592651, 29.835939407349, 17.069671630859) },
		{ Pos = Vector(25.442136764526, 53.892211914063, 18.112731933594) },
	},
	["models/props_trainstation/traincar_seats001.mdl"] = {
		{ Pos = Vector(4.6150, 41.7277, 18.5313) },
		{ Pos = Vector(4.7320, 14.4948, 18.5313) },
		{ Pos = Vector(4.5561, -13.3913, 18.5313) },
		{ Pos = Vector(5.4507, -40.9903, 18.5313) },
	},
	["models/props_c17/chair02a.mdl"] = {
		{ Pos = Vector(16.809963226318, 5.6439781188965, 1.887882232666) },
	},
	["models/props_interiors/furniture_chair03a.mdl"] = {
		{ Pos = Vector(0, 0, -1) },
	},
	["models/props/de_inferno/chairantique.mdl"] = {
		{ Pos = Vector(0, 0, 15) },
	},
	["models/props/de_tides/patio_chair.mdl"] = {
		{ Pos = Vector(5, 0, 20) },
	},
	["models/haxxer/me2_props/reclining_chair.mdl"] = {
		{ Pos = Vector(0, 0, 15), Ang = Angle(0, 0, 0) },
	},
	["models/haxxer/me2_props/illusive_chair.mdl"] = {
		{ Pos = Vector(0, 0, 15), Ang = Angle(0, 90, 0) },
	},
	["models/props_vtmb/armchair.mdl"] = {
		{ Pos = Vector(0, -10, 15), Ang = Angle(0, 0, 0) },
	},
	["models/props_vtmb/sofa.mdl"] = {
		{ Pos = Vector(0, 10, 25), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(38, 10, 25), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-38, 10, 25), Ang = Angle(0, 0, 0) },
	},
	["models/props_c17/chair_stool01a.mdl"] = {
		{ Pos = Vector(-0.4295127093792, -1.5806334018707, 35.876251220703) },
	},
	["models/props/cs_militia/barstool01.mdl"] = {
		{ Pos = Vector(-0.72143560647964, 0.90307611227036, 33.387348175049) },
	},
	["models/props_interiors/furniture_chair01a.mdl"] = {
		{ Pos = Vector(0.46997031569481, -0.053411800414324, -1.7953878641129) },
	},
	["models/props_interiors/furniture_couch01a.mdl"] = {
		{ Pos = Vector(1.8,0,-6.5) },
		{ Pos = Vector(1.8,-23.9,-6.5) },
		{ Pos = Vector(1.8,23.9,-6.5) },
	},
	["models/props_interiors/furniture_couch02a.mdl"] = {
		{ Pos = Vector(2.1,0,-6.3) },
	},
	["models/props/cs_militia/couch.mdl"] = {
		{ Pos = Vector(30.384033203125, 5.251708984375, 15.507431030273), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(0.44091796875, 4.386474609375, 16.095657348633), Ang = Angle(0, 0, 0) },
		{ Pos = Vector(-31.472412109375, 6.045166015625, 16.215229034424), Ang = Angle(0, 0, 0) },
	},
	["models/props_c17/furnituretoilet001a.mdl"] = {
		{ Pos = Vector(0.90478515625, -0.208984375, -30.683263778687) },
	},
	["models/props/cs_office/chair_office.mdl"] = {
		{ Pos = Vector(2.5078778266907, 1.4323912858963, 14.806640625) },
	},
	["models/gmod_tower/stealth box/box.mdl"] = {
		{ Pos = Vector(-2.0869002342224, -10.265548706055, 37.816131591797), Ang = Angle(0, 180, 0) },
	},
	["models/props_c17/furniturechair001a.mdl"] = {
		{ Pos = Vector(0.30538135766983, 0.14535087347031, -6.69970703125) },
	},
	["models/gmod_tower/suitecouch.mdl"] = {
		{ Pos = Vector(2.5263111591339, -25.540681838989, 17.753444671631) },
		{ Pos = Vector(2.563271522522, 0.83294534683228, 17.750255584717) },
		{ Pos = Vector(1.3705009222031, 27.729253768921, 17.448686599731) },
	},
	["models/gmod_tower/suite_booth.mdl"] = {
		{ Pos = Vector(-2.5263111591339, -40.540681838989, 17.753444671631), Ang = Angle(0, 70, 0) },
		{ Pos = Vector(-2.563271522522, 0.83294534683228, 17.750255584717), Ang = Angle(0, 90, 0) },
		{ Pos = Vector(-2.3705009222031, 40.729253768921, 17.448686599731), Ang = Angle(0, 110, 0) },
	},
	["models/props_combine/breenchair.mdl"] = {
		{ Pos = Vector(6.8169813156128, -2.8282260894775, 16.551658630371) },
	},
	["models/gmod_tower/medchair.mdl"] = {
		{ Pos = Vector(5, 0, 16) },
	},
	["models/props_vtmb/chairfancyhotel.mdl"] = {
		{ Pos = Vector(0, 8, 16) },
	},
	["models/props_vtmb/hotelchair.mdl"] = {
		{ Pos = Vector(0, 0, 16) , Ang = Angle(0, 180, 0) },
	},
	["models/gmod_tower/comfychair.mdl"] = {
		{ Pos = Vector(4, 0, 16) },
	},
	["models/splayn/rp/lr/chair.mdl"] = {
		{ Pos = Vector(4, 0, 22) },
	},
	["models/splayn/rp/lr/couch.mdl"] = {
		{ Pos = Vector(0, 0, 22) },
		{ Pos = Vector(0, -30, 22) },
		{ Pos = Vector(0, 30, 22) },
	},
	["models/pt/lobby/pt_couch.mdl"] = {
		{ Pos = Vector(0, 20, 16) },
		{ Pos = Vector(0, -20, 16) },
	},
	["models/sunabouzu/lobby_chair.mdl"] = {
		{ Pos = Vector(5.2, 0, 24.1) },
	},
	["models/gmod_tower/theater_seat.mdl"] = {
		{ Pos = Vector(1, -5, 23), Ang = Angle(10, 180, 0) },
	},
	["models/map_detail/plaza_bench.mdl"] = {
		{ Pos = Vector(3, 25, 15) },
		{ Pos = Vector(3, 0, 15) },
		{ Pos = Vector(3, -25, 15) },
	},
	["models/map_detail/plaza_bench2.mdl"] = {
		{ Pos = Vector(3, 25, 15) },
		{ Pos = Vector(3, 0, 15) },
		{ Pos = Vector(3, -25, 15) },
	},
	["models/map_detail/plaza_bench_metal.mdl"] = {
		{ Pos = Vector(3, 25, 5) },
		{ Pos = Vector(3, 0, 5) },
		{ Pos = Vector(3, -25, 5) },
	},
	["models/map_detail/station_bench.mdl"] = {
		{ Pos = Vector(3, 25, 0) },
		{ Pos = Vector(3, 0, 0) },
		{ Pos = Vector(3, -25, 0) },
	},
	["models/map_detail/sofa_lobby.mdl"] = {
		{ Pos = Vector(30, 0, 15), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(0, 0, 15), Ang = Angle(0, 180, 0) },
		{ Pos = Vector(-30, 0, 15), Ang = Angle(0, 180, 0) },
	},
	["models/map_detail/chair_lobby.mdl"] = {
		{ Pos = Vector(0, 0, 15), Ang = Angle(0, 180, 0) },
	},
	["models/map_detail/condo_toilet.mdl"] = {
		{ Pos = Vector(0, 0, 15), Ang = Angle(0, 0, 0) },
	},
	["models/map_detail/music_drumset_stool.mdl"] = {
		{ Pos = Vector(0, 0, 24) },
	},
	["models/map_detail/lobby_cafechair.mdl"] = {
		{ Pos = Vector(0, 0, -5), Ang = Angle(0, 90, 0) },
	},
	["models/map_detail/beach_chair.mdl"] = {
		{ Pos = Vector(0, -12, 8), Ang = Angle(30, 180, 0) },
	},
	["models/sunabouzu/theater_curve_couch.mdl"] = {
		{ Pos = Vector(-73.6, 17.3, 18.8), Ang = Angle(0, -128, 0) },
		{ Pos = Vector(-65.2, 50.3, 18.8), Ang = Angle(0, -128, 0) },
		{ Pos = Vector(-37.5, 71.7, 18.8), Ang = Angle(0, -153, 0) },
		{ Pos = Vector(0, 80, 18.8), Ang = Angle(0, -180, 0) },
		{ Pos = Vector(37.5, 71.7, 18.8), Ang = Angle(0, 153, 0) },
		{ Pos = Vector(65.2, 50.3, 18.8), Ang = Angle(0, 128, 0) },
		{ Pos = Vector(73.6, 17.3, 18.8), Ang = Angle(0, 128, 0) },
	},
	["models/sunabouzu/theater_sofa01.mdl"] = {
		{ Pos = Vector(-16.8, -0.9, 16.2), Ang = Angle(0, -180, 0) },
		{ Pos = Vector(16.8, -0.9, 16.2), Ang = Angle(0, -180, 0) },
	},
}

DefaultSitSound = Sound("sunabouzu/chair_sit.wav")
ChairSitSounds = {
	["models/sunabouzu/theater_curve_couch.mdl"] = Sound("sunabouzu/couch_sit.wav"),
}