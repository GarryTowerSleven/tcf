---------------------------------
include('shared.lua')

local DrawPlayers = CreateClientConVar( "gmt_tetris_drawplayers", 0, true, false )

surface.CreateFont( "TetrisScore", { font = "System", size = 40, weight = 900, } )

local TETRISCOLORS = {
	Color(255,255,255,255),
	Color(0,255,255,255),
	Color(255,0,255,255),
	Color(255,255,0,255),
	Color(255,0,0,255),
	Color(0,0,255,255),
	Color(0,255,0,255),
	Color(255,255,255,10)
}

ENT.NextBlock = {}

net.Receive( "TetrisNextBlock", function( len )
	local self = net.ReadEntity()

	self.NextBlock = net.ReadTable()
	self.NextBlockColor = net.ReadInt(4)
end )

local function DrawBoard( self )
	self:DrawModel()

	local EntPos = self:GetPos()
	local EyeForward = self:EyeAngles():Forward()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 		90 )
	ang:RotateAroundAxis(ang:Forward(), 		90 )

	local pos = EntPos + EyeForward * 6.0


	cam.Start3D2D( pos, ang, self.ImageZoom )

		local x,y,w,h = self.NegativeStartX / self.ImageZoom,
						self.NegativeStartY / self.ImageZoom,
						self.DoorWidth / self.ImageZoom,
						self.DoorHeight / self.ImageZoom


		local color = colorutil.Smooth( .25 )
		local bgcolor = Color( SinBetween( 0, 20, RealTime() / 3 ), SinBetween( 0, 20, RealTime() / 3 ), SinBetween( 0, 50, RealTime() / 3 ) )

		if self.FlashTime && self.FlashTime > UnPredictedCurTime() then
			color = colorutil.Smooth( 5 )
		end

		// Background
		surface.SetDrawColor( bgcolor.r, bgcolor.g, bgcolor.b, 255 )
		surface.DrawRect( x, y, w, h )

		// Border
		x,y,w,h = x+2, y+2, w-4, h-4

		surface.SetDrawColor( color.r, color.g, color.b, 150 )
		surface.DrawOutlinedRect( x, y, w, h )

		// Blocks
		x,y,w,h = x+1, y+1, w-2, h-2

		local NumBlocks = self.WidthSize
		local EachBlockX = math.floor( w / NumBlocks )
		local EachBlockY = math.floor( h / (NumBlocks * 2) )

		for k, v in pairs( self.Blocks ) do

			local Posx,Posy = self:NumToXY( k )

			if Posy > 0 then
				local col = TETRISCOLORS[ v ]

				surface.SetDrawColor( col.r, col.g, col.b, col.a )
				surface.DrawRect( x + EachBlockX * Posx, y + EachBlockY * (Posy-1) + 1, EachBlockX - 1, EachBlockY - 1 )
			end

		end
		
		for k, v in pairs( self.NextBlock ) do
			local Posx,Posy = self:NumToXY2( v[1], v[2] )
			local col = TETRISCOLORS[ self.NextBlockColor ]
			surface.SetDrawColor( col.r, col.g, col.b, 10 )
			surface.DrawRect( (x + EachBlockX * Posx), (y + EachBlockY * (Posy-1) + 1), EachBlockX - 1, EachBlockY - 1 )
		end

		surface.SetFont( "TetrisScore" )

		surface.SetTextColor( 255, 255, 255, 127 )
		surface.SetTextPos( x + 3 ,y )
		surface.DrawText( self.Points )

	cam.End3D2D()

end

local function DrawWaiting( self )
	self.Entity:DrawModel()
end

function ENT:Initialize()
	self.ImageZoom = 0.25
	self.Blocks = {}
	self.Points = 0

	self.OldResult = false

	self:SetNWVarProxy( "initGame", RecieveInitGame )

end

local function RecieveInitGame( ent, name, old, new )
	if IsValid( ent ) && ent.OldResult != new then

		if new == true then
			ent.ImageZoom = 0.25
			ent.Draw = DrawBoard
		else
			ent.ImageZoom = 0.4
			ent.Draw = DrawWaiting
		end

	end

	ent.OldResult = new

