local PANEL = {}
PANEL.DEBUG = false

local BackSelect = surface.GetTextureID( "inventory/inv_item_extended" )

local GhostEntity = nil

local BackgroundColor = Color(255, 255, 255, 150)
local SelectedBackgroundColor = Color(155, 255, 155, 255)

surface.CreateFont( "InvTinyText", { font = "Oswald", size = 16, weight = 400 } )

function PANEL:Init()
    self.ReadyToDraw = true
    self.CanDrawBackground = true
    self.Id = nil
    self.ItemName = ""
    self.CanEntCreate = true

    self.OriginX = 0
    self.OriginY = 0

    self.Ticker = draw.NewTicker(4, 2, math.random(2, 3))

    self.MouseRotation = 0

    self.FuncDrawItem = EmptyFunction
    self.NormalPaint = self.Paint
    self.ItemBackgroundColor = BackgroundColor

    self.BaseClass.Init(self)

    self:SetSize(GTowerItems.InvItemSize, GTowerItems.InvItemSize)
end

function PANEL:DrawName()
    local x, y = 2, 2
	local w, h = self:GetWide(), 16

	surface.SetDrawColor( 0, 0, 0, 100 )

	--render.SetScissorRect( self.x + x, self.y + y, x + w, y + h, true )
		surface.DrawRect( x, y, w, h )
		draw.TickerText( string.upper( tostring( self.ItemName ) ), "InvTinyText", Color( 255, 255, 255 ), self.Ticker, self:GetWide() )
	--render.SetScissorRect( 0, 0, 0, 0, false )
end

local gradient = surface.GetTextureID("vgui/gradient_up")

function PANEL:DrawBackground()
    surface.SetDrawColor(
		self.ItemBackgroundColor.r,
		self.ItemBackgroundColor.g,
		self.ItemBackgroundColor.b,
		self.ItemBackgroundColor.a
	)
	surface.SetTexture( BackSelect )
	surface.DrawTexturedRect( 0, 0, 64, 64 )
end

function PANEL:Paint(w, h)
    if self.CanDrawBackground or self:IsDragging() then
        self:DrawBackground()
    end

    self:FuncDrawItem()
end

function PANEL:RemoveEntity()
    if IsValid(self.Entity) then
        self.ModelName = ""
        self.Entity:Remove()
        self.Entity = nil
    end
end

function PANEL:ResetDrawing()
    self.ItemName = ""
    self.PaintOver = EmptyFunction
end

function PANEL:ItemPaintOver()
    local Item = self:GetItem()

    if Item then
        Item:PaintOver(self)
    end
end

function PANEL:OnModelCreated()
    local Item = self:GetItem()

    if Item then
        local look, cam = Item:GetRenderPos(self.Entity)
        local t = PositionSpawnIcon(self.Entity, self.Entity:GetPos(), false)
        self:SetCamAng(t.angles or self.Entity:WorldSpaceCenter())
        self:SetCamPos(t.origin)
        self:SetFOV(t.fov)
    end
end

function PANEL:PerformLayout()
    local Item = self:GetItem()

    if Item then
        --Draw client side model
        if Item.DrawModel == true then
            self:SetModel(Item.Model, Item.ModelSkinId, false, 1, Item.ModelColor)
            self.FuncDrawItem = self.BaseClass.Paint

            if self.DEBUG then
                Msg("Item(" .. self.Id .. "/" .. Item.Model .. ") drawing model\n")
            end
        else
            self:RemoveEntity()

            --Draw the custom item set by item
            if type(Item.Draw) == "function" then
                self.FuncDrawItem = self.DrawCustomItem

                if self.DEBUG then
                    Msg("Item(" .. self.Id .. ") drawing custom\n")
                end
            else
                self.FuncDrawItem = EmptyFunction

                if self.DEBUG then
                    Msg("Item(" .. self.Id .. ") drawing normal\n")
                end
            end
        end

        if Item.DrawName == true or self.DEBUG then
            self.ItemName = Item.Name
            self.PaintOver = self.DrawName
        elseif Item.PaintOver then
            self.PaintOver = self.ItemPaintOver
        else
            self:ResetDrawing()
        end

        if Item.DrawSelected and Item:DrawSelected() then
            self.ItemBackgroundColor = SelectedBackgroundColor
        else
            self.ItemBackgroundColor = BackgroundColor
        end

        if self:IsMouseInWindow() then
            self:ShowToolTip()
        end

        self.CanEntCreate = Item.CanEntCreate
    else
        self.ItemBackgroundColor = BackgroundColor
        self.FuncDrawItem = EmptyFunction
        self:ResetDrawing()
        self:RemoveEntity()
    end

    if self.DEBUG then
        Msg("Main item: Performing layout, ITEM: " .. tostring(self.Id) .. "/" .. tostring(Item) .. "\n")
    end
