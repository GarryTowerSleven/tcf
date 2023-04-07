include("shared.lua")

local color_gray = Color( 240, 240, 240, 255 )
local model_offset = Vector( 0, 0, 40 )

function ENT:Initialize()

	self.PlayerModel = nil
	self:InitPlayer()

	self.Ball = nil
	self:InitBall()

end

function ENT:InitBall()
	local ply = self:GetOwner()
	if !IsValid( ply ) or self.Ball then return end

	local ballid = math.Clamp( (IsValid( ply ) and ply.GetNet) and ply:GetNet( "BallID" ) or 1, 1, table.Count( GAMEMODE.AvailableModels ) )

	self.Ball = ClientsideModel( GAMEMODE.AvailableModels[ ballid ], RENDERGROUP_TRANSLUCENT )
	if !IsValid( self.Ball ) then return end
	self.Ball:SetNoDraw(true)
end

function ENT:InitPlayer()

	local ply = self:GetOwner()
	if !IsValid( ply ) || self.PlayerModel then return end

	self.PlayerModel = ClientsideModel( ply:GetModel() )
	if !IsValid( self.PlayerModel ) then return end

	self.PlayerModel:SetSkin( ply:GetSkin() or 1 )

	self.IdleSeq = self.PlayerModel:LookupSequence( "idle_all_01" )

	if self.IdleSeq <= 0 then

		local model = ply:GetTranslatedModel()
		self.PlayerModel:Remove()

		if util.IsValidModel( model ) then

			self.PlayerModel = ClientsideModel( model ) // using SetModel messes up everything, recreate it
			self.IdleSeq = self.PlayerModel:LookupSequence("idle_all_01")

		end

	end

	if !IsValid( self.PlayerModel ) then return end

	self.PlayerModel:SetNoDraw( true )
	
	self.WalkSeq = self.PlayerModel:LookupSequence( "walk_all" )
	self.RunSeq = self.PlayerModel:LookupSequence( "run_all_01" )

	self.PlayerModel:ClearPoseParameters()
	self.PlayerModel:ResetSequenceInfo()

	self.PlayerModel:ResetSequence( self.IdleSeq )
	self.PlayerModel:SetCycle( 0.0 )
	self.PlayerModel:SetBodygroup( 0, 1 ) // Hat.Bodygroup would probably be something to consider in the future

	self.BodyAngle = 0

	self.LastAngle = Angle(0,0,0)
	self.LastBlip = 0
	self.AngleAccum = Angle(0,0,0)

end

function ENT:OnRemove()

	if IsValid( self.PlayerModel ) then
		self.PlayerModel:Remove()
		self.PlayerModel = nil
	end

	if IsValid( self.Ball ) then
		self.Ball:Remove()
		self.Ball = nil
	end
	
	self.Links = {}

end

function ENT:SelectSequence( ply )

	local velocity = self:GetVelocity():Length()
	local veln = self:GetVelocity():GetNormal()
	local velangle = self:GetVelocity():Angle()

	local seq = self.IdleSeq

	local aim = ply:EyeAngles()

	local rate = 1

	if velocity > 200 then
		seq = self.RunSeq
		rate = velocity / 300
	elseif velocity > 10 then
		seq = self.WalkSeq
		rate = velocity / 100
	end

	rate = math.Clamp(rate, 0.1, 2)

	if ( self.PlayerModel:GetSequence() != seq ) then
		self.PlayerModel:SetPlaybackRate( 1.0 )
		self.PlayerModel:ResetSequence( seq )
		self.PlayerModel:SetCycle( 0 )
	end

	if seq != self.IdleSeq then
		self.BodyAngle = aim.y
	else
		local diff = math.NormalizeAngle( aim.y - self.BodyAngle )
		local abs = math.abs( diff )
		if abs > 45 then
			local norm = math.Clamp( diff, -1, 1 )
			self.BodyAngle = math.NormalizeAngle( self.BodyAngle + ( diff - 45 * norm ) )
		end
	end

	local HeadYaw = math.NormalizeAngle( aim.y - self.BodyAngle )
	local MoveYaw = math.NormalizeAngle( velangle.y - self.BodyAngle )

	self.PlayerModel:SetAngles( Angle( 0, self.BodyAngle, 0 ) )
	self.PlayerModel:SetPos( self:GetPos() - model_offset )

	self.PlayerModel:SetPoseParameter( "breathing", 0.4 )


	self.PlayerModel:SetPoseParameter( "head_pitch", math.Clamp( aim.p - 40, -19, 20 ) )
	self.PlayerModel:SetPoseParameter( "head_yaw", HeadYaw )
	self.PlayerModel:SetPoseParameter( "move_yaw", MoveYaw )

	local forward, right = aim:Forward(), aim:Right()
	local dot = veln:Dot( forward )
	local dotr = veln:Dot(right)

	local spd = math.Clamp( velocity / 100, 0, 1 )

	self.PlayerModel:SetPoseParameter( "body_pitch", -aim.p )

	self.PlayerModel:SetPoseParameter( "move_x", spd * dot )
	self.PlayerModel:SetPoseParameter( "move_y", spd * dotr )

	self.PlayerModel:FrameAdvance( FrameTime() * rate )

