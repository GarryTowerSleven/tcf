include('shared.lua')

local GTowerRooms = GTowerRooms

CreateClientConVar( "gmt_suitename", "", true, true )

-- Fonts
surface.CreateFont( "suitePanelBig", { font = "Trebuchet MS", size = 45, weight = 700 } )
surface.CreateFont( "suitePanelSmall", { font = "Trebuchet MS", size = 30, weight = 800 } )

ENT.matBackdrop 		= surface.GetTextureID( "func_touchpanel/terminal_backdrop04" )
ENT.matButtonOpen 		= surface.GetTextureID( "func_touchpanel/button_open04" )
ENT.matButtonClose 		= surface.GetTextureID( "func_touchpanel/button_close04" )
ENT.matButtonLock 		= surface.GetTextureID( "func_touchpanel/button_lock04" )
ENT.matButtonUnlock		= surface.GetTextureID( "func_touchpanel/button_unlock04" )

function ENT:Initialize()

	self:SetModel( self.Model )
	self:SetRenderBounds( Vector( 75, 0, -72 ), Vector( -8, 2, 72 ) )

end
/*
function ENT:UpdateRoomId( val )
	self.RoomId = tonumber( val )
	
	if self.RoomId != 0 then
		self.DrawLoading =  self.DrawActualLoaded
	end
end

function ENT:RoomIdChanged( name, old, new )
	if new != 0 then
		self.DrawLoading =  self.DrawActualLoaded
		cookie.Set("GMTSuitePanel" .. self:EntIndex(), new )
	end
end
*/

function ENT:Think()
	
	local Skin = tonumber( self:GetSkin() )
	
	if Skin && Skin != 0 then
		self.DrawLoading =  self.DrawActualLoaded
		self.RoomId = Skin
	end
	
end

-- Now here's the fun part...

local _last = nil

function ENT:Draw()

	self:DrawModel()
	
	// Aim the screen forward
	local ang = self.Entity:GetAngles()
	local rot = Vector( -180, 0, -90 )
	ang:RotateAroundAxis( ang:Right(), rot.x )
	ang:RotateAroundAxis( ang:Up(), rot.y )
	ang:RotateAroundAxis( ang:Forward(), rot.z )
	
	// Place screen at the front of the model
	local pos = self:GetPos() - ( self:GetRight() * 0.8 )
	
	local dist = pos:Distance( LocalPlayer():GetShootPos() )
	if dist > 2048 + 1024 then return end
	
	// Start the fun
	cam.Start3D2D( pos, ang, 0.025 )

		local cur_x, cur_y, visible = self:MakeEyeTrace( LocalPlayer() )
		LocalPlayer().IsOnPanel = visible
		if visible then
			LocalPlayer().UsingPanel = self
		else
			//LocalPlayer().UsingPanel = nil
		end

		-- Draw the panel
		self:DrawPanel( cur_x, cur_y, visible )
		//self:DrawCursor( cur_x, cur_y, visible )

	cam.End3D2D()

	if self:DrawOverDoor() then

		local pos = self:GetPos() + ( self:GetRight() * 0.1 )
		local ang = self:GetAngles()
		local rot = Vector( -180, 0, -90 )
		ang:RotateAroundAxis( ang:Right(), rot.x )
		ang:RotateAroundAxis( ang:Up(), rot.y )
		ang:RotateAroundAxis( ang:Forward(), rot.z )
		
		// Start the fun
		cam.Start3D2D( pos, ang, .5 )

		self:DrawRoomID()

		cam.End3D2D()


		pos = pos + ( self:GetRight() * -2 )
	
		// Start the fun
		cam.Start3D2D( pos, ang, .25 )

		self:DrawMessage()

		cam.End3D2D()

	end

	self.RenderTime = CurTime() + 0.1
	
end

function ENT:DrawOverDoor()

	local loc = self:Location() or 0
	
	if loc == 6 || loc == 5 then
		return true
	end

	return false

end

function ENT:OnRoomLock()
	if !GTowerRooms then return false end
    
	local Owner = GTowerRooms:RoomOwner( self.RoomId )
	
	if IsValid( Owner ) then
		return Owner:GetNet( "RoomLock" )
	end
	
	return false	
end

function ENT:LocalOwner()
    return self.RoomId == LocalPlayer():GetNet("RoomID")
end

function ENT:DrawLoading()
	draw.DrawText( "Loading" .. string.rep( ".", CurTime() % 4 ), "suitePanelBig", -140, -140, Color( 255, 255, 255, 255 ) )
	draw.DrawText( "Vacant", "suitePanelSmall", -140, -68, Color( 255, 255, 255, 200 ) )
end

function ENT:DrawActualLoaded()
	draw.DrawText( "Suite #" .. self.RoomId, "suitePanelBig", -140, -140, Color( 255, 255, 255, 255 ) )
	draw.DrawText( GTowerRooms:RoomOwnerName( self.RoomId ) , "suitePanelSmall", -140, -68, Color( 255, 255, 255, 200 ) )
