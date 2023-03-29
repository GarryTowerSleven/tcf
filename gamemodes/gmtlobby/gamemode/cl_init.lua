include("shared.lua")

inv = inv or {}

net.Receive("Inventory", function()
    inv = net.ReadTable()
end)

if IsValid(Inventory) then
    Inventory:Remove()
end

local panel = vgui.Create("DPanel")
Inventory = panel
panel:SetSize(600, 400)
panel:CenterHorizontal()

local slotsize = 64
local border = 24

panel:SetSize(slotsize * #inv + border, slotsize * #inv[1] + border)

for i = 0, #inv - 1 do
    for i2 = 0, #inv[1] - 1 do
        local slot = inv[i + 1][i2 + 1]
        local button = vgui.Create("DButton", panel)
        button:SetSize(slotsize, slotsize)
        button:SetPos(i * slotsize + border / 2, i2 * slotsize + border / 2)

        button.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, color_black)
            surface.SetDrawColor(255, 255, 255, 100)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end
    end
end

local _, y = panel:GetPos()
panel:SetPos(_, -panel:GetTall())

function GM:OnSpawnMenuOpen()
    print("!")
    Inventory.Open = true
    gui.EnableScreenClicker(true)
    local _, y = panel:GetPos()
    panel:SetPos(_, -panel:GetTall())
    panel:MoveTo(_, 0, 0.4, 0, 0.4)
    panel:SetAlpha(0)
    panel:AlphaTo(255, 0.4, 0)
end

function GM:OnSpawnMenuClose()
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
