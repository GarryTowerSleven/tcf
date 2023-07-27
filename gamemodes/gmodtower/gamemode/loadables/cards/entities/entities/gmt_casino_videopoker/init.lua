AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local BUTTONSND = Sound("gmodtower/casino/videopoker/button.wav")
local BUZZSND = Sound("gmodtower/casino/videopoker/buzz.wav")
local CLICKSND = Sound("gmodtower/casino/videopoker/click.wav")
local DINGSND = Sound("gmodtower/casino/videopoker/ding.wav")
local WINSND = Sound("gmodtower/casino/videopoker/win.wav")
local LOSESND = Sound("buttons/button14.wav")

local function playVideoPokerSound(sound, ply)
    if IsValid(ply.VideoPoker) then
        ply.VideoPoker:EmitSound(sound, 65, 100, 0.5)
    end
end

function ENT:CheckHand(myhand)
    myhand.evaluated = false
    local score = myhand:Evaluate().hand

    if ( score == Cards.e_handranks.ONE_PAIR ) then
        local winning = myhand.winningHand

        if ( winning[1].value < Cards.e_card.JACK ) then
            score = 1
        end
    end

    self:SetScore(score)
end

-- CONCOMMANDS
concommand.Add("videopoker_credit", function(ply, cmd, args)
    if not IsValid(ply.VideoPoker) then return end
    local self = ply.VideoPoker
    if self:GetState() ~= 1 then return end
    local command = args[1]
    playVideoPokerSound(CLICKSND, ply)

    if tonumber(command) ~= nil then
        local newNum = self:GetBeginCredits() .. tonumber(command)

        if tonumber(newNum) >= 100000 then
            self:SetBeginCredits(100000)
        else
            self:SetBeginCredits(newNum)
        end
    elseif command == "delete" then
        local strCredits = tostring(self:GetBeginCredits())

        if #strCredits > 1 then
            strCredits = string.sub(strCredits, 1, -2)
        else
            strCredits = "0"
        end

        local numCredits = tonumber(strCredits)
        self:SetBeginCredits(numCredits)
    elseif command == "start" then
        self:SetCredits(self:GetBeginCredits())

        if self:GetBeginCredits() > 0 then
            if not ply:Afford(self:GetBeginCredits() * 2) then
                self:SetCredits(0)
                ply:MsgT("VideoPokerNoAfford")

                return
            end

            if self:GetBet() == 0 then
                self:SetBet(1)
            end

            ply:AddMoney(-(self:GetBeginCredits() * 2))
            local bzr = ents.Create("gmt_money_bezier")

            if IsValid(bzr) then
                bzr:SetPos(ply:GetPos())
                bzr.GoalEntity = self
                bzr.GMC = self:GetBeginCredits() * 2
                bzr.RandPosAmount = 1
                bzr.Offset = (self:GetForward() * 4) + (self:GetRight() * -12) + (self:GetUp() * 15)
                bzr:Spawn()
                bzr:Activate()
                bzr:Begin()
            end

            self:SetState(2)
            playVideoPokerSound(DINGSND, ply)
        else
            ply:MsgT("VideoPokerIsZero")
        end
    end
end)

concommand.Add("videopoker_bet", function(ply, cmd, args)
    if not IsValid(ply.VideoPoker) then return end
    local self = ply.VideoPoker
    if self:GetState() == 1 or self:GetState() == 3 then return end

    if args[1] == "max" then
        self:SetBet(5)
    else
        if self:GetBet() == 5 then
            self:SetBet(0)
        end

        self:SetBet(math.Clamp(self:GetBet() + 1, 1, 5))
    end
end)