end

function ENT:GetPanelColor()

	local Room = GTowerRooms:Get( self.RoomId )
	
	if Room && Room.HasOwner then

		if self:OnRoomLock() then
			return Color( 255, 100, 100, 255 )
		end

		if self:LocalOwner() then
			return Color( 100, 255, 100, 255 )
		else
			return Color( 100, 100, 255, 255 )
		end

	end
	
	return Color( 200, 200, 200, 255 )
	
end

-- Big 2-button Terminal
function ENT:DrawPanel( cur_x, cur_y, onscreen )
    local col = self:GetPanelColor()	

	-- Backdrop
	surface.SetDrawColor( col.r, col.g, col.b, 255 )
	surface.SetTexture( self.matBackdrop )
	surface.DrawTexturedRect( -360, -180, 720, 360 )
	
	self:DrawLoading()

	-- Don't show controls at all
	local Room = GTowerRooms:Get( self.RoomId )
	if !(Room && Room.HasOwner) then return end

	if ( !self:OnRoomLock() or self:LocalOwner() or LocalPlayer():IsAdmin() ) then

		-- Open Button
		if onscreen && cur_x < 80 && cur_x > -70 && cur_y > -30 && cur_y < 160 then
			surface.SetDrawColor( col.r, col.g, col.b, 255)
			onscreen = false
		else
		    surface.SetDrawColor( col.r, col.g, col.b, 96)
		end

		surface.SetTexture( self.matButtonOpen )
		surface.DrawTexturedRect( -180, -180, 360, 360 )

		-- Close Button
		if onscreen && cur_x > 80 && cur_x < 240 && cur_y > -30 && cur_y < 160 then
			surface.SetDrawColor( col.r, col.g, col.b, 255)
			onscreen = false
		//elseif self:GetNetworkedBool(2) == false then
		//    surface.SetDrawColor( col.r, col.g, col.b, 160)
		else
		    surface.SetDrawColor( col.r, col.g, col.b, 96)
		end
		
		surface.SetTexture( self.matButtonClose )
		surface.DrawTexturedRect( 0, -180, 360, 360 )

	end

	-- Owner only
	if self:LocalOwner() or LocalPlayer():IsAdmin() then
	
		-- Lock Button
		if onscreen && cur_x < -70 && cur_x > -240 && cur_y > -30 && cur_y < 60 then
			surface.SetDrawColor( col.r, col.g, col.b, 255)
		elseif self:OnRoomLock() then
			 surface.SetDrawColor( col.r, col.g, col.b, 200)
		else
		    surface.SetDrawColor( col.r, col.g, col.b, 96)
		end
		
		surface.SetTexture( self.matButtonLock )
		surface.DrawTexturedRect( -360, -180, 360, 360 )

		-- Unlock Button
		if onscreen && cur_x < -70 && cur_x > -240 && cur_y > 70 && cur_y < 160 then
			surface.SetDrawColor( col.r, col.g, col.b, 255)
		elseif !self:OnRoomLock() then
			surface.SetDrawColor( col.r, col.g, col.b, 200)
		else
		    surface.SetDrawColor( col.r, col.g, col.b, 96)
		end
		
		surface.SetTexture( self.matButtonUnlock )
		surface.DrawTexturedRect( -360, -180, 360, 360 )

	end
	
end


surface.CreateFont( "SuiteMessageFont", {
	font      = "Bebas Neue",
	size      = 150,
	weight    = 700,
	antialias = true
})

surface.CreateFont( "SuiteNameFont", {
	font      = "Bebas Neue",
	size      = 50,
	weight    = 700,
	antialias = true
})

surface.CreateFont( "SuiteNameFont2", {
	font      = "Bebas Neue",
	size      = 40,
	weight    = 700,
	antialias = true
})

