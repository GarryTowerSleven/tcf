include('shared.lua')

local IsValid = IsValid
local LocalPlayer = LocalPlayer
local cam = cam
local draw = draw
local surface = surface

local MaxNameHeight = 1

ENT.RenderGroup = RENDERGROUP_BOTH

local locationMaterials = {
	["Lobby"] = Scoreboard.GenTexture( "LobbyFloor", "lobby/lobby_new" ),
	["Gamemodes"] = Scoreboard.GenTexture( "GamemodesFloor", "lobby/gamemodes" ),
	["Suites"] = Scoreboard.GenTexture( "SuiteFloor", "lobby/suite" )
}

function ENT:Initialize()

	self.TotalPlacesHeight = 1
	
	self.CamScale = 0.04
	self.TotalSize = 9 / self.CamScale //Do not change
	
	self.BoxNameW = 2
	self.ChoosingItem = 2
	self.BoxNameH = 2
	
	self.ItemList = {}

	self:ProcessNames()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:MyPlace()
	return 1
end

local MarkupBackup = {}

function ENT:ProcessNames()

	local HeightSpace = 22
	local ExtraSpace = 24
	local CurY = 0
	
	local StartPosX = -1 * self.TotalSize
	local TotalWidth = 2 * self.TotalSize
	
	local LocalPosition = self:Location()

	surface.SetFont("GTowerHUDHuge")

	for k, v in pairs( Location.TeleportLocations ) do
	
		if LocalPosition != k then
	
			local w,h = surface.GetTextSize( v.name )
			local Markup = MarkupBackup[ k ]
			
			if !Markup then
				Markup = markup.Parse( "<font=GTowerHUDHuge><color=white>" .. v.desc .. "</color></font>", TotalWidth - 2 )
				MarkupBackup[ k ] = Markup
			end
			
			if h > MaxNameHeight then
				MaxNameHeight = h
			end
			
			table.insert( self.ItemList, {
				["id"] = k,
				["TextWide"] = w,
				["name"] = v.name,
				["Markup"] = Markup
			} )
			
		end
	end
	
	local LocalSize = ( MaxNameHeight + ExtraSpace + HeightSpace ) * self.CamScale
	addz = math.min(LocalPlayer():GetViewOffset().z + 4, 67)
	for k, v in pairs( self.ItemList ) do
		
		v.YPos = CurY
		
		v.XTextPos = StartPosX + TotalWidth * 0.5 - v.TextWide * 0.5
		v.YTextPos = v.YPos + (MaxNameHeight + ExtraSpace) * 0.5 - MaxNameHeight * 0.5
		
		v.StartYTrace = addz - (k-1) * LocalSize
		v.EndYTrace   = addz - k * LocalSize
		
		CurY = CurY + MaxNameHeight + ExtraSpace + HeightSpace
	end
		
	self.StartPosX = StartPosX
	self.BoxNameW = TotalWidth
	self.BoxNameH = MaxNameHeight + HeightSpace

end

function ENT:GetActivePlayer()

	if CLIENT && self:TestForPlayer( LocalPlayer() ) then
		return LocalPlayer()
	end
	
	for _, v in pairs( player.GetAll() ) do
		if self:TestForPlayer( v ) then
			return v
		end
	end

end

function ENT:GetTraceItem( forceplayer )

	local PlyTrace = forceplayer or self:GetActivePlayer()
	
	if !IsValid(PlyTrace) then
		return nil
	end
	
	local PlyTrace = PlyTrace:GetEyeTrace()
	
	if PlyTrace.Entity != self then
		return nil
	end
	
	local TraceHitPos = self:WorldToLocal( PlyTrace.HitPos )

	for k, v in pairs( self.ItemList ) do
		if k == 1 then
			if TraceHitPos.y > -18.4091 && TraceHitPos.y < -3.93 &&
				TraceHitPos.z < v.StartYTrace -0.21 &&
				TraceHitPos.z > v.EndYTrace -0.42 then
				return k
			end
		end
		if k == 2 then
			if TraceHitPos.y > -18.4091 && TraceHitPos.y < -3.93 &&
				TraceHitPos.z < v.StartYTrace -0.67 &&
				TraceHitPos.z > v.EndYTrace -0.85 then
				return k
			end
		end
	end

	return nil
end

local g = Material("vgui/gradient-r")

