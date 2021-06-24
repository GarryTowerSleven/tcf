soundscapes = soundscapes or {}

local debug = CreateClientConVar( "sscapes_debug", "0", false, false )

soundscapes.locations = {}

	table.Merge( soundscapes.locations, {

		plaza = {

      a = Vector( 6032, -2980, -953 ),

      b = Vector( -1662, 3110, 659 ),

			streams = {

				plaza = 0.5

			},

    },

     trainstation = {

       a = Vector( 6092, -1427, -895 ),

       b = Vector( 8934, 1521, -1311 ),

       streams = {

         station = 0.5

       },

		},

    boardwalk = {

      a = Vector( -1512, -5328, -1635 ),

      b = Vector( -7692, 3972, 706 ),

      streams = {

        boardwalk = 0.5

      },

   },

   theatre_lobby = {

     a = Vector( 5271, 3229, -973 ),

     b = Vector( 3582, 4544, -438 ),

     streams = {

       theatre = 0.3

     },

  },
	vending_hum_plaza_l = {

		a = Vector( 137.75639343262, 264.18966674805, -906.96875 ),
		b = Vector( 659.93139648438, 503.44879150391, -676.70568847656 ),

		streams = {

			hum = 0.5

		},

 },
 vending_hum_plaza_r = {

	 a = Vector( 76.163261413574, -506.29861450195, -931.04553222656 ),
	 b = Vector( 609.0146484375, -280.19247436523, -680.53076171875 ),

	 streams = {

		 hum = 0.5

	 },

},
	vending_hum_station_r = {

		a = Vector( 6355.4580078125, 65.113975524902, -1124.5051269531 ),
		b = Vector( 6744.3984375, 320.26449584961, -954.93646240234 ),


		streams = {

			hum = 0.5

		},

 },

 vending_hum_station_l = {

	 a = Vector( 6369.1997070313, -320.93960571289, -1119.2869873047 ),
	b = Vector( 6742.0493164063, -64.412391662598, -932.85101318359 ),



	 streams = {

		 hum = 0.5

	 },

 },

  tower_lobby = {

    a = Vector( 6141, 1539, -629 ),

    b = Vector( 9221, -1543, 356 ),

    streams = {

      tower = 0.5

    },

 },

 tower_music = {

   a = Vector( 6141, 1539, -629 ),

   b = Vector( 9221, -1543, 356 ),

   streams = {

     towermainlobby = 0

   },

},

songbirds = {

	a = Vector( 787, -2209, -687 ),
	b = Vector( 1029, -2020, -528 ),

	streams = {

		songbirds = 1

	},

},

nightclub = {

	a = Vector( 1721.3178710938, -1918.4085693359, -900.96875 ),
	b = Vector( 2084.1108398438, -1441.6885986328, -604.51696777344 ),

	streams = {

		nightclub = 1

	},

},

nightclubInside = {

	a = Vector( 1405.9475097656, -5803.2221679688, -2712.97265625 ),
	b = Vector( 2867.4421386719, -4282.4287109375, -2079.0947265625 ),

	streams = {

		nightclubInside = .25

	},

},

centralplaza = {

	a = Vector( 2003.7834472656, -688.13256835938, -1272.96875 ),
	b = Vector( 3366.9855957031, 684.97399902344, -460.46875 ),

	streams = {

		centralplaza = .5

	},

},

nature = {

	a = Vector( 6104.3076171875, 1556.6644287109, -674.57879638672 ),
	b = Vector( 8563.5205078125, 3898.3820800781, 1653.4239501953 ),

	streams = {

		nature = 1

	},

},

	} )

for k, v in pairs( soundscapes.locations ) do
	v.a.x, v.b.x = math.min(v.a.x, v.b.x), math.max(v.a.x, v.b.x)
	v.a.y, v.b.y = math.min(v.a.y, v.b.y), math.max(v.a.y, v.b.y)
	v.a.z, v.b.z = math.min(v.a.z, v.b.z), math.max(v.a.z, v.b.z)
end

soundscapes.streamfiles = {
	plaza = Sound( "gmodtower/soundscapes/plaza.wav" ),
	station = Sound( "gmodtower/soundscapes/trainstation.wav" ),
	boardwalk = Sound( "gmodtower/soundscapes/boardwalk.mp3" ),
	theatre = Sound( "gmodtower/soundscapes/theatre_lobby.wav" ),
	tower = Sound( "gmodtower/soundscapes/tower_lobby.wav" ),
	towermainlobby = Sound( "gmodtower/soundscapes/music/towermainlobby1.mp3" ),
	songbirds = Sound( "gmodtower/soundscapes/music/deluxe_musicstore.mp3" ),
	nightclub = Sound( "gmodtower/lobby/club/club_exterior.mp3" ),
	nightclubInside = Sound( "gmodtower/soundscapes/tower_lobby.wav" ),
	centralplaza = Sound( "gmodtower/soundscapes/music/deluxe_centralplaza.mp3" ),
	nature = Sound( "gmodtower/soundscapes/music/deluxe_nature.mp3" ),
	hum = Sound( "gmodtower/lobby/trainstation/vendingmachinehumm.mp3" ),
}

