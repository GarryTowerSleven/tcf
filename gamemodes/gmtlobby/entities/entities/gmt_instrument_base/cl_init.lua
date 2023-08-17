include("shared.lua")

ENT.DEBUG = false

ENT.KeysDown = {}
ENT.KeysWasDown = {}

ENT.AllowAdvancedMode = false
ENT.AdvancedMode = false
ENT.ShiftMode = false

local Volume = CreateClientConVar( "gmt_volume_instrument", 100, true, false, "Set how loud instruments will sound.", 0, 100 )

ENT.PageTurnSound = Sound( "GModTower/inventory/move_paper.wav" )
surface.CreateFont( "InstrumentKeyLabel", {
	size = 22, weight = 400, antialias = true, font = "Impact"
} )
surface.CreateFont( "InstrumentNotice", {
	size = 30, weight = 400, antialias = true, font = "Impact"
} )

// For drawing purposes
// Override by adding MatWidth/MatHeight to key data
ENT.DefaultMatWidth = 128
ENT.DefaultMatHeight = 128
// Override by adding TextX/TextY to key data
ENT.DefaultTextX = 5
ENT.DefaultTextY = 10
ENT.DefaultTextColor = Color( 150, 150, 150, 255 )
ENT.DefaultTextColorActive = Color( 80, 80, 80, 255 )
ENT.DefaultTextInfoColor = Color( 120, 120, 120, 150 )

ENT.MaterialDir	= ""
ENT.KeyMaterials = {}

ENT.MainHUD = {
	Material = nil,
	X = 0,
	Y = 0,
	TextureWidth = 128,
	TextureHeight = 128,
	Width = 128,
	Height = 128,
}

ENT.AdvMainHUD = {
	Material = nil,
	X = 0,
	Y = 0,
	TextureWidth = 128,
	TextureHeight = 128,
	Width = 128,
	Height = 128,
}

ENT.BrowserHUD = {
	URL = GAMEMODE.WebsiteUrl .. "instruments/piano.php",
	Show = true, // display the sheet music?
	X = 0,
	Y = 0,
	Width = 1024,
	Height = 768,
}

function ENT:Initialize()
	self:PrecacheMaterials()
end

function ENT:Think()

	if !IsValid( LocalPlayer().Instrument ) || LocalPlayer().Instrument != self then return end

	if self.DelayKey && self.DelayKey > CurTime() then return end

	// Update last pressed
	for keylast, keyData in pairs( self.KeysDown ) do
		self.KeysWasDown[ keylast ] = self.KeysDown[ keylast ]
	end

	// Get keys
	for key, keyData in pairs( self.Keys ) do

		// Update key status
		self.KeysDown[ key ] = input.IsKeyDown( key )

		// Check for note keys
		if self:IsKeyTriggered( key ) then

			if self.ShiftMode && keyData.Shift then
				self:OnRegisteredKeyPlayed( keyData.Shift.Sound )
			elseif !self.ShiftMode then
				self:OnRegisteredKeyPlayed( keyData.Sound )
			end

		end

	end

	// Get control keys
	for key, keyData in pairs( self.ControlKeys ) do

		// Update key status
		self.KeysDown[ key ] = input.IsKeyDown( key )

		// Check for control keys
		if self:IsKeyTriggered( key ) then
			keyData( self, true )
		end

		// was a control key released?
		if self:IsKeyReleased( key ) then
			keyData( self, false )
		end

	end

	// Send da keys to everyone
	//self:SendKeys()

end

function ENT:IsKeyTriggered( key )
	return self.KeysDown[ key ] && !self.KeysWasDown[ key ]
end

function ENT:IsKeyReleased( key )
	return self.KeysWasDown[ key ] && !self.KeysDown[ key ]
end

local function GetClientVolume()

	return Volume:GetInt() / 100

end

