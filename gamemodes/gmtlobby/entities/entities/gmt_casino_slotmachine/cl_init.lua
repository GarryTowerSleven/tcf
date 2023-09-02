include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.SpinSpeed = 15

Casino.SlotsLocalPlaying = Casino.SlotsLocalPlaying or nil
Casino.SlotsSettingBet = Casino.SlotsSettingBet or false

/*---------------------------------------------------------
	Basics
---------------------------------------------------------*/
function ENT:Initialize()

	self.SpinRotation = -180
	self.Spinners = { false, false, false }
	self.SelectedIcons = { getRand(), getRand(), getRand() }
	self:SendAnim( self:GetPitch(1), self:GetPitch(2), self:GetPitch(3) )

	//self.GameSound = CreateSound( self, Casino.SlotGameSound )
	//self.GameSound:Play()

end

local matLight = Material( "sprites/pickup_light" )

function ENT:Draw()

	if !self.Light then
		self.Light = ClientsideModel( self.LightModel )
	end

	if IsValid( self.Light ) then

		self.Light:SetModelScale( .5, 0 )
		self.Light:SetPos( self:GetPos() + self:GetUp() * 80 + self:GetForward() * -5 )

		local ang = self:GetAngles()
		local spin = 0

		if self.LightTime && self.LightTime > CurTime() then
			spin = CurTime() * 600
		end

		local toang = Angle( 1, spin, ang.r )
		self.Light:SetAngles( toang )

		self.Light:DrawModel()
	end

	self:DrawModel()


	if !self.LightTime || self.LightTime < CurTime() then return end

	local size = SinBetween( 20, 30, CurTime() * 15 )

	local LightPos = self:GetPos()
	if IsValid( self.Light ) then
		LightPos = self.Light:GetPos()
	end

	local color = Color( 255, 0, 0 )

	render.SetMaterial( matLight )
	render.DrawSprite( LightPos, size, size, color )
	render.DrawSprite( LightPos, size*0.4, size*0.4, color )

	if IsValid( self.Light ) then
		local dlight = DynamicLight( self:EntIndex() )
		if dlight then
			dlight.Pos = self.Light:GetPos() + Vector( 0, 0, 5 )
			dlight.r = 255
			dlight.g = 0
			dlight.b = 0
			dlight.Brightness = SinBetween( 3, 5, CurTime() * 15 )
			dlight.Size = SinBetween( 128, 256, CurTime() * 15 )
			dlight.Decay =  80 * 5
			dlight.DieTime = CurTime() + .1
		end
	end

end

function ENT:OnRemove()

	if IsValid( self.Light ) then
		self.Light:Remove()
	end

end

function ENT:Think()

	if not LocalPlayer():InVehicle() then
		Casino.SlotsLocalPlaying = nil
	end

	self:Spin()

end

local function SetPlayersAlpha( col )
	for _, ply in pairs( player.GetAll() ) do
		ply:SetColorAll( Color( 255, 255, 255, col ) )
	end
end

hook.Add( "PlayerThink", "FadePlayersCasino", function()
	if Casino.SlotsLocalPlaying then
		SetPlayersAlpha( 35 )
	else
		SetPlayersAlpha( 255 )
	end
end )

/*---------------------------------------------------------
	Slot Machine Related Functions
---------------------------------------------------------*/
function ENT:IsSpinning(spinner)
	return self.Spinners[spinner]
end

function ENT:GetPitch(spinner)
	return self.IconPitches[self.SelectedIcons[spinner]]
end


function ENT:SendAnim( spin1, spin2, spin3 )

	if spin1 then
		self:SetPoseParameter( "spinner1_pitch", spin1 )
	end

	if spin2 then
		self:SetPoseParameter( "spinner2_pitch", spin2 )
	end

	if spin3 then
		self:SetPoseParameter( "spinner3_pitch", spin3 )
	end

end

