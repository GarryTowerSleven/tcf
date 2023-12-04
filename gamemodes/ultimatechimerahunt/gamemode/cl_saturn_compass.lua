local saturn = surface.GetTextureID( "UCH/hud_saturnbeacon" )

function GM:DrawSaturn()

	if !LocalPlayer():IsPig() then return end

	local saturns = ents.FindByClass( "mr_saturn" )
	if #saturns == 0 then return end

	for k, v in pairs( saturns ) do

		if IsValid( v ) then

			local name = "Mr. Saturn"
			local pos = ( v:GetPos() + Vector( 0, 0, 25 ) ):ToScreen()

			local dist = LocalPlayer():GetPos():Distance( v:GetPos() )

			if dist <= 250 || dist >= 1024 then return end
			local opacity = math.Clamp( 310.526 - ( 0.394737 * dist ), 0, 200 ) // woot mathematica

			if pos.visible then

				local x, y = pos.x, pos.y
				local size = 64 //math.Clamp( dist / 64, 0, 64 )

				cam.Start2D()

					surface.SetTexture( saturn )
					surface.SetDrawColor( Color( 255, 255, 255, opacity ) )
					surface.DrawTexturedRect( x - (size/2), y - (size/2), size, size )

					/*draw.SimpleText( name, "UCH_TargetIDName", x + 2, y + 2, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					draw.SimpleText( name, "UCH_TargetIDName", x, y, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )*/

				cam.End2D()

			end

		end

	end
	
end

local lang
local sprint = 0

function GM:PostRender()

	local ply = LocalPlayer()

	if !ply:GetNet("HasSaturn") || ply:ShouldDrawLocalPlayer() then return end

	cam.Start3D(EyePos(), EyeAngles(), 54)
	cam.IgnoreZ(true)

	if !IsValid(mrsaturn) then
		mrsaturn = ClientsideModel("models/uch/saturn.mdl")
		mrsaturn:SetNoDraw(true)
	end

	local vel = LocalPlayer():GetVelocity()
	local vel2d = vel:Length2D()
	local l = vel2d / LocalPlayer():GetWalkSpeed()

	local ang = EyeAngles()
	local ang2 = EyeAngles()
	local l2 = ang2.p / 90

	lang = lang or ang2
	lang = LerpAngle(FrameTime() * 24, lang, ang2)

	local diff = lang - ang2
	diff:Normalize()
	diff.p = math.Clamp(diff.p, -10, 10)
	diff.y = math.Clamp(diff.y, -10, 10)
	diff.r = 0

	sprint = math.Approach(sprint, LocalPlayer():GetNet("IsSprinting") and l > 0.5 && 1 or 0, FrameTime() * 8)

	ang:RotateAroundAxis(ang:Forward(), 20 - diff.y * 0.4)
	ang:RotateAroundAxis(ang:Up(), 160)
	ang:RotateAroundAxis(ang:Right(), 2 * l2 + math.sin(CurTime()))

	mrsaturn:SetPos(EyePos() + ang2:Right() * (12 + math.sin(CurTime() * 6) * 0.2 * l) + ang2:Forward() * (40 + l2 * 2) - ang2:Up() * (8 + sprint * 4 + math.sin(CurTime() * 18) * 0.4 * l))
	mrsaturn:SetAngles(ang - diff * 0.4)
	mrsaturn:DrawModel()

	cam.IgnoreZ(false)
	cam.End3D()

end


// I don't know what the fuck I'm doing - so fuck this code.  Feel free to make this work!
/*local PANEL = {}

function PANEL:Init()

	self:SetModel( "models/gmod_tower/arrow.mdl" )
	
	self.Visible = false
	self:SetPos( ScrW() - 1 , 0 )
	
	self:PerformLayout()

end

function PANEL:Think()

	self:PerformLayout()

end

function PANEL:LayoutEntity( ent )

	if !IsValid( LocalPlayer() ) || !LocalPlayer():IsPig() then return end

	self:SetCamPos( Vector( 0, 20, 0 ) )
	self:SetLookAt( Vector( 0, 0, 0 ) )

	local saturn = ents.FindByClass( "mr_saturn" )[1]
	if !IsValid( saturn ) then self.Visible = false return end

	local TargetDir = saturn:GetPos()
	
	if TargetDir == Vector( 0, 0, 0 ) && self.Visible then

		self:MoveTo( ScrW() - 1, 0, 1, 0, 0.5 )
		self.Visible = false

	else

		self:MoveTo( ScrW() - self:GetWide(), 0, 1, 0, 2 )
		self.Visible = true

	end

	local TargetDir = ( LocalPlayer():EyePos() - TargetDir )
	TargetDir.z = 0

	local dir = TargetDir:Angle()
	local eyeangle = LocalPlayer():EyeAngles()

	eyeangle.pitch = 0
	local dir = dir - eyeangle

	ent:SetPos( Vector( 0, 0, 0 ) )
	ent:SetAngles( dir + Angle( 0, 90, 0 ) )
	ent:SetModelScale( .5, 0 )

end

function PANEL:PerformLayout()

	self:SetSize( ScrW() * 0.3, ScrW() * 0.3 )

end

if Compass then Compass:Remove() end
Compass = vgui.CreateFromTable( vgui.RegisterTable( PANEL, "DModelPanel" ) )*/