
-----------------------------------------------------
include( "shared.lua" )

CreateClientConVar( "gmt_petname_bcorn", "", true, true )

ENT.SpriteMat = Material( "sprites/powerup_effects" )

ENT.OffsetAmount = 25 //Amount, in units, to offset ourselves from the player
ENT.MoveSpeed = 7 //Speed to move to goal position
ENT.AngleSpeed = 6 //Speed to move the angle to goal angle

ENT.GoalPos = Vector( 0, 0, 0 ) //Our "goal position" to always try to be at
ENT.CurPos = Vector( 0, 0, 0 )

ENT.GoalAngle = Angle( 0, 0, 0 )//same as above
ENT.CurAngle = Angle( 0, 0, 0 )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()

	self.CurPos = self:GetPos()
	self.CurAngle = self:GetAngles()

	local owner = self:GetOwner()
	if IsValid( owner ) then
		self.CurPos = owner:GetPos()
		self.CurAngle = owner:GetAngles()
	end

end

function ENT:Draw()

	self:DrawModel()

	local ang = LocalPlayer():EyeAngles()
	local pos = self:GetPos()

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

	pos.z = pos.z + 20

	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.05 )

		if self:GetPetName() and self:GetPetName() != "" then
			self:DrawText( self:GetPetName(), "PetName", 0, 0, 255, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

	cam.End3D2D()

end

function ENT:DrawText( text, font, x, y, alpha, xalign, yalign )

	if !text then return end

	draw.DrawText( text, font, x + 1, y + 1, Color( 0, 0, 0, alpha ), xalign, yalign )
	draw.DrawText( text, font, x, y, Color( 255, 255, 255, alpha ), xalign, yalign )

end


function ENT:Think()

	if !IsValid( self:GetOwner() ) || self:GetColor().a == 0 then return end

	local ply = self:GetOwner()
	local pos = util.GetHeadPos( ply )
	local ang = ply:EyeAngles()

	local offset = ( ang + Angle( 0, 40, 0 ) ):Right() * self.OffsetAmount

	self.GoalPos = pos + offset	+ Vector( 0, 0, 15 + ( math.sin( CurTime() * 1.2 ) * 4 ) )
	self.GoalAngle = Angle( 0, ang.y + 90, ang.r + 90 )

	//Do the splinin' here
	self.CurPos = LerpVector( FrameTime() * self.MoveSpeed, self.CurPos, self.GoalPos )
	self.CurAngle = LerpAngle( FrameTime() * self.AngleSpeed, self.CurAngle, self.GoalAngle )
	self:SetPos( self.CurPos )
	self:SetAngles( self.CurAngle )

end
