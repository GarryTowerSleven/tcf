include("shared.lua")

include("cl_icons.lua")
include("cl_draw.lua")
include("cl_hud.lua")

// Create GMT fonts
surface.CreateFont( "tiny", { font = "Arial", size = 10, weight = 100 } )
surface.CreateFont( "smalltiny", { font = "Arial", size = 12, weight = 100 } )
surface.CreateFont( "small", { font = "Arial", size = 14, weight = 400 } )
surface.CreateFont( "smalltitle", { font = "Arial", size = 16, weight = 600 } )

local mainFont = "CenterPrintText"
surface.CreateFont( "GTowerhuge", { font = mainFont, size = 128, weight = 100 } )
surface.CreateFont( "GTowerbig", { font = mainFont, size = 48, weight = 125 } )
surface.CreateFont( "GTowerbigbold", { font = mainFont, size = 20, weight = 1200 } )
surface.CreateFont( "GTowerbiglocation", { font = mainFont, size = 28, weight = 125 } )
surface.CreateFont( "GTowermidbold", { font = mainFont, size = 16, weight = 1200 } )
surface.CreateFont( "GTowerbold", { font = mainFont, size = 14, weight = 700 } )

surface.CreateFont( "GTowersmall", { font = mainFont, size = 14, weight = 100 } )

local mainFont2 = "Oswald"
surface.CreateFont( "GTowerHUDHuge", { font = mainFont2, size = 50, weight = 400 } )
surface.CreateFont( "GTowerHUDMainLarge", { font = mainFont2, size = 38, weight = 400 } )
surface.CreateFont( "GTowerHUDMain", { font = mainFont2, size = 24, weight = 400 } )
surface.CreateFont( "GTowerHUDMainMedium", { font = mainFont2, size = 20, weight = 400 } )
surface.CreateFont( "GTowerHUDMainSmall", { font = mainFont2, size = 18, weight = 400 } )
surface.CreateFont( "GTowerHUDMainSmall2", { font = "Clear Sans", size = 18, weight = 800 } )
surface.CreateFont( "GTowerHUDMainTiny", { font = mainFont2, size = 16, weight = 400 } )
surface.CreateFont( "GTowerHUDMainTiny2", { font = "Clear Sans", size = 12, weight = 400 } )
surface.CreateFont( "GTowerNPC", { font = mainFont2, size = 100, weight = 800 } )

surface.CreateFont( "GTowerHudCText", { font = "default", size = 35, weight = 700 } )
surface.CreateFont( "GTowerHudCSubText", { font = "default", size = 18, weight = 700, } )
surface.CreateFont( "GTowerHudCNoticeText", { font = "default", size = 16, weight = 700, } )
surface.CreateFont( "GTowerHudCNewsText", { font = "default", size = 16, weight = 700, } )

surface.CreateFont( "GTowerTabNotice", { font = "Impact", size = 30, weight = 400 } )
surface.CreateFont( "GTowerMinigame", { font = "Impact", size = 24, weight = 400 } )
surface.CreateFont( "GTowerGMTitle", { font = "Impact", size = 24, weight = 400 } )
surface.CreateFont( "GTowerMessage", { font = "Arial", size = 16, weight = 600 } )
surface.CreateFont( "GTowerToolTip", { font = "Tahoma", size = 16, weight = 400 } )

//surface.CreateFont( "GTowerFuel", { font = "Impact", size = 18, weight = 400 } )

function GM:CalcView(ply, pos, ang, fov)
    if thirdperson then
        local tr = util.TraceHull({
            start = ply:EyePos() + ply:GetRight() * 8,
        endpos = ply:EyePos() - ang:Forward() * 48 + ang:Right() * 24,
        filter = ply
        })

        return {
            origin = tr.HitPos,
            drawviewer = true,
            fov = fov - 18
        }
    end

    ragdoll = ply:GetRagdollEntity()
    if IsValid(ragdoll) then

        if !ragdolled then
            ply:SetEyeAngles(angle_zero)
            ragdolled = true
        end

        local att = ragdoll:GetAttachment(1)
        ang.y = math.Clamp(ang.y, -90, 90)
        ply:SetEyeAngles(ang)
        return {
            origin = att.Pos + att.Ang:Forward() * 8,
            angles = att.Ang + Angle(-ang.y, ang.p, ang.y)
        }
    else
        ragdolled = false
    end
    if !splash then return end
    local ang = Angle(40 + math.sin(CurTime() * 0.1) * 8, 0, 0)
    y = y or 0
    y = y + FrameTime() * 2
    y = math.fmod(y, 361)
    ang.y = y
    return {
        origin = Vector(2684, -11, -900) - ang:Forward() * 2000,
        angles = ang,
        fov = 40
    }
end

local gradient = Material("vgui/gradient_up")

