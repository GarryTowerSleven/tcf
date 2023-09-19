	surface.CreateFont("VoteTitle", {
    font = "Bebas Neue",
    size = 68,
    weight = 200
})

surface.CreateFont("VoteGMTitle", {
    font = "Bebas Neue",
    size = 40,
    weight = 200
})

surface.CreateFont("VoteCancel", {
    font = "TodaySHOP-MediumItalic",
    size = 40,
    weight = 200
})

surface.CreateFont("VoteTip", {
    font = "Bebas Neue",
    size = 32,
    weight = 200
})

surface.CreateFont("VoteText", {
    font = "Calibri",
    size = 22,
    weight = 20
})

--=======================================================
local PANEL = {}
PANEL.Maps = {}

function PANEL:Init()
    self:ParentToHUD()

    self.Canvas = vgui.Create("Panel", self)
    self.Canvas:MakePopup()
    self.Canvas:SetKeyboardInputEnabled(false)

    self.lblTitle = vgui.Create("DLabel", self.Canvas)
    self.lblGMTitle = vgui.Create("DLabel", self.Canvas)
    self.lblTimer = vgui.Create("DLabel", self.Canvas)
    self.lblTip = vgui.Create("DLabel", self.Canvas)

    self.MapList = vgui.Create("DMapList", self.Canvas)
    self.MapList:SetDrawBackground(false)
    self.MapList:SetSpacing(4)

    self.MapPreview = vgui.Create("DPanel", self.Canvas)

    self.Canvas:Dock(FILL)

    self.Time = RealTime()

    self.VotedMap = nil
    self.HoveredMap = nil

    self.CancelButton = vgui.Create("DPanel", self.Canvas)
    self.CancelButton.Paint = PanelDrawCancelButton

    self.CancelButton.OnMousePressed = function()
        Derma_Query("Are you sure you no longer want to join this server (you will leave your group)?", "Are you sure?", "Yes", function()
            RunConsoleCommand("gmt_mtsrv", 2)
            GTowerServers:CloseChooser()
            RunConsoleCommand("gmt_leavegroup")
        end, "No", EmptyFunction)
    end
end

GamemodePrefixes = {
    ["ballracer_"] = "ballrace",
    ["pvp_"] = "pvpbattle",
    ["virus_"] = "virus",
    ["uch_"] = "ultimatechimerahunt",
    ["zm_"] = "zombiemassacre",
    ["minigolf_"] = "minigolf",
    ["sk_"] = "sourcekarts",
}

function PANEL:SetGamemode(Gamemode)
    print(Gamemode.Maps[math.Rand(1, table.Count(Gamemode.Maps))])
    self.Gamemode = Gamemode
    local map = table.Random(Gamemode.Maps)
    self.HoveredMap = Maps.GetMapData(map)
    self:SetupMaps()
    self:SetupPreview()
end

