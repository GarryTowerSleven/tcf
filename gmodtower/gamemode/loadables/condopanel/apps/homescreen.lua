
-----------------------------------------------------
--module("panelos", package.seeall )



--self: local storage on app

--I: local storage on panel / panel instance functions

--E: panel entity

--P: player



--TODO: use actual door entity to figure out lock state

--Example

--E:GetCondoDoor():IsLocked()

--E:GetCondoDoor():SetLocked()



--Fast RPC Calls, Do this if the argument types are known (less net traffic)

--[functionname] = {arg1type, arg2type, ...}

APP.FRPC = {

	["MouseThing"] = {DT_SHORT, DT_SHORT}

}


if CLIENT then

	surface.CreateFont( "AppBarLarge", {

	font		= "Clear Sans Medium",

	antialias	= true,

	weight		= 400,

	size = 80

} )

surface.CreateFont( "AppBarSmall", {

	font		= "Clear Sans Medium",

	antialias	= true,

	weight		= 400,

	size = 40

} )

surface.CreateFont( "AppBarLabel", {

	font		= "Clear Sans Medium",

	antialias	= true,

	weight		= 600,

	size = 32

} )

surface.CreateFont( "AppBarLabelSmall", {

	font		= "Clear Sans Medium",

	antialias	= true,

	weight		= 600,

	size = 24

} )


GradientDown = surface.GetTextureID( "VGUI/gradient_down" )

GradientUp = surface.GetTextureID( "VGUI/gradient_up" )

Cursor2D = surface.GetTextureID( "cursor/cursor_default" )



Backgrounds = {

	Material( "gmod_tower/panelos/backgrounds/background1.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background2.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background3.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background4.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background5.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background6.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background7.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background8.png", "unlitsmooth" ),

	Material( "gmod_tower/panelos/backgrounds/background9.png", "unlitsmooth" ),

}



--Icons = GTowerIcons.Icons


local path = "gmod_tower/panelos/icons/"

local function Create( png, filter, path_override )
	return Material( (path_override or path).. png, filter or "unlitsmooth" )
end

Icons = {
	["gmt"] = Create( "logo_flat.png", "unlitsmooth", "gmod_tower/hud/" ),
	["gmtsmall"] = Create( "gmt.png" ),
	["home"] = Create( "home.png" ),
	["back"] = Create( "back.png" ),
	["camera"] = Create( "video.png" ),
	["music"] = Create( "music.png" ),
	["options"] = Create( "settings.png" ),
	["lock"] = Create( "lock.png" ),
	["unlock"] = Create( "unlock.png" ),
	["alarm"] = Create( "alarms.png" ),
	["time"] = Create( "time.png" ),
	["backspace"] = Create( "backspace.png" ),
	["label"] = Create( "label.png" ),
	["about"] = Create( "about.png" ),
	["storage"] = Create( "storage.png" ),
	["skip"] = Create( "skip.png" ),
	["rewind"] = Create( "rewind.png" ),
	["pause"] = Create( "pause.png" ),
	["play"] = Create( "play.png" ),
	["shuffle"] = Create( "shuffle.png" ),
	["addqueue"] = Create( "addqueue.png" ),
	["images"] = Create( "images.png" ),
	["doorclose"] = Create( "door_closed.png" ),
	["dooropen"] = Create( "door_open.png" ),
	["condo"] = Create( "condo.png" ),
	["players"] = Create( "players.png" ),
	["controller"] = Create( "controller.png" ),
	["movies"] = Create( "movies.png" ),
	["beer"] = Create( "beer.png" ),
	["tv"] = Create( "tv.png" ),
	["party"] = Create( "party.png" ),
	["musicpage"] = Create( "musicpage.png" ),
	["instrument"] = Create( "instrument.png" ),
	["accept"] = Create( "accept.png" ),
	["cancel"] = Create( "cancel.png" ),
	["ban"] = Create( "ban.png" ),
	["heart"] = Create( "heart.png" ),
	["box"] = Create( "box.png" ),
	["broom"] = Create( "broom.png" ),
	["safe"] = Create( "safe.png" ),
	["money"] = Create( "money.png" ),
	["moneylost"] = Create( "money.png" ),
	["trophy"] = Create( "trophy.png" ),
	["present"] = Create( "present.png" ),
	["clipboard"] = Create( "clipboard.png" ),
	["hat"] = Create( "hat.png" ),
	["arcade"] = Create( "arcade.png" ),
	["cards"] = Create( "cards.png" ),
	["slots"] = Create( "slots.png" ),
	["pool"] = Create( "pool.png" ),
	["flag"] = Create( "flag.png" ),
	["admin"] = Create( "admin.png" ),
	["announce"] = Create( "announce.png" ),
	["exclamation"] = Create( "exclamation.png" ),
	["next"] = Create( "next.png" ),
	["light"] = Create( "light.png" ),
	["floor1"] = Create( "floor1.png" ),
	["floor2"] = Create( "floor2.png" ),
	["volume_on"] = Create( "volume_on.png" ),
	["volume_off"] = Create( "volume_off.png" ),
	["volume"] = Create( "volume.png" ),
	["volume16"] = Create( "volume16.png", "unlit" ),
	["chips"] = Create( "chip.png", nil, "gmod_tower/icons/" ),
}

