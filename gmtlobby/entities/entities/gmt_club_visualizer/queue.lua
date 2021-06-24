
-----------------------------------------------------
-- Basic queue data structure 
-- Push from top, pop from buttom 
-- Technically this will keep increasing the keys until overflow, but that won't be for a while
-- A while as in 200 years at a million operations a second
local QUEUE = {}
QUEUE.__index = QUEUE

-- Push the value into the queue
function QUEUE:Push( val )
	self.Count = self.Count + 1

	local last = self.Last + 1 
	self.Last = last 
	self[last] = val
end

-- Pop the next value from the queue
-- This is the value at the bottom of the stack, not the top
function QUEUE:Pop()
	local first = self.First 
	if first > self.Last then error("Queue is empty") end

	self.Count = self.Count - 1

	local val = self[first]
	self[first] = nil 
	self.First = self.First + 1

	return val
end

-- Sets the value at a specified index
-- This converts it from sane table index values to our little setup
function QUEUE:Set( idx, val )
	if idx < 1 or idx > self.Last - self.First + 1 then error("Index out of range") end
	self[self.First + idx - 1] = val
end

-- Return the value at a specified index
-- This converts it from sane table index values to our little setup
function QUEUE:Get(idx)
	if idx < 1 or idx > self.Last - self.First + 1 then error("Index out of range") end

	return self[self.First + idx - 1]
end

function QUEUE:__tostring()
	local str = "A queue of " .. self.Count
	for i=self.First, self.Last do 
		str = str .. "\n\t" .. self[i]
	end

	return str 
end


module("queue", package.seeall )

function create( tbl )
	tbl = tbl or {}
	tbl = setmetatable(tbl, QUEUE)

	tbl.Count = 0
	tbl.First = 0
	tbl.Last = -1
	
	return tbl
end
