
-----------------------------------------------------
module("panelos", package.seeall )



local IncludeList = {}

local ModuleFiles = file.FindDir( "GModTower/gamemode/loadables/condopanel/apps/*", "LUA" )

local List = {}

local AppRPCFactories = {}



for k,v in pairs(ModuleFiles or {}) do

	local f = string.sub(v,1,string.find(v,".lua")-1)

	--print("Added Panel App: " .. f)

	table.insert(IncludeList, f)

end



local function makeAppRPCFactory( appname )

	AppRPCFactories[appname] = exnet.NetworkedRPCFactory( "osApp_" .. appname, List[appname] )

end



function getAppRPCFactory( appname )

	return AppRPCFactories[appname]

end



function getApps()

	return List

end



APPBASE = {}

APPBASE.FRPC = {}



function APPBASE:Start()

	self.stopTime = nil

	self.buttons = nil

	self.confirmation = nil

end

function APPBASE:Think() end

function APPBASE:Draw() end

function APPBASE:DrawButtons() -- So we can sort the call

	if self.buttons then

		for _, btn in pairs( self.buttons ) do

			local isover = IsMouseOver( btn.x, btn.y, btn.w, btn.h )

			if self.confirmation then isover = false end

			btn:DoPaint( btn.x, btn.y, btn.w, btn.h, isover )

		end

	end

end

function APPBASE:DrawConfirmation() -- So we can sort the call



	if self.confirmation then

		surface.SetDrawColor( 0, 0, 0, 250 )

		surface.DrawRect( 0, 0, scrw, scrh )



		-- Labels

		DrawLabel( self.confirmation.label, 200, scrh/2 - 150, scrw-600, nil, Color( 255, 255, 255, 150 ) )



		-- Buttons

		for _, btn in pairs( self.confirmation.buttons ) do

			btn:DoPaint( btn.x, btn.y, btn.w, btn.h, IsMouseOver( btn.x, btn.y, btn.w, btn.h ) )

		end

	end



end

function APPBASE:DrawPreview() end

function APPBASE:End() self.stopTime = self.I:GetTime() end

function APPBASE:MouseEvent( ev, x, y )

	if ev == MOUSE_PRESS then



 		-- Normal buttons

		if self.buttons then

			for _, btn in pairs( self.buttons ) do



				local isover = IsMouseOver( btn.x, btn.y, btn.w, btn.h )

				if self.confirmation then isover = false end



				if isover then

					if not btn.NextPress or btn.NextPress < CurTime() then

						btn.NextPress = CurTime() + .25

						btn:OnPressed()

					end

				end



			end

		end

 		-- Confirmation buttons

		if self.confirmation and self.confirmation.buttons then

			for _, btn in pairs( self.confirmation.buttons ) do



				local isover = IsMouseOver( btn.x, btn.y, btn.w, btn.h )



				if isover then

					if not btn.NextPress or btn.NextPress < CurTime() then

						btn.NextPress = CurTime() + .25

						btn:OnPressed()

					end

				end



			end

		end



	end

	if ev == MOUSE_ENTER then self:OnFocus() end

	if ev == MOUSE_LEAVE then self:OnLostFocus() end

end

function APPBASE:OnFocus() end

function APPBASE:OnLostFocus() end

function APPBASE:GetTime() return self.stopTime or self.I:GetTime() end

function APPBASE:GetEntity() return self.E end

function APPBASE:NetLaunch(app, force)

	--print("CALL NET LAUNCH: " .. tostring(app) .. " : " .. tostring(force))

	self.I:Launch(app, force)

end

function APPBASE:Launch(app, force)

	self:Repl3("NetLaunch", app, force)

end

function APPBASE:CreateButton( name, x, y, w, h, paint, pressed )



	if not self.buttons then

		self.buttons = {}

	end



	local btn = {

		x = x or 0,

		y = y or 0,

		w = w or 1,

		h = h or 1,

		originx = x or 0,

		originy = y or 0,

		Name = name,

		DoPaint = paint,

		OnPressed = pressed

	}



	self.buttons[name] = btn



end

function APPBASE:CreateConfirmation( label, func_accept, func_deny )



	self.confirmation = {}

	self.confirmation.buttons = {}

	self.confirmation.label = label



	local iconSize = 64

	local spacing = 6



	local w, h = 250, iconSize + (spacing*2)

	local y = scrh/2 - h + 50

	local x = scrw/2 - w - 10



	local function CreateConfirmationButton( name, x, y, w, h, paint, pressed )

		local btn = {

			x = x or 0,

			y = y or 0,

			w = w or 1,

			h = h or 1,

			originx = x or 0,

			originy = y or 0,

			Name = name,

			DoPaint = paint,

			OnPressed = pressed

		}

		self.confirmation.buttons[name] = btn

	end



	-- Accept

	CreateConfirmationButton( "accept", x, y, w, h,

		function( btn, x, y, w, h, isover ) -- draw

			DrawButtonTab( "YES", Icons["accept"], iconSize, x, y, w, h, isover, nil, nil, nil, Color( 0, 255, 0, 200 ) )

		end,

		function( btn ) -- onclick

			if func_accept then func_accept() end

			self:Repl("_ClearConfirmation")

		end

	)



	-- Decline

	x = scrw/2 + 10

	CreateConfirmationButton( "decline", x, y, w, h,

		function( btn, x, y, w, h, isover ) -- draw

			DrawButtonTab( "NO", Icons["cancel"], iconSize, x, y, w, h, isover, nil, nil, nil, Color( 255, 0, 0, 200 ) )

		end,

		function( btn ) -- onclick

			if func_deny then func_deny() end

			self:Repl("_ClearConfirmation")

		end

	)