function ENT:Spin()

	self.SpinRotation = math.NormalizeAngle(self.SpinRotation + self.SpinSpeed)
	
	if self:IsSpinning(1) then
		self:SendAnim( self.SpinRotation )
	else
		self:SendAnim( self:GetPitch(1) )
	end
	
	if self:IsSpinning(2) then
		self:SendAnim( nil, self.SpinRotation )
	else
		self:SendAnim( nil, self:GetPitch(2) )
	end
	
	if self:IsSpinning(3) then
		self:SendAnim( nil, nil, self.SpinRotation )
	else
		self:SendAnim( nil, nil, self:GetPitch(3) )
	end
		
end


net.Receive( "casino.slots.play", function( len, ply )

	local ent = net.ReadEntity()

	if IsValid( ent ) then
		Casino.SlotsLocalPlaying = ent
	else
		Casino.SlotsLocalPlaying = nil
	end

end )

net.Receive( "casino.slots.win", function( len, ply )

	local ent = net.ReadEntity()
	if not IsValid( ent ) then return end

	local jackpot = net.ReadBool()
	local time = jackpot and 20 or 1

	ent.LightTime = CurTime() + time

end )

net.Receive( "casino.slots.result", function( len, ply )

	local ent = net.ReadEntity()
	if not IsValid( ent ) then return end

	local num1 = net.ReadUInt( 3 )
	local num2 = net.ReadUInt( 3 )
	local num3 = net.ReadUInt( 3 )

	ent.Spinners = { true, true, true }
	ent.SelectedIcons = { num1, num2, num3 }

	local SpinSnd = CreateSound( ent, Casino.SlotSpinSound )
	SpinSnd:PlayEx(0.1, 100 )

	ent.SlotsSpinning = true
	
	timer.Simple( Casino.SlotSpinTime[1], function()
		if IsValid( ent ) then
			ent.Spinners[1] = false
			ent:EmitSound( Casino.SlotSelectSound, 75, 100 )
		end
	end )
	
	timer.Simple( Casino.SlotSpinTime[2], function()
		if IsValid( ent ) then
			ent.Spinners[2] = false
			ent:EmitSound( Casino.SlotSelectSound, 75, 100 )
		end
	end )
	
	timer.Simple( Casino.SlotSpinTime[3], function()
		if IsValid( ent ) then
			ent.Spinners[3] = false
			ent:EmitSound( Casino.SlotSelectSound, 75, 100 )
		end
		SpinSnd:Stop()
	end )

	timer.Simple( Casino.SlotSpinTime[3] + 1, function()
		if IsValid( ent ) then
			ent.SlotsSpinning = false
		end

		ent.SlotsSpinning = false
	end )

end )

/*---------------------------------------------------------
	Console Commands
---------------------------------------------------------*/
concommand.Add( "slotm_setbet", function( ply, cmd, args )

	if vr and vr.InVR() then
		local amount = math.fmod(Casino.SlotsLocalBet * 2, 1000) or tonumber( strTextOut ) or Casino.SlotsLocalBet
		Casino.SlotsLocalBet = math.Clamp( math.Round(amount), Casino.SlotsMinBet, Casino.SlotsMaxBet )
		Casino.SlotsSettingBet = false
		return
	end

	if !Casino.SlotsSettingBet then
		Casino.SlotsSettingBet = true
		Derma_StringRequest( "Slot Machine", "Set the amount of money you would like to bet. (" .. Casino.SlotsMinBet .. " - " .. Casino.SlotsMaxBet .. ")", Casino.SlotsLocalBet,
						function( strTextOut )
							local amount = tonumber( strTextOut ) or Casino.SlotsLocalBet
							Casino.SlotsLocalBet = math.Clamp( math.Round(amount), Casino.SlotsMinBet, Casino.SlotsMaxBet )
							Casino.SlotsSettingBet = false
						end,
						function( strTextOut )
							Casino.SlotsSettingBet = false
						end,
						"Set Bet", "Cancel" )
	end
end )

/*---------------------------------------------------------
	3D2D Drawing
---------------------------------------------------------*/
function ENT:DrawTranslucent()

	self:DrawDisplay()

	if Casino.SlotsLocalPlaying != self then return end

	//self:DrawCombinations()
	self:DrawControls()

