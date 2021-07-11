
-----------------------------------------------------
--print("NET RPC " .. (SERVER and "SERVER" or "CLIENT"))

module("exnet", package.seeall)

local RPC = {}

RPC_DEBUG = false

local function dummyCall(self, func, args)
	if args[1] == self then table.remove(args, 1) end

	if type(func) ~= "string" then return end

	local mcall = self:__lookup( func )
	if not mcall then
		ErrorNoHalt("RPC CALL: NOT FOUND: '" .. tostring(func) .. "'")
		--[[for k,v in pairs(self.metacalls) do
			print(k .. ": " .. tostring(v) .. "\n")
		end]]
		return
	end

	if #args > 7 then
		ErrorNoHalt("RPC CALL: TOO MANY ARGUMENTS (max 7)\n")
	end

	if RPC_DEBUG then print("RPC CALL: " .. tostring(self) .. " : " .. tostring(func) .. "[" .. mcall .. "] : " .. #args .. " args.") end
	for k,v in pairs(args) do
		if RPC_DEBUG then print("\targs[" .. k .. "] = " .. tostring(v)) end
	end

	table.insert( self.pending_calls, { func = func, mcall = mcall, args = args } )

	if self.onCall then
		self.onCall()
	end
end

RPC.__index = function(self, k)
	local v = rawget(self, k)
	if v then return v end
	if RPC[k] then return RPC[k] end

	return function(...)

		if self.role then
			return dummyCall(self, k, {...})
		end

	end
end

function RPC:__init( tab, role, onCall )
	self.role = role
	self.calltable = tab
	self.metacalls = getmetatable(self.calltable)
	self.fastcalls = self.metacalls.FRPC
	self.pending_calls = {}
	self.rpc_lookup0 = {}
	self.rpc_lookup1 = {}
	self.onCall = onCall

	local i = 1

	if self.role then

		if RPC_DEBUG then print(tostring(tab) .. ":\n") end
		local sortCalls = {}
		for k,v in pairs(self.metacalls) do
			if type(v) == "function" and k ~= "__index" then
				table.insert(sortCalls, k)
			end
		end

		table.sort(sortCalls, function(a,b) return a<b end)

		for k,v in pairs(sortCalls) do
			self.rpc_lookup0[v] = i - 1
			self.rpc_lookup1[i] = v
			i = i + 1

			if RPC_DEBUG then print("\t" .. v .. " : " .. (i-1)) end
		end

	end

	return self
end

function RPC:__lookup( v )
	if type(v) == "number" then
		return self.rpc_lookup1[v+1]
	elseif type(v) == "string" then
		return self.rpc_lookup0[v]
	end
end

function RPC:Post()
	local n_calls = #self.pending_calls
	if n_calls > 15 then n_calls = 15 ErrorNoHalt("RPC Call Overflow!") end
	--net.WriteUInt(n_calls, 4)

	--if RPC_DEBUG then print("RPC POST: " .. n_calls .. " calls") end

	--for i=1, 15 do

	local t = self.pending_calls[1]
	if not t then return end

	net.WriteUInt(t.mcall, 7) --TODO optimize

	--print("POST CALL: " .. self:__lookup(t.mcall) .. "\n")

	local fastcall = self.fastcalls[t.func]

	if not fastcall then
		net.WriteUInt(#t.args, 3)

		for k,v in pairs(t.args) do
			local vtype = exnet.TypeOf(v)
			--if RPC_DEBUG then print("DEFER TYPE: " .. tostring(v) .. " = " .. vtype) end
			net.WriteUInt(vtype, 4)
			exnet.DefWriteValue(vtype, v)
		end
	else
		for k,v in pairs(t.args) do
			local carg = fastcall[k]
			if carg then

				exnet.DefWriteValue(carg, v)

			end
		end
	end

	table.remove(self.pending_calls, 1)
	--end
end

function RPC:Receive(...)
	local n_calls = 1 --net.ReadUInt(4)
	local args = {}

	--if RPC_DEBUG then print("RPC GOT: " .. n_calls .. " calls") end

	for i=1, n_calls do
		local mcall = net.ReadUInt(7) --TODO optimize
		local fname = self:__lookup(mcall)

		local fastcall = self.fastcalls[fname]

		for k,v in pairs({...}) do
			table.insert(args, v)
		end

		if not fastcall then
			local n_args = net.ReadUInt(3)
			for j=1, n_args do
				local vtype = net.ReadUInt(4)
				table.insert(args, exnet.DefReadValue(vtype))
			end
		else
			if RPC_DEBUG then print("---FAST CALL---") end
			for i=1, #fastcall do
				table.insert(args, exnet.DefReadValue(fastcall[i]))
			end
		end

		
		if RPC_DEBUG then print("CALL: " .. fname .. " : " .. tostring(self.metacalls[fname])) end
		local b,e = pcall(self.metacalls[fname], self.calltable, unpack(args))
		if not b then
			ErrorNoHalt("RPC_ERROR: " .. e)
			--[[for k,v in pairs(getmetatable(self.calltable)) do
				print(k .. ": " .. tostring(v) .. "\n")
			end]]
		end
		args = {}
	end
end

function CreateRPCTable( tab, role, onCall )
	return setmetatable( {}, RPC ):__init( tab, role, onCall )
end