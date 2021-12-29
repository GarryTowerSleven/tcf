AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("LoadingDoor")

ENT.Model = Model("models/sunabouzu/theater_door02.mdl")
ENT.DoorOpen = Sound("doors/door1_move.wav") //just defaults
ENT.DoorClose = Sound("doors/door_wood_close1.wav") //just defaults

ENT.rouletteExit = false
function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:DrawShadow(false)
	self:SetUseType(SIMPLE_USE)

	// Roulette Exit
	if self:GetPos() == Vector(11263, -5032, -586) then
		self.rouletteExit = true
	end
end

function ENT:IsRoulette(ply)
	return self:GetModel() == "models/map_detail/firework_door.mdl"
end

local rouletters = {}
local function IsRouletter(ply)
	if ( table.HasValue( rouletters, ply:SteamID() ) ) then
		return true
	end
end

function ENT:Use(ply)

	if ply.UsingDoor then return end

	for k,v in pairs(ents.FindByClass("info_teleport_destination")) do
		if tostring( v:GetName() ) == self.TeleportName then
			self.TeleportEnt = v
		end
	end

	if !IsValid(self.TeleportEnt) then return end

	ply.UsingDoor = true
	ply:Freeze(true)

	local doorOpenS = self.OpenSound
	if self:IsRoulette() then
		doorOpenS = self.OpenSoundRoulette
	end
	if self:IsRoulette() && IsRouletter(ply) then
		doorOpenS = self.OpenSoundRouletter
	end

	if self.rouletteExit then
		doorOpenS = self.ExitSoundRoulette
	end

	self:EmitSound( doorOpenS, 80 )

	local OpenSeq = self:LookupSequence("open")
	local CloseSeq = self:LookupSequence("close")

	self:ResetSequence(OpenSeq)

	local wait = 0
	if self:IsRoulette() && !IsRouletter(ply) && !self.rouletteExit then
		wait = 4
	end

	timer.Simple( wait, function()
		net.Start("LoadingDoor")
		net.WriteEntity(self)
		net.Send(ply)

		timer.Simple( (self.DelayTime + self.WaitTime) ,function()
			ply.UsingDoor = false
			ply:Freeze(false)

			ply:EmitSound( self:IsRoulette() and self.CloseSoundRoulette or self.CloseSound, 80 )

			if self:IsRoulette() && !IsRouletter(ply) then
				table.uinsert( rouletters, ply:SteamID() )
			end

			self:ResetSequence(CloseSeq)

			if self.TeleportName == "secret_exit2" then ply:AddAchievement(ACHIEVEMENTS.WTF, 1) end

			if ( ply.BallRaceBall && IsValid(ply.BallRaceBall) ) then
				ply.BallRaceBall:SetAngles(self.TeleportEnt:GetAngles())
				ply:SetEyeAngles(self.TeleportEnt:GetAngles())
				ply.BallRaceBall:SetPos( self.TeleportEnt:GetPos() + Vector(0,0,35) )
			else
				ply:SetEyeAngles(self.TeleportEnt:GetAngles())
				ply.DesiredPosition = self.TeleportEnt:GetPos()
			end
		end)
	end)

end

function ENT:KeyValue( key,value )
	if key == "model" then self.Model = value end
	if key == "modelscale" then self:SetModelScale(tonumber(value)) end
	if key == "skin" then self:SetSkin(tonumber(value)) end
	if key == "teleportentity" then self.TeleportName = value end
end