function GM:HUDPaint()
    self.BaseClass.HUDPaint(self)
    if !splash then return end

    local w, h = ScrW(), ScrH()

    t = t or {}

    DrawToyTown(2, ScrH() / 4)

    surface.SetMaterial(gradient)
    surface.SetDrawColor(Color(0, 0, 0, 180))
    surface.DrawTexturedRect(0, -h * 0.2, w, h * 1.2)

    draw.SimpleText("GMTower", "GTowerhuge", w / 2, h / 2 - 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("Click to start!", "GTowerbig", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    for i = 1, 4 do
        t[i] = t[i] or draw.NewTicker(w, h / 2 + i * 4, 0.001)
        draw.TickerText("VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF VIRUS UCH BALLRACE MINIGOLF", "GTowerhuge", Color(255, 255, 255, 255 * (i / 4)), t[i], 2, 200, 0 )
    end
    end

inv = inv or {}

local down = {}

function GM:Move()
    for i = 2, 9 do
        local k = i - 1
        if input.WasKeyPressed(i) then
            if down[i] then continue end
            down[i] = true
            print(k, i)
            net.Start("Inventory")
            net.WriteInt(2, 8)
            net.WriteTable({k, 1})
            net.SendToServer()
        else
            down[i] = nil
        end
    end
end

net.Receive("Inventory", function()
    inv = net.ReadTable()
end)

function openInv()
if IsValid(Inventory) then
    Inventory:Remove()
end

local panel = vgui.Create("DPanel")
Inventory = panel
panel:SetSize(600, 400)
panel:CenterHorizontal()

local gradient = surface.GetTextureID("vgui/gradient_up")

local slotsize = 54
local border = 24 / 2
SlotBarHeight = border

panel:SetSize(slotsize * #inv + border, slotsize * #inv[1] + border + SlotBarHeight)
panel:CenterHorizontal()

panel.Paint = function(self, w, h)
    local ew = self.EquipWidth or w

	-- Draw background
	surface.SetDrawColor( 64, 64, 64, 255 )
	surface.DrawRect( 0, 0, ew, 3 )
	draw.RoundedBox( 3, 0, 0, ew, h, Color(48, 48, 48, 255) )
	
	surface.SetDrawColor( 32, 32, 32, 50 )
	surface.SetTexture( gradient )
	surface.DrawTexturedRect( 0, SlotBarHeight, w, h )
end

for i = 0, #inv - 1 do
    for i2 = 0, #inv[1] - 1 do
        local slot = inv[i + 1][i2 + 1]
        local button = vgui.Create("DButton", panel)
        button:SetSize(slotsize, slotsize)
        button:SetPos(i * slotsize + border / 2, i2 * slotsize + border / 2 + (i2 == 0 and 0 or SlotBarHeight))

        button.MDL = vgui.Create("SpawnIcon", button)
        button.MDL:Dock(FILL)
        button.MDL:SetPaintedManually(true)
        button.MDL:SetMouseInputEnabled(false)

        button.x2 = i + 1
        button.y2 = i2 + 1

        button.Paint = function(self, w, h)

            -- Gradient
            surface.SetDrawColor(0, 0, 0, 100)
            surface.SetTexture(gradient)
            surface.DrawTexturedRect(1, 1, w, h)
            -- Main black
            surface.SetDrawColor(0, 0, 0, 75)
            surface.DrawRect(1, 1, w, h)

            if self:IsHovered() then
                surface.SetDrawColor(128, 128, 128, 50)
                surface.SetTexture(gradient)
                surface.DrawTexturedRect(0, 0, w, h)
            end

            local item = inv[self.x2][self.y2]

            if i2 == 0 then
                draw.SimpleText(i + 1, "GTowerHUDMainTiny2", 2, 2, color_white)
            end

            if !item.Name then return end

            self.MDL:SetModel(item.Model or "models/error.mdl")
            self.MDL:PaintManual()

            local x, y = 2, 2
            local w, h = self:GetWide(), 16
            surface.SetDrawColor(0, 0, 0, 100)
            --render.SetScissorRect( self.x + x, self.y + y, x + w, y + h, true )
            surface.DrawRect(x, y, w, h)
            draw.SimpleText(item.Name or "ITEM", "GTowerHUDMainTiny2", x, y, color_white)
        end

        // self.Item = inv[receiver.x][receiver.y]

        button:SetText("")

        button:Droppable("InventorySlot")
        button:Receiver("InventorySlot", function(self, tbl, dropped)
            print("!")
            if dropped then
                local receiver = tbl[1]
                print(receiver.x, receiver.y)
                print(inv[receiver.x])
                local i1 = inv[receiver.x2][receiver.y2]
                local i2 = inv[self.x2][self.y2]
                local mx, my = gui.MousePos()
                print(i1, i2)
                net.Start("Inventory")
                net.WriteInt(1, 8)
                net.WriteTable(
                    {
                        receiver.x2, receiver.y2, self.x2, self.y2
                    }
                )
                net.SendToServer()
                
                timer.Simple(0, function()
                    openInv()
                    gui.EnableScreenClicker(true)
                    gui.SetMousePos(mx, my)
                end)
            end
        end)

        button:SetPos(i * slotsize + border / 2, i2 * slotsize + border / 2 + (i2 == 0 and 0 or SlotBarHeight))

    end
end
end

function GM:OnSpawnMenuOpen()
    openInv()
    local panel = Inventory
    local _, y = panel:GetPos()
    panel:SetPos(_, -panel:GetTall())
    Inventory.Open = true
    gui.EnableScreenClicker(true)
    local _, y = panel:GetPos()
    panel:SetPos(_, -panel:GetTall())
    panel:MoveTo(_, 0, 0.4, 0, 0.4)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.4, 0)

    -- Let the gamemode decide whether we should open or not..
	if ( !hook.Call( "SpawnMenuOpen", self ) ) then return end

	if ( IsValid( g_SpawnMenu ) ) then
		g_SpawnMenu:Open()
        if LocalPlayer():IsAdmin() then return end
		// menubar.ParentTo( g_SpawnMenu )
        if IsValid(menubar.Control) then
        menubar.Control:Hide()
        end
        g_SpawnMenu.HorizontalDivider:SetRight( nil ) -- What an ugly hack
        g_SpawnMenu.HorizontalDivider:SetLeft( nil )
        g_SpawnMenu.CreateMenu:SetParent( g_SpawnMenu )
        g_SpawnMenu.CreateMenu:Dock( FILL )
        g_SpawnMenu.CreateMenu.tabScroller:Hide()
        if IsValid(g_SpawnMenu.ToolToggle) then
        g_SpawnMenu.ToolToggle:Hide()
        end
	end

    g_SpawnMenu:SetSize(800, 480)
    g_SpawnMenu:Dock(NODOCK)
    g_SpawnMenu:SetPos(0, ScrH() - g_SpawnMenu:GetTall())
    g_SpawnMenu:CenterHorizontal()

	hook.Call( "SpawnMenuOpened", self )
end

function GM:OnSpawnMenuClose()
    local panel = Inventory
    Inventory.Open = false
    Inventory.m_AnimList = {}
    gui.EnableScreenClicker(false)
    Inventory:SetAnimationEnabled(true)
    Inventory:SetAnimationEnabled(false)
    local _, y = panel:GetPos()
    panel:SetPos(_, -panel:GetTall())
    panel:MoveTo(_, -panel:GetTall(), 0.4, 0, 0.4)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.4, 0)

    if ( IsValid( g_SpawnMenu ) ) then g_SpawnMenu:Close() end
	hook.Call( "SpawnMenuClosed", self )
end

colorutil = {}
colorutil.Brighten = function(col) return col end

local function isEmpty(str)
	return str == nil or str == ""
end

-- Some locations call for certain behavior of soundscapes, more than just groups
soundscape = soundscape or {}
function soundscape.GetSoundscape(loc)
	local location = Location.Get(loc)
	if not location then return end

	-- First, see if there's a soundscape defined for the current specific location
	local scape = soundscape.IsDefined(location.Name) and location.Name or nil 
	scape = scape and string.lower(scape) or nil 

	-- if it's registered, return
	if not isEmpty(scape) then return scape end

	-- Move on to any overrides before we get to a 'group' soundscape
	-- Play a super quiet soundscape when they're in the movie theater itself
	if location.Group == "theater" and location.Name ~= "theatermain" then
		return "theater_inside"
	end

	-- When in the stores, stop playing the plaza soundscape
	if location.Group == "stores" and location.Name ~= "stores" then
		return "stores_inside"
	end

	-- Fix for the condos
	if location.CondoID then
		return "condo"
	end

	-- Just use default methods to find the soundscape
 	scape = Location.GetGroup(loc)

	-- Return what we've got
	return scape and string.lower(scape) or nil
end

-- Set the soundscapes automatically depending on their location
hook.Add("Location", "SoundscapeChangeLocation", function(ply, loc)

	-- Retrieve the two locations
	local newGroup = string.lower(Location.GetGroup(loc))

	-- Get the soundscape matching this location
	local sndscape = soundscape.GetSoundscape(loc)

	-- if there's no soundscapes for this location stop the presses
	if isEmpty(sndscape) then
		soundscape.StopChannel("background")
		
		 -- spook their pants off
		if loc == 0 or Location.Get(loc) == nil then
			soundscape.Play("somewhere", "background")
		end
		return
	end
	-- If the soundscape wasn't playing, stop current soundscapes to play it
	if not soundscape.IsPlaying(sndscape) then
		soundscape.StopChannel("background")
		soundscape.Play(sndscape, "background")
	end
end )


--------------------------------------
--      SOUNDSCAPE DEFINITIONS      --
-- TODO: Better place to put these? --
--------------------------------------

local STATE_IDLE 		= 1
local STATE_ARRIVING 	= 2
local STATE_UNLOADING 	= 3
local STATE_LEAVING 	= 4

local PSASounds = 
{
	{Sound("GModTower/voice/station/psa1.mp3"), 7},
	{Sound("GModTower/voice/station/psa2.mp3"), 10},
	{Sound("GModTower/voice/station/psa3.mp3"), 5},
	{Sound("GModTower/voice/station/psa4.mp3"), 7},
	{Sound("GModTower/voice/station/psa5.mp3"), 11},
}
local ApproachSound = { Sound("GModTower/voice/station/approaching.mp3"), 8}

soundscape.Register("transit", 
{
	dsp = 0,
	--dsp = 2,

	-- Create a new rule that plays a random sound
	{
	type = "playrandom_bass",
		time = {90, 120}, -- Rule is run every 90 to 120 seconds
		volume = 0.55, -- Full volume
		pitch = 100, -- Normal pitch
		--soundlevel = 100000, -- Sound level in decibels

		-- Override the sound selector function with our own
		sounds = function()
		
			-- If the train is approaching, play the arrival sound
			for _, v in pairs(ents.FindByClass("gmt_maglev")) do
				if v and v.State == STATE_ARRIVING or v.State == STATE_UNLOADING then

					-- Return the approaching file and length
					return ApproachSound[1], ApproachSound[2]
				end
			end

			-- If the train wasn't approaching, play a random other sound
			local rnd = table.Random(PSASounds)
			return rnd[1], rnd[2]
		end,
	},

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.80,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/trainstation.wav"), 3},
	},
})