function ENT:DrawTranslucent()

	if IsValid(LocalPlayer()) then
		local dist = self:GetPos():Distance(LocalPlayer():GetPos())
		if dist > 1000 then
			return
		end
	end

	local Vec = self:LocalToWorld( Vector(-10, -10, 67 ) )
	local Vec2 = self:LocalToWorld( Vector(-9, 10, 67 ) )
	local ang = self:GetAngles()
	Vec.z = self:GetPos().z + math.min(LocalPlayer():GetViewOffset().z + 4, 67)
	Vec2.z = Vec.z
	
	ang:RotateAroundAxis( ang:Right(), -90 )
	ang:RotateAroundAxis( ang:Forward(), -45 )
	ang:RotateAroundAxis( ang:Up(), 90 )

	self.ItemList = {}
	self:ProcessNames()
	
	
	local HitItem = self:GetTraceItem()
	local ActiveHit = HitItem != nil
	
	if ActiveHit then
		self.ChoosingItem = HitItem	
	end

	surface.SetFont("GTowerHUDHuge")
	surface.SetTextColor( 60,75,80,255 )

	cam.Start3D2D( Vec, ang, self.CamScale )
		
		for k, v in pairs( self.ItemList ) do
			
			local bgColor = Color(130,140,145,200)
			local alpha = 100
			
			if self.ChoosingItem == k then

				if ActiveHit then
					surface.SetTextColor( 255,255,255,255 )
					bgColor = Color(90,164,206,100)	
					alpha = 20
				else
					surface.SetTextColor( 255,255,255,150 )
				end
				
			else
				surface.SetTextColor( 150,150,150,255 )
				bgColor = Color(130,140,145,80)
			end

			self.LastItem = self.ChoosingItem

			draw.RoundedBox( 2, self.StartPosX + 2, v.YPos + 2, self.BoxNameW, self.BoxNameH, bgColor )

			if locationMaterials[v.name] then
				surface.SetMaterial( locationMaterials[v.name] )
				surface.SetDrawColor( Color(255, 255, 255, alpha) )
				surface.DrawTexturedRect( self.StartPosX + 2, v.YPos + 2, self.BoxNameW, self.BoxNameH )
			end

			surface.SetTextPos( v.XTextPos, v.YTextPos )
			surface.DrawText( v.name )
			
		end
	
	cam.End3D2D()
	
	local Markup = self.ItemList[ self.ChoosingItem ].Markup
	
	if Markup then
	
		ang:RotateAroundAxis( ang:Right(), 90 )
		
		cam.Start3D2D( Vec2, ang, self.CamScale )
		
			//draw.RoundedBox( 0, self.StartPosX, 0, self.BoxNameW, Markup:GetHeight() + 2 , Color(130,140,145,50) )
			
			Markup:Draw( self.StartPosX + 2, 2 )
		
		cam.End3D2D()
	
	end
	
end

local function TeleporterTestForClick( ent )
	if !ent.GetTraceItem then return end

	local ItemTrace = ent:GetTraceItem( LocalPlayer() )
	
	if ItemTrace then
		RunConsoleCommand("gmt_cteleporter", ent:EntIndex(), ent.ItemList[ ItemTrace ].id )
		return true
	end

end

hook.Add("KeyRelease", "CheckPlayerTeleporter", function( ply, key )

	if ply == LocalPlayer() && IsValid(LocalPlayer()) && (key == IN_USE or key == IN_ATTACK) then
		local Trace = LocalPlayer():GetEyeTrace()
		
		if IsValid( Trace.Entity ) && Trace.Entity:GetClass() == "gmt_teleporter" then
			TeleporterTestForClick( Trace.Entity )
		end
	end

end )

/*hook.Add("GtowerMouseEnt", "GtowerMouseTeleporter", function( ent, mc )
	if ent:GetClass() != "gmt_teleporter" then return end
	if TeleporterTestForClick( ent ) != true then return end
	
	return true
end )*/


local l = 1

net.Receive( "Teleport", function()

	l = 0

end )

local grad = Material("vgui/gradient_up")

hook.Add("HUDPaintBackground", "Teleport", function()

	if l == 1 then return end

	l = math.min( l + FrameTime() * 2, 1 )

	local l = math.ease.OutSine( l )

	local w, h = ScrW(), ScrH()

	surface.SetMaterial( grad )

	surface.SetDrawColor( Color( 255, 255, 255, 64 * ( 1 - l ) ) )
	surface.DrawTexturedRect( 0, h * 0.2, w, h * 0.8 )


end )