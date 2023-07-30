AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local ENT = {}

ENT.Base = "base_nextbot"

function ENT:IsHidden()
    return self.Visible
end

function ENT:Name()
    return "Hatsune Miku"
end

function ENT:Ping()
    return math.random(666, 667)
end

function ENT:IsMuted()
    return false
end

function ENT:GetRespectName()
    return math.random(4) == 1 and "GOD" or "dead"
end

function ENT:IsBot()
    return true
end

function ENT:IsAdmin()
    return false
end

function ENT:GetNet()
    return false
end

function ENT:IsModerator()
    return false
end

function ENT:Initialize()
    self:SetModel("models/player/miku.mdl")
    self.Visible = false
    self:DrawShadow(false)
end

function ENT:Think()
    self.loco:SetDesiredSpeed(64)
    self.loco:SetAcceleration(400)
    //self:StartActivity(ACT_HL2MP_WALK)
    self:BodyMoveXY()
    self.Location2 = self:GetPos() + self:GetForward() * 128



    // AI
    if IsLobby then
        if SERVER then
            self.Goal = self.Goal or 0

            // 0 - wander
            // 1 - interact
            // 2 - scare (say hi)

            if self.Goal == 0 then
                if !self.LastLocation or !self.Location or self.LastLocation < CurTime() then
                    self.Location2 = self:FindSpot("far", {pos = self:GetPos()})
                    self.LastLocation = CurTime() + 2

                    print("UPDATE!")
                end



            end
        end
    end
    
    if self.Path then
        if self.Location3 ~= self.Location2 then
            self.Path:Compute(self, self.Location2)
        end

        self.Path:Update(self)
        self:NextThink(CurTime() + 0.1)
        return true
    else
        self:ChaseEnemy()
        print("Oh no.")
    end
end

function ENT:RunBehavior()
    while true do
        self:ChaseEnemy()
        coroutine.yield()
    end
end

function ENT:ChaseEnemy( options )

	local options = options or {}
	local path = Path( "Follow" )
    self.Path = path
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self.Location2 or self:GetPos() or self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end

	return "ok"

end

scripted_ents.Register(ENT, "miku")