end

function PANEL:DrawCustomItem()
    local Item = self:GetItem()

    if Item then
        Item:Draw(self)
    end
end

function PANEL:OpenMenu()
    local Item = self:GetItem()
    local CommandId = self:GetCommandId()
    if not Item then return end
    local Price = Item.StorePrice or 0

    local Menu = {
        [1] = {
            ["type"] = "text",
            ["Name"] = Item.Name,
            ["order"] = -10,
            ["closebutton"] = true
        }
    }

    if Item.CanUse and Item.EquipType ~= "Model" then
        table.insert(Menu, {
            ["Name"] = Item.UseDesc or "Use",
            ["function"] = function()
                RunConsoleCommand("gmt_invuse", CommandId, 1)
                hook.Call("InventoryUse", GAMEMODE, CommandId)
            end
        })
    end

    if Item.CanSecondaryUse then
        table.insert(Menu, {
            ["Name"] = Item.SecondaryUseDesc or "Secondary Use",
            ["function"] = function()
                RunConsoleCommand("gmt_invuse", CommandId, 2)
                hook.Call("InventoryUse", GAMEMODE, CommandId)
            end
        })
    end

    local HookTable = hook.GetTable().InvExtra

    if HookTable then
        for _, v in pairs(HookTable) do
            local b, rtn = pcall(v, Item)

            if b then
                table.insert(Menu, rtn)
            else
                ErrorNoHalt(rtn)
            end
        end
    end

    if Item.ExtraMenuItems then
        Item:ExtraMenuItems(Menu, CommandId)
    end

    if Item.CanRemove then
        local Name = "Discard"
        local SellPrice = Item:SellPrice()

        if SellPrice > 0 then
            Name = "Sell for " .. string.FormatNumber(SellPrice) .. " GMC"
        end

        table.insert(Menu, {
            ["Name"] = Name,
            ["canclose"] = true,
            ["sub"] = {
                [1] = {
                    ["Name"] = "Yes",
                    ["function"] = function()
                        RunConsoleCommand("gmt_invremove", CommandId)
                        hook.Call("InventoryRemove", GAMEMODE, CommandId)
                    end
                }
            }
        })
    end

    if !string.find(CommandId, "-2") then
        --Msg( CommandId )
        table.insert(Menu, {
            ["Name"] = "Send To Trunk",
            ["canclose"] = true,
            ["sub"] = {
                [1] = {
                    ["Name"] = "Yes",
                    ["function"] = function()
                        RunConsoleCommand("gmt_invtobank", CommandId)
                        hook.Call("InventoryRemove", GAMEMODE, CommandId)
                    end
                }
            }
        })
    end

    if #Menu > 1 and not self:IsDragging() then
        GTowerMenu:OpenMenu(Menu)
    end
end

function PANEL:OnMousePressed(mc)
    if mc == MOUSE_RIGHT then
        self:OpenMenu()

        return
    end

    local Item = self:GetItem()

    if Item then
        self:StartDrag()
    end
end

function PANEL:OnMouseReleased(mc)
    if self:IsDragging() then
        self:CheckDropItem()
        self:StopDrag()
    end
end

function PANEL:OnCursorEntered()
    self:ShowToolTip()
end

function PANEL:ShowToolTip()
    --Show tooltip if tem exists
    local Item = self:GetItem()

    if Item then
        GTowerItems:ShowTooltip(Item.Name, Item.Description, self)
    end
end

function PANEL:OnCursorExited()
    GTowerItems:HideTooltip()
    GTowerItems:CheckSubClose()
end

function PANEL:OnMouseWheeled(delta)
    local amt = 15
    local shift = input.IsKeyDown(KEY_LSHIFT)

    if shift then
        amt = 1
    end

    self.MouseRotation = math.NormalizeAngle(self.MouseRotation + delta * amt)

    if not shift then
        -- try to snap to world axes
        for i = -180, 180, 90 do
            if self.MouseRotation > i - 15 and self.MouseRotation < i + 15 then
                self.MouseRotation = i
                break
            end
        end
    end

    self:DragUpdateRotation()
end

--[[===========================

 == External functions

=============================]]
function PANEL:IsEquipSlot()
    return GTowerItems:IsEquipSlot(self.Id)
end

function PANEL:IsCosmeticSlot()
    return false //GTowerItems:IsCosmeticSlot(self.Id)
end

PANEL.Equippable = PANEL.IsEquipSlot