concommand.Add("videopoker_draw", function(ply, cmd, args)
    if not IsValid(ply.VideoPoker) then return end
    local self = ply.VideoPoker
    if (ply._VideoNextDeal or 0) > CurTime() then return end
    ply._VideoNextDeal = CurTime() + 1

    if self:GetState() == 2 then
        -- DEAL BUTTON DURING BET SELECTION
        self:SetCredits(self:GetCredits() - self:GetBet())

        if self:GetBet() == 1 then
            ply:MsgT("VideoPokerSpend", self:GetBet(), "")
        else
            ply:MsgT("VideoPokerSpend", self:GetBet(), "s")
        end

        ply._PendingMoney = self:GetCredits() * 2

        if self:GetCredits() <= 0 then
            ply:MsgT("VideoPokerBankrupt")
            ply:ExitVehicle()

            return
        end

        self:SetProfit(self:GetProfit() - self:GetBet())
		SQL.getDB():Query("UPDATE gm_casino SET jackpot=jackpot + " .. self:GetBet() .. " WHERE type='videopoker'")
        self:SetJackpot(self:GetJackpot() + self:GetBet())
        self:SetState(3)
        self.deck = Cards.Deck()
        self.deck:Shuffle()
        self.hand = self.deck:GetHand()
        self:SetHand(self.hand)
        self:CheckHand(self.hand)

        if self.Prizes[self:GetScore()] then
            playVideoPokerSound(DINGSND, ply)
        end
    elseif self:GetState() == 3 then
        -- DEAL BUTTON DURING GAME
        for k, v in pairs(self:GetHeld()) do
            if not v then
                self.hand.cards[k] = self.deck:GetCard()
            end
        end

        self:SetHand(self.hand)
        self:CheckHand(self.hand)
        -- CLEARS THE HOLD ON CARDS
        local held = self:GetHeld()

        for k, v in pairs(held) do
            if v then
                held[k] = false
            end
        end

        self:SetHeld(held)
        local handRank = self:GetScore()

        if handRank >= 2 and handRank <= 11 then
            playVideoPokerSound(WINSND, ply)
            local winnings = self.Prizes[self:GetScore()][self:GetBet()]

            if winnings == -1 then
                winnings = self:GetJackpot()
                self:SetJackpot(0)
            end

            self:SetCredits(self:GetCredits() + winnings)
            ply._PendingMoney = self:GetCredits() * 2
            ply:MsgT("VideoPokerWin", winnings)
            self:SetProfit(self:GetProfit() + winnings)
        else
            ply:MsgT("VideoPokerLose")
            playVideoPokerSound(LOSESND, ply)
        end

        self:SetState(4)
        self:SetState(2)
    end
end)

concommand.Add("videopoker_hold", function(ply, cmd, args)
    if not IsValid(ply.VideoPoker) then return end
    local self = ply.VideoPoker
    local num = tonumber(args[1])

    if self:GetState() == 3 and num <= 5 then
        playVideoPokerSound(BUTTONSND, ply)
        local tbl = self:GetHeld()
        if num > #tbl then return end
        tbl[num] = not tbl[num]
        self:SetHeld(tbl)
    end
end)

