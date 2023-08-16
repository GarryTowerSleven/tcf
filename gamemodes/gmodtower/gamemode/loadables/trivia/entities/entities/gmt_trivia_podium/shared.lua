ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName	= "Trivia Podium"
ENT.Category    = "Trivia"
ENT.Author		= "kity"
ENT.Spawnable   = false

ENT.Model = Model( "models/gmod_tower/answerboard.mdl" )

ENT.Controller = nil

ENT.MaxDist = 512

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "ID" )
    
    self:NetworkVar( "Entity", 0, "Controller" )
    self:NetworkVar( "Entity", 1, "Player" )
    
    self:NetworkVar( "Bool", 0, "Answered" )
    self:NetworkVar( "Bool", 1, "Correct" )

    self:NetworkVar( "Int", 1, "Points" )
    self:NetworkVar( "Int", 2, "Choice" )

    self:NetworkVar( "Int", 3, "NumCorrect" )
    //self:NetworkVar( "Int", 4, "Streak" )
end

function ENT:IsInDistance( ply )
    if ( CLIENT ) then
        ply = ply or LocalPlayer()
    end

	return ply:GetPos():Distance( self:GetPos() ) < self.MaxDist
end

function ENT:Think()
    if ( not self.Controller ) then
        self.Controller = self:GetController() or NULL
    end

    if ( SERVER ) then
        if ( self.Controller and not IsValid( self.Controller ) ) then
            self:Remove()
        end
    end
end