
-----------------------------------------------------
--print("NET UTIL " .. (SERVER and "SERVER" or "CLIENT"))

module("exnet", package.seeall)

local NMETA = {}
NMETA.__index = NMETA

function NMETA:__init(base, networkString)
	self.nextIndex = 1
	self.spawn = base
	self.netstring = networkString
	self.instances = {}
end

function NMETA:Create(index, ...)
	local out = setmetatable({}, self.spawn)

	out.__instanceIndex = index
	out.__factory = self

	if out.__init then out:__init(unpack({...})) end

	self.instances[index] = out

	return out
end

function NMETA:__send(instance, players)
	if instance.__instanceIndex then
		--print("NET_FACTORYSEND: " .. instance.__instanceIndex)

		net.Start(self.netstring)
		net.WriteUInt(instance.__instanceIndex, 32)

		if instance.__send then instance:__send() end

		if SERVER then
			if isvector(players) then
				--print("SEND IN PVS")
				net.SendPVS(players)
			else
				if not players then
					--print("SEND BROADCAST")
					net.Broadcast()
				else 
					--print("SEND TO PLAYERS")
					net.Send(players)
				end
			end
		else
			net.SendToServer()
		end
	end
end

function NMETA:__recv(pl)
	local index = net.ReadUInt(32)
	local tab = self.instances[index]
	if tab and tab.__recv then
		--print("NET_FACTORYRECV: " .. index)
		tab:__recv(pl)
	end
end

function NetworkedTableFactory( networkString, base )
	if SERVER then util.AddNetworkString( networkString ) end

	local netObject = setmetatable({}, NMETA)
	netObject:__init(base, networkString)

	if SERVER then
		net.Receive( networkString, function(len, pl)
			--print("SV_NETTABLE_RECV: " .. networkString)
			netObject:__recv(pl)
		end)
	else
		net.Receive( networkString, function(len)
			--print("CL_NETTABLE_RECV: " .. networkString)
			netObject:__recv()
		end)
	end

	return netObject
end

function NetworkedRPCFactory( networkString, rpcFunctions )

	local CL_Selector = {}
	local RPC_Table = {}

	table.Inherit(RPC_Table, rpcFunctions)

	--[[print("Make RPC Factory[" .. networkString .. "]:\n")
	for k,v in pairs(rpcFunctions) do
		if type(v) == "function" then print("\t" .. tostring(k)) end
	end]]

	CL_Selector.__index = function(self, k)
		local parent = rawget(self, "parent")
		local client = rawget(parent, "__client")
		if type(k) == "string" then return client[k] end 
		if type(k) == "number" then rawset(parent, "__selectorTarget", player.GetAll()[k]) end
		if IsEntity(k) and k:IsPlayer() then rawset(parent, "__selectorTarget", k) end
		if isvector(k) then rawset(parent, "__selectorTarget", k) end
		if type(k) == "table" then rawset(parent, "__selectorTarget", k) end
		return client
	end

	RPC_Table.__index = function(self, k)

		if k == "client" then
			--print("USE SELECTOR")
			rawset(self, "__selectorTarget", nil)
			return rawget(self, "__selector")
		end

		if k == "server" then
			return rawget(self, "__server")
		end

		local t = rawget(self, k)
		if not t then return rawget(RPC_Table, k) end

		return t
	end

	function RPC_Table:__init()
		--if self.BaseClass.Init then self.BaseClass.Init(self) end

		self.__selectorTarget = nil
		self.__selector = setmetatable({}, CL_Selector)
		self.__selector.parent = self
		self.__server = exnet.CreateRPCTable( self, CLIENT, function() self.__factory:__send(self) end )
		self.__client = exnet.CreateRPCTable( self, SERVER, function() self.__factory:__send(self, self.__selectorTarget) end )
	end

	function RPC_Table:__send()
		local b,e = pcall(function()
			if SERVER then
				self.__client:Post()
			elseif CLIENT then
				self.__server:Post()
			end
		end)

		if not b then
			ErrorNoHalt(e)
		end
	end

	function RPC_Table:__recv(pl)
		_G.RCVPLY = pl

		if SERVER then
			self.__client:Receive()
		elseif CLIENT then
			self.__server:Receive()
		end

		_G.RCVPLY = nil
	end

	return NetworkedTableFactory( networkString, RPC_Table )

end