end

function APPBASE:_ClearConfirmation()

	self.confirmation = nil

end



--Call on self and other clients and on server

function APPBASE:Repl3(func, ...)

	if type(func) == "number" then func = self.RPC:__lookup(func) end



	if CLIENT then

		self.RPC.Repl3(self.RPC:__lookup(func), unpack({...}))

		self[func](self, unpack({...}))

	else

		self[func](self, unpack({...}))

		self:Repl(func, unpack({...}))

	end

end



--Only call on other clients

function APPBASE:Repl2(func, ...)

	if CLIENT then

		self.RPC.Repl(self.RPC:__lookup(func), ...)

	end

end



--Call on self and other clients

function APPBASE:Repl(func, ...)

	if type(func) == "number" then func = self.RPC:__lookup(func) end



	if CLIENT then

		self.RPC.Repl(self.RPC:__lookup(func), ...)

		self[func](self, ...)

	else

		local targets = {}



		--MAC: Here's where you set it up to target players in the current suite only



		for k,v in pairs(player.GetAll()) do

			if v ~= _G.RCVPLY then --don't loop back to sender

				table.insert(targets, v)

			end

		end



		--print("SV_REPL: " .. tostring(func) .. " : " .. tostring(self.Name) .. " : " .. tostring(targets[1]))

		self.RPC[targets][func](...)

	end

	--return self.RPC

end



function registerApp( name, tbl )



	local List = getApps()



	tbl.Name = name

	tbl.ID = table.Count( List )



	if tbl.FRPC then

		tbl.FRPC = table.Inherit(tbl.FRPC, APPBASE.FRPC)

	end



	List[ tbl.Name ] = table.Inherit(tbl, APPBASE)

	--tbl.__index = tbl



	makeAppRPCFactory( name )



	--[[for k,v in pairs(tbl) do

		if type(v) == "function" then

			setfenv(v, getfenv())

		end

	end]]



	--print((SERVER and "SERVER: " or "CLIENT: ") .. "REGISTER APP: " .. name)



end



function getAppID( name )



	local List = getApps()

	local app = List[name]



	if not app then return 0 end



	return app.ID



end



function getAppName( id )



	local List = getApps()



	for _, app in pairs( List ) do



		if app.ID == id then

			return app.Name

		end



	end



end



for _, v in pairs( IncludeList ) do



	if SERVER then

		AddCSLuaFile("apps/" .. v .. ".lua" )

	end



	_G.APP = {}

	include("apps/" .. v .. ".lua" )

	panelos.registerApp(v, APP)

	_G.APP = nil



end



local DeadApp = {NiceName = "Error Occurred"}

function DeadApp:Start() if CLIENT then self.E:Sound(Sounds["error"]) end end

function DeadApp:SetMsg(msg) self.msg = msg end

function DeadApp:SetTrace(trace) self.trace = trace end

function DeadApp:Draw()

	local s1 = draw.GetTextSize( self.msg or "Panel Crashed", "AppBarSmall" )

	local final = self.trace or ""

	local s2 = draw.GetTextSize( final, "AppBarLabelSmall" )

	local lastSpace = 0

	for i = 1, #final do // word wrap

		local sub, char = string.sub( final, 1, i ), string.sub( final, i, i )

		if char == " " then

			lastSpace = i

		end

		local size = draw.GetTextSize( sub, "AppBarLabelSmall" )

		if size.w > scrw - 20 then

			final = string.sub( final, 1, ( lastSpace == 0 and i or lastSpace ) - 1 ) .. ( lastSpace == 0 and "-" or "" ) .. "\n" .. string.sub( final, ( lastSpace == 0 and i or lastSpace + 1 ) )

		end

	end

	draw.DrawText(self.msg or "Panel Crashed", "AppBarSmall", scrw/2, scrh/2 - ( self.trace and s1.h + s2.h or s1.h ) / 2, Color(255,100,100), TEXT_ALIGN_CENTER)

	if self.trace then

		draw.DrawText( final, "AppBarLabelSmall", scrw/2, scrh / 2 + ( s1.h + s2.h ) / -2 + s1.h, Color( 255, 100, 100 ), TEXT_ALIGN_CENTER )

	end



end



panelos.registerApp("dead", DeadApp)



--Refresh apps on entities

for k,v in pairs(ents.FindByClass("gmt_condo_panel")) do

	if v.instance then

		v.instance.__apps = getApps()

		v.instance:Refresh()

		v.instance:Launch("homescreen", true)

	end

end
