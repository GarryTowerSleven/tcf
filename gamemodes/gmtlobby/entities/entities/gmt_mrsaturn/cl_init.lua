include( "shared.lua" )
include( "SCHED.lua" )

surface.CreateFont( "PetFontS", { font = "Saturn Boing", size = 100, weight = 400 } )
surface.CreateFont( "PetNameS", { font = "Saturn Boing", size = 50, weight = 400 } )
surface.CreateFont( "PetMsgS", { font = "Saturn Boing", size = 24, weight = 300 } )

CreateClientConVar("gmt_petname_saturn","",true,true)

function ENT:Initialize()

	self:SetupSchedules()
	self:SetCLHat(math.random(1,#MrSaturnHatTable))

end

function ENT:DrawText( text, font, x, y, alpha, xalign, yalign )
	if text then
		draw.DrawText( text, font, x + 2, y + 2, Color( 0, 0, 0, alpha ), xalign, yalign )
		draw.DrawText( text, font, x, y, Color( 255, 255, 255, alpha ), xalign, yalign )
	end

end


function ENT:DrawMessage()

	local perc = 1 - math.Clamp( ( MsgTime - diff ) / MsgTime, 0, 1 )

	local alpha = 255 * perc
	local yPos = 40 * perc

	local randText = Pets.GetQuote( "melon", self.EmoteIndex, self.SubIndex )
	self:DrawText( randText, "PetMsgS", 50, yPos - 20, alpha, 0, 0 )

	if perc == 0 then
		self.EmoteIndex = nil
		return
	end

end

function ENT:Draw()

	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	pos.z = pos.z + 20

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.1 )

		if self:GetPetName() and self:GetPetName() != "" then
			self:DrawText( self:GetPetName(), "PetNameS", 0, -30, 255, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	cam.End3D2D()

	self:DrawModel()

	if IsValid( self.Hat ) then
		self.Hat:DrawModel()
	end

end

function ENT:OnRemove()

	if IsValid( self.Hat ) then
		self.Hat:Remove()
	end

end

function ENT:Think()

	if IsValid( self.Hat ) then

		local hat = self.Hat

		local atch = self:LookupAttachment( "hat" )
		atch = self:GetAttachment( atch )
		local pos, ang = atch.Pos, atch.Ang
		pos = pos + ( self:GetRight() * hat.pos.x )
		pos = pos + ( self:GetForward() * hat.pos.y )
		pos = pos + ( self:GetUp() * hat.pos.z )
		ang = ang + hat.ang

		hat:SetPos( pos )
		hat:SetAngles( ang )
		hat:SetParent( self )

	end

	self:NextThink( CurTime() )
	return true

end

function ENT:SetCLHat( num, skin )

	skin = skin == 99 and false or skin
	local rndhat = MrSaturnHatTable[num]
	local hat = ClientsideModel( rndhat.mdl, RENDERGROUP_OPAQUE )
	hat.pos = rndhat.pos
	hat.ang = rndhat.ang
	hat:PhysicsInit( SOLID_NONE )
	hat:SetMoveType( MOVETYPE_NONE )
	hat:SetSolid( SOLID_NONE )
	hat:SetCollisionGroup( COLLISION_GROUP_NONE )
	hat.IsSaturnHat = true
	hat:Spawn()
	hat:SetSkin( skin or math.random( hat:SkinCount() ) )
	hat:SetNoDraw( true )

	self.Hat = hat

end

local function GetHat(um)

	local ent = um:ReadEntity()
	local num, skin = um:ReadLong(), um:ReadLong()

	timer.Simple( .1, function()
		if IsValid( ent ) then ent:SetCLHat(num, skin) end
	end )

end
usermessage.Hook("SaturnHat", GetHat)