function ENT:OnRegisteredKeyPlayed( key )

	// Play on the client first
	local sound = self:GetSound( key )
	self:EmitSound( sound, 100, 100, GetClientVolume() )

	// Network it
	net.Start( "InstrumentNetwork" )

		net.WriteEntity( self )
		net.WriteInt( INSTNET_PLAY, 3 )
		net.WriteString( key )

	net.SendToServer()

	// Add the notes (limit to max notes)
	/*if #self.KeysToSend < self.MaxKeys then

		if !table.HasValue( self.KeysToSend, key ) then // only different notes, please
			table.insert( self.KeysToSend, key )
		end

	end*/

end

// Network it up, yo
function ENT:SendKeys()

	if !self.KeysToSend then return end

	// Send the queue of notes to everyone

	// Play on the client first
	for _, key in ipairs( self.KeysToSend ) do

		local sound = self:GetSound( key )

		if sound then
			self:EmitSound( sound, 100 )
		end

	end

	// Clear queue
	self.KeysToSend = nil

end

function ENT:DrawKey( mainX, mainY, key, keyData, bShiftMode )

	if keyData.Material then
		if ( self.ShiftMode && bShiftMode && input.IsKeyDown( key ) ) ||
		   ( !self.ShiftMode && !bShiftMode && input.IsKeyDown( key ) ) then

			surface.SetTexture( self.KeyMaterialIDs[ keyData.Material ] )
			surface.DrawTexturedRect( mainX + keyData.X, mainY + keyData.Y,
									  self.DefaultMatWidth, self.DefaultMatHeight )
		end

	end

	// Draw keys
	if keyData.Label then

		local offsetX = self.DefaultTextX
		local offsetY = self.DefaultTextY
		local color = self.DefaultTextColor

		if ( self.ShiftMode && bShiftMode && input.IsKeyDown( key ) ) ||
		   ( !self.ShiftMode && !bShiftMode && input.IsKeyDown( key ) ) then

			color = self.DefaultTextColorActive
			if keyData.AColor then color = keyData.AColor end
		else
			if keyData.Color then color = keyData.Color end
		end

		// Override positions, if needed
		if keyData.TextX then offsetX = keyData.TextX end
		if keyData.TextY then offsetY = keyData.TextY end

		draw.DrawText( keyData.Label, "InstrumentKeyLabel",
						mainX + keyData.X + offsetX,
						mainY + keyData.Y + offsetY,
						color, TEXT_ALIGN_CENTER )
	end
end

function ENT:DrawHUD()

	surface.SetDrawColor( 255, 255, 255, 255 )

	local mainX, mainY, mainWidth, mainHeight

	// Draw main
	if self.MainHUD.Material && !self.AdvancedMode then

		mainX, mainY, mainWidth, mainHeight = self.MainHUD.X, self.MainHUD.Y, self.MainHUD.Width, self.MainHUD.Height

		surface.SetTexture( self.MainHUD.MatID )
		surface.DrawTexturedRect( mainX, mainY, self.MainHUD.TextureWidth, self.MainHUD.TextureHeight )

	end

	// Advanced main
	if self.AdvMainHUD.Material && self.AdvancedMode then

		mainX, mainY, mainWidth, mainHeight = self.AdvMainHUD.X, self.AdvMainHUD.Y, self.AdvMainHUD.Width, self.AdvMainHUD.Height

		surface.SetTexture( self.AdvMainHUD.MatID )
		surface.DrawTexturedRect( mainX, mainY, self.AdvMainHUD.TextureWidth, self.AdvMainHUD.TextureHeight )

	end

	// Draw keys (over top of main)
	for key, keyData in pairs( self.Keys ) do

		self:DrawKey( mainX, mainY, key, keyData, false )

		if keyData.Shift then
			self:DrawKey( mainX, mainY, key, keyData.Shift, true )
		end
	end

	// Sheet music help
	if !IsValid( self.Browser ) && self.BrowserHUD.Show then

		draw.DrawText( "SPACE FOR SHEET MUSIC", "InstrumentKeyLabel",
						mainX + ( mainWidth / 2 ), mainY + 60,
						self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )

	end

	// Advanced mode
	if self.AllowAdvancedMode && !self.AdvancedMode then

		draw.DrawText( "CONTROL FOR ADVANCED MODE", "InstrumentKeyLabel",
						mainX + ( mainWidth / 2 ), mainY + mainHeight + 30,
						self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )

	elseif self.AllowAdvancedMode && self.AdvancedMode then

		draw.DrawText( "CONTROL FOR BASIC MODE", "InstrumentKeyLabel",
						mainX + ( mainWidth / 2 ), mainY + mainHeight + 30,
						self.DefaultTextInfoColor, TEXT_ALIGN_CENTER )
	end