local ElevatorMusicName = "GModTower/soundscapes/music/elevator"
local ElevatorMusicCount = 21 -- Define the number of music files for ambient lobby jams
local ElevatorSongs = {}
for n=1, ElevatorMusicCount do 
	table.insert(ElevatorSongs, {ElevatorMusicName .. n .. ".mp3", 10} )
end
soundscape.Register("elevator", 
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	--idle = true, 

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = 2, -- Play the next sound 2 seconds after this one ends
		pitch = 100, -- Normal pitch

		-- Override the sound selector function with our own
		sounds = ElevatorSongs,
	},
})


soundscape.Register("lobby", 
{
	dsp = 0,
	--dsp = 3,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},

})

soundscape.Register("theater", 
{
	dsp = 0,
	--dsp = 2,
	
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/theatre_lobby.wav"), 2},
	},

	{
	type = "playlooping",
		volume = 1,
		position = Vector(4864.0913085938, 4366.1127929688, -874.30322265625),
		soundlevel = 150,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {"GModTower/music/theater.mp3", 2},
	},
	{
	type = "playlooping",
		volume = 1,
		position = Vector(3946.9204101563, 4366.6865234375, -872.61047363281),
		soundlevel = 150,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {"GModTower/music/theater.mp3", 2},
	},

	
	{
	type = "playrandom",

		time = {300, 600},
		volume = {0.5, 0.75},
		pitch = {90, 110},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"ambient/levels/citadel/strange_talk7.wav", 10 },
			{"ambient/levels/citadel/strange_talk8.wav", 10 },
			{"ambient/levels/citadel/strange_talk9.wav", 10 },
			{"ambient/levels/citadel/strange_talk10.wav", 10 },
			{"ambient/levels/citadel/strange_talk11.wav", 10 },
		},
	},
})

soundscape.Register("theaterarcade", 
{
	dsp = 0,
	--dsp = 2,
	
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {"GModTower/music/arcade.mp3", 2},
	},	
	{
	type = "playrandom",

		time = {300, 600},
		volume = {0.5, 0.75},
		pitch = {90, 110},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"ambient/levels/citadel/strange_talk7.wav", 10 },
			{"ambient/levels/citadel/strange_talk8.wav", 10 },
			{"ambient/levels/citadel/strange_talk9.wav", 10 },
			{"ambient/levels/citadel/strange_talk10.wav", 10 },
			{"ambient/levels/citadel/strange_talk11.wav", 10 },
		},
	},
})

soundscape.Register("theater_inside", 
{
	dsp = 0,
})

soundscape.Register("monorail", 
{
	dsp = 0,
})

soundscape.Register("casino", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},

	-- Create a looping sound rule
	--[[{
	type = "playlooping",
		-- Limit the volume
		volume = 0.00, --
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/casinobase.wav"), 2},
	},]]
})

soundscape.Register("casinoloft", 
{
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.25,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.8,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},
})

soundscape.Register("duels", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = .1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 2},
	},
})

soundscape.Register("plaza", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.87,

		-- Worldsound position of the looping sound
		position = Vector(1685.487793, -1691.865723, -771.9),

		-- Control the falloff of the sound
		-- Note the values are different than source's builtin soundlevel, I need to figure out the math for this
		soundlevel = 300,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/lobby/club/club_exterior.mp3"), 10},
	},

})

soundscape.Register("games", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.65,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/construct_tone.wav"), 8},
	},
		-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.20,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.006,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/forest_day.wav"), 16},
	},

})

soundscape.Register("gameslobby", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.30,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/construct_tone.wav"), 8},
	},
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.30,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},

	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.003,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/forest_day.wav"), 16},
	},

})

soundscape.Register("boardwalk", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.8,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/boardwalk.mp3"), 8},
	},

	{
	type = "playrandom",

		time = {2, 8},
		volume = 0.32,
		pitch = {90, 110},
		soundlevel = 110, -- Sound level in decibels
		position = 5500,
		sounds = 
		{
			{"ambient/levels/coast/seagulls_ambient1.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient2.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient3.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient4.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient5.wav", 10 },
		},
	},
})

soundscape.Register("pool", 
{
	dsp = 0,

	-- Poolwater lapping
	{
	type = "playrandom",

		time = {1, 4},
		volume = 1,
		pitch = {90, 110},
		soundlevel = 140, -- Sound level in decibels
		position = 500,
		sounds = 
		{
			{"GModTower/pool/lap1.mp3", 10 },
			{"GModTower/pool/lap2.mp3", 10 },
			{"GModTower/pool/lap3.mp3", 10 },
			{"GModTower/pool/lap4.mp3", 10 },
			{"GModTower/pool/lap5.mp3", 10 },
			{"GModTower/pool/lap6.mp3", 10 },
			{"GModTower/pool/lap7.mp3", 10 },
			{"GModTower/pool/lap8.mp3", 10 },
		},
	},

	
	-- Duplicate the beach soundscape
	-- TODO: make a 'playsoundscape' rule so we don't have to do this
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.80,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/boardwalk.mp3"), 8},
	},

	{
	type = "playrandom",

		time = {2, 8},
		volume = 0.32,
		pitch = {90, 110},
		soundlevel = 110, -- Sound level in decibels
		position = 5500,
		sounds = 
		{
			{"ambient/levels/coast/seagulls_ambient1.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient2.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient3.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient4.wav", 10 },
			{"ambient/levels/coast/seagulls_ambient5.wav", 10 },
		},
	},
})


