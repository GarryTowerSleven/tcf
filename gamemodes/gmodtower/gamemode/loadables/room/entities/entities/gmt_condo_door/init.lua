AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.OpenSound = Sound("doors/door1_move.wav")
ENT.CloseSound = Sound("doors/door_wood_close1.wav")
ENT.LockedSound = Sound("doors/latchlocked2.wav")

function ENT:KeyValue( key, value )
	if key == "model" then
		self.Model = value
	end

	if key == "condoid" then
		self:SetNWInt( "CondoID", tonumber( value ) )
	end

	if key == "condodoortype" then
		self:SetNWInt( "CondoDoorType", tonumber( value ) )
	end
end

function ENT:Initialize()
    self:SetModel(self.Model)
    self:SetSolid(SOLID_VPHYSICS)
    self:DrawShadow(false)
    self:SetUseType(SIMPLE_USE)

    self:SetNWInt("DoorBell", 1)
end

function ENT:Think()
	if CurTime() > (self.Delay or 0) then
		self.Delay = CurTime() + 1

		local room = GTowerRooms.Get(self:GetCondoID())

		if room && IsValid(room.Owner) then
			if room.Owner:GetNWBool("Party") then
				self:SpawnDancers()
			else
				self:RemoveDancers()
			end
		else
			self:RemoveDancers()
		end
	end
end

ENT.Dancers = {}

function ENT:SpawnDancers()
	if #self.Dancers > 0 then return end

	local posSide = {
		[1] = 50,
		[2] = 1,
		[3] = -50,
	}

	for i=1, 3 do
		local e = ents.Create("gmt_ai_dancer")
		e:SetPos( self:GetPos() + (self:GetForward() * -55) + (self:GetRight() * posSide[i]) )
		e:SetAngles( Angle( 0, math.random( 0, 360 ), 0 ) )
		e:Spawn()

		table.insert( self.Dancers, e )
	end
end

function ENT:RemoveDancers()
	for k,v in pairs(self.Dancers) do
		if IsValid(v) then v:Remove() end
	end
	self.Dancers = {}
end

local bells = {
	"standard1",
	nil,

	"standard2",
	"ambient1",

	"happy1",
	"happy2",

	"spooky1",
	"spooky2",
	"spooky3",

	"disco1",
	"disco2",
	"disco3",

	"french1",
	"french2",
	"french3",

	"jazzy1",
	"jazzy2",
	"jazzy3",

	"funky1",
	"funky2",
	"funky3",
	"funky4",

	"robot1",
	"robot2",

	"vocoder1",
	"vocoder2",

	"deluxe",
	"assi"
}

function ENT:Use( ply )
	if ply.UsingDoor then return end
		self.TeleportEnt = NULL

		for k,v in pairs(ents.FindByClass("gmt_condo_door")) do
			if self:GetCondoDoorType() == 1 then
				if Location.Find(v:GetPos()) == self:GetCondoID() then
					self.TeleportEnt = v
				end
			else
				if Location.Find(self:GetPos()) == v:GetCondoID() then
					self.TeleportEnt = v
				end
			end
		end

		if !IsValid(self.TeleportEnt) then return end

		local owner

		if self:GetCondoDoorType() == 1 then

			for k,v in pairs(player.GetAll()) do
				if !v.GRoom then continue end
				if v:GetNet( "RoomID" ) == self:GetCondoID() then
					owner = v
				end
			end

			if !owner then
				self:EmitSound(self.LockedSound,80)
				return
			end

			if owner.RoomBans and table.HasValue( owner.RoomBans, ply ) then
				ply:Msg2("You have been banned from this Condo.")
				self:EmitSound(self.LockedSound,80)
				return
			end

			if owner:GetNet( "RoomLock" ) && ply != owner && !IsFriendsWith( owner, ply ) then

			local doorbell = bells[math.Clamp( self:GetNWInt("DoorBell"), 1, #bells )]

			if doorbell then
				self:EmitSound( Sound("GModTower/lobby/condo/doorbells/" .. doorbell) .. ".wav", 80 )
				if (owner:Location()) == self:GetCondoID() then
					owner:EmitSound( Sound("GModTower/lobby/condo/doorbells/" .. doorbell) .. ".wav" )
				end
			end

			self:EmitSound(self.LockedSound,80)
			if CurTime() < (ply.RingDelay or 0) then return end
			ply.RingDelay = CurTime() + 5

			return
		end
	end

	ply.UsingDoor = true
	ply:Freeze(true)

	net.Start("LoadingDoor")
		net.WriteEntity(self)
	net.Send(ply)

	self:EmitSound(self.OpenSound,80)

	local OpenSeq = self:LookupSequence("open")
	local CloseSeq = self:LookupSequence("close")

	self:ResetSequence(OpenSeq)

	timer.Simple( (self.DelayTime + self.WaitTime) ,function()
		ply.UsingDoor = false
		ply:Freeze(false)
		ply:EmitSound(self.CloseSound,80)
		self:ResetSequence(CloseSeq)

		if ( ply:GetBallRaceBall() && IsValid(ply:GetBallRaceBall()) ) then
			ply:GetBallRaceBall():SetAngles(self.TeleportEnt:GetAngles())
			ply:SetEyeAngles(self.TeleportEnt:GetAngles())
			ply:GetBallRaceBall():SetPos( self.TeleportEnt:GetPos() + Vector(0,0,35) )
		else
			ply:SetEyeAngles(self.TeleportEnt:GetAngles())
			ply.DesiredPosition = self.TeleportEnt:GetPos() + (self.TeleportEnt:GetForward()*50)
		end
	end)
end

concommand.Add( "gmt_setdoorbell", function(ply, cmd, args)
	if !args[1] then return end
	if args[1] && !tonumber(args[1]) then return end
	if !IsValid(ply) then return end

	local num = math.Clamp( tonumber(args[1]), 1, 50 )

	if ply:GetNet( "RoomID" ) then
		local door = GTowerRooms.GetCondoDoor(ply:GetNet( "RoomID" ))
		if door then
		  door:SetNWInt("DoorBell", num)
		end
	end
end )