--------------
function ENT:Initialize()
    self:SetModel("models/sam/videopoker.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:DrawShadow(false)

    timer.Simple(1, function()
        self:SetupChair()
    end)

    local phys = self.Entity:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
        phys:Sleep()
    end
	
	SQL.getDB():Query( "SELECT * FROM gm_casino WHERE type='videopoker'", function(res)
		local data = res[1].data[1]
		if #res[1].data == 0 then
			SQL.getDB():Query( "INSERT INTO gm_casino (type,jackpot) VALUES ('videopoker', 0)" )
		else
			self:SetJackpot(data.jackpot)
		end
	end)
	
end

local function HandleRollercoasterAnimation(vehicle, player)
    return player:SelectWeightedSequence(ACT_GMOD_SIT_ROLLERCOASTER)
end

function ENT:SetupChair()
    -- Chair Model
    self.chairMdl = ents.Create("prop_dynamic")
    self.chairMdl:SetModel("models/gmod_tower/aigik/casino_stool.mdl")
    --self.chairMdl:SetModel(self.ChairModel)
    --self.chairMdl:SetParent(self)
    self.chairMdl:SetPos(self:GetPos() + (self:GetForward() * 35))
    self.chairMdl:SetAngles(self:GetAngles() + Angle(0, 180, 0))
    --[[if self:GetAngles().y == 270 then
		self.chairMdl:SetPos( self:GetPos() + Vector(0,-35,-2) )
	else
		self.chairMdl:SetPos( self:GetPos() + Vector(0,35,-2) )
	end

	if self:GetAngles().y == 270 then
		self.chairMdl:SetAngles( Angle(0, 90, 0) )
	else
		self.chairMdl:SetAngles( Angle(0, -90, 0) )
	end]]
    self.chairMdl:DrawShadow(false)
    self.chairMdl:PhysicsInit(SOLID_VPHYSICS)
    self.chairMdl:SetMoveType(MOVETYPE_NONE)
    self.chairMdl:SetSolid(SOLID_VPHYSICS)
    self.chairMdl:Spawn()
    self.chairMdl:Activate()
    self.chairMdl:SetParent(self)
    local phys = self.chairMdl:GetPhysicsObject()

    if IsValid(phys) then
        phys:EnableMotion(false)
        phys:Sleep()
    end

    self.chairMdl:SetKeyValue("minhealthdmg", "999999")
end

function ENT:SetupVehicle()
    -- Chair Vehicle
    self.chair = ents.Create("prop_vehicle_prisoner_pod")
    self.chair:SetModel("models/nova/airboat_seat.mdl")
    self.chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
    self.chair:SetParent(self.chairMdl)
    self.chair:SetPos(self.chairMdl:GetPos() + Vector(0, 0, 30))
    self.chair:SetAngles(Angle(0, self:GetAngles().y + 90, 0))
    self.chair:SetNotSolid(true)
    self.chair:SetNoDraw(true)
    self.chair:DrawShadow(false)
    self.chair.HandleAnimation = HandleRollercoasterAnimation
    self.chair.bSlots = true
    self.chair:Spawn()
    self.chair:Activate()
    local phys = self.chair:GetPhysicsObject()

    if IsValid(phys) then
        phys:EnableMotion(false)
    end

    if phys:IsValid() then
        phys:EnableMotion(false)
    end
end

function ENT:IsInUse()
    if IsValid(self.chair) and self.chair:GetDriver():IsPlayer() then
        return true
    else
        return false
    end
end

function ENT:Use(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    if not self:IsInUse() then
        self:SetupVehicle()
        if not IsValid(self.chair) then return end -- just making sure...
        ply.SeatEnt = self.chair
        ply.EntryPoint = ply:GetPos()
        ply.EntryAngles = ply:EyeAngles()
        ply:SetNWVector("SeatEntry", ply.EntryPoint)
        ply:SetNWVector("SeatEntryAng", ply.EntryAngles)
        ply:EnterVehicle(self.chair)
        ply.VideoPoker = self
        --self:SendPlaying( ply )
        self:SetPlayer(ply)
        self:SetState(1)

        /*timer.Create("VideoPokerFuckoff" .. ply:EntIndex(), 5 * 60, 1, function() -- Not sure what practical use this has besides pissing people off
            if IsValid(ply) and IsValid(ply.VideoPoker) and ply.VideoPoker == self then
                ply:ExitVehicle()
                ply:MsgT("VideoPokerEjectTooLong")
            end
        end)*/
    else
        return
    end
end

hook.Add("PlayerLeaveVehicle", "VideoPokerLeave", function(ply)
    if not IsValid(ply.VideoPoker) then return end
    ply.SeatEnt = nil
    ply.EntryPoint = nil
    ply.EntryAngles = nil

    if ply.VideoPoker:GetState() > 1 then
        ply:AddMoney(ply.VideoPoker:GetCredits() * 2)
    end

    if ply.VideoPoker:GetClass() == "gmt_casino_videopoker" then
        if ply.VideoPoker:GetCredits() > 0 and ply.VideoPoker:GetState() > 1 then
            ply:MsgT("VideoPokerProfit", "earned", string.FormatNumber(math.abs(ply.VideoPoker:GetCredits() * 2)))
        elseif ply.VideoPoker:GetCredits() < 0 then
            ply:MsgT("VideoPokerProfit", "lost", string.FormatNumber(math.abs(ply.VideoPoker:GetCredits() * 2)))
        end

        if timer.Exists("VideoPokerFuckoff" .. ply:EntIndex()) then
            timer.Destroy("VideoPokerFuckoff" .. ply:EntIndex())
        end

        ply.VideoPoker:SetLastPlayer(ply:Name())
        ply.VideoPoker:SetLastPlayerValue(math.Clamp(ply.VideoPoker:GetCredits() - ply.VideoPoker:GetBeginCredits(), 0, 100000) * 2)

        if ply.VideoPoker:GetMostGMCSpentValue() < (ply.VideoPoker:GetBeginCredits() * 2) then
            ply.VideoPoker:SetMostGMCSpent(ply:Name())
            ply.VideoPoker:SetMostGMCSpentValue(ply.VideoPoker:GetBeginCredits() * 2)
        end

        ply.VideoPoker:SetPlayer(nil)
        ply.VideoPoker:SetState(0)
        ply.VideoPoker:SetBet(0)
        ply.VideoPoker:SetScore(0)
        ply.VideoPoker:SetCredits(0)
        ply._PendingMoney = 0
        ply.VideoPoker:SetProfit(0)
        ply.VideoPoker:SetBeginCredits(0)
    end

    ply.VideoPoker = nil
    umsg.Start("slotsPlaying", ply)
    umsg.End()
end)

hook.Add("CanPlayerEnterVehicle", "PreventEntry", function(ply, vehicle) return true end)

--[[if ( ply:GetBilliardTable() ) then
		//GAMEMODE:PlayerMessage( ply, "Warning!", "You cannot play slots while you are in a billiards game.\nYou must quit your billiards game!" )
		return false
	end]]
function ENT:GetPlayer()
    local ply = player.GetByID(self.SlotsPlaying)
    if IsValid(ply) and ply:IsPlayer() and self:IsInUse() then return ply end
end