end

surface.CreateFont( "SlotText", {
		font = "Tahoma",
		size = 22,
		weight = 300,
		antialias = true,
} )

surface.CreateFont( "SlotTextSmall", {
		font = "Tahoma",
		size = 18,
		weight = 300,
		antialias = true,
} )

function ENT:DrawDisplay()

	local attachment = self:GetAttachment( self:LookupAttachment("display") )
	if !attachment then return end

	local pos, ang = attachment.Pos, attachment.Ang
	local scale = 0.05

	local dist = pos:Distance( LocalPlayer():GetShootPos() )
	if dist > 1024 then return end
	
	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )

	cam.Start3D2D( pos, ang, scale )	
	
		draw.SimpleText( "Jackpot: " .. string.FormatNumber( self:GetJackpot() ), "SlotText", 5, 10, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		
		if self:GetLastPlayerName() != "" then
			draw.SimpleText( "Locked To: " .. self:GetLastPlayerName(), "SlotTextSmall", 5, 10 + 20, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			draw.SimpleText( "Lock Time: " .. math.ceil(self:GetLastPlayerTime() - CurTime()) .. " sec", "SlotTextSmall", 5, 10 + 20 + 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end

		//if Casino.SlotsLocalPlaying == self then
			draw.SimpleText( "Bet Amount: " .. Casino.SlotsLocalBet, "SlotText", 190, 188, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
		//end
		
	cam.End3D2D()

end


function ENT:DrawCombinations()

	local attachment = self:GetAttachment( self:LookupAttachment("winnings") )
	local pos, ang = attachment.Pos, attachment.Ang

	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	
	local Scale = 0.25

	cam.Start3D2D( pos, ang, Scale )	
	
		//draw.RoundedBox(8, -32, -16, 64, 32, Color( 200,200,255,75) )
		draw.SimpleText( "Winnings", "ScoreboardText", 45, 25, Color(255,255,255,255), 1, 1 )
		
	cam.End3D2D()

end

/*---------------------------------------------------------
	3D2D Buttons
---------------------------------------------------------*/
ENT.Controls = {

	[1] = {
		text = "BET",
		x = -40,
		col = Color(255,0,0,255),
		bcol = Color(128,0,0,255),
		selected = false,
		cmd = "slotm_setbet"
	},
	
	[2] = {
		text = "SPIN",
		x = 40,
		col = Color(0,0,255,255),
		bcol = Color(0,0,160,255),
		selected = false,
		cmd = "slotm_spin"
	},

}

surface.CreateFont( "Buttons", { font = "coolvetica", size = 22, weight = 200 } )
local ButtonTexture = surface.GetTextureID( "models/gmod_tower/casino/button" )
function ENT:DrawControls()

	local attachment = self:GetAttachment( self:LookupAttachment("controls") )
	local pos, ang = attachment.Pos, attachment.Ang
	local scale = 0.1

	if vr and vr.InVR() then
		if Casino.SlotsLocalPlaying && vrmod.GetRightHandPos(LocalPlayer()):Distance(self:GetAttachment(1).Pos) < 24 then
			if Casino.SlotsLocalPlaying.Controls != nil then
				for _, btn in ipairs( Casino.SlotsLocalPlaying.Controls ) do
					if btn.selected then
						//Msg( "[" .. Casino.SlotsLocalPlaying:EntIndex() .. "] " .. LocalPlayer():Name() .. " has pressed the " .. btn.text .. " button.\n" )
						RunConsoleCommand( btn.cmd, Casino.SlotsLocalBet )
					end
				end
			end
		end
	end
	
	ang:RotateAroundAxis( ang:Up(), 90 )
	ang:RotateAroundAxis( ang:Forward(), 90 )
	
	local function IsMouseOver( x, y, w, h )
		mx, my = self:GetCursorPos( pos, ang, scale )
		
		if mx && my then
			return ( mx >= x && mx <= (x+w) ) && (my >= y && my <= (y+h))
		else
			return false
		end
	end

	local alpha = self.SlotsSpinning and .25 or 1

	cam.Start3D2D( pos, ang, scale )
		
		// Draw buttons
		for _, btn in ipairs( self.Controls ) do
			local x, col, text = btn.x, btn.col, btn.text
			local y, w, h = 2, 48, 30
		
			if not self.SlotsSpinning and IsMouseOver(x - (w/2), y - (h/2), w, h) then
				btn.selected = true
				btn.col = Color(col.r,col.g,col.b,120 * alpha)
			else
				btn.selected = false
				btn.col = Color(col.r,col.g,col.b,40 * alpha)
			end
		
			surface.SetDrawColor( 255, 255, 255, 255 * alpha )
			surface.SetTexture( ButtonTexture )
			surface.DrawTexturedRect( x - (w/2), y - (h/2), w, h )
		
			draw.RoundedBox( 0, x - (w/2), y - (h/2), w, h, btn.col ) // Color button texture
		
			draw.SimpleText(text, "Buttons", x, y + 1, btn.bcol, 1, 1)
		end

		// Draw small cursor
		local mx, my = self:GetCursorPos( pos, ang, scale )
		if IsMouseOver( -190/2, -35/2, 190, 35 ) then
			self:DrawCursor( mx, my )
			vgui.GetWorldPanel():SetCursor( "blank" )
			/*surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawRect( mx - 2, my - 2, 4, 4 )*/
		else
			vgui.GetWorldPanel():SetCursor( "default" )
		end
		
	cam.End3D2D()

end

hook.Add( "KeyPress", "KeyPressedHook", function( ply, key )
	if Casino.SlotsLocalPlaying && key == IN_ATTACK then

		if Casino.SlotsLocalPlaying.Controls != nil then
			for _, btn in ipairs( Casino.SlotsLocalPlaying.Controls ) do
				if btn.selected then
					// Msg( "[" .. Casino.SlotsLocalPlaying:EntIndex() .. "] " .. LocalPlayer():Name() .. " has pressed the " .. btn.text .. " button.\n" )
					RunConsoleCommand( btn.cmd, Casino.SlotsLocalBet )
				end
			end
		end

	end
end )

/*---------------------------------------------------------
	Mind Blowing 3D2D Cursor Math -- Thanks BlackOps!
---------------------------------------------------------*/
ENT.Width = 190 / 2
ENT.Height = 35 / 2

function ENT:MouseRayInteresct( pos, ang )
	local plane = pos + ( ang:Forward() * ( self.Width / 2 ) ) + ( ang:Right() * ( self.Height / -2 ) )

	local x = ( ang:Forward() * -( self.Width ) )
	local y = ( ang:Right() * ( self.Height ) )

	local pos, ang = EyePos(), GetMouseAimVector()

	if vr and vr.InVR() then
		pos, ang = vrmod.GetRightHandPos(LocalPlayer()), vrmod.GetRightHandAng(LocalPlayer()):Forward()
	end

	return RayQuadIntersect( pos, ang, plane, x, y )
end

function ENT:GetCursorPos( pos, ang, scale )

	local uv = self:MouseRayInteresct( pos, ang )
	
	if uv then
		local x,y = (( 0.5 - uv.x ) * self.Width), (( uv.y - 0.5 ) * self.Height)
		return (x / scale), (y / scale)
	end
end

function ENT:DrawCursor( cur_x, cur_y )

	local cursorSize = 32

	surface.SetTexture( self.SlotsSpinning and CursorLock2D or Cursor2D )

	if input.IsMouseDown( MOUSE_LEFT ) then
		cursorSize = 28
		surface.SetDrawColor( 255, 150, 150, 255 )
	else
		surface.SetDrawColor( 255, 255, 255, 255 )
	end

	local offset = cursorSize / 2
	surface.DrawTexturedRect( cur_x - offset + 5, cur_y - offset + 7, cursorSize, cursorSize )

end