function PANEL:OriginalPos(x, y)
    self.OriginX = x
    self.OriginY = y

    if self.DEBUG then
        Msg("New item(" .. self.Id .. ") position: " .. x .. " " .. y .. "\n")
    end

    self:ForcePosition()
end

--[[===========================

 == Internal functions

=============================]]
function PANEL:SetId(id)
    self.Id = id
    self:UpdateDrawBackground()
end

function PANEL:UpdateDrawBackground()
    self.CanDrawBackground = true --self:IsEquipSlot() == false
end

function PANEL:ForcePosition()
    self:SetPos(self.OriginX, self.OriginY)
end

function PANEL:IsMouseInWindow()
    local x, y = self:CursorPos()

    return x >= 0 and y >= 0 and x <= self:GetWide() and y <= self:GetTall()
end

function PANEL:UpdateParent()
    if self:IsDragging() then return end
    local parent = self:GetOriginalParent()

    if parent then
        self:SetParent(parent)
        self:SetVisible(true)
    else
        self:SetVisible(false)
    end
end

function PANEL:GetCursorParent()
    if GTowerItems.MainInvPanel and GTowerItems.MainInvPanel:IsMouseInWindow() then return GTowerItems.MainInvPanel end
    if GTowerItems.DropInvPanel and GTowerItems.DropInvPanel:IsMouseInWindow() then return GTowerItems.DropInvPanel end
    local Tbl = hook.GetTable().GTowerInvHover

    if Tbl then
        for k, v in pairs(Tbl) do
            local b, ret = pcall(v, self)

            if b then
                if ret then return ret end
            else
                Msg("Inventory: GetCursorParent: COULD NOT CALL: " .. k .. " (" .. ret .. ")\n")
            end
        end
    end

    return nil
end

--[[===========================

 == DRAGGING

=============================]]
function PANEL:StartDrag()
    if self:OnStartDrag() == true then return end

    //self.ReadyToDraw = true

    self.Think = self.DraggingThink
    self.DragCanDrop = false
    self.GhostHitNormal = Vector(0, 0, 1)
    self.MouseRotation = self.ForceRotation or 0
    self:SetParent(nil)

    --self:UpdateModel()
    self:SetAlpha(125)
    self:SetZPos(1000) -- Keep this above EVERYTHING

    self.BackupCheckParentLimit = self.CheckParentLimit
    self.CheckParentLimit = nil

    if self.DEBUG then
        Msg2("Start dragging object")
    end
end

function PANEL:StopDrag()
    self:DragDestroyEntity()

    if self:OnStopDrag() == true then
        GTowerItems:HideTooltip()

        return
    end

    -- Remove invalid drops
    for k, v in pairs(GTowerItems.ClientItems[1]) do
        if v._VGUI then
            v._VGUI.InvalidDrop = nil
            v._VGUI.HighlightDrop = nil
        end
    end

    self.Think = EmptyFunction
    self:SetAlpha(255)
    self:UpdateParent()
    self:ForcePosition()
    self:SetZPos(0)
    self.CheckParentLimit = self.BackupCheckParentLimit

    if self.DEBUG then
        Msg2("STOP dragging")
    end
end

function PANEL:IsDragging()
    return self.Think == self.DraggingThink
end

function PANEL:DraggingThink()
    local Parent = self:GetCursorParent()
    self:SetPos(gui.MouseX() - self:GetWide() / 2, gui.MouseY() - self:GetTall() / 2)

    -- Rotate with keys
    if input.IsKeyDown(KEY_MINUS) or input.IsKeyDown(KEY_PAD_MINUS) then
        self.MouseRotation = math.NormalizeAngle(self.MouseRotation + 1 * 2)
    elseif input.IsKeyDown(KEY_EQUAL) or input.IsKeyDown(KEY_PAD_PLUS) then
        self.MouseRotation = math.NormalizeAngle(self.MouseRotation + -1 * 2)
    end

    -- Dragging into world, create ghost
    if not Parent then
        if self.CanEntCreate then
            if not GhostEntity then
                self:UpdateModel()
            end

            self:DraggingEntThink()

            -- Rotate with keys
            if input.IsKeyDown(KEY_MINUS) or input.IsKeyDown(KEY_PAD_MINUS) then
                self.MouseRotation = math.NormalizeAngle(self.MouseRotation + 1 * 5)
            elseif input.IsKeyDown(KEY_EQUAL) or input.IsKeyDown(KEY_PAD_PLUS) then
                self.MouseRotation = math.NormalizeAngle(self.MouseRotation + -1 * 5)
            end
        end

        return
    end

    -- Dragging onto items, remove ghost
    self:CheckHoverItem()

    if GhostEntity then
        self:DragDestroyEntity()
    end