Sounds = {

	["accept"] = "GModTower/ui/panel_accept.wav",

	["back"] = "GModTower/ui/panel_back.wav",

	["error"] = "GModTower/ui/panel_error.wav",

	["save"] = "GModTower/ui/panel_save.wav",

}


end

function APP:LockCondo( locked )



	if SERVER then

		--print("locc")
		local room = self.E:GetCondo()

		if room then

			--print("SV_CONDO_LOCKED: " .. tostring(locked))

			room:SetLock( locked )

		end

	end



end


local function NetLock(ply,lock)
	if (LocalPlayer() != ply) then return end
	local num = (LocalPlayer().GLocation - 1)

	RunConsoleCommand("gmt_roomkick")
	net.Start("gmt_lockcondo")
	net.WriteInt(num, 16)
		net.WriteBool(lock)
	net.SendToServer()
end

function APP:Start()


	self.BaseClass.Start(self)



	local ent = self:GetEntity()


	self.mp = ent:GetCondoMediaPlayer()



	if SERVER then return end


	self.homebuttons = {}

	self.condoUnLockButton = {

		icon = Icons["lock"],

		name = "Unlock Condo",

		func = function() local owner = GtowerRooms:RoomOwner( LocalPlayer().GLocation - 1 )
			owner.GRoomLock = false
			NetLock(owner,false)
			self.homebuttons[1] = self.condoLockButton
			self:Repl3("LockCondo", false)
		end,

	}

	self.condoLockButton = {

		icon = Icons["unlock"],

		name = "Lock Condo",

		func = function()
			local owner = GtowerRooms:RoomOwner( LocalPlayer().GLocation - 1 )
			if owner:GetNWBool("Party") then return end
			owner.GRoomLock = true
			NetLock(owner,true)
			self.homebuttons[1] = self.condoUnLockButton
			self:Repl3("LockCondo", true)
		end,

	}

	self.homebuttons[1] = self.condoUnLockButton



	local list = getApps()

	local sorted = { // there must be a better way to do this

		"camera",

		--"condo",

		"players",

		"music",

		"party",

		"settings"

	}

	local final = {}

	for k,v in pairs( sorted ) do

		table.insert( final, list[ v ] )

	end



	for k,v in pairs(final) do



		if v.Icon then



			local app = {

				icon = Icons[v.Icon],

				name = v.NiceName or v.Name,

				app = v.Name

			}



			table.insert(self.homebuttons, app)



		end



	end

end



function APP:Think()

	--Make this right

	if SERVER then return end



	self.homebuttons[1] = self:IsCondoLocked() and self.condoUnLockButton or self.condoLockButton

end



function APP:IsCondoLocked()


	local loc = LocalPlayer().GLocation
	local owner = GtowerRooms:RoomOwner( loc - 1 )
	return IsValid(owner) and owner.GRoomLock


end