end

// This is so I don't have to do GetTextureID in the table EACH TIME, ugh
function ENT:PrecacheMaterials()

	if !self.Keys then return end

	self.KeyMaterialIDs = {}

	for name, keyMaterial in pairs( self.KeyMaterials ) do
		if type( keyMaterial ) == "string" then // TODO: what the fuck, this table is randomly created
			self.KeyMaterialIDs[name] = surface.GetTextureID( keyMaterial )
		end
	end

	if self.MainHUD.Material then
		self.MainHUD.MatID = surface.GetTextureID( self.MainHUD.Material )
	end

	if self.AdvMainHUD.Material then
		self.AdvMainHUD.MatID = surface.GetTextureID( self.AdvMainHUD.Material )
	end

end

function ENT:OpenSheetMusic()

	if IsValid( self.Browser ) || !self.BrowserHUD.Show then return end

	self.Browser = vgui.Create( "HTML" )
	self.Browser:SetVisible( false )
	self.Browser:SetPaintedManually(true)

	local width = self.BrowserHUD.Width

	if self.BrowserHUD.AdvWidth && self.AdvancedMode then
		width = self.BrowserHUD.AdvWidth
	end

	local url = self.BrowserHUD.URL

	if self.AdvancedMode then
		url = self.BrowserHUD.URL .. "?&adv=1"
	end

	local x = self.BrowserHUD.X - ( width / 2 )

	self.Browser:OpenURL( url )

	// This is delayed because otherwise it won't load at all
	// for some silly reason...
	timer.Simple( .1, function()

		if IsValid( self.Browser ) then
			self.Browser:SetVisible( true )
			self.Browser:SetPos( x, self.BrowserHUD.Y )
			self.Browser:SetSize( width, self.BrowserHUD.Height )
		end

	end )

end

function ENT:CloseSheetMusic()

	if !IsValid( self.Browser ) then return end

	self.Browser:Remove()
	self.Browser = nil

end

function ENT:ToggleSheetMusic()

	if IsValid( self.Browser ) then
		self:CloseSheetMusic()
	else
		self:OpenSheetMusic()
	end

end

function ENT:SheetMusicForward()

	if !IsValid( self.Browser ) then return end

	self.Browser:Exec( "pageForward()" )
	self:EmitSound( self.PageTurnSound, 100, math.random( 120, 150 ) )

end

function ENT:SheetMusicBack()

	if !IsValid( self.Browser ) then return end

	self.Browser:Exec( "pageBack()" )
	self:EmitSound( self.PageTurnSound, 100, math.random( 100, 120 ) )

end

function ENT:OnRemove()

	self:CloseSheetMusic()

end

function ENT:Shutdown()

	self:CloseSheetMusic()

	self.AdvancedMode = false
	self.ShiftMode = false

	if self.OldKeys then
		self.Keys = self.OldKeys
		self.OldKeys = nil
	end

end

function ENT:ToggleAdvancedMode()
	self.AdvancedMode = !self.AdvancedMode

	if IsValid( self.Browser ) then
		self:CloseSheetMusic()
		self:OpenSheetMusic()
	end

end

function ENT:ToggleShiftMode()
	self.ShiftMode = !self.ShiftMode
end

function ENT:ShiftMod() end // Called when they press shift
function ENT:CtrlMod() end // Called when they press cntrl

