if _G.__SURFACE_HOOKED then return end --Only Once

print("HOOK SURFACE")

local Color = Color
local type = type
local _G = _G

module( "surface" )

local _SetDrawColor = SetDrawColor
local _LastDrawColor = Color(0,0,0)

function SetDrawColor(r,g,b,a)

	if type(r) == "table" and r.r and r.g and r.b then
		_LastDrawColor.r = r.r
		_LastDrawColor.g = r.g
		_LastDrawColor.b = r.b
		_LastDrawColor.a = r.a or 255
	else
		_LastDrawColor.r = r
		_LastDrawColor.g = g
		_LastDrawColor.b = b
		_LastDrawColor.a = a or 255
	end

	_SetDrawColor(r,g,b,a)

end

function GetDrawColor()
	return _LastDrawColor
end

_G.__SURFACE_HOOKED = true