end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()

	local playing = IsValid(self:GetOwner())

	if playing then
		self.ImageZoom = 0.25
		self.Draw = DrawBoard
	else
		self.ImageZoom = 0.4
		self.Draw = DrawWaiting
		self.NextBlock = {}
	end


	-- Stop music
	if self:GetOwner() != LocalPlayer() then

		if self.CurrentPlayer then
			self:StopMusic()
			if self.CurrentPlayer == LocalPlayer() then
				for k,v in pairs(player.GetAll()) do
					v:SetNoDraw(false)
				end
			end
			self.CurrentPlayer = nil
			self.Points = 0
		end

 	-- Start music
	else
		if !IsValid(self.CurrentPlayer) then
			self.CurrentPlayer = self:GetOwner()
			self:StartMusic()
		else
			if self.CurrentPlayer == LocalPlayer() then
				if !DrawPlayers:GetBool() then
					for k,v in ipairs(Location.GetPlayersInLocation( LocalPlayer():Location() )) do
						if not v._TetrisHidden then
						v:SetNoDrawAll(true)
						v._TetrisHidden = true
					end
				else
					for k,v in ipairs(Location.GetPlayersInLocation( LocalPlayer():Location() )) do
						if v._TetrisHidden then
							v:SetNoDrawAll(false)
							v._TetrisHidden = false
						end
					end
				end
			end		
			self:AdjustMusic( self.Points )
		end
	end

	self:NextThink( UnPredictedCurTime() + 1.0 )

end

function ENT:StartMusic()

	if !self.Music || ( self.RepeatMusicTime && self.RepeatMusicTime < UnPredictedCurTime() ) then
		self.MusicStart = UnPredictedCurTime()
		self.Music = CreateSound( self:GetOwner(), self.SoundList[1] )
		self.Music:PlayEx( .25, 85 )
	end

end

function ENT:StopMusic()

	if self.Music && self.Music:IsPlaying() then
		self.Music:FadeOut( 1 )
		self.Music = nil
	end

end

function ENT:AdjustMusic( score )

	self.MusicRate = math.Fit( score, 0, 5000, .85, 1.8 )

	if self.Music then
		self.Music:ChangePitch( 100 * self.MusicRate, 0 )
		self.RepeatMusicTime = self.MusicStart + ( self.MusicLength / self.MusicRate )
	end

end

ENT.Draw = DrawWaiting

function ENT:DrawTranslucent()
end

function ENT:ReadBlock( um )
	local ReturnInt = 0

	if um:ReadBool() then
		ReturnInt = ReturnInt + 1
	end

	if um:ReadBool() then
		ReturnInt = ReturnInt + 2
	end

	if um:ReadBool() then
		ReturnInt = ReturnInt + 4
	end

	return ReturnInt
end

function ENT:RecieveDataUpdate( um )
	self.Points = um:ReadShort() + 32000

	local SizeDelete = um:ReadChar()
	for i=1, SizeDelete do
		local id = um:ReadChar() + 127
		self.Blocks[ id ] = nil
	end

	local SizeAdd = um:ReadChar()
	for i=1, SizeAdd do
		local id = um:ReadChar() + 127
		local value = self:ReadBlock( um ) + 1

		self.Blocks[ id ] = value
	end

	local PlaySound = self:ReadBlock( um ) + 1

	if PlaySound > 1 && self:GetOwner() == LocalPlayer():EntIndex() then
		LocalPlayer():EmitSound( self.SoundList[ PlaySound ], 100, 100 )
	end

end

function ENT:RecieveDataFull( um )

	self.Blocks = {}

	local LastPoints = self.Points

	self.Points = um:ReadShort() + 32000
	
	if self.Points - LastPoints > 6 then
		self.FlashTime = UnPredictedCurTime() + .5
	end

	local MessageType = um:ReadBool()

	if MessageType == true then

		local Size = um:ReadChar()
		for i=1, Size do
			local id = um:ReadChar() + 127
			local value = self:ReadBlock( um ) + 1

			self.Blocks[ id ] = value
		end
	else
		for i=9, 209 do
			local HasBlock = um:ReadBool()

			if HasBlock == true then
				self.Blocks[ i ] = self:ReadBlock( um ) + 1
			end
		end
	end

	local PlaySound = self:ReadBlock( um ) + 1
	if self:GetOwner() == LocalPlayer() then
		if PlaySound > 1  then
			LocalPlayer():EmitSound( self.SoundList[ PlaySound ], 100, 100 )
		end
	end

end

usermessage.Hook("Tetr", function(um)
	local ent = um:ReadEntity()

	if IsValid( ent ) && ent:GetClass() == "gmt_tetris" && ent.RecieveDataFull then
		local Type = um:ReadBool()

		if Type == true then
			ent:RecieveDataUpdate( um )
		else
			ent:RecieveDataFull( um )
		end
	end

end )
