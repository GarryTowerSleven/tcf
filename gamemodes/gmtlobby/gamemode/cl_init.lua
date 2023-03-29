include("shared.lua")

// Create GMT fonts
surface.CreateFont( "tiny", { font = "Arial", size = 10, weight = 100 } )
surface.CreateFont( "smalltiny", { font = "Arial", size = 12, weight = 100 } )
surface.CreateFont( "small", { font = "Arial", size = 14, weight = 400 } )
surface.CreateFont( "smalltitle", { font = "Arial", size = 16, weight = 600 } )

local mainFont = "CenterPrintText"
surface.CreateFont( "GTowerhuge", { font = mainFont, size = 45, weight = 100 } )
surface.CreateFont( "GTowerbig", { font = mainFont, size = 28, weight = 125 } )
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

inv = inv or {}

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
	surface.SetDrawColor( 70, 100, 150, 255 )
	surface.DrawRect( 0, 0, ew, 3 )
	draw.RoundedBox( 3, 0, 0, ew, h, Color(70, 100, 150, 255) )
	
	surface.SetDrawColor( 0, 0, 0, 50 )
	surface.SetTexture( gradient )
	surface.DrawTexturedRect( 0, SlotBarHeight, w, h )
end

for i = 0, #inv - 1 do
    for i2 = 0, #inv[1] - 1 do
        local slot = inv[i + 1][i2 + 1]
        local button = vgui.Create("DButton", panel)
        button:SetSize(slotsize, slotsize)
        button:SetPos(i * slotsize + border / 2, i2 * slotsize + border / 2 + (i2 == 0 and 0 or SlotBarHeight))

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
                surface.SetDrawColor(56, 142, 203, 50)
                surface.SetTexture(gradient)
                surface.DrawTexturedRect(0, 0, w, h)
            end

            local item = inv[self.x2][self.y2]

            if i2 == 0 then
                draw.SimpleText(i + 1, "GTowerHUDMainTiny2", 2, 2, color_white)
            end

            if !item.Name then return end

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
end