soundscape.Register("stores", 
{
	dsp = 0,
	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/plaza.wav"), 8},
	},
})

soundscape.Register("stores_inside", 
{
	dsp = 0,
	--dsp = 104,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.25,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/tower_lobby.wav"), 4},
	},
})


soundscape.Register("condolobby", 
{
	dsp = 0,
	--dsp = 2,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 1,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/condocorridor.wav"), 4},
	},
})
soundscape.Register("condo", 
{
	dsp = 0,
})

-- TODO: Add playsoundscape rule
soundscape.Register("duels", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.05,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/atmosphere/town_ambience.wav"), 9.2833560090703},
	},

	{
	type = "playrandom",

		time = {6, 12},
		volume = 1,
		pitch = {50, 140},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"GModTower/lobby/void/void1.mp3", 10 },
			{"GModTower/lobby/void/void2.mp3", 10 },
			{"GModTower/lobby/void/void3.mp3", 10 },
			{"GModTower/lobby/void/void4.mp3", 10 },
			{"GModTower/lobby/void/void5.mp3", 10 },
		},
	},
})



-- SPOOK ZONE: ACTIVATE
soundscape.Register("somewhere", 
{
	dsp = 0,

	-- Create a looping sound rule
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.05,
		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("ambient/atmosphere/town_ambience.wav"), 9.2833560090703},
	},

	{
	type = "playrandom",

		time = {6, 12},
		volume = 1,
		pitch = {50, 140},
		soundlevel = 140, -- Sound level in decibels
		position = 1500,
		sounds = 
		{
			{"GModTower/lobby/void/void1.mp3", 10 },
			{"GModTower/lobby/void/void2.mp3", 10 },
			{"GModTower/lobby/void/void3.mp3", 10 },
			{"GModTower/lobby/void/void4.mp3", 10 },
			{"GModTower/lobby/void/void5.mp3", 10 },
		},
	},
})


local function isEmpty(str)
	return str == nil or str == ""
end

local lastRand 
local curRand 
local function uniqueRandom(min, max )

	-- Prevent infinite loop
	if min == max then return min end

	-- Repeat until we have a new unique number 
	repeat
		curRand = math.random(min, max)
	until (curRand ~= lastRand )

	return curRand 
end

local Enabled = CreateClientConVar("gmt_bgmusic_enable", "1", true, false )
local Volume = CreateClientConVar("gmt_bgmusic_volume", "50", true, false )

-- Hook into when these babies change
cvars.AddChangeCallback(Enabled:GetName(), function(name, old, new )
	if not tobool(new) then
		soundscape.StopChannel("music", 0.5, true)
	elseif not soundscape.IsPlaying("music_global_ambient") then
		soundscape.Play("music_global_ambient", "music", true)
	end
end )

cvars.AddChangeCallback(Volume:GetName(), function(name, old, new )
	soundscape.SetVolume("music", math.Clamp(tonumber(new), 0, 100) / 100)
end )

-- Set initial volume
soundscape.SetVolume("music", math.Clamp(Volume:GetInt(), 0, 100) / 100)

-- Some locations call for certain behavior of soundscapes, more than just groups
-- This function is fine-tuned for background music, not just generic soundscapes
-- To define a custom musicscape, name it exactly as you would a normal soundscape, prefixed with "music_"
-- For example, a custom musicscape for the "lobby" location would be named "music_lobby"
soundscape = soundscape or {}
function soundscape.GetMusicSoundscape(loc)
	local location = Location.Get(loc)
	if not location then return end

	-- First, see if there's a soundscape defined for the current specific location
	local scape = soundscape.IsDefined("music_" .. location.Name) and "music_" .. location.Name or nil 
	scape = scape and string.lower(scape) or nil 

	-- if it's registered, return
	if not isEmpty(scape) then return scape end

	-- Move on to any overrides before we get to a 'group' soundscape
	-- Play a super quiet soundscape when they're in the movie theater itself
	if location.Group == "theater" and location.Name ~= "theatermain" then
		return "music_theater_inside"
	end

	-- When in the stores, stop playing the plaza soundscape
	if location.Group == "stores" and location.Name ~= "stores" then
		return "music_stores_inside"
	end

	-- Fix for the condos
	if location.CondoID then
		return "music_condo"
	end

	-- Just use default methods to find the soundscape
 	scape = Location.GetGroup(loc)

	-- Return what we've got
	return (scape and soundscape.IsDefined("music_" .. scape) ) and string.lower("music_" .. scape) or nil
end

-- Very similar to the one in cl_soundscape.lua
-- However, this one changes PASSIVELY, so that it's only changed when it's set to change
-- This keeps the music going even in new locations, whereas the other does not
hook.Add("Think", "MusicscapeChangeLocation", function(ply, loc)
	if not Enabled:GetBool() then return end

    local ply = LocalPlayer()
    local loc = ply:Location()
    if ply.LocationDEAD == loc then return end
    ply.LocationDEAD = loc
    print("!")

	-- Retrieve the two locations
	local newGroup = string.lower(Location.GetGroup(loc))

	-- Get the soundscape matching this location
	local sndscape = "music_global_ambient" or soundscape.GetMusicSoundscape(loc)
    print(sndscape, soundscape.GetMusicSoundscape(loc))

	-- if there's no soundscapes for this location stop the presses
	if isEmpty(sndscape) or not soundscape.IsDefined(sndscape) then
		 -- Only stop the soundscape if they're in no man's land
		if loc == 0 or Location.Get(loc) == nil then
			soundscape.StopChannel("music")

		-- Just play an ambient music track if there's no music override here
		elseif not soundscape.IsPlaying("music_global_ambient") then
			soundscape.StopChannel("music")
			soundscape.Play("music_global_ambient", "music", true)
		end
		return
	end

	-- If there is an actual defined soundscape for this location, use that
	if not soundscape.IsPlaying(sndscape) then
        print("!", sndscape, "TEST")
		soundscape.StopChannel("music")
		soundscape.Play(sndscape, "music")
    else
        print("?")
	end
end )


--------------------------------------
--      SOUNDSCAPE DEFINITIONS      --
-- TODO: Better place to put these? --
--------------------------------------

local LobbyMusicName = "GModTower/soundscapes/music/lobby"
local LobbyMusicCount = 10 -- Define the number of music files for ambient lobby jams
local LobbySongs = {}
for n=1, LobbyMusicCount do 
	if n != 5 then // fuck this track
		table.insert(LobbySongs, {LobbyMusicName .. n .. ".mp3", 10} )
	end
