module( "serialize", package.seeall )

local function ProcessToSerialize( data )

	if type(data) == "string" then
		data = string.gsub(data, "\"", "'")
		data = "\"" .. data .. "\""
		return data
	end

	--if isvector(data) then
		--return "(" .. data.x .. " " .. data.y .. ")"
	--end

	if type(data) == "table" then
		local str = ""
		for k,v in pairs(data) do
			str = str .. ProcessToSerialize( v ) .. ", "
		end
		if str ~= "" then
			str = string.sub(str, 0, -3)
		end
		return str
	end

	return tostring( data )

end

local function ProcessToDeSerialize( str )

	--Check for string
	for part in string.gmatch(str, "%b\"\"") do
		local v = string.sub(part, 2, string.len(part) - 1)
		return v
	end

	--Check for array
	if string.find(str, ",") then
		local t = {}
		for part in string.gmatch(str, "[^,]+") do
			table.insert(t, ProcessToDeSerialize( part ))
		end
		return t
	end

	--Check for vector
	--[[for part in string.gmatch(str, "%b()") do
		local v = string.sub(part, 2, string.len(part) - 1)
		return Vec2( v )
	end]]

	--Check for number
	for part in string.gmatch(str, "[%-*%d*.*%d*]+") do
		return tonumber( part )
	end

	return nil

end

function ToString( tab )
	local str = ""

	for k,v in pairs(tab) do
		if v.class and v.values then

			str = str .. v.class .. " {\n"
			for i,j in pairs(v.values) do
				str = str .. "\t" .. i .. ":[" .. ProcessToSerialize( j ) .. "]\n"
			end
			str = str .. "}\n"

		end
	end

	return str
end

// print( ToString( { { class = "camera_flash", values = particle_params.GetDefault() } } ) )

function FromString( str, tab )
	for part in string.gmatch(str, "%w+ %b{}") do
		local class = string.gmatch(part, "%w+")()
		local body = string.sub(part, string.len(class) + 2)
		--print("Class: " .. class)
		--print("Body: " .. body)

		local values = {}

		for s in string.gmatch(part, "%w+:%b[]") do
			local fkey = ""
			local fval = ""

			for key in string.gmatch(s, "%w+:") do
				fkey = string.sub(key, 1, string.len(key)-1)
			end

			for value in string.gmatch(s, "%b[]") do
				fval = string.sub(value, 2, string.len(value)-1)
			end

			values[fkey] = ProcessToDeSerialize( fval )
			--print("KV: " .. fkey .. " = " .. tostring(values[fkey]) .. "[" .. type(values[fkey]) .. "]")

		end

		FromString( body, values )

		table.insert( tab, {class = class, values = values})
	end

	return true
end

function printTable(t, s)

	s = s or 0

	local tab = string.rep("\t", s)

	for k,v in pairs(t) do

		if type(v) == "table" then
			if v.__tostring then
				print(tab .. k .. " = " .. tostring( v ))
			else
				print(tab .. k .. " = {")
				printTable(v, s + 1)
				print(tab .. "}")
			end
		else
			print(tab .. k .. " = " .. tostring(v))
		end

	end

end