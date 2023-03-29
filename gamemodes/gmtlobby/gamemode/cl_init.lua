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

local gradient = surface.GetTextureID("vgui/gradient_up")

local slotsize = 54
local border = 24 / 2
SlotBarHeight = slotsize

panel:SetSize(slotsize * #inv + border, slotsize * #inv[1] + border)
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
        button:SetPos(i * slotsize + border / 2, i2 * slotsize + border / 2)

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

            local x, y = 2, 2
            local w, h = self:GetWide(), 16
            surface.SetDrawColor(0, 0, 0, 100)
            --render.SetScissorRect( self.x + x, self.y + y, x + w, y + h, true )
            surface.DrawRect(x, y, w, h)
            draw.SimpleText("ITEM", "DermaDefault", x, y, color_white)
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