end

function PANEL:UpdateModel()
    local Item = self:GetItem()
    if not Item then return end

    if Item.Model and util.IsValidModel(Item.Model) then
        if not GhostEntity then
            self:DragCreateEntity(Item)
        else
            GhostEntity:SetModel(Item.Model)
            GhostEntity:SetSkin(Item.ModelSkinId or 1)
        end
    else
        Msg("Model for item: " .. tostring(Item.Name) .. " (" .. tostring(Item.Model) .. ") is invalid!\n")
    end
end

function PANEL:DragCreateEntity(item)
    if not GhostEntity then
        GhostEntity = ClientsideModel(item.Model)
    end

    GhostEntity:SetModel(item.Model)
    GhostEntity:SetSkin(item.ModelSkinId or 1)
    GhostEntity:SetSolid(SOLID_VPHYSICS)
    GhostEntity:SetMoveType(MOVETYPE_NONE)
    GhostEntity:SetNotSolid(true)
    GhostEntity:SetColor(Color(255, 100, 100, 150))
    GhostEntity:SetRenderMode(RENDERMODE_TRANSALPHA)
    GhostEntity.Item = item
    GhostEntity._GTInvSQLId = item.MysqlId

    if self.DEBUG then
        Msg2("Creating ghost entity with model: " .. item.Model)
    end
end

function PANEL:DragDestroyEntity()
    if IsValid(GhostEntity) then
        GhostEntity:Remove()
    end

    GhostEntity = nil
end

function PANEL:DragUpdateRotation()
    if not self.GhostHitNormal then return end
    local BaseAngle = self.GhostHitNormal:Angle()

    if AngleWithinPrecisionError(BaseAngle.p, 270) or AngleWithinPrecisionError(BaseAngle.p, 90) then
        BaseAngle.y = 0
    end

    BaseAngle:RotateAroundAxis(BaseAngle:Right(), -90)
    BaseAngle:RotateAroundAxis(BaseAngle:Up(), self.MouseRotation)

    if IsValid(GhostEntity) then
        local itm = GhostEntity.Item
        local Pos = GhostEntity:GetPos()

        if itm.Manipulator then
            itm.Manipulator(BaseAngle, Pos, self.GhostHitNormal)
        end

        GhostEntity:SetAngles(BaseAngle)
    end
end

function PANEL:GetTrace()
    local ply = LocalPlayer()

    return util.QuickTrace(ply.CameraPos, GetMouseVector() * GTowerItems.MaxDistance, self:GetTraceFilter())
end

function PANEL:CheckTraceHull()
    return GTowerItems:CheckTraceHull(GhostEntity, self:GetTraceFilter())
end

function PANEL:DraggingEntThink()
    if not IsValid(GhostEntity) then return end
    local Trace = self:GetTrace()
    local min = GhostEntity:OBBMins()

    if Trace.Hit and self:AllowDrop(Trace) then
        self.GhostHitNormal = Trace.HitNormal

        if Trace.HitTexture == "**displacement**" then
            self.GhostHitNormal = Vector(0, 0, 1)
        end

        GhostEntity:SetColor(Color(100, 255, 100, 190))
    else
        self.GhostHitNormal = Vector(0, 0, 1)
        GhostEntity:SetColor(Color(255, 100, 100, 190))
    end

    self:DragUpdateRotation()

    GTowerItems.NewPos = Trace.HitPos - self.GhostHitNormal * min.z

    local itm = GhostEntity.Item
    local BaseAngle = GhostEntity:GetAngles()

    if itm.Manipulator then
        GTowerItems.NewPos = itm.Manipulator(BaseAngle, GTowerItems.NewPos, self.GhostHitNormal)
    end

    if GTowerItems.Snapping:GetBool() then
        local snap = math.Clamp(GTowerItems.Snapping:GetInt(), 2, 16)
        GTowerItems.NewPos.x = math.Round(GTowerItems.NewPos.x / snap) * snap
        GTowerItems.NewPos.y = math.Round(GTowerItems.NewPos.y / snap) * snap
        //NewPos.z = math.Round(NewPos.z / snap) * snap
    end

    GhostEntity:SetPos(GTowerItems.NewPos)

    if not self:CheckTraceHull() then
        GhostEntity:SetColor(Color(255, 100, 100, 190))
    end
end