soundscapes.streams = {}

local outdoors_state = 1

local rays = 8

local outdoors_state_last_calc = 0

local function calcOutdoorState()

	if RealTime() - outdoors_state_last_calc <= .03 then

		return

	end



	outdoors_state = 0

	for i = 1, rays do

		local pos = LocalPlayer():GetPos() + vector_up * 32

		local t = RealTime() * 0.1

		local off = Vector(math.cos(t + math.pi * i/rays * 2), math.sin(t + math.pi * i/rays * 2), -0.5) * 1024



		local tr = util.QuickTrace(pos, off, LocalPlayer())



		if debug:GetBool() then

			debugoverlay.Line(pos, tr.HitPos, 0.5, Color(255, 0, 0), true)

		end



		if tr.Hit then

			local up = util.QuickTrace(tr.HitPos, vector_up * 32768)

			if up.HitSky then

				outdoors_state = outdoors_state + 1

			--else

				--outdoors_state = math.max(0, outdoors_state - 0.05)

			end

		else

			--outdoors_state = math.max(0, outdoors_state - 0.1)

		end

	end



	outdoors_state = outdoors_state/rays

	outdoors_state_last_calc = RealTime()



	if debug:GetBool() then

		print("Outdoor state: " .. outdoors_state)

	end

end



local last = {}

local function getAudibleStreams()

	local t = {}



	local heard = 0



	local ceil



	for k, v in pairs(soundscapes.locations) do

		if LocalPlayer():EyePos():WithinAABox(v.a, v.b) then

			if v.streams then for k, v in pairs(v.streams) do

				heard = heard + 99

				t[k] = v

			end end

			if v.rain_indoors and GetGlobalBool("rain") then for k, v in pairs(v.rain_indoors) do

				calcOutdoorState()

				if not ceil then

					ceil = util.QuickTrace(LocalPlayer():GetPos(), vector_up * 16384, pl)

					for i = 1, 4 do

						if not ceil.HitSky then

							ceil = util.QuickTrace(ceil.HitPos + vector_up * 32, vector_up * 16384, pl)

						else

							break

						end

					end

					ceil = util.QuickTrace(ceil.HitPos + vector_up * 32, -vector_up * 16384, pl)

				end

				t[k] = (1-outdoors_state) * 0.2 * (1-math.min(1, LocalPlayer():GetPos():Distance(ceil.HitPos)/512))

				last[k] = t[k]

			end end



		end

	end





	if heard < 1 then

		t = last

	else

		last = t

	end



	if debug:GetBool() then

		PrintTable(t)

	end



	return t

end

local MuteLoseFocus = GetConVar("snd_mute_losefocus")

local function init()

	if not IsValid(LocalPlayer()) then

		return

	end



	for k, v in pairs(soundscapes.streamfiles) do

		soundscapes.streams[k] = false



		sound.PlayFile("sound/" .. v, "noplay", function(chan, err, str)

			if IsValid(chan) then

				soundscapes.streams[k] = chan

				chan:SetVolume(0)

				chan:EnableLooping(true)

				chan:Play()

			end

		end)

	end



	local t = -math.huge

	hook.Add("Think", "atmosphere", function()

		if RealTime() - t <= 0.03 then

			return

		end



		t = RealTime()



		local strs = getAudibleStreams()

		for k, v in pairs(soundscapes.streams) do

			if IsValid(v) then

				if v:GetState() ~= GMOD_CHANNEL_PLAYING then

					v:SetVolume(0)

					v:Play()

				end



				if MuteLoseFocus:GetBool() and not system.HasFocus() then

					v:SetVolume(0)

				else

					v:SetVolume(Lerp(0.03, v:GetVolume(), strs[k] or 0))

				end

			end

		end

	end)

end



if hook.GetTable().InitPostEntity and hook.GetTable().InitPostEntity.soundscapes then

	timer.Simple(0, init)

end



hook.Add("InitPostEntity", "soundscapes", init)



hook.Add("PostDrawOpaqueRenderables", "atmosphere", function(depth, sky)

	if sky then return end

	if not debug:GetBool() then return end



	local i, c = 0, table.Count(soundscapes.locations)

	for k, v in pairs(soundscapes.locations) do

		i = i + 1

		render.SetColorMaterial()

		local col = HSVToColor(360/c * i, 1, 1)

		col.a = 128

		render.DrawBox((v.a+v.b)/2, Angle(), (v.a+v.b)/2 - v.a, (v.a+v.b)/2 - v.b, col, false)

		render.DrawBox((v.a+v.b)/2, Angle(), - ((v.a+v.b)/2 - v.a), -((v.a+v.b)/2 - v.b), col, false)

		render.DrawWireframeBox((v.a+v.b)/2, Angle(), - ((v.a+v.b)/2 - v.a), -((v.a+v.b)/2 - v.b), ColorAlpha(col, 64), true)

	end

end)
