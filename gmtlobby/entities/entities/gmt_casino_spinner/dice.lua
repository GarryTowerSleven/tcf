--[[ --------------------------------------------------------------------------------------
		dice.lua
		Description:
			A collection of functions for rolling and analysing pools of dice with an
			arbitrary number of sides on each die.
			Die pools are lists (tables) of the number of sides on each die. Dice are
			assumed to have consecutive valued faces from 1 to the number of sides.
			i.e. { n1, n2, n3, ..., ni } where ni is the number of sides on the
			corresponding die.
		Author:
			Falcqn
	 ----------------------------------------------------------------------------------- ]]

module( "dice", package.seeall )

--[[
	dice.roll
	Rolls a pool of dice returning the sum and result of each die.
	e.g: dice.roll( { 6, 6 } ) would roll two six-sided dice.
]]

function roll( pool )

	local total = 0
	local results = {}

	local x
	-- For each die in the pool..
	for _, v in pairs( pool ) do
		x = math.random( 1, v )		-- roll the die
		table.insert( results, x )	-- insert to results table
		total = total + x			-- add result to total
	end

	return results

end

--[[
	dice.minMax
	Returns the minimum, maximum, and average results of a die pool.
	e.g: dice.roll( { 10, 20 } ) would return min=2, max=30, avg=16
]]
function minMax( pool )

	if #pool == 0 then return end

	-- The lowest face on each die is a 1, so the minimum is the number of dice
	local min = #pool

	-- Running totals
	local avg = 0
	local max = 0

	-- For each die..
	for _, v in pairs( pool ) do
		-- Increase the max by the highest face value
		max = max + v
		-- Increase the average by the mean value of the die
		avg = avg + ( 1 + v ) / 2
	end

	return min, max, avg

end

--[[
	recurse
	!! Internal function, do not call !!
	Use dice.stats to get frequency distributions.
]]
local function recurse( pool, iterator, total, results )

	-- if end of list reached
	if iterator > #pool then
		results[ total ] = ( results[ total ] or 0 ) + 1 -- add 1 to frequency of running total
	-- otherwise,
	else
		-- for each face on current die,
		for i = 1, pool[ iterator ] do
			-- recursively sum each face on each following die
			recurse( pool, iterator + 1, total + i, results )
		end

	end
end

--[[
	dice.stats
	Recursively analyses a pool of dice to find each possible result and the number of combinations
	that lead to each result.
	Passing a 'true' value to the second parameter normalises the distribution such that its area is unitary.
	Returns a table where the keys are the possible results and the values are the frequencies.

	e.g. dice.stats( { 6, 6 } [,false] ) would return:
	key 	value
	-------------
	2       1
	3       2
	4       3
	5       4
	6       5
	7       6
	8       5
	9       4
	10      3
	11      2
	12      1
]]

function stats( pool, normalise )

	if #pool == 0 then return end
	local results = {}
	recurse( pool, 1, 0, results )

	if normalise then
		local combinations = 1
		for _, v in pairs( pool ) do
			combinations = combinations * v
		end

		for k, v in pairs( results  ) do
			results[ k ] = v / combinations
		end
	end

	return results

end
