
-----------------------------------------------------
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Dopefish"
ENT.Information		= "It spins around"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false

ENT.Model			= Model("models/gmod_tower/dopefishisaliveyall.mdl")

for i=1,10 do
	util.PrecacheSound("gmodtower/voice/dopefish/fish"..tostring(i)..".mp3")
end

function ENT:CanUse()
  return true, "TALK"
end