end
soundscape.Register("music_global_ambient", 
{
	-- Tell the soundscape system that when this is usually removed and faded out, keep it alive
	idle = true, 

	-- Select a random song to play every once in a while
	{
	type = "playlist",
		time = {60 * 0.5, 60 * 5}, -- Play the next song 0.5 to 5 minutes after the song ends

		-- Override the sound selector function with our own
		sounds = LobbySongs,
	},
})

soundscape.Register("music_lobby", 
{
	{
	type = "playlooping",
		-- Limit the volume
		volume = 0.25,

		-- Start this sound's position syncronized with servertime
		--sync = true,

		-- All sounds are in a table format of {soundpath, soundlength}
		sound = {Sound("GModTower/soundscapes/music/towermainlobby1.mp3"), 234},
	},
})

-- Mute BG music in elevator
soundscape.Register("music_elevator", {})

-- Mute any music in the theater
soundscape.Register("music_theater_inside", {} )

-- Mute any music in the condo
soundscape.Register("music_condo", {})

-- Mute any music in the nightclub
soundscape.Register("music_nightclub", {})

-- Mute any music in the duels lobby
soundscape.Register("music_duels", {})

-- Mute any music in the duels arena
soundscape.Register("music_duelarena", {})

-- Mute any music in the button room
soundscape.Register("music_secret", {})

local soundLengths = {}
soundLengths["sound/gmodtower/soundscapes/music/lobby1.mp3"] = 492.487596
soundLengths["sound/gmodtower/lobby/void/void1.mp3"] = 7.001882
soundLengths["sound/gmodtower/balls/ballsmusicwmemories.mp3"] = 260.127347
soundLengths["sound/gmodtower/music/arcade.mp3"] = 236.030454
soundLengths["sound/gmodtower/soundscapes/tower_lobby.wav"] = 4.062517
soundLengths["sound/gmodtower/soundscapes/boardwalk.mp3"] = 28.004331
soundLengths["sound/gmodtower/soundscapes/music/lobby10.mp3"] = 159.08678004535
soundLengths["sound/gmodtower/sourcekarts/music/raceway_race1.mp3"] = 132.493061
soundLengths["sound/gmodtower/voice/station/psa5.mp3"] = 10.448980
soundLengths["sound/gmodtower/balls/ballsmusicwgrass.mp3"] = 126.955102
soundLengths["sound/gmodtower/voice/station/psa4.mp3"] = 7.053061
soundLengths["sound/gmodtower/voice/station/psa3.mp3"] = 5.511837
soundLengths["sound/gmodtower/voice/station/psa2.mp3"] = 9.586939
soundLengths["sound/gmodtower/voice/station/psa1.mp3"] = 7.262041
soundLengths["sound/gmodtower/soundscapes/music/elevator3.mp3"] = 34.298776
soundLengths["sound/gmodtower/virus/waiting_forplayers6.mp3"] = 30.798367
soundLengths["sound/gmodtower/virus/waiting_forplayers2.mp3"] = 30.014694
soundLengths["sound/gmodtower/soundscapes/music/towermainlobby1.mp3"] = 116.324331
soundLengths["sound/gmodtower/virus/waiting_forplayers8.mp3"] = 30.275918
soundLengths["sound/gmodtower/virus/waiting_forplayers7.mp3"] = 30.484898
soundLengths["sound/gmodtower/virus/waiting_forplayers5.mp3"] = 30.040816
soundLengths["sound/gmodtower/virus/waiting_forplayers4.mp3"] = 30.040816
soundLengths["sound/gmodtower/virus/waiting_forplayers3.mp3"] = 30.040816
soundLengths["sound/gmodtower/minigolf/music/waiting2.mp3"] = 30.040816
soundLengths["sound/gmodtower/minigolf/music/waiting7.mp3"] = 36.623673
soundLengths["sound/gmodtower/minigolf/music/waiting6.mp3"] = 35.578776
soundLengths["sound/gmodtower/minigolf/music/waiting5.mp3"] = 36.257959
soundLengths["sound/gmodtower/minigolf/music/waiting4.mp3"] = 29.685782
soundLengths["sound/gmodtower/lobby/stores/train/track.wav"] = 0.684989
soundLengths["sound/gmodtower/minigolf/music/waiting3.mp3"] = 33.384490
soundLengths["sound/gmodtower/virus/waiting_forplayers1.mp3"] = 30.066939
soundLengths["sound/gmodtower/soundscapes/music/elevator19.mp3"] = 161.671837
soundLengths["sound/gmodtower/zom/music/music_waiting3.mp3"] = 30.746122
soundLengths["sound/gmodtower/balls/ballsmusicwparadise.mp3"] = 305.057959
soundLengths["sound/gmodtower/soundscapes/music/elevator18.mp3"] = 249.260408
soundLengths["sound/gmodtower/soundscapes/condocorridor.wav"] = 5.029387755102
soundLengths["sound/gmodtower/balls/ballsmusicwsky.mp3"] = 83.644082
soundLengths["sound/gmodtower/zom/music/music_waiting2.mp3"] = 32.444082
soundLengths["sound/gmodtower/soundscapes/music/elevator16.mp3"] = 144.039184
soundLengths["sound/gmodtower/sourcekarts/music/raceway_race3.mp3"] = 114.233469
soundLengths["sound/gmodtower/sourcekarts/music/raceway_race2.mp3"] = 229.720816
soundLengths["sound/gmodtower/lobby/trainstation/vendingmachinehumm.mp3"] = 2.925714
soundLengths["sound/gmodtower/sourcekarts/music/island_race3.mp3"] = 221.283265
soundLengths["sound/gmodtower/sourcekarts/music/island_race2.mp3"] = 214.047347
soundLengths["sound/gmodtower/sourcekarts/music/island_race1.mp3"] = 230.739592
soundLengths["sound/gmodtower/soundscapes/music/elevator9.mp3"] = 201.586939
soundLengths["sound/gmodtower/soundscapes/music/elevator21.mp3"] = 246.257392
soundLengths["sound/gmodtower/soundscapes/music/elevator20.mp3"] = 48.718367
soundLengths["sound/gmodtower/minigolf/music/waiting1.mp3"] = 32.026122
soundLengths["sound/gmodtower/balls/ballsmusicwkhromidro.mp3"] = 322.377143
soundLengths["sound/gmodtower/soundscapes/music/elevator17.mp3"] = 88.528980
soundLengths["sound/gmodtower/zom/music/music_waiting1.mp3"] = 44.773878
soundLengths["sound/gmodtower/soundscapes/music/elevator15.mp3"] = 131.840000
soundLengths["sound/gmodtower/soundscapes/music/elevator14.mp3"] = 89.521633
soundLengths["sound/gmodtower/soundscapes/music/elevator13.mp3"] = 187.689796
soundLengths["sound/ambient/levels/citadel/strange_talk7.wav"] = 5.017007
soundLengths["sound/gmodtower/soundscapes/music/elevator1.mp3"] = 147.278367
soundLengths["sound/gmodtower/pool/lap3.mp3"] = 1.150454
soundLengths["sound/ambient/levels/coast/seagulls_ambient4.wav"] = 2.658866
soundLengths["sound/gmodtower/pvpbattle/startoffrostbiteround.mp3"] = 253.584739
soundLengths["sound/ambient/levels/coast/seagulls_ambient3.wav"] = 4.737143
soundLengths["sound/ambient/levels/coast/seagulls_ambient1.wav"] = 4.133424
soundLengths["sound/gmodtower/pvpbattle/startofmeadowround.mp3"] = 360.138209
soundLengths["sound/ambient/levels/coast/seagulls_ambient5.wav"] = 1.782630
soundLengths["sound/ambient/construct_tone.wav"] = 25.000000
soundLengths["sound/gmodtower/soundscapes/trainstation.wav"] = 3.375011
soundLengths["sound/gmodtower/soundscapes/music/elevator2.mp3"] = 77.818776
soundLengths["sound/gmodtower/lobby/void/void5.mp3"] = 8.516984
soundLengths["sound/ambient/levels/citadel/strange_talk10.wav"] = 6.124263
soundLengths["sound/gmodtower/pool/lap6.mp3"] = 1.202698
soundLengths["sound/gmodtower/pool/lap4.mp3"] = 1.385556
soundLengths["sound/gmodtower/pool/lap7.mp3"] = 1.072086
soundLengths["sound/gmodtower/pool/lap5.mp3"] = 0.941474
soundLengths["sound/ambient/levels/coast/seagulls_ambient2.wav"] = 6.433469
soundLengths["sound/gmodtower/pvpbattle/startofthepitround.mp3"] = 239.635351
soundLengths["sound/gmodtower/pvpbattle/startofcolonyround.mp3"] = 232.150204
soundLengths["sound/gmodtower/soundscapes/music/lobby9.mp3"] = 222.982290
soundLengths["sound/gmodtower/soundscapes/music/lobby7.mp3"] = 120.007596
soundLengths["sound/gmodtower/music/theater.mp3"] = 635.297959
soundLengths["sound/gmodtower/soundscapes/plaza.wav"] = 4.500023
soundLengths["sound/ambient/levels/citadel/strange_talk11.wav"] = 3.994649
soundLengths["sound/gmodtower/soundscapes/theatre_lobby.wav"] = 4.500023
soundLengths["sound/gmodtower/pvpbattle/startofoneslipround.mp3"] = 359.171678
soundLengths["sound/gmodtower/soundscapes/music/lobby2.mp3"] = 281.83616780045
soundLengths["sound/ambient/levels/citadel/strange_talk8.wav"] = 3.720091
soundLengths["sound/gmodtower/soundscapes/music/lobby3.mp3"] = 165.356168
soundLengths["sound/gmodtower/soundscapes/music/lobby4.mp3"] = 213.839433
soundLengths["sound/gmodtower/pvpbattle/startofconstructionround.mp3"] = 360.085964
soundLengths["sound/gmodtower/soundscapes/music/lobby5.mp3"] = 174.55126984127
soundLengths["sound/ambient/levels/citadel/strange_talk9.wav"] = 5.527483
soundLengths["sound/gmodtower/soundscapes/music/lobby6.mp3"] = 193.855760
soundLengths["sound/gmodtower/lobby/stores/train/whistle.wav"] = 1.583946
soundLengths["sound/gmodtower/soundscapes/music/lobby8.mp3"] = 257.620658
soundLengths["sound/ambient/forest_day.wav"] = 30.000000
soundLengths["sound/gmodtower/pool/lap2.mp3"] = 1.254943
soundLengths["sound/gmodtower/pool/lap1.mp3"] = 0.889229
soundLengths["sound/gmodtower/pool/lap8.mp3"] = 1.333311
soundLengths["sound/gmodtower/lobby/void/void2.mp3"] = 9.013311
soundLengths["sound/gmodtower/lobby/void/void3.mp3"] = 7.315351
soundLengths["sound/gmodtower/lobby/void/void4.mp3"] = 8.020658
soundLengths["sound/ambient/atmosphere/town_ambience.wav"] = 9.283356
soundLengths["sound/gmodtower/pvpbattle/startofcontainershipround.mp3"] = 243.945556
soundLengths["sound/gmodtower/lobby/club/club_exterior.mp3"] = 30.015760
soundLengths["sound/gmodtower/soundscapes/music/elevator4.mp3"] = 119.588571
soundLengths["sound/gmodtower/soundscapes/music/elevator5.mp3"] = 130.403265
soundLengths["sound/gmodtower/soundscapes/music/elevator12.mp3"] = 244.610612
soundLengths["sound/gmodtower/soundscapes/music/elevator6.mp3"] = 100.205714
soundLengths["sound/gmodtower/soundscapes/music/elevator7.mp3"] = 162.586122
soundLengths["sound/gmodtower/soundscapes/music/elevator8.mp3"] = 132.414694
soundLengths["sound/gmodtower/soundscapes/music/elevator10.mp3"] = 122.017959
soundLengths["sound/gmodtower/soundscapes/music/elevator11.mp3"] = 214.543673