hook.Add( "HUDPaint", "InstrumentPaint", function()

	if IsValid( LocalPlayer().Instrument ) then

		// HUD
		local inst = LocalPlayer().Instrument
		//inst:DrawHUD()

		// Notice bar
		local name = inst.PrintName or "INSTRUMENT"
		name = string.upper( name )

		surface.SetDrawColor( 0, 0, 0, 180 )
		surface.DrawRect( 0, ScrH() - 60, ScrW(), 60 )

		draw.SimpleText( "PRESS TAB TO LEAVE THE " .. name, "InstrumentNotice", ScrW() / 2, ScrH() - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )

	end

end )

hook.Add( "CalcView", "InstrumentPaint", function(ply, pos, ang, fov)

	if IsValid( LocalPlayer().Instrument ) then
		return {
			fov = math.max(fov, 90)
		}
	end

end )

hook.Add( "PostDrawTranslucentRenderables", "InstrumentPaint", function()

	if IsValid( LocalPlayer().Instrument ) then

		// HUD
		local inst = LocalPlayer().Instrument
		local s = 1.94 / 1.5
		local ang = inst:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 60)
		cam.Start3D2D(inst:WorldSpaceCenter() - inst:GetRight() * (inst.AdvancedMode && -18.55 || -18.23) * s - inst:GetForward() * -1 - inst:GetUp() * -7.5, ang or Angle(180, inst:GetAngles().y - 90, 240), 0.04 * s)
		inst.MainHUD.X = 305
		inst.MainHUD.Y = -60
		inst.AdvMainHUD.X = 0
		inst.AdvMainHUD.Y = -60
		//draw.RoundedBox(0, 0, 0, 128, 128, color_white)
		inst:DrawHUD()
		cam.End3D2D()
		ang:RotateAroundAxis(ang:Forward(), 20)
		cam.Start3D2D(inst:WorldSpaceCenter() - inst:GetRight() * -8.5 * s - inst:GetForward() * 1 - inst:GetUp() * -25.5, ang or Angle(180, inst:GetAngles().y - 90, -100), 0.04 * s)
		if inst.Browser then
			inst.Browser:SetWide(428)
			inst.Browser:SetPos(0, 0)
			inst.Browser:PaintManual()
		end
		cam.End3D2D()

		// Notice bar
		local name = inst.PrintName or "INSTRUMENT"
		name = string.upper( name )

		surface.SetDrawColor( 0, 0, 0, 180 )
		surface.DrawRect( 0, ScrH() - 60, ScrW(), 60 )

		draw.SimpleText( "PRESS TAB TO LEAVE THE " .. name, "InstrumentNotice", ScrW() / 2, ScrH() - 35, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1 )

	end

end )

// Override regular keys
hook.Add( "PlayerBindPress", "InstrumentHook", function( ply, bind, pressed )

	if IsValid( ply.Instrument ) then
		return true
	end

end )

net.Receive( "InstrumentNetwork", function( length, client )

	local ent = net.ReadEntity()
	local enum = net.ReadInt( 3 )

	// When the player uses it or leaves it
	if enum == INSTNET_USE then

		if IsValid( LocalPlayer().Instrument ) then
			LocalPlayer().Instrument:Shutdown()
		end

		ent.DelayKey = CurTime() + .1 // delay to the key a bit so they don't play on use key
		LocalPlayer().Instrument = ent

	// Play the notes for everyone else
	elseif enum == INSTNET_HEAR then

		// Instrument doesn't exist
		if !IsValid( ent ) then return end

		// Don't play for the owner, they've already heard it!
		if IsValid( LocalPlayer().Instrument ) && LocalPlayer().Instrument == ent then
			return
		end

		// Gather note
		local key = net.ReadString()
		local sound = ent:GetSound( key )

		if sound then
			ent:EmitSound( sound, 80, 100, GetClientVolume() )
		end

		// Gather notes
		/*local keys = net.ReadTable()

		for i=1, #keys do

			local key = keys[1]
			local sound = ent:GetSound( key )

			if sound then
				ent:EmitSound( sound, 80 )

				local eff = EffectData()
				eff:SetOrigin( ent:GetPos() + Vector(0, 0, 60) )
				eff:SetEntity( ent )

				util.Effect( "musicnotes", eff, true, true )
			end

		end*/

	end

end )