function PANEL:CheckHoverItem()
    local VguiDrop = nil

    -- Find the slot we're hovering over
    for k, v in pairs(GTowerItems.ClientItems[1]) do
        if v._VGUI and self ~= v._VGUI and v._VGUI:IsEquipSlot() then
            if v._VGUI:IsMouseInWindow() then
                VguiDrop = v._VGUI
            else
                v._VGUI.InvalidDrop = nil
            end
        end
    end

    if not VguiDrop then
        for k, v in pairs(GTowerItems.ClientItems[1]) do
            if v._VGUI then
                v._VGUI.HighlightDrop = nil
            end
        end

        return
    end

    if VguiDrop.InvalidDrop == self then return end
    local Item = self:GetItem()

    if Item then
        -- Check equippables
        --if !GTowerItems:AllowPositionClient( Item, VguiDrop ) then
        --VguiDrop.InvalidDrop = self
        --return
        --end
        -- Check for unique euqippables
        if Item.UniqueEquippable then
            for k, v in pairs(GTowerItems.ClientItems[1]) do
                if v._VGUI and v._VGUI:IsEquipSlot() and self ~= v._VGUI then
                    local OtherItem = v._VGUI:GetItem()

                    -- Find a matching equiptype
                    if OtherItem and OtherItem.EquipType == Item.EquipType then
                        VguiDrop.InvalidDrop = self
                        v._VGUI.HighlightDrop = true

                        return
                    end
                end
            end
        end
    end

    VguiDrop.InvalidDrop = nil
end

function PANEL:CheckDropItem()
    local Parent = self:GetCursorParent()

    if self.DEBUG then
        Msg2("Checking drop item: " .. tostring(Parent))
    end

    -- Drop in the world
    if Parent == nil then
        local Trace = self:GetTrace()

        if Trace.Hit then
            local AimPos = GetMouseVector()
            self:OnDropFloor(self.MouseRotation, AimPos, LocalPlayer().CameraPos)
        end

        return
    end

    -- Drop on a slot
    local VguiDrop = hook.Call("InvGuiDrop", GAMEMODE, self)
    if VguiDrop and self:OnSlotDrop(VguiDrop) == true then return end
    if self:FinalDrop() == true then return end

    if Parent.CheckDrop then
        Parent:CheckDrop(self)
    end
end

--[[===========================

 == THINGS TO BE OVERWRITTEN WHEN NECESSARY

=============================]]
function PANEL:GetItem()
    return self.Id and GTowerItems:GetItem(self.Id)
end

function PANEL:GetCommandId()
    return self.Id .. "-1"
end

function PANEL:OnDropFloor(Rotation, AimPos)
    local ShootPos = LocalPlayer().CameraPos
    RunConsoleCommand("gm_invspawn", self:GetCommandId(), Rotation, AimPos.x, AimPos.y, AimPos.z, ShootPos.x, ShootPos.y, ShootPos.z)
    hook.Call("InventoryDrop", GAMEMODE, self:GetCommandId())

    if self.DEBUG then
        Msg2("Dropping entity: " .. tostring(self.Id))
    end
end

function GTowerItems:AllowPositionClient(item, panel)
    if not panel:IsEquipSlot() then return true end -- Allow normal slots always
    -- Is a weapon, don't allow in wearable slot
    if panel:IsCosmeticSlot() and item:IsWeapon() then return false end
    -- Allow all other equippables
    if item.Equippable then return true end
end

function PANEL:AllowPosition(panel)
    local Item = self:GetItem()

    if Item then
        if not GTowerItems:AllowPositionClient(Item, panel) then return false end
    end

    return true
end

function PANEL:OnSlotDrop(panel)
    if panel:AllowPosition(self) and self:AllowPosition(panel) then
        if self.DEBUG then
            Msg2("On slot drop: " .. tostring(self:GetCommandId()) .. " | " .. tostring(panel:GetCommandId()))
        end

        RunConsoleCommand("gm_invswap", self:GetCommandId(), panel:GetCommandId())
        hook.Call("InventorySwap", GAMEMODE, self:GetCommandId(), panel:GetCommandId())

        return true
    end
end

function PANEL:GetTraceFilter()
    return LocalPlayer()
end

function PANEL:OnStopDrag()
end

function PANEL:FinalDrop()
end

function PANEL:AllowDrop()
    return true
end

function PANEL:GetOriginalParent()
    return GTowerItems:GetOriginalParent(self.Id)
end

function PANEL:OnStartDrag()
    GTowerItems:OpenDropInventory()
end

vgui.Register("GTowerInvItem", PANEL, "DModelPanel2")

concommand.Add("gmt_invtracehull", function(ply)
    if not ply:IsValid() then return end

    if IsValid(GhostEntity) then
        PrintTable(GTowerItems:TraceHull(GhostEntity))
    end
end)
