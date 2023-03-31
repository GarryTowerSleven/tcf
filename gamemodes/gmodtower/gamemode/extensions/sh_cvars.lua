local cvars = cvars
local AddChangeCallback = cvars.AddChangeCallback
local RunConsoleCommand = RunConsoleCommand

---
-- Creates an N-way data binding between N cvars.
--
-- @param Variable number of command names.
--
function cvars.Bind(...)

	local vars = {...}

	-- Binded value synced between all cvars
	local curvalue

	for _, a in pairs(vars) do
		for _, b in pairs(vars) do

			if a == b then continue end

			-- When CVar B changes...
			AddChangeCallback( b, function (name, old, new)
				if new == curvalue then return end
				curvalue = new

				-- ...update CVar A
				RunConsoleCommand( a, new )
			end )

		end
	end

end

---
-- Creates an 2-way data binding between cvars; accepts optional functions for
-- translating values between convars.
--
-- @param CVar name A
-- @param CVar name B
-- @param Optional translation function for A => B
-- @param Optional translation function for B => A
--
function cvars.TwoWayBind(a, b, translateA, translateB)

	-- Binded value synced between the two cvars
	local curvalue

	-- When CVar A changes...
	AddChangeCallback( a, function (name, old, new)
		if new == curvalue then return end
		curvalue = new

		-- ...update CVar B
		local value = translateA and translateA(new) or new
		RunConsoleCommand( b, value )
	end)

	-- When CVar B changes...
	AddChangeCallback( b, function (name, old, new)
		local value = translateB and translateB(new) or new
		if value == curvalue then return end
		curvalue = value

		-- ...update CVar A
		RunConsoleCommand( a, value )
	end)

end