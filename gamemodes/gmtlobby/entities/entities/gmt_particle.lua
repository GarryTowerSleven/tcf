AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.Model = Model( "models/props_junk/watermelon01.mdl" )

function ENT:Initialize()

    if SERVER then
        
        if not self._ParticleEffect then
            self:Remove()
            return
        else
            self:SetNW2String( "ParticleName", self._ParticleEffect )
        end

    end

    if SERVER then
        self:MakeParticle()
    end

    self:DrawShadow( false )

end

function ENT:MakeParticle()

    local particle = self:GetNW2String( "ParticleName", nil )
    if not particle then return end

    PrecacheParticleSystem( particle )

    if SERVER then return end

    self:CreateParticleEffect( particle, 0, { attachtype = PATTACH_ABSORIGIN, entity = self } )

    self._Init = true

end

if SERVER then return end

function ENT:Draw() end

function ENT:Think()

    if IsValid( LocalPlayer() ) and LocalPlayer()._ClientCreated and not self._Init then
        self:MakeParticle()
    end

end