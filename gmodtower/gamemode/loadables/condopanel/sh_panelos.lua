
-----------------------------------------------------
module("panelos", package.seeall )



MOUSE_PRESS = 1

MOUSE_RELEASE = 2

MOUSE_MOVE = 3

MOUSE_ENTER = 4

MOUSE_LEAVE = 5



local launchedApp = nil

local IMeta = {}

IMeta.__index = IMeta



function createOSInstance(ent)

	return setmetatable({ent = ent}, IMeta):Init()

end



function IMeta:Init()

	self.__app = nil

	self.__prevapp = nil

	self.__apptime = 0

	self.__apps = getApps()



	self:Refresh()



	return self

end



function IMeta:Refresh()

	self.__myapps = {}



	--print("APP REFRESH ON ENTITY: " .. tostring(self.ent:EntIndex()))



	for k,v in pairs(self.__apps) do

		self.__myapps[k] = getAppRPCFactory( k ):Create(self.ent:EntIndex()) --setmetatable({}, v)

		self.__myapps[k].BaseClass = v.BaseClass



		--print("AppINIT[" .. k .. "]: " .. tostring(self.__myapps[k]) .. "[" .. self.ent:EntIndex() .. "]")

		--self.__myapps[k].__rpc = getAppRPCFactory( k ):Create(self.ent:EntIndex())



		local app = self.__myapps[k]



		--print("SET ENV:\n")



		if SERVER then

			app.RPC = app.client

		else

			app.RPC = app.server

		end



		app.I = self -- The meta table

		app.P = SERVER and self.ent:GetOwner() or LocalPlayer() -- The player or owner

		app.E = self.ent -- The entity

		app.C = function() -- The condo

			return IsValid( self.ent ) and self.ent:GetCondo()

		end

		app.R = function() -- The condo's networking

			if not IsValid( self.ent ) then return end

			local condo = self.ent:GetCondo()

			if condo and condo.RefEnt then

				return condo.RefEnt

			end

		end



		--print("initialize: " .. tostring(k))

		self:AppCall(app, "Init")

		--[[for i,j in pairs(getmetatable(app)) do

			if type(j) == "function" then

				print("SETENV[" .. k .. "]:" .. i)

				local env = getfenv(app[i])

				if SERVER then

					env.RPC = app.client

				else

					env.RPC = app.server

				end

			end

		end]]

	end

end



function IMeta:OnAppCrash(name, func, err, ent, trace)

	if name ~= "dead" then

		self.__prevapp = nil

		self.__app = nil

		self:Launch("dead", true)

		self:AppCall(self.__app, "SetMsg", string.format("App 'com.android.%s' has died", name ) )

		self:AppCall(self.__app, "SetTrace", err .. "\n" .. "Trace:\n" .. trace )

	end

end



function IMeta:AppCall(app, func, ...)

	if not app then return false end

	if not app[func] then return false end



	local env = getfenv(app[func])

	for i,j in pairs(_G["panelos"]) do

		env[i] = j

	end



	local ply = _G.RCVPLY

	_G.RCVPLY = nil



	local die = false

	local arg = {...}

	if ply then table.insert(arg, ply) end

	xpcall(app[func], function(err)

		local name = tostring(app.Name)

		local ent = tostring(self.ent)

		local func = tostring(func)



		MsgC(Color(255,100,100), "CRASH[" .. name .. "]" .. ent .. "::(" .. func .. ")\n" .. err)



		//err = "Line " .. string.sub(err, string.find(err, ":")+1, string.len(err))



		local trace = "Error: could not obtain trace"

		local stack = {}

		local Level = 1

		while true do



			local info = debug.getinfo( Level + 1, "Sln" )

			if !info then break end

			if info.what == "C" then

				table.insert( stack, string.format( "%i. C function", Level ) )

			else

				local new = string.format( "%i. Line %d: \"%s\"  %s", Level, info.currentline, info.name or "unknown", info.short_src )

				table.insert( stack, new )

			end

			Level = Level + 1



		end



		for i = #stack, 1, -1 do // these loops filter out unneeded trace entries; anything after the last entry containing the app name is considered unneeded



			if string.find( stack[i], tostring( app.Name ) ) then



				for i2 = i + 1, #stack do



					stack[i2] = nil



				end

				break



			end



		end



		trace = table.concat( stack, "\n" )



		if app.Name then

			local path = "(gamemodes/gmodtower/gamemode/loadables/condopanel/apps/" .. app.Name .. ".lua)"

			trace = string.gsub( trace, path, "com.android." .. app.Name )

			err = string.gsub( err, path, "com.android." .. app.Name )

			self:OnAppCrash(name, func, err, ent, trace)

		end

		die = true

	end, app, unpack(arg))



	return !die

end



function IMeta:Launch( name, force )



	--print("LAUNCH: " .. name)



	if (self.__app and self.__app.Name == name) and force ~= true then return end



	self.__prevapp = self.__app



	local app = self.__myapps[name]

	if app then

		self.__app = app



		self:AppCall(self.__prevapp, "End")

		self.__apptime = CurTime()

		self:AppCall(self.__app, "Start")



		return

	end



	ErrorNoHalt("Unable to launch app: " .. name)



end



function IMeta:GetTime()

	return CurTime() - self.__apptime

end



function IMeta:Current(nice)

	if nice then return self.__app and (self.__app.NiceName or self.__app.Name) or "" end

	return self.__app and self.__app.Name or ""

end



function IMeta:App()

	return self.__app

end



function IMeta:CurrentIcon()

	return self.__app and self.__app.Icon or ""

end



function IMeta:Think()

	self:AppCall(self.__app, "Think")

end



function IMeta:DrawGUI(prev)

	self:AppCall(prev and self.__prevapp or self.__app, "Draw")

end



function IMeta:DrawPreviewGUI(prev)

	local appsubfunc = self:AppCall(prev and self.__prevapp or self.__app, "DrawPreview")

	if not appsubfunc then

		self:DrawGUI(prev)

	end

end



function IMeta:MouseEvent(ev, x, y)


	-- Don't let non room owners be able to click

	if ev == MOUSE_PRESS then

		local room = self.ent:GetNWInt("condoID")--self.ent:GetCondoID()

		if not room or not GtowerRooms:CanManagePanel(room,LocalPlayer()) then

			return

		end

	end



	self:AppCall(self.__app, "MouseEvent", ev, x, y)

end