soundscape = soundscape or {}
soundscape.SoundLengths = soundLengths


---------------------------------
Ambiance = Ambiance or {}


local function duration( min, sec )
	return min * 60 + sec
end

Ambiance.Music = {
	// Condo Elevator
	[31] = {
		{ "gmodtower/soundscapes/music/elevator1.mp3", 147.278367 },
		{ "gmodtower/soundscapes/music/elevator2.mp3", 77.818776 },
		{ "gmodtower/soundscapes/music/elevator3.mp3", 34.298776 },
		{ "gmodtower/soundscapes/music/elevator4.mp3", 119.588571 },
		{ "gmodtower/soundscapes/music/elevator5.mp3", 130.403265 },
		{ "gmodtower/soundscapes/music/elevator6.mp3", 100.205714 },
		{ "gmodtower/soundscapes/music/elevator7.mp3", 162.586122 },
		{ "gmodtower/soundscapes/music/elevator8.mp3", 132.414694 },
		{ "gmodtower/soundscapes/music/elevator9.mp3", 201.586939 },
		{ "gmodtower/soundscapes/music/elevator10.mp3", 122.017959 },
		{ "gmodtower/soundscapes/music/elevator11.mp3", 214.543673 },
		{ "gmodtower/soundscapes/music/elevator12.mp3", 244.610612 },
		{ "gmodtower/soundscapes/music/elevator13.mp3", 187.689796 },
		{ "gmodtower/soundscapes/music/elevator14.mp3", 89.521633 },
		{ "gmodtower/soundscapes/music/elevator15.mp3", 131.840000 },
		{ "gmodtower/soundscapes/music/elevator16.mp3", 144.039184 },
		{ "gmodtower/soundscapes/music/elevator17.mp3", 88.528980 },
		{ "gmodtower/soundscapes/music/elevator18.mp3", 249.260408 },
		{ "gmodtower/soundscapes/music/elevator19.mp3", 161.671837 },
		{ "gmodtower/soundscapes/music/elevator20.mp3", 48.718367 },
		{ "gmodtower/soundscapes/music/elevator21.mp3", 246.257392 },
	},

	// Transit Station
	[38] = {
		{ "gmodtower/voice/station/psa1.mp3", 50 },
		{ "gmodtower/voice/station/psa2.mp3", 45 },
		{ "gmodtower/voice/station/psa3.mp3", 55 },
		{ "gmodtower/voice/station/psa4.mp3", 60 },
	},

	// Station A
	[39] = {
		{ "gmodtower/voice/station/psa1.mp3", 25 },
		{ "gmodtower/voice/station/psa2.mp3", 25 },
		{ "gmodtower/voice/station/psa3.mp3", 25 },
		{ "gmodtower/voice/station/psa4.mp3", 25 },
	},

	// Station B
	[40] = {
		{ "gmodtower/voice/station/psa1.mp3", 25 },
		{ "gmodtower/voice/station/psa2.mp3", 25 },
		{ "gmodtower/voice/station/psa3.mp3", 25 },
		{ "gmodtower/voice/station/psa4.mp3", 25 },
	},

	// Plaza
	[17] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Garden
	[57] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Condo Lobby
	[29] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Stores
	[18] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[20] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[21] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[22] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[23] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	[37] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Boardwalk
	[42] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Games
	[28] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Games Lobby
	[36] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Arcade Loft
	[19] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Center Plaza
	[16] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Casino Loft
	[24] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Pool
	[43] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Top of Water Slides
	[46] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Water Slides
	[48] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Beach
	[45] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Ocean
	[47] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Ocean
	[44] = {
		{ "gmodtower/soundscapes/music/deluxe_plaza1.mp3", 2*60+54 },
		{ "gmodtower/soundscapes/music/deluxe_plaza2.mp3", 2*60+2 },
		{ "gmodtower/soundscapes/music/deluxe_plaza3.mp3", 2*60+37 },
		{ "gmodtower/soundscapes/music/deluxe_plaza4.mp3", 7*60+28 },
		{ "gmodtower/soundscapes/music/deluxe_plaza5.mp3", 60+36 },
		{ "gmodtower/soundscapes/music/deluxe_plaza6.mp3", 2*60+20 },
		{ "gmodtower/soundscapes/music/deluxe_plaza7.mp3", 60+39 },
		{ "gmodtower/soundscapes/music/deluxe_plaza8.mp3", 60+30 },
		{ "gmodtower/soundscapes/music/deluxe_plaza9.mp3", 60+57 },
	},

	// Tower Lobby
	[15] = {
		{ "gmodtower/soundscapes/music/towermainlobby1.mp3", 116.324331 },
	},

	[14] = {
		{ "gmodtower/soundscapes/music/towermainlobby1.mp3", 116.324331 },
	},

	// Theater Main
	[32] = {
		{ "GModTower/music/theater.mp3", duration( 10, 35 ) },
	},

	// Arcade
	[58] = {
		{ "GModTower/music/arcade.mp3", duration( 3, 56 ) },
	},

	[55] = {
		{ "GModTower/minigolf/music/waiting1.mp3", duration( 0, 32 ) },
		{ "GModTower/minigolf/music/waiting3.mp3", duration( 0, 33 ) },
		{ "GModTower/minigolf/music/waiting5.mp3", duration( 0, 36 ) },
	},

	[54] = {
		{ "GModTower/sourcekarts/music/island_race2.mp3", duration( 3, 34 ) },
		{ "GModTower/sourcekarts/music/raceway_race1.mp3", duration( 2, 12 ) },
		{ "GModTower/sourcekarts/music/island_race3.mp3", duration( 3, 41 ) },
	},

	[53] = {
		{ "GModTower/pvpbattle/startofcolonyround.mp3", duration( 3, 52 ) },
		{ "GModTower/pvpbattle/startofoneslipround.mp3", duration( 5, 59 ) },
		{ "GModTower/pvpbattle/startoffrostbiteround.mp3", duration( 4, 13 ) },
	},

	[52] = {
		{ "GModTower/balls/midori_vox.mp3", duration( 4, 19 ) },
		{ "GModTower/balls/ballsmusicwmemories.mp3", duration( 4, 20 ) },
		{ "GModTower/balls/ballsmusicwsky.mp3", duration( 1, 23 ) },
		{ "GModTower/balls/ballsmusicwwater.mp3", duration( 3, 25 ) },
	},

	[51] = {
		{ "uch/music/round/round_music2.mp3", duration( 2, 14 ) },
		{ "uch/music/round/round_music3.mp3", duration( 0, 50 ) },
		{ "uch/music/round/round_music7.mp3", duration( 1, 43 ) },
	},

	[49] = {
		{ "gmodtower/zom/music/music_round2.mp3", duration( 4, 0 ) },
		{ "gmodtower/zom/music/music_round5.mp3", duration( 4, 1 ) },
		{ "gmodtower/zom/music/music_waiting3.mp3", duration( 0, 30 ) },
	},

	[50] = {
		{ "gmodtower/virus/roundplay2.mp3", duration( 2, 0 ) },
		{ "gmodtower/virus/roundplay4.mp3", duration( 2, 6 ) },
		{ "gmodtower/virus/roundplay3.mp3", duration( 2, 0 ) },
	},

}



