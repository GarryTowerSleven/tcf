
local pairs = pairs
local ipairs = ipairs
local math = math
local next = next

module("table")

--[[---------------------------------------------------------
    Name: tableUniqueValues( tbl )
    Desc: Removes any duplicate, non-unique values from a table and returns it.
-----------------------------------------------------------]]
function UniqueValues( tbl )

	local KeysToRemove = {}

	for k, v in pairs( tbl ) do
		for k2, v2 in pairs( tbl ) do
			
			if k2 != k && v == v2 then
				insert( KeysToRemove, k2 )
			end
			
		end
	end
	
	for _, v in pairs( KeysToRemove ) do
		remove( tbl, v )
	end
	
	return tbl

end

--[[---------------------------------------------------------
    Name: table.RemoveValue( tbl, value )
    Desc: Removes a value from a table.
-----------------------------------------------------------]]
function RemoveValue( tbl, value ) 
	for k, v in pairs( tbl ) do
		if v == value then
			tbl[ k ] = nil
		end
	end
end

--[[---------------------------------------------------------
    Name: table.uinsert( tbl, value )
    Desc: Inserts a value that is unique. Returns nil if it's already in there.
-----------------------------------------------------------]]
function uinsert( tbl, value )

	if !HasValue( tbl, value ) then
		return insert( tbl, value )
	end
	return nil

end


--[[---------------------------------------------------------
    Name: table.walk( tbl, func )
    Desc: Preforms a function while transversing through a table.
-----------------------------------------------------------]]
function walk( tbl, func )
	for k, v in pairs( tbl ) do
		func( v, k )
	end
end

--[[---------------------------------------------------------
    Name: table.shuffle( tbl )
    Desc: Shuffles a table and returns that.
-----------------------------------------------------------]]
function shuffle( tbl )

 	local n = #tbl

	while n >= 2 do
  		-- n is now the last pertinent index
    	local k = math.random(n) -- 1 <= k <= n
    	-- Quick swap
 		tbl[n], tbl[k] = tbl[k], tbl[n]
		n = n - 1
	end

	return tbl

end

--[[---------------------------------------------------------
    Name: table.circular( tbl, start )
    Desc: Preforms a circular loop around a table from the starting index.
    Usage: for v in table.circular( tbl, 1 ) do
-----------------------------------------------------------]]
function circular( tbl, start )

	local n = start

	return function(_, v)
		if v == nil and tbl[start] == nil then return end
		if n == start and v ~= nil then return end
		v = tbl[n] 
		n = next(tbl, n)
		if tbl[n] == nil then n = next(tbl, nil) end
		return v
	end

end

--[[---------------------------------------------------------
    Name: table.circular_skip( tbl, start )
    Desc: Preforms a circular loop around a table from the starting index, 
    	  but skips the starting index.
    Usage: for v in table.circular_skip( tbl, 1 ) do
-----------------------------------------------------------]]
function circular_skip( tbl, start )

	local n = start

	return function(_, v)
		if v == nil and tbl[start] == nil then return end
		n = next(tbl, n)
		if tbl[n] == nil then n = next(tbl, nil) end
		if n == start then return end
		return tbl[n], n
	end

end