
-----------------------------------------------------
module( "stringmod", package.seeall )



function IReplace(str, tofind, toreplace)

	local start = 1

	while (true) do

		local pos = string.find(string.lower(str), tofind, start, true)



		if (pos == nil) then

			break

		end



		local left = string.sub(str, 1, pos-1)

		local right = string.sub(str, pos + #tofind)



		str = left .. toreplace .. right

		start = pos + #toreplace

	end

	return str

end


function stringmod.SafeChatName( name )

	-- Escapes all big quotes from player names
	local escaped1 = string.gsub( name, [["]], [[\"]] )

	-- Gets the result and escapes all single quotes from that
	local escaped2 = string.gsub( escaped1, [[']], [[\']] )

	return escaped2
end

function FormattedTime( TimeInSeconds, Format )



	if not TimeInSeconds then TimeInSeconds = 0 end



	local i = math.floor( TimeInSeconds )



	local h,m,s,ms = math.Clamp( math.floor( i/3600 ), 0, 59 ),

					 math.Clamp( math.floor( i/60 ) % 60, 0, 59 ), //Garry can't do math

					 math.Clamp( TimeInSeconds - ( math.floor( i/60 )*60 ), 0, 59 ),

					 math.Clamp( ( TimeInSeconds-i ) * 100, 0, 99 )



	if Format then

		return string.format( Format, m, s, ms )

	else

		return { h=h, m=m, s=s, ms=ms }

	end



end



function FormatNumber( num )

	local formatted = num



	while true do

		formatted, k = string.gsub( formatted, "^(-?%d+)(%d%d%d)", '%1,%2' )

		if ( k == 0 ) then

			break

		end

	end



	return formatted

end



function FormatSeconds(sec)



	sec = math.Round(sec)



	local hours = math.floor(sec / 3600)

	local minutes = math.floor((sec % 3600) / 60)

	local seconds = sec % 60



	if minutes < 10 then

		minutes = "0" .. tostring(minutes)

	end



	if seconds < 10 then

		seconds = "0" .. tostring(seconds)

	end



	if hours > 0 then

		return string.format("%s:%s:%s", hours, minutes, seconds)

	else

		return string.format("%s:%s", minutes, seconds)

	end



end



function Uppercase( str )

	return string.lower(str):gsub("^%l", string.upper)

end



function NiceTime( seconds )



	if ( seconds == nil ) then return "a few seconds" end



	if ( seconds < 60 ) then

		local sec = math.floor( seconds )

		if sec > 1 then

			return sec .. " seconds"

		else

			return sec .. " second"

		end

	end



	if ( seconds < 60 * 60 ) then

		local min = math.floor( seconds / 60 )

		if min > 1 then

			return min .. " minutes"

		else

			return min .. " minute"

		end

	end



	if ( seconds < 60 * 60 * 24 ) then

		local hour = math.floor( seconds / (60 * 60) )

		if hour > 1 then

			return hour .. " hours"

		else

			return hour .. " hour"

		end

	end



	if ( seconds < 60 * 60 * 24 ) then

		return math.floor( seconds / (60 * 60 * 24) ) .. " days";

	end



	return "ages"



end



function NiceTimeShort( seconds, format )



	seconds = tonumber( seconds )



	local minsLeft = math.floor( seconds / 60 )

	local secsLeft = math.floor( seconds % 60 )



	local str = ""



	// Min

	str = str .. minsLeft



	if format then str = str .. "<color=ltgrey>" end

	str = str .. " " .. Pluralize( "min", minsLeft )

	if format then str = str .. "</color>" end



	// Space

	str = str .. " "



	// Secs

	str = str .. secsLeft



	if format then str = str .. "<color=ltgrey>" end

	str = str .. " " .. Pluralize( "sec", secsLeft )

	if format then str = str .. "</color>" end



	return str



end



function hash( str )



	local bytes = {string.byte( str, 0, string.len( str ) )}

	local hash = 0



	//0x07FFFFFF

	//It is a sequrence of 31 "1".

	//If it was a sequence of 32 "1", it would not be able to send over network as a positive number

	//Now it must be 27 "1", because DTVarInt hates 31... Do not ask why...

	for _, v in ipairs( bytes ) do

		hash = math.fmod( v + ((hash*32) - hash ), 0x07FFFFFF )

	end



	return hash



end



function reduce( str, font, width )



	surface.SetFont( font )



	local tw, th = surface.GetTextSize(str)

	while tw > width do

		str = string.sub( str, 1, string.len(str) - 1 )

		tw, th = surface.GetTextSize(str)

	end



	return str



end



function findFromTable( str, tbl )



	for _, v in pairs( tbl ) do

		if string.find( str, v ) then

			return true

		end

	end



	return false



end



function Pluralize( str, num )



	if num > 1 then

		str = str .. "s"

	end



	return str



end



function join( str, ... )

	local tab = {}

	local args = {...}

	for k, v in pairs(args) do

		table.insert( tab, v )

		if k ~= #args then

			table.insert( tab, str )

		end

	end

	return table.concat(tab)

end



function NumberToNth( num, nonum )



	local x = num > 4 and 4 or num

	if nonum then

		return string.sub("stndrdth", x*2 - 1, x*2)

	else

		return num .. string.sub("stndrdth", x*2 - 1, x*2)

	end



end



local UTF8SubLastCharPattern = "[^\128-\191][\128-\191]*$"

local OverflowString = "..." -- ellipsis



---

-- Limits a rendered string's width based on a maximum width.

--

-- @param text		Text string.

-- @param font		Font.

-- @param w			Maximum width.

-- @return String	String fitting the maximum required width.

--

function RestrictStringWidth( text, font, w )



	-- TODO: Cache this



	surface.SetFont( font )

	local curwidth = surface.GetTextSize( text )

	local overflow = false



	-- Reduce text by one character until it fits

	while curwidth > w do



		-- Text has overflowed, append overflow string on return

		if not overflow then

			overflow = true

		end



		-- Cut off last character

		text = string.gsub(text, UTF8SubLastCharPattern, "")



		-- Check size again

		curwidth = surface.GetTextSize( text .. OverflowString )



	end



	return overflow and (text .. OverflowString) or text



end



local WriteBuffer = nil

local TableDepth = 0

local function write( str )

	WriteBuffer = WriteBuffer .. str

end



local WriteValue = nil

function WriteTable( tbl, keepbuffer )



	if not keepbuffer then

		WriteBuffer = ""

		TableDepth = -1

	end



	 write("{\n")



	for k,v in pairs(tbl) do



		for i=0,TableDepth do write("\t") end



		if(type(k) == "string") then



			local m = string.match(k,"^[A-Za-z_0-9]+$")

			--if(m) then print(k .. " | " .. m .. "\n") end

			if(m and m == k) then

				write("\t" .. k .. " = ")

			else

				write("\t[\"" .. k .. "\"] = ")

			end



		elseif(type(k) == "number") then



			write("\t[" .. k .. "] = ")



		end



		WriteValue( v )

		write(",\n")



	end



	for i=0,TableDepth do write("\t") end

	write("}")

	TableDepth = TableDepth - 1



	return WriteBuffer



end



WriteValue = function(v)



	local t = type(v)



	if(t == "table") then

		TableDepth = TableDepth + 1

		WriteTable(v, true)



	elseif(t == "Vector") then

		write("Vector(" .. v.x .. "," .. v.y .. "," .. v.z .. ")")



	elseif(t == "userdata") then



		if(IsVector(v)) then

			write("Vector(" .. v.x .. "," .. v.y .. "," .. v.z .. ")")

		end



	elseif(t == "string") then

		write("\"" .. tostring(v) .. "\"")



	elseif(t == "number") then

		write(tostring(v))



	else

		write("nil")

	end



end
