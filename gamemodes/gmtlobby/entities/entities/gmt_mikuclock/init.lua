---------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(true)
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

	self.Playing = false
	self.LastSong = 0
	
	self:Precache()
end

function ENT:Use(ply)
	if self.Playing then return end

	self.Playing = true

	local song = self:PickSong()
	self.Song = CreateSound( self, song )
	self.Song:PlayEx( .45, 100 )
	timer.Simple(10, function()
		if IsValid(self) then 
			self.Playing = false
			if self.Song then self.Song:FadeOut(1) end
		end
	end)
end

function ENT:OnRemove()
	print("TEST")
	if self.Song then self.Song:Stop() end
end
function ENT:Think()
	if !self.Playing then return end
	
	self:EmitNotes()		
	self:NextThink(CurTime() + 2)
end

function ENT:PickSong()
	local song = self.Songs[math.random(#self.Songs)]
	if self.LastSong == song then return self:PickSong() end
	self.LastSong = song
	return song
end

function ENT:EmitNotes()
	local edata = EffectData()
	edata:SetOrigin(self:GetPos())
	edata:SetEntity(self)

	util.Effect("musicnotes", edata, true, true)
end