function APP:DrawNewsTicker()



	local text = [[GMTower News: Today is a great day. | Local News: man yells: "LOBBY, LOBBY EVERYWHERE" before collapsing on the sidewalk. | Stocks: Hats UP 14.2%, pets DOWN 16.7% | Sports: The local team got more points than the opposing team, a victory for tower. | How many licks does it take to get to the center of a tootsie-pop? Scientists say 2953.45]]


	local h = scrh-50

	if self:IsCondoLocked() then
		h = scrh-50 - (scrh - 16 + 6)
	end

	surface.SetDrawColor( 50, 58, 69, 100 )

	surface.DrawRect( 0, h, scrw, 44 )



	surface.SetFont( "AppBarSmall" )

	local tw = surface.GetTextSize( text )



	draw.DrawText(text, "AppBarSmall", scrw - math.fmod(self:GetTime() * 200,(tw + scrw)), h, Color(255, 255, 255, 80))





end



function APP:DrawNowPlaying( tx, ty )


	if not self.mp then
		local ent

		for k,v in pairs( ents.FindByClass("gmt_condoplayer") ) do
			if v:GetNWInt("condoID") == self.E:GetNWInt("condoID") then ent = v end
		end

		if IsValid(ent) then
			self.mp = ent:GetMediaPlayer()
		end

	end

	if !IsValid(self.mp) then return end
	local media = self.mp:GetMedia()

	if not media then return end


	local padding = 90



	surface.SetDrawColor( 50, 58, 69, 100 )

	surface.DrawRect( 0, 70, scrw, 44 )



	-- Track bar

	if media:IsTimed() then



		local duration = media:Duration()

		local curTime = media:CurrentTime()

		local percent = math.Clamp( curTime / duration, 0, 1 )



		-- Duration bar

		surface.SetDrawColor( 0, 0, 0, 150 )

		surface.DrawRect( tx, ty + 40, scrw, 8 )

		surface.SetDrawColor( 0, 125, 173, 255 )

		surface.DrawRect( tx, ty + 40, scrw * percent, 8 )



		-- Current time

		local durationStr = string.FormatSeconds( duration )

		draw.SimpleText( durationStr, "AppBarLabelSmall", tx + scrw - 16, ty + 18 + 5, Color( 255, 255, 255, 25 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )



		-- Duration

		local curTimeStr = string.FormatSeconds(math.Clamp(math.Round(curTime), 0, duration))

		draw.SimpleText( curTimeStr, "AppBarLabelSmall", tx + 16, ty + 18 + 5, Color( 255, 255, 255, 25 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )



	end



	-- Title

	title = string.RestrictStringWidth( media:Title(), "AppBarSmall", scrw - (padding*2) )

	draw.SimpleText( "Now playing: " .. title, "AppBarLabel", tx + padding, ty + 18, Color( 255, 255, 255, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )



end



function APP:Draw()



	--print("SET MATERIAL " .. tostring(self.I.HomeBG))



	surface.SetDrawColor( 150, 150, 150, 255 )

	surface.SetMaterial(Backgrounds[math.Clamp(CondoBackground:GetInt(),1,9) or 1])


	surface.SetDrawColor( 255, 255, 255, 100 )

	for i=1, 4 do

		local scroll0 = (1 + math.cos(self:GetTime() / 2 + i)) * scrw

		local scroll1 = (1 + math.sin(self:GetTime() / 2 + i)) * scrh

		surface.DrawTexturedRect( -scroll0, -scroll1, scrw * 4, scrh * 4 )

	end



	local iconSize = 128

	local spacing = 16

	local x = (scrw/2) - ((spacing/2 + iconSize) * table.Count(self.homebuttons))/2 - (iconSize/2)

	local y = (scrh/2)-(iconSize/2)



	local Dividers = { {}, {} }

	for k,v in pairs(self.homebuttons) do

		local over = DrawButton( v.icon, x, y, iconSize )

		if over then

			draw.DrawText(v.name, "AppBarSmall", x + iconSize/2, y + iconSize, Color(255, 255, 255, 80), TEXT_ALIGN_CENTER)

		end

		v.over = over

		if k == 4 then

			Dividers[1][1] = x + iconSize

			x = x + iconSize/2

		elseif k == 5 then

			Dividers[1][2] = x

		elseif k == 6 then

			Dividers[2][1] = x + iconSize

			x = x + iconSize/2

		elseif k == 7 then

			Dividers[2][2] = x

		end

		x = x + iconSize + spacing

	end



	local h = iconSize/2

	surface.SetDrawColor( 255, 255, 255, 20 )

	surface.DrawRect( ( Dividers[1][1] + Dividers[1][2] ) / 2 - 1, y+h/2, 4, h )

	--surface.DrawRect( ( Dividers[2][1] + Dividers[2][2] ) / 2 - 1, y+h/2, 4, h )



	//self:DrawNewsTicker()

	self:DrawNowPlaying( 0, 70 )



	self.LASTM = self.LASTM or 0

	local dt = 1 - math.min(CurTime() - self.LASTM - 3, 1)



	if self.MX and self.MY then



		self.LMX = self.LMX or 0

		self.LMY = self.LMY or 0



		self.LMX = self.LMX + (self.MX - self.LMX) * .1

		self.LMY = self.LMY + (self.MY - self.LMY) * .1



		local cursorSize = 64



		surface.SetDrawColor( 255, 255, 255, 255 * dt )

		surface.SetTexture( Cursor2D )

		--draw.DrawText(tostring(self.TestValue) .. " " .. tostring(self), "AppBarSmall", self.LMX or 0, self.LMY or 0, Color(255,255,255,100))



		local offset = cursorSize / 2

		surface.DrawTexturedRect( self.LMX - offset + 15, self.LMY - offset + 15, cursorSize, cursorSize )



	end



	-- Lock border

	if self:IsCondoLocked() then



		local thickness = 16

		surface.SetDrawColor( Color( 255, 0, 0, 150 ) )

		surface.DrawRect( 0, 0, scrw, thickness - 6 ) -- Top

		surface.DrawRect( 0, scrh - thickness + 6, scrw, thickness ) -- Bottom

		surface.DrawRect( 0, thickness-6, thickness, scrh - thickness ) -- Left

		surface.DrawRect( scrw - thickness, thickness-6, thickness, scrh - thickness ) -- Right



		local text = "CONDO LOCKED: ONLY FRIENDS OR GROUP MEMBERS CAN ENTER"



		surface.SetFont( "AppBarSmall" )

		local tw, th = surface.GetTextSize( text )

		local padding = 8



		tw = tw + ( padding * 2 )



		surface.DrawRect( scrw/2 - tw/2, scrh - 50 - padding, tw, th + padding ) -- Text BG

		draw.DrawText( text, "AppBarSmall", scrw/2, scrh - 50, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)





	end



end



function APP:MouseEvent(event, x, y)

	self.BaseClass.MouseEvent(self, event, x, y)

	if event == MOUSE_PRESS then

		local iconSize = 128

		local spacing = 16





		/*

		local ix = (scrw/2) - ((spacing/2 + iconSize) * #self.homebuttons)/2

		for k,v in pairs(self.homebuttons) do

			if x > ix and x < ix + iconSize then

				if y > (scrh/2)-(iconSize/2) and y < (scrh/2)+(iconSize/2) then

					if v.app then self:Launch(v.app, false) elseif v.func then v.func() end

					self.E:Sound(Sounds["accept"])

				end

			end



			ix = ix + iconSize + spacing

		end

		*/

		for k,v in pairs(self.homebuttons) do

			if v.over then

				if v.app then self:Launch(v.app, false) elseif v.func then v.func() end

				self.E:Sound(Sounds["accept"])

			end

		end

	end



	self.NextMouseTime = self.NextMouseTime or CurTime()



	if self.NextMouseTime < CurTime() then

		--print("HOMEMOUSEEVT: " .. tostring(x) .. ", " .. tostring(y))

		self:Repl2("MouseThing", math.Round(x), math.Round(y))

		self.NextMouseTime = CurTime() + 0.1

	end

end



function APP:MouseThing(x,y)

	self.MX = x

	self.MY = y

	self.LASTM = CurTime()

end



function APP:End()

	self.BaseClass.End(self)

end
