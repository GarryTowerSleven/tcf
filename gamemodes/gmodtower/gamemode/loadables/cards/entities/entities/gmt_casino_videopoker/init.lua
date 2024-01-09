AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

/*
    TODO: all of this should be redone
*/

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
            local price = self:GetBeginCredits() * 2

            if not ply:Afford(price) then
                self:SetCredits(0)
                ply:MsgT("VideoPokerNoAfford")

                return
            end

            if self:GetBet() == 0 then
                self:SetBet(1)
            end

            ply:TakeMoney( price, false, self )

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

        self:SetCredits(self:GetCredits() - self:GetBet())
        self:SetProfit(self:GetProfit() - self:GetBet())        
        self:SetJackpot( self:GetJackpot() + self:GetBet() )
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
				ply:MsgI( "videopoker", "VideoPokerJackpot" )
				self:BroadcastJackpot(ply, winnings)
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

function ENT:FetchFromSQL()

    if not Database.IsConnected() then return end

    Database.Query( "SELECT * FROM `gm_casino` WHERE `type` = 'videopoker';", function( res, status, err )
    
        if status != QUERY_SUCCESS then
            return
        end

        if table.Count( res ) == 0 then
            Database.Query( "INSERT INTO gm_casino (type, jackpot) VALUES ('videopoker', 0);" )
        else
            self:SetJackpot( res[1].jackpot )
        end

    end )

end

function ENT:UpdateToSQL()

    if not Database.IsConnected() or GMT_IS_RESTARTING then return end

    Database.Query( "UPDATE `gm_casino` SET `jackpot` = " .. tonumber( self:GetJackpot() ) .. " WHERE `type` = 'videopoker';" )

end

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

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:EnableMotion(false)
        phys:Sleep()
    end
	
end

hook.Add( "DatabaseConnected", "FetchVideoPoker", function()

    local ent = ents.FindByClass( "gmt_casino_videopoker" )[1]
    if IsValid( ent ) then
        ent:FetchFromSQL()
    end

end )

function ENT:SetupChair()
    self.chairMdl = ents.Create("prop_dynamic")
    self.chairMdl:SetModel( "models/gmod_tower/aigik/casino_stool.mdl" )

    self.chairMdl:SetPos(self:GetPos() + (self:GetForward() * 35))
    self.chairMdl:SetAngles(self:GetAngles() + Angle(0, 180, 0))

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

    self.chairMdl.OnSeatUse = function( ply )
		self:Use( ply )
	end
end

function ENT:SetupVehicle( ply )

	self.chair = seats.ForceEnterGivenSeat( self.chairMdl, ply )

	self.chair.OnSeatLeave = function( leaver )

        if not IsValid( leaver.VideoPoker ) then return end

        if not ply.VideoPoker:GetPlayer() == self then return end

        if self:GetState() > 1 then
        
            ply:GiveMoney( self:GetCredits() * 2, false, self )
    
        end
    
        if self:GetClass() == "gmt_casino_videopoker" then
            if self:GetProfit() > 0 and self:GetState() > 1 then
                ply:MsgT("VideoPokerProfit", "earned", string.FormatNumber(math.abs(self:GetProfit() * 2)))
            elseif self:GetProfit() < 0 then
                ply:MsgT("VideoPokerProfit", "lost", string.FormatNumber(math.abs(self:GetProfit() * 2)))
            end
    
            if timer.Exists("VideoPokerFuckoff" .. ply:EntIndex()) then
                timer.Destroy("VideoPokerFuckoff" .. ply:EntIndex())
            end
    
            self:SetLastPlayer(ply:Name())
            self:SetLastPlayerValue(math.Clamp(self:GetCredits() - self:GetBeginCredits(), 0, 100000) * 2)
    
            if self:GetMostGMCSpentValue() < (self:GetBeginCredits() * 2) then
                self:SetMostGMCSpent(ply:Name())
                self:SetMostGMCSpentValue(self:GetBeginCredits() * 2)
            end
    
            self:SetPlayer(nil)
            self:SetState(0)
            self:SetBet(0)
            self:SetScore(0)
            self:SetCredits(0)
            ply._PendingMoney = 0
            self:SetProfit(0)
            self:SetBeginCredits(0)
            self:SetHandInternal(0)
        end
    
        ply.VideoPoker = nil
		
		return true

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
        self:SetupVehicle( ply )

        if not IsValid(self.chair) then return end -- just making sure...

        ply:SetEyeAngles(self:GetAngles() + Angle(0, 90, 0))
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

function ENT:Think()

	// Player Idling Check
	if self:IsInUse() then
		ply = self:GetPlayer()
		if ply:GetNet( "AFK" ) then
			ply:ExitVehicle()
			ply:Msg2('You have been ejected for being AFK!')
		end
	end
	
end

function ENT:BroadcastJackpot(ply, winnings)

    GTowerChat.AddChat( T( "VideoPokerJackpotAll", string.upper( ply:Name() ), string.FormatNumber( winnings * 2) ), Color( 255, 200, 0 ), "Server" )

end