function ENT:DrawRoomID()

	// Size/pos of door
	local x, y = -152, -110
	local w, h = 110, 222

	local color = Color( 255, 255, 255, 50 )
	local owner = GTowerRooms:RoomOwner( self.RoomId )

	if IsValid( owner ) then
		color = Color( 0, 0, 255, 50 )
	end
	if self:OnRoomLock() then
		color = Color( 255, 0, 0, 50 )
	end
	if self:LocalOwner() then
		color = Color( 0, 255, 0, 50 )
	end
	if IsValid( owner ) && owner:GetNWBool("GRoomParty") then
		color = colorutil.Smooth()
	end

	if true or IsValid( owner ) then
		local dist = LocalPlayer():GetPos():Distance( self:GetPos() + self:GetForward() * 32 )
		color.a = math.Clamp( math.Fit( dist, 100, 64, 10, 0 ), 0, 50 )
		h = h * math.Clamp( dist / 256, 0, 1 )
		y = -h - y
	end

	draw.SimpleText( tostring( self.RoomId ), "SuiteMessageFont", -100, 0, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	surface.SetTexture( surface.GetTextureID( "VGUI/gradient_up" ) )
	surface.DrawTexturedRect( x, y, w, h )
	//surface.DrawRect( x, y, w, h )
	//surface.DrawRect( x, y * 1, w, SinBetween( 0, h, CurTime() * 2 ) * 1 )

	/*if IsValid( owner ) && owner:GetNWBool("GRoomParty") then
		surface.DrawRect( x, y * 1, w, SinBetween( 0, h, CurTime() * 2 ) * 1 )
	end*/

end

function ENT:DrawMessage( a )

	local owner = GTowerRooms:RoomOwner( self.RoomId )
	local iv = IsValid( owner )
	local y = iv && -265 || -230
	local txt = iv && owner:Nick() .. "'s" || "No one's Suite!"
	local a = 255

	if !iv then

		local dist = LocalPlayer():GetPos():Distance( self:GetPos() + self:GetForward() * 32 )
		a = math.Clamp( dist / 512, 0, 1 )
		a = ( 1 - a ) * 255
		
	end

	draw.SimpleText( txt, "SuiteNameFont2", -190+2, y+2, Color( 0, 0, 0, a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
	draw.SimpleText( txt, "SuiteNameFont2", -190, y, Color( 255, 255, 255, a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )

	if iv then

		if owner:GetNWString("RoomName") != "" then
			draw.SimpleText( owner:GetNWString("RoomName"), "SuiteNameFont", -190+2, -250+2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( owner:GetNWString("RoomName"), "SuiteNameFont", -190, -250, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText( "SUITE", "SuiteNameFont", -190+2, -250+2, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.SimpleText( "SUITE", "SuiteNameFont", -190, -250, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end

		if owner:GetNWBool("GRoomParty") then
			draw.SimpleText( "PARTY!", "SuiteMessageFont", -190, -325 - 64, colorutil.Smooth(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			self:FireworksDraw()
		end

	end

end

function ENT:FireworksDraw()

	if self.LastFirework && self.LastFirework > CurTime() then return end

	self.LastFirework = CurTime() + .25

	if ( math.random( 1, 2 ) == 1 ) then
	
		local eff = EffectData()
			eff:SetOrigin( self:GetPos() + self:GetForward() * 64 + self:GetUp() * 80 + ( VectorRand():GetNormal() * 25 )  )
			eff:SetEntity( self )
		util.Effect( "firework_npc", eff )
		
	end

end

function ENT:DrawCursor( cur_x, cur_y, onscreen )

	if !onscreen then return end


	local cursorSize = 64

	if self:OnRoomLock() && !self:LocalOwner() && !LocalPlayer():IsAdmin() then
		surface.SetTexture( CursorLock2D )
	else
		surface.SetTexture( Cursor2D )
	end

	if input.IsMouseDown( MOUSE_LEFT ) then
		cursorSize = 58
		surface.SetDrawColor( 255, 150, 150, 255 )
	else
		surface.SetDrawColor( 255, 255, 255, 255 )
	end

	local offset = cursorSize / 2
	surface.DrawTexturedRect( cur_x - offset + 15, cur_y - offset + 15, cursorSize, cursorSize )

end

hook.Add( "KeyPress", "KeyPressedPanelHook", function( ply, key )

	if IsValid( ply.UsingPanel ) && key == IN_ATTACK then

		local cur_x, cur_y, visible = ply.UsingPanel:MakeEyeTrace( ply )
		RunConsoleCommand( "gmt_usesuitepanel", ply.UsingPanel:EntIndex(), math.Round(cur_x), math.Round(cur_y) )

	end

end )

hook.Add( "GTowerMouseEnt", "GTowerMouseSuitePanel", function(ent, mc)

	if ent:GetClass() != "func_suitepanel" then return end
	if ent:GetPos():Distance( LocalPlayer():GetShootPos() ) > 65 then return end
	
	local cur_x, cur_y, visible = ent:MakeEyeTrace( LocalPlayer() )

	if vgui.CursorVisible() && visible && cur_x > -230 && cur_x < 224 && cur_y > -150 && cur_y < -35 then

		local owner = GTowerRooms:RoomOwner( ent.RoomId )

		if !IsValid(owner) then return end

		GTowerClick:ClickOnPlayer( owner , mc )
	
	elseif ent:LocalOwner() || LocalPlayer():IsAdmin() then

		RunConsoleCommand( "gmt_usesuitepanel", ent:EntIndex(), math.Round(cur_x), math.Round(cur_y) )

	end

	return true
end )

local function GetClientPanel()

	for _, ent in pairs( ents.FindByClass( "func_suitepanel" ) ) do

		if ent:LocalOwner() then
			return ent
		end

	end

end

/*hook.Add( "PreDrawHalos", "GTowerSuiteHalo", function()

	if !Location.IsSuite( LocalPlayer():Location() ) then return end

	local panel = GetClientPanel()

	if IsValid( panel ) then
		effects.halo.Add( {panel}, Color( 100, 255, 100 ), 4, 4, 3, true, false )
	end

end )*/