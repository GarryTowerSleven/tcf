ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName	= "Trivia Base"
ENT.Category    = "Trivia"
ENT.Author		= "kity"
ENT.Spawnable   = true

ENT.ChildClass = "gmt_trivia_podium"

ENT.MaxDistance = 512

ENT.PlayerCount = 8
ENT.MinPlayers = 2

ENT.QuestionCount = 10

ENT.BasePoints = 100
ENT.SafeZone = 3 // seconds

ENT.WaitingTime = 30
ENT.RoundTime = 20
ENT.IntermissionTime = 5
ENT.EndTime = 10

ENT.ErrorTimeout = 60 * 5

ENT.WinSound = Sound( "gmodtower/misc/win.wav" )

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "State" )
    self:NetworkVar( "Int", 1, "Question" )

    self:NetworkVar( "Int", 2, "PlayerCount" )

    self:NetworkVar( "Bool", 0, "Loading" )

    self:NetworkVar( "Float", 0, "Time" )
    self:NetworkVar( "Float", 1, "StartTime" )

    self:NetworkVar( "Bool", 0, "Error" )
    self:NetworkVar( "Int", 3, "ErrorCode" )
    self:NetworkVar( "Float", 2, "ErrorTime" )
end

function ENT:GetPodiums()
    table.sort( self.Podiums, function(a, b)
        return a:GetID() < b:GetID()
    end )

    return self.Podiums
end

function ENT:GetActivePodiums()
    local active = {}

    for _, v in ipairs( self:GetPodiums() ) do
        if ( IsValid( v:GetPlayer() ) ) then
            table.insert( active, v )
        end
    end

    return active
end

function ENT:GetWinner()
    local winning = nil
    for _, v in ipairs( self:GetActivePodiums() ) do
        if ( not winning or winning:GetPoints() < v:GetPoints() ) then
            winning = v
        end
    end

    return winning
end

function ENT:GetContestents()
    local players = {}

    for _, v in ipairs( self:GetPodiums() ) do
        if ( IsValid( v:GetPlayer() ) ) then
            table.insert( players, v:GetPlayer() )
        end
    end

    return players
end

function ENT:ContestentCount()
    return table.Count( self:GetContestents() )
end

function ENT:PlayersNeeded()
    return math.Clamp( self.MinPlayers - self:GetPlayerCount(), 0, self.MinPlayers )
end

function ENT:NoTime()
	return CurTime() > self:GetTime()
end

function ENT:TimeLeft( percent )
    if ( percent ) then
        return math.Clamp( self:TimeLeft() / (self:GetTime() - self:GetStartTime()), 0, 1 )
    end

	return math.Clamp( self:GetTime() - CurTime(), 0, 60 )
end