function PanelDrawCancelButton(self)
    if self.Hovered then
        surface.SetDrawColor(170, 14, 41, 190)
    else
        surface.SetDrawColor(0, 0, 0, 150)
    end

    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
    draw.SimpleText("LEAVE", "VoteCancel", self:GetWide() / 2, self:GetTall() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:PerformLayout()
    self:SetPos(0, 0)
    self:SetSize(ScrW(), ScrH())
    self.Canvas:SetZPos(0)
    self.lblTitle:SetText("SELECT A MAP")
    self.lblTitle:SetFont("VoteTitle")
    self.lblTitle:SetTextColor(color_white)
    self.lblTitle:SizeToContents()
    self.lblTitle:SetPos(ScrW() / 2 - self.lblTitle:GetWide() / 2, 50)
    self.lblGMTitle:SetText(self.Gamemode.Name)
    self.lblGMTitle:SetFont("VoteGMTitle")
    self.lblGMTitle:SetTextColor(color_white)
    self.lblGMTitle:SizeToContents()
    self.lblGMTitle:SetPos(ScrW() / 2 - self.lblGMTitle:GetWide() / 2, 10)
    self.lblTimer:SetText("20")
    self.lblTimer:SetFont("VoteTitle")
    self.lblTimer:SetTextColor(color_white)
    self.lblTimer:SetContentAlignment(5)
    self.lblTimer:SizeToContents()
    self.lblTimer:SetPos(ScrW() - 95, 25)
    self.lblTip:SetText("")
    self.lblTip:SetFont("VoteTip")
    self.lblTip:SetTextColor(color_white)
    self.lblTip:SetContentAlignment(5)
    self.lblTip:SizeToContents()
    self:SetRandomTip()
    self.MapList:SetPos(ScrW() / 4 - self.MapList:GetWide() / 2, 160)
    self.MapList:SetSize(ScrW() / 2, ScrH() - 160)
    self.MapPreview:SetSize(500, 430)
    self.MapPreview:SetPos(ScrW() + self.MapPreview:GetWide(), 160)
    self.MapPreview:MoveTo((ScrW() * (3 / 4)) - self.MapPreview:GetWide() / 2, 160, 0.65)
    self.CancelButton:SetSize(250, 40)
    self.CancelButton:SetPos((ScrW() / 2) - (self.CancelButton:GetWide() / 2), ScrH() + 40)
    self.CancelButton:MoveTo((ScrW() / 2) - (self.CancelButton:GetWide() / 2), ScrH() - 120 - 40 - 20, 0.65)
    self:UpdateVotes()
    self:UpdatePreview()
end

function PANEL:SetupMaps()
    self.MapList:Clear()
    local Gamemode = self.Gamemode
    local maps = self.Gamemode.Maps

    for id, map in pairs(maps) do
        -- Collect map data
        local mapData = Maps.GetMapData(map)
        if not mapData then continue end
        mapData.PreviewIcon = Maps.GetPreviewIcon(map)
        local canPlay = not table.HasValue(GTowerServers.NonPlayableMaps, map)
        -- Setup panel
        local panel = vgui.Create("DPanel", self.MapList)
        panel:SetPaintBackground(false)
        -- Setup main data
        panel.NumVotes = GTowerServers:GetVotes(map)
        panel.Map = map
        panel.Priority = mapData.Priority
        panel.btnMap = vgui.Create("DButton", panel)
        panel.btnMap:SetText(mapData.Name)
        panel.btnMap:SetSize(280, 100)
        panel.btnMap:SetTextColor(color_white)
        panel.btnMap:SetFont("VoteText")
        panel.btnMap:SetContentAlignment(7)
        panel.btnMap:SetTextInset(8, 0)

        if not canPlay then
            panel.btnMap:SetTextColor(Color(255, 255, 255, 100))
            panel.btnMap.Disabled = true
            panel.btnMap:SetToolTip("Map disabled due to play amount.")
        end

        panel.btnMap.OnCursorEntered = function()
            if panel.btnMap.DisableVote then return end
            self.HoveredMap = mapData
            self:UpdatePreview()
        end

        panel.btnMap.OnCursorExited = function()
            if panel.btnMap.DisableVote then return end
            self.HoveredMap = nil
            self:UpdatePreview()
        end

        panel.btnMap.DoClick = function()
            if panel.btnMap.DisableVote then return end

            if panel.btnMap.Disabled then
                Msg2(T("GamemodeCooldown", panel.btnMap:GetText()))
            end

            if GTowerServers:CanStillVoteMap() and not panel.btnMap.Disabled then
                GTowerServers:ChooseMap(map)
                self.VotedMap = mapData
                self:UpdateVotes()
                self:UpdatePreview()
            end
        end

        panel.btnMap.CurProgress = 0
        panel.lblVotes = vgui.Create("DLabel", panel)

        if panel.NumVotes >= 0 then
            panel.lblVotes:SetText(panel.NumVotes)
        else
            panel.lblVotes:SetText("")
        end

        panel.lblVotes:SetPos(panel.btnMap:GetWide() + 5, 3)
        panel.lblVotes:SetTextColor(color_white)
        panel.lblVotes:SetFont("VoteText")
        panel.lblVotes:SetContentAlignment(4)
        panel.lblVotes:SizeToContents()
        self.MapList:AddItem(panel)
    end

    -- Shuffle
    --self.MapList:Shuffle()
    -- Sort by prioirty, if possible
    self.MapList:SortByMember("Priority")
    local panel = vgui.Create("DPanel", self.MapList)
    panel:SetPaintBackground(false)
    panel.lblUndecided = vgui.Create("DLabel", panel)
    panel.lblUndecided:SetText(string.format("%s player(s) haven't cast their vote", #player.GetAll()))
    panel.lblUndecided:SetTextColor(Color(180, 180, 180, 255))
    panel.lblUndecided:SetFont("VoteText")
    panel.lblUndecided:SetContentAlignment(5)
    panel.lblUndecided:SizeToContents()
    self.MapList:AddItem(panel)
end

function PANEL:SetupPreview(map)
    -- Map Preview Container
    local w, h = 500, 500

    self.MapPreview.Paint = function()
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 160))
    end

    -- Map Name
    self.lblMapName = vgui.Create("DLabel", self.MapPreview)
    self.lblMapName:SetText(self.HoveredMap.Name)
    self.lblMapName:SetTextColor(color_white)
    self.lblMapName:SetFont("VoteTitle")
    self.lblMapName:SetTextInset(8, 0)
    self.lblMapName:SetSize(w - 10, 64)
    -- Map Author
    self.lblAuthor = vgui.Create("DLabel", self.MapPreview)
    self.lblAuthor:SetText("Author: " .. self.HoveredMap.Author)
    self.lblAuthor:SetTextColor(color_white)
    self.lblAuthor:SetFont("VoteText")
    self.lblAuthor:SetTextInset(8, 0)
    self.lblAuthor:SetSize(w - 10, 128)
    -- Map icon
    local y = 72
    local realheight = 230
    self.MapIcon = vgui.Create("DImage", self.MapPreview)
    self.MapIcon:SetOnViewMaterial(self.HoveredMap.PreviewIcon)
    --self.MapIcon:SetFailsafeMatName( "maps/gmt_pvp_default.vmt" ) // handled in gamemode definition
    self.MapIcon:SetSize(512, 256)
    self.MapIcon:SetPos(10, y)
    -- Map description
    self.lblDesc = vgui.Create("DLabel", self.MapPreview)
    self.lblDesc:SetText(self.HoveredMap.Desc or "N/A")
    self.lblDesc:SetTextColor(color_white)
    self.lblDesc:SetFont("VoteText")
    --self.lblDesc:SetWidth( 320 )
    self.lblDesc:SetSize(w - 10 * 2, 300)
    y = y + realheight + 10
    self.lblDesc:SetPos(10, y)
    self.lblDesc:SetWrap(true)
    self.lblDesc:SetContentAlignment(7)
end

PANEL.BarPercent = 0
local gradientUp = surface.GetTextureID("VGUI/gradient_up")
local gradientDown = surface.GetTextureID("VGUI/gradient_down")

function PANEL:Paint()
    surface.SetDrawColor(Color(0, 0, 0, 180))
    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
    self.BarPercent = math.Approach(self.BarPercent, 1, .25 / 50)
    surface.SetDrawColor(0, 0, 0, 255)
    surface.DrawRect(0, 0, ScrW(), 120 * self.BarPercent)
    surface.SetTexture(gradientDown)
    surface.DrawTexturedRect(0, 120 * self.BarPercent, ScrW(), 80)
    surface.DrawRect(0, ScrH() - (120 * self.BarPercent), ScrW(), 120)
    surface.SetTexture(gradientUp)
    surface.DrawTexturedRect(0, ScrH() - ((120 + 80) * self.BarPercent), ScrW(), 80)
    local TimeLeft = math.max(GTowerServers.MapEndTime - CurTime(), 0) / GTowerServers.MapTotalTime
    local Width = ScrW() * TimeLeft
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(0, ScrH() - 120 - 12, Width, 12)
end

function PANEL:UpdateVotes()
    -- Get player count from server
    local ServerId = GTowerServers.ChoosenServerId
    local Server = GTowerServers.Servers[ServerId]
    local Players = player.GetAll()

    if Server then
        Players = Server.Players
    end

    for _, panel in pairs(self.MapList:GetItems()) do
        if not panel.btnMap then
            local undecided = #Players - GTowerServers:GetTotalVotes()

            if undecided > 0 then
                panel.lblUndecided:SetText(string.format("%s player(s) haven't cast their vote", undecided))
            else
                panel.lblUndecided:SetText("")
            end

            return
        end

        local NumVotes = GTowerServers:GetVotes(panel.Map)

        if NumVotes ~= 0 then
            panel.lblVotes:SetText(NumVotes)
        else
            panel.lblVotes:SetText("")
        end

        panel.btnMap.Paint = function()
            local x, y = panel.btnMap:GetPos()
            local w, h = panel.btnMap:GetSize()
            local col = Color(0, 0, 0, 120)
            local col_progress = Color(40, 121, 211, 84)

            if panel.btnMap.Disabled or panel.btnMap.DisableVote then
                col = Color(25, 25, 25, 50)
            elseif panel.btnMap.Depressed then
                col = Color(0, 0, 0, 84)
            elseif panel.btnMap.Hovered then
                col = Color(100, 100, 100, 84)
            end

            if panel.btnMap.bgColor ~= nil then
                col = panel.btnMap.bgColor
            end

            draw.RoundedBox(0, x, y, w, h, col)
            local progress = w * (NumVotes / #Players)

            if not panel.btnMap.CurProgress or panel.btnMap.CurProgress ~= progress then
                panel.btnMap.CurProgress = math.Approach(panel.btnMap.CurProgress, progress, FrameTime() * 500)
                draw.RoundedBox(0, x, y, panel.btnMap.CurProgress, 30, col_progress)
            else
                draw.RoundedBox(0, x, y, progress, 30, col_progress)
            end
        end
        -- TODO show new/modified icons
        --[[if !panel.btnMap.HasMap then

				local downloadTexture = surface.GetTextureID( "vgui/mapselector/download" )

				surface.SetDrawColor( 255, 255, 255, 33 )

				surface.SetTexture( downloadTexture )

				surface.DrawTexturedRect( w - 28, 0, 32, 32 )

			end]]
    end

    self.MapList:InvalidateLayout()
end

function PANEL:UpdatePreview()
    local mapData = nil

    -- Hovered map
    if self.HoveredMap then
        mapData = self.HoveredMap
        -- Voted map
    elseif self.VotedMap and not self.HoveredMap then
        mapData = self.VotedMap
    end

    if not mapData then return end
    self.lblMapName:SetText(mapData.Name)
    self.MapIcon:SetOnViewMaterial(mapData.PreviewIcon)
    self.lblDesc:SetText(mapData.Desc or "N/A")
    self.lblAuthor:SetText("Author: " .. mapData.Author or "N/A")
    self.MapPreview:InvalidateLayout()
end

net.Receive("VoteScreenFinish", function()
    local map = net.ReadString()
    if not ValidPanel(GTowerServers.MapChooserGUI) then return end
    GTowerServers.MapChooserGUI:FinishVote(map)
end)

function PANEL:FinishVote(map)
    self.lblTitle:SetText(string.format("Now Loading %q", Maps.GetName( map )))
    self.lblTitle:SizeToContents()
    self.lblTitle:SetPos(ScrW() / 2 - self.lblTitle:GetWide() / 2, 30)
    local bar = nil

    for _, v in pairs(self.MapList:GetItems()) do
        if v.btnMap then
            if v.btnMap:GetText() == Maps.GetName( map ) then
                bar = v.btnMap
            end

            v.btnMap.DisableVote = true
        end
    end

    -- Copied from Fretta -- temporary until I can come up with something creative
    --	- Maybe animate buttons outward and focus winning map panel in the center?
    timer.Simple(0.0, function()
        bar.bgColor = Color(57, 131, 181)
        surface.PlaySound("gmodtower/misc/blip.wav")
    end)

    timer.Simple(0.2, function()
        bar.bgColor = nil
    end)

    timer.Simple(0.4, function()
        bar.bgColor = Color(57, 131, 181)
        surface.PlaySound("gmodtower/misc/blip.wav")
    end)

    timer.Simple(0.6, function()
        bar.bgColor = nil
    end)

    timer.Simple(0.8, function()
        bar.bgColor = Color(57, 131, 181)
        surface.PlaySound("gmodtower/misc/blip.wav")
    end)

    timer.Simple(1.0, function()
        bar.bgColor = Color(100, 100, 100)
    end)
end

-- TODO: clean this up
function PANEL:SetRandomTip()
    local tip = self.lblTip:GetText()
    local tips = self.Gamemode.Tips

    if tips then
        while tip == self.lblTip:GetText() do
            tip = string.format("Tip: %s", table.Random(tips))
        end
    else
        tip = ""
    end

    self.lblTip:SetText(tip)
    self.lblTip:SizeToContents()
    self.lblTip:SetPos(ScrW() / 2 - self.lblTip:GetWide() / 2, ScrH() - 72)
    self.NextTip = CurTime() + 5
end

function PANEL:Think()
    if self.NextTip and self.NextTip < CurTime() then
        self:SetRandomTip()
    end

    local TimeLeft = GTowerServers.MapEndTime - CurTime()

    if TimeLeft < 0 then
        TimeLeft = 0
    end

    local ElapsedTime = string.FormattedTime(TimeLeft)
    ElapsedTime = math.Round(ElapsedTime.s)
    self.lblTimer:SetText(ElapsedTime)
    self.lblTimer:SizeToContents()
end

vgui.Register("MapSelector", PANEL, "DPanel")
