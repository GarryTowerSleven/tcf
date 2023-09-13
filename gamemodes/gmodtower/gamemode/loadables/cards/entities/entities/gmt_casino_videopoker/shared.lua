ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Video Poker"
ENT.Author = "mitterdoo"
ENT.Purpose = "GMod Tower"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.States = {
    IDLE = 0,
    BEGIN = 1,
    NOPLAY = 2,
    DISCARD = 3,
    FINISH = 4,
}

ENT.GMCPerCredit = 2

function ENT:SetJackpot(amount)
    SetGlobalInt("VideoPokerJackpot", amount)

    if SERVER then
        self:UpdateToSQL()
    end
end

function ENT:GetJackpot()
    return GetGlobalInt("VideoPokerJackpot")
end

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Player")
    self:NetworkVar("Int", 0, "HandInternal") -- use self:SetHand( hand:ToInt() ) and Hand():FromInt( hand )
    self:NetworkVar("Int", 1, "State")
    --self:NetworkVar( "Int", 2, "Jackpot" )
    self:NetworkVar("Int", 2, "Bet")
    self:NetworkVar("Int", 3, "Score")
    self:NetworkVar("Int", 4, "HeldInternal")
    self:NetworkVar("Int", 5, "Credits")
    self:NetworkVar("Int", 6, "Profit")
    self:NetworkVar("Int", 7, "BeginCredits")
    -- statistics ( player name then GMC )
    self:NetworkVar("String", 0, "LastPlayer")
    self:NetworkVar("Int", 8, "LastPlayerValue")
    self:NetworkVar("String", 1, "LastJackpot")
    self:NetworkVar("Int", 9, "LastJackpotValue")
    self:NetworkVar("String", 2, "MostGMCSpent")
    self:NetworkVar("Int", 10, "MostGMCSpentValue")
end

ENT.Prizes = {
    [11] = {
        2500, 5000, 7500, 10000, -1, Name = "ROYAL FLUSH"
    },
    [9] = {
        100, 200, 300, 400, 500, Name = "STRAIGHT FLUSH"
    },
    [8] = {
        50, 100, 150, 200, 250, Name = "FOUR OF A KIND"
    },
    [7] = {
        25, 50, 75, 100, 125, Name = "FULL HOUSE"
    },
    [6] = {
        20, 25, 50, 75, 100, Name = "FLUSH"
    },
    [5] = {
        10, 20, 30, 40, 50, Name = "STRAIGHT"
    },
    [4] = {
        5, 10, 15, 20, 25, Name = "THREE OF A KIND"
    },
    [3] = {
        3, 6, 9, 12, 15, Name = "TWO PAIR"
    },
    [2] = {
        2, 4, 6, 8, 10, Name = "JACKS OR BETTER"
    },
}

function ENT:CanUse(ply)
    return true, "PLAY"
end

if SERVER then
    function ENT:SetHeld(held)
        local Binary = ""

        for k, v in pairs(held) do
            Binary = Binary .. (v and 1 or 0)
        end

        self:SetHeldInternal(math.BinToInt(Binary))
    end

    function ENT:SetHand(hand)
        self:SetHandInternal(hand:ToInt())
    end
end

function ENT:GetHand()
    return Cards.Hand():FromInt(self:GetHandInternal())
end

function ENT:GetHeld()
    local held = {}
    local Binary = math.IntToBin(self:GetHeldInternal())

    if #Binary < 6 then
        Binary = string.rep("0", 6 - #Binary) .. Binary
    end

    for i = 2, #Binary do
        table.insert(held, string.sub(Binary, i, i) == "1")
    end

    return held
end

function ENT:GetStateName()
    local s = self:GetState()

    if s == self.States.NOPLAY or s == self.States.FINISH then
        return "Game Over"
    elseif s == self.States.DISCARD then
        return ""
    elseif s == self.States.ENDING then
        return ""
    else
        return "Error"
    end
end
