AddCSLuaFile()

ENT.PrintName = "NPC"
ENT.Type = "anim"
ENT.Selling = {
}


function ENT:Initialize()
    if CLIENT then return end

    self:SetModel("models/humans/gmtsui1/male_07.mdl")
    self:SetSequence(self:LookupSequence("lineidle01"))
    self:PhysicsInitBox(Vector(-16, -16, 0), Vector(16, 16, 64))
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then
		phys:EnableMotion( false )
	end
end

function ENT:Use(ply)
    net.Start("shop_open")
    net.WriteEntity(self)
    net.WriteTable(self.Selling or {
        ["build"] = 400
    })
    net.Send(ply)
end

ENT.AutomaticFrameAdvance = true
function ENT:Think()
    self:NextThink(CurTime())
    self:SetFlexScale(1)
    return true
end

if SERVER then
util.AddNetworkString("shop_open")
concommand.Add("buy", function(ply, _, args)
    local item, cost = args[1], args[2]

    if !item or !cost then return end

    cost = tonumber(cost)

    if !ply:canAfford(cost) then return end
    
    ply:GiveItem(item)
    ply:AddMoney(-cost)
    ply:EmitSound("gmodtower/stores/purchase.wav")
end)
return end

net.Receive("shop_open", function()
    local ent = net.ReadEntity()
    local shop = net.ReadTable()

    if IsValid(store) then
        store:Remove()
    end

    store = vgui.Create("DFrame")
    store:SetSize(640, 36 + table.Count(shop) * 44)
    store:Center()
    store:MakePopup()
    local scroll = vgui.Create("DScrollPanel", store)
    scroll:Dock(FILL)

    store:SetAlpha(0)
    store:AlphaTo(255, 0.2)
    store:SetPos(ScrW() / 2 - store:GetWide() / 2, ScrH() / 2 - store:GetTall())
    store:MoveTo(store:GetPos(), ScrH() / 2 - store:GetTall() / 2, 0.4, 0, 0.4)

    timer.Simple(0.1, function()
        for _, item in pairs(shop) do
            local item2 = Items[_]
            local i = scroll:Add("DPanel")
            i:SetSize(scroll:GetWide(), 40)
            i:Dock(TOP)
            i:DockMargin(0, 4, 0, 0)

            i:SetText("")
            i.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 100, 200))

                if self.mdl then
                    self.mdl:PaintManual()
                end

                draw.SimpleText(item2.Name, "DermaLarge", 2, h / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

                draw.SimpleText(item .. "GMC", "DermaLarge", w / 2 + 120, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            i2 = vgui.Create("DButton", i)
            i2:SetText("BUY")
            i2:SetFontInternal("DermaLarge")
            i2:Dock(RIGHT)

            if item2.Model then
                local mdl = vgui.Create("SpawnIcon", i)
                mdl:SetMouseInputEnabled(false)
                mdl:SetSize(i:GetWide() / 2, i:GetWide() / 2)
                mdl:SetPos(i:GetWide() / 2 - mdl:GetWide() / 1.44, -i:GetTall() * 2)
                mdl:SetModel(item2.Model)
                i.mdl = mdl
                mdl:SetPaintedManually(true)
            end
        end
    end)
end)