IsPlaying = false

CurID = 0
LastID = 0

CurMusic = nil
CurMusicTime = nil
CurMusicEndTime = 0

CurMusicVolume = 20

CurMusicFading = false
CurMusicFadingVolume = 0

function Ambiance:SetupBGM( id )

	if !self.Enabled:GetBool() then return end

    if self.CurMusic then
        self.CurMusic:ChangeVolume(0, 8)
    end

	local songData = self:GetSongData( id )

	self.SongData = songData
	self.CurID = id
	self.CurMusic = CreateSound( LocalPlayer(), songData[1] )
	self.CurMusicTime = songData[2]

end

function Ambiance:GetSongData( id )

	local songData = self.Music[ id ]

	// Handle multiple songs per location
	if type( songData ) == "table" then
		local rand = math.random( 1, #songData )

		songData = songData[rand]
	end

	return songData

end

function Ambiance:PlayBGM( volume )

	if !self.Enabled:GetBool() then return end
	if !self.CurMusic then return end

	self.CurMusic:Stop()
	self.CurMusic:PlayEx( volume or 1, 100 )
	self.CurMusicVolume = volume or 1

	self.IsPlaying = true

	self.CurMusicEndTime = CurTime() + self.SongData[2]

end

function Ambiance:CheckSetting()

	if !Ambiance.Enabled:GetBool() then
		self:StopBGM()
	end
	/*else
		if !self.IsPlaying then
			self:FadeInBGM( Ambiance.PreferredVolume:GetInt() * .01 )
		end
	end*/

end

function Ambiance:ThinkBGM()

	if !self.CurMusic then return end

	self:CheckSetting()

	if !Ambiance.Enabled:GetBool() then return end

	if CurTime() > self.CurMusicEndTime then
		self:PlayBGM()
	end

	self:ThinkBGMFade()

end

function Ambiance:ThinkBGMFade()

	if !self.CurMusicFading then return end

	if self.CurMusicFadingVolume != self.CurMusicVolume then

		local volume = self.CurMusicVolume or 0
		local fadeVolume = self.CurMusicFadingVolume or 0

		volume = math.Approach( volume, fadeVolume, .0015 )
		self:SetVolumeBGM( volume )

		if volume == 0 then
			self.CurMusic = nil
		end

	else
		self.CurMusicFading = false
	end

end

function Ambiance:FadeInBGM( volume )

	if !self.Enabled:GetBool() then return end

	if !self.CurMusic then return end

	//self:SetVolumeBGM( 0.0079 ) // this is a hack, setting to zero will reset the song!
	self:PlayBGM( 0 )

	self.CurMusicFading = true
	self.CurMusicFadingVolume = volume

end

function Ambiance:SetDefaultBGM( id )

	//if self.CurID == id then return end

	self:SetupBGM( id )
	self:FadeInBGM( self.PreferredVolume:GetInt() * .01 )

end

function Ambiance:SetVolumeBGM( volume )

	if !self.Enabled:GetBool() then return end

	if !self.CurMusic then return end

	self.CurMusicVolume = volume
	self.CurMusic:ChangeVolume( volume, 0 )

end

function Ambiance:FadeOutBGM()

	if !self.Enabled:GetBool() then return end

	if !self.CurMusic then return end

	if !self.CurMusic:IsPlaying() then return end

	self.CurMusic:FadeOut(1)
	/*self.CurMusicFading = true
	self.CurMusicFadingVolume = 0
	self.IsPlaying = false
	self.LastID = self.CurID*/
	//self.CurID = 0
	//self.CurMusicFadingVolume = 0.0079 // this is a hack, setting to zero will reset the song!

end

function Ambiance:StopBGM()

	if !self.CurMusic then return end

	self.CurMusic:Stop()
	self.CurMusic = nil
	self.IsPlaying = false
	self.LastID = self.CurID
	//self.CurID = 0

end

function Ambiance:ALocation()
	if Ambiance.Enabled:GetBool() then

		loc = LocalPlayer():Location()

		// Find ambiance based on the location ID
		local nextID = 0
		for id, tbl in pairs( Ambiance.Music ) do

			if loc == id then
				nextID = id
			end

			// Handle Plaza
			if nextID == 18 || nextID == 20 || nextID == 29 || nextID == 57 || nextID == 21 || nextID == 22 || nextID == 37 || nextID == 27 || nextID == 23 || nextID == 45 || nextID == 24 || nextID == 19 || nextID == 16 || nextID == 47 || nextID == 44 || nextID == 42 || nextID == 28 || nextID == 36 || nextID == 43 || nextID == 46 || nextID == 48 then
				nextID = 17
			end

			// Handle Station
			if nextID == 39 || nextID == 40 then
				nextID = 38
			end

			// Handle Tower Lobby
			if nextID == 14 then
				nextID = 15
			end

		end

		// Don't set the same ID
		if Ambiance.CurID == nextID then return end

		// Set the song
		if nextID != 0 then
			Ambiance:SetDefaultBGM( nextID )
		else
			// No song, fade whatever we have out
			if Ambiance.IsPlaying then
				Ambiance:FadeOutBGM()
			end
		end

	end
end

/*hook.Add( "InitPostEntity", "AmbianceInitPostEntity", function()

	if !Ambiance.Enabled:GetBool() then return end

	Ambiance:SetupBGM( 1 )
	Ambiance:PlayBGM( 0 )

end )*/

hook.Add( "Think", "AmbianceThink", function()

	Ambiance:ALocation()
	Ambiance:ThinkBGM()

end )

usermessage.Hook( "AmbianceMessage", function( um )

	local id = um:ReadChar()

	if id == 1 then // Play

		local vol = um:ReadChar()
		Ambiance:PlayBGM( vol )

	elseif id == 2 then // Stop

		Ambiance:StopBGM()

	elseif id == 3 then // Fade in

		local vol = um:ReadChar()
		Ambiance:FadeInBGM( vol )

	elseif id == 4 then // Fade out

		Ambiance:FadeOutBGM()

	elseif id == 5 then // Setup new BGM

		local num = um:ReadChar()
		Ambiance:SetupBGM( num )

	elseif id == 6 then // Play a single sound

		if Ambiance.Enabled:GetBool() then

			local num = um:ReadChar()
			local snd = Ambiance.Sounds[num]
			if snd then
				surface.PlaySound( snd )
			end

		end

	end

end )

/*hook.Add( "MikuOpenStore", "AmbianceStoreOpen", function()

	if Ambiance.Enabled:GetBool() then

		Ambiance.LastID = Ambiance.CurID
		LocalPlayer():ChatPrint( Ambiance.LastID )

		Ambiance:SetupBGM( 0 )
		Ambiance:FadeInBGM( Ambiance.PreferredVolume:GetInt() * .01 )

	end

end )

hook.Add( "MikuCloseStore", "AmbianceStoreClose", function()

	if Ambiance.Enabled:GetBool() then

		if Ambiance.LastID then
			LocalPlayer():ChatPrint( Ambiance.LastID )
			Ambiance:SetupBGM( Ambiance.LastID )
			Ambiance:FadeInBGM( Ambiance.PreferredVolume:GetInt() * .01 )
		end

		Ambiance:FadeOutBGM()

	end

end )*/

/*hook.Add( "Location", "AmbianceLocation", function( ply, loc )

	if LocalPlayer() != ply then return end

	if Ambiance.Enabled:GetBool() then

		// Find ambiance based on the location ID
		local nextID = 0
		for id, tbl in pairs( Ambiance.Music ) do

			if loc == id then
				nextID = id
			end

			// Handle gamemodes
			if nextID == 36 || nextID == 37 then
				nextID = 35
			end

		end

		// Don't set the same ID
		if Ambiance.CurID == nextID then return end

		// Set the song
		if nextID != 0 then
			Ambiance:FadeOutBGM()
			Ambiance:SetDefaultBGM( nextID )
		else
			// No song, fade whatever we have out
			if Ambiance.IsPlaying then
				Ambiance:FadeOutBGM()
			end
		end

	end
end )*/

Ambiance.Enabled = CreateClientConVar( "gmt_ambiance_enable", "1", true, false )
Ambiance.PreferredVolume = CreateClientConVar( "gmt_ambiance_volume", "20", true, false )

Ambiance.IsPlaying = false

Ambiance.CurID = 0
Ambiance.LastID = 0

Ambiance.CurMusic = nil
Ambiance.CurMusicTime = nil
Ambiance.CurMusicEndTime = 0

Ambiance.CurMusicVolume = 20

Ambiance.CurMusicFading = false
Ambiance.CurMusicFadingVolume = 0