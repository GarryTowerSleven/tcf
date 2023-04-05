module( "particle_params", package.seeall )

function Load(params, def)

	for k,v in pairs(def) do

		if v.class == "settings" then
			local image = v.values.image
			params.image = string.sub(image, 0, -5)
		end

		if v.class == "articulator" then
			local m = v.values
			local pk = 0

			for i=1, #params[m.name].keys do
				if params[m.name].keys[i] == m.key then pk = i end
			end

			if pk ~= 0 then
				params[m.name].values[pk]:ClearPoints()
				if type(m.times) == "table" then
					local ntimes = #m.times
					for i=1, ntimes do
						params[m.name].values[pk]:AddPoint(m.times[i],m.values[i])
						params[m.name].values[pk]:GetLastAdded().curve = m.curves[i]
					end
				else
					params[m.name].values[pk]:AddPoint(m.times,m.values)
					params[m.name].values[pk]:GetLastAdded().curve = m.curves
				end
			end
		end
	end

end

function LoadFromText( text )
	local particle_def = {}
	serialize.FromString( text, particle_def )

	local params = particle_params.GetDefault()
	particle_params.Load(params, particle_def)

	if params.image then
		params.image = Material("particles/" .. params.image)
		if tostring(params.image) == "___error" then
			params.image = nil
		end
	end

	return params
end

function LoadFromFile( filename, path )

	filename = "particles/" .. filename .. ".txt"

	local particle_str = file.Read( filename, path or "DATA" )

	if particle_str then
		return LoadFromText( particle_str )
	end

end

function GetDefault()
return {
	color = {
		rt = {false,false,false,false},
		shared = true,
		bounds = {
			{0,255},
			{0,255},
			{0,255},
			{0,255},
		},
		strings = {
			"Red",
			"Green",
			"Blue",
			"Alpha"
		},
		keys = {"red","green","blue","alpha"},
		values = {
			articulator.new():AddPoint(0,255), --r
			articulator.new():AddPoint(0,255), --g
			articulator.new():AddPoint(0,255), --b
			articulator.new():AddPoint(0,255), --a
		},
	},
	range = {
		rt = {true},
		bounds = { {0,180},},
		strings = {"Emission Range"},
		keys = {"time"},
		values = { articulator.new():AddPoint(0,180) },
	},
	angle = {
		rt = {true},
		bounds = { {nil,nil}, },
		focus = { {-360,360}, },
		strings = {"Emission Angle"},
		keys = {"time"},
		values = { articulator.new():AddPoint(0,0) },
	},
	rotation = {
		rt = {true, true},
		bounds = { 
			{-360,360},
			{-360,360},
		},
		keys = {"time","variation"},
		strings = {
			"Rotation", 
			"Rotation Variation"
		},
		values = { 
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,0),
		},
	},
	velocity = {
		rt = {true,true,false},
		bounds = { 
			{0,nil},
			{0,nil},
			{-1,1},
		},
		focus = {
			{0,500},
			{0,300},
			nil,
		},
		keys = {"time","variation","life"},
		strings = {
			"Velocity",
			"Velocity Variation",
			"Velocity Over Life" 
		},
		values = { 
			articulator.new():AddPoint(0,100),
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,1),
		},
	},
	size = {
		rt = {true,true,false},
		bounds = { 
			{0,nil},
			{0,nil},
			{0,1},
		},
		keys = {"time","variation","life"},
		strings = {
			"Size",
			"Size Variation",
			"Size Over Life" 
		},
		values = { 
			articulator.new():AddPoint(0,3),
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,1),
		},
	},
	spin = {
		rt = {true,true,false},
		bounds = { 
			{nil,nil},
			{nil,nil},
			{-1,1},
		},
		keys = {"time","variation","life"},
		strings = { 
			"Spin",
			"Spin Variation",
			"Spin Over Life",
		},
		values = { 
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,1),
		},
	},
	weight = {
		rt = {true,true,false},
		bounds = { 
			{nil,nil},
			{nil,nil},
			{-1,1},
		},
		keys = {"time","variation","life"},
		strings = { 
			"Weight",
			"Weight Variation",
			"Weight Over Life",
		},
		values = { 
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,0),
			articulator.new():AddPoint(0,1),
		},
	},
	life = {
		rt = {true,true},
		bounds = { 
			{0,nil},
			{0,nil},
		},
		focus = {
			{0,5},
			{-5,5},
		},
		keys = {"time","variation"},
		strings = { 
			"Life",
			"Life Variation",
		},
		values = { 
			articulator.new():AddPoint(0,2),
			articulator.new():AddPoint(0,0),
		},
	},
	number = {
		rt = {true,true},
		bounds = { 
			{0,nil},
			{0,nil},
		},
		focus = {
			{0,5000},
			{0,100},
		},
		keys = {"time","variation"},
		strings = { 
			"Number",
			"Number Variation",
		},
		values = { 
			articulator.new():AddPoint(0,20),
			articulator.new():AddPoint(0,0),
		},
	},
}
end