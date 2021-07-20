AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.Model = Model( "models/characters/mutants/major/major.mdl" )

ENT.HP = 9999
ENT.Damage = 20
ENT.Points = 32

ENT.SAlert = { "room209/ghost/alert", 3 }
ENT.SAttack = { "room209/ghost/attack", 3 }
ENT.SDie = { "room209/ghost/death", 3 }
ENT.SIdle = { "room209/ghost/idle", 5 }
ENT.SPain = { "room209/ghost/pain", 3 }

local function LobbyCheck()
    for k,v in pairs(ents.FindByClass("ghost_ghost")) do
        if !Location.IsGroup( v:Location(), "lobby" ) then
            v:SetPos( halloween2014.CenterPos )
        end
    end
end

hook.Add( "Think", "StayInLobbyBitch", LobbyCheck )