util.AddNetworkString("open_halloween")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BloodSpots = {
	Vector("926.444336 -2427.804932 0.031250;"),
	Vector("929.334167 -2301.968018 17.050926"),
	Vector("880.692627 -2161.361572 48.031250"),
	Vector("738.701538 -2048.522461 64.031250"),
	Vector("604.709351 -1939.739868 64.031250"),
	Vector("460.714569 -1813.450195 64.031250"),
	Vector("334.323669 -1674.117554 64.031250"),
	Vector("228.608917 -1542.398682 64.031250"),
	Vector("74.498573 -1500.999634 64.031250"),
	Vector("-135.084656 -1483.775146 64.031250"),
	Vector("-313.624878 -1481.875366 64.031250"),
	Vector("-397.699524 -1410.789429 64.031250"),
	Vector("-410.835205 -1300.471558 96.031250"),
	Vector("-411.241760 -1160.401001 96.031250"),
	Vector("-416.572327 -1036.065918 96.026733")
}

ENT.AmbientSounds = {
	Sound("gmodtower/lobby/halloween/chant1.mp3"),
	Sound("gmodtower/lobby/halloween/chant6.mp3"),
	Sound("gmodtower/lobby/halloween/chant9.mp3"),
	Sound("gmodtower/lobby/halloween/darkalert.wav"),
	Sound("gmodtower/lobby/halloween/elevator_power_msg.mp3"),
	Sound("gmodtower/lobby/halloween/ghostwhispers2.mp3"),
	Sound("gmodtower/lobby/halloween/laugh.wav")
}

ENT.ImpactSounds = {
	Sound("physics/flesh/flesh_squishy_impact_hard1.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard2.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard3.wav"),
	Sound("physics/flesh/flesh_squishy_impact_hard4.wav")
}

ENT.StingerSound = Sound("gmodtower/lobby/halloween/wallslamming.wav")
ENT.PanicSound = Sound("gmodtower/lobby/halloween/panic.mp3")
ENT.SawSound = Sound("gmodtower/lobby/halloween/sawmeatscream.wav")

function ENT:Initialize()

	self:SetModel( self.Model )
	self:SetUseType( SIMPLE_USE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )
	self:UseTriggerBounds( true, 60 )
	self:SetPos( Vector( -419.450562, -1002.996887, 32.621159 ) )
	self:SetAngles( Angle( 0, 90, 0 ) )
	self:DrawShadow( false )

	self:CacheDoors()

	timer.Create( "halloween_sounds", 20, 0, function()
		if !IsValid( self ) then return end

		local snd = table.Random( self.AmbientSounds )
		self:EmitSound( snd, 70, 100 )
	end )

	timer.Create( "halloween_effects", 60*3, 0, function()
		if !IsValid( self ) then return end

		self:StartEffects()
	end )
end

function ENT:Use( ply )

	net.Start( "open_halloween" )
	net.Send( ply )

end

local doors = {}
ENT.Toggled = false
ENT.Opener = NULL

function ENT:CacheDoors()

	for k,v in pairs( ents.FindInSphere( self:GetPos(), 80 ) ) do
		if v:GetClass() != "func_door" then continue end

		doors[k] = v
		v:SetSaveValue( "m_flWait", -1 )
	end

end

function ENT:ControlDoors( toggle )

	for k,v in pairs( doors ) do
		if IsValid( v ) then
			v:Fire( toggle )
		end
	end

end

function ENT:StartTouch( ply )

	if !ply:IsPlayer() then return end

	if self.Toggled != true then
		self.Opener = ply
		self:ControlDoors( "Open" )
		self.Toggled = true
	end

end

function ENT:EndTouch( ply )

	if !ply:IsPlayer() then return end

	if IsValid( self.Opener ) then
		if ply == self.Opener then
			self:ControlDoors( "Close" )
			self.Toggled = false
		end
	end

end

function ENT:StartEffects()
	if not self.CurrentEffect then self.CurrentEffect = 0 end
	self.CurrentEffect = self.CurrentEffect + 1

	local pos = self.BloodSpots[self.CurrentEffect]

	if not pos then
		self.CurrentEffect = 0
		return
	end

	-- SPLASH!
	local effect = EffectData()
	effect:SetOrigin( pos - Vector(0, 0, 64) )
	effect:SetFlags( 3 )
	effect:SetColor( 0 )
	effect:SetScale( 8 )
	util.Effect( "bloodspray", effect )
	util.Effect( "BloodImpact", effect )

	-- Blood decals
	local tr = util.TraceLine({
		start = pos,
		endpos = pos - Vector(0, 0, 128),
		filter = self
	})

	-- Four blood decals spread around the trace
	for i = 1, 4 do
		local rand = VectorRand() * 24
		util.Decal("Blood", tr.HitPos + tr.HitNormal + rand, tr.HitPos - tr.HitNormal)
	end

	-- Sounds.
	if self.CurrentEffect == 1 then
		sound.Play( self.PanicSound, Vector("-410.277985 -1156.301758 180.372787"), 70 )
	end

	if self.CurrentEffect == #self.BloodSpots then
		self:EmitSound( self.SawSound, 65, 100 )

		timer.Simple( 1, function()
			if IsValid( self ) then
				local effect = EffectData()
				effect:SetOrigin( self:GetPos() )
				util.Effect( "bloodstream", effect )
				util.Effect( "bloodstream", effect )
				util.Effect( "bloodstream", effect )
			end
		end)
	end

	sound.Play( table.Random( self.ImpactSounds ), pos, 70 )

	if (self.CurrentEffect - 1) % 6 == 0 then
		sound.Play( self.StingerSound, pos, 70 )
	end

	if self.CurrentEffect < #self.BloodSpots then
		timer.Simple( 0.8, function()
			if IsValid( self ) then
				self:StartEffects()
			end
		end)
	else
		self.CurrentEffect = 0
	end
end

concommand.Add("gmt_halloween_effects", function(ply, cmd, args)
	if !ply:IsAdmin() then return end

	for k,v in pairs(ents.FindByClass("gmt_halloween_connection")) do
		v:StartEffects()
	end
end)

hook.Add("Location", "HalloweenOverlay", function( ply, loc )
	if loc == 49 then
		PostEvent( ply, "bw_on" )
		ply._BWVision = true
	elseif ply._BWVision then
		PostEvent( ply, "bw_off" )
		ply._BWVision = false
	end
end)