end

function ENT:Think()

	// BUG: Invisible players inside the ball
	// the CSEnt is IsValid, but GetModel throws an error
	/*
	] lua_run_cl print(LocalPlayer():GetBall().PlayerModel)
	CSEnt: 02EA39B8
	] lua_run_cl print(LocalPlayer():GetBall().PlayerModel:GetModel())
	:1: Tried to use a NULL entity!
	*/

	if !IsValid( self.Ball ) then

		self.Ball = nil
		self:InitBall()
		if !IsValid( self.Ball ) then return end

	end

	self.Ball:SetPos( self:GetPos() )
	self.Ball:SetAngles( self:GetAngles() )

	if !IsValid( self.PlayerModel ) || !self.PlayerModel:GetModel() then

		self.PlayerModel = nil
		self:InitPlayer()
		if !IsValid( self.PlayerModel ) then return end

	end

	local ply = self:GetOwner()
	if !IsValid( ply ) then return end

	self:SelectSequence( ply )

	local velocity = self:GetVelocity():Length()

	ply.Speed = velocity

	local anglediff = self:GetAngles() - self.LastAngle
	self.LastAngle = self:GetAngles()
	anglediff.p, anglediff.y, anglediff.r = math.abs(anglediff.p), math.abs(anglediff.y), math.abs(anglediff.r)
	self.AngleAccum = self.AngleAccum + anglediff

	if CurTime() > ( self.LastBlip + ( 100/velocity ) ) && ( self.AngleAccum.p > 180 || self.AngleAccum.y > 180 || self.AngleAccum.r > 180 ) then

		local Pitch = 80 + (1 - (100/velocity)) * 90 + math.min(math.max((velocity - 400), 0) * 0.1, 40)
		Pitch = math.Clamp(Pitch, 75, 255)

		self.Entity:EmitSound(self.RollSound, 100, Pitch)

		self.AngleAccum = Angle( 0, 0, 0 )
		self.LastBlip = CurTime()

	end

end

function ENT:DrawTranslucent()

	local ply = self:GetOwner()
	if !IsValid( ply ) then return end

	// Draw player model
	if IsValid( self.PlayerModel ) and (ply ~= LocalPlayer() || !FIRSTPERSON) then

		local scale = 1
		if GTowerModels then
			scale = GTowerModels.GetScale( self.PlayerModel:GetModel() )
		end

		//scale = scale * self:GetModelScale()
		self.PlayerModel:SetPlayerProperties( ply )
		self.PlayerModel:SetModelScale( scale, 0 )

		//self.PlayerModel:SetPos( self:GetPos() - model_offset * self:GetModelScale() )
		self.PlayerModel:DrawModel()
		

		ply:ManualEquipmentDraw()
		ply:ManualBubbleDraw()

	end

	// Draw Ball
	if IsValid( self.Ball ) then
		render.CullMode(FIRSTPERSON and ply == LocalPlayer() and MATERIAL_CULLMODE_CW or MATERIAL_CULLMODE_CCW)
		render.SetBlend(FIRSTPERSON and ply == LocalPlayer() and 0.4 or 1)
		self.Ball:DrawModel()
	end
	render.CullMode(MATERIAL_CULLMODE_CCW)

	// Draw ball
	// self:DrawModel()

	// Draw names
	local name = ply:Name()
	local pos = ( self:Center() + Vector( 0, 0, 50 ) ):ToScreen()

	if pos.visible && ply != LocalPlayer() then

		local x, y = pos.x, pos.y
		cam.Start2D()
			draw.SimpleText(name, "BallPlayerName", x + 2, y + 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(name, "BallPlayerName", x, y, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		cam.End2D()

	end

end