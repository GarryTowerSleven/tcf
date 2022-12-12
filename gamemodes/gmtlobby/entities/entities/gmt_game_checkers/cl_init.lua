include('shared.lua')

ENT.RenderGroup = RENDERGROUP_BOTH

local HELP = [[How to Move:

In checkers, each standard piece can move one place forward, diagonally.
They can also "jump" over an opponent's checker - removing the 
taken piece from the board. If having executed this move, the same attacking
checker can take another opposing piece which allows a double move.

Kings:

When a piece reaches the opposite end of the board, it is 
crowned and becomes a "king". Kings are the same as standard
checkers, except that they can move in all four directions.

How to Win:

A player wins by leaving the opposing player with no more 
available pieces or moves.]]
local CheckersHelp

local MatDir = "gmod_tower/arcade/checkers/"
local MatBlack = Material( MatDir .. "black.png" )
local MatBlackKing = Material( MatDir .. "blackking.png" )
local MatWhite = Material( MatDir .. "white.png" )
local MatWhiteKing = Material( MatDir .. "whiteking.png" )
local MatDarkSquare = Material( MatDir .. "darksquare2.png" )
local MatLightSquare = Material( MatDir .. "lightsquare2.png" )

function ENT:Initialize()

	self.Ply1 = nil
	self.Ply2 = nil

	self.CurTurn = false // needed?
	
	self.ImageZoom = 0.4
	
	self.ActivePlayer = nil
	
	self:ReloadOBBBounds()
	
	self.Blocks = {}
	
end

function ENT:TurnOn() 
	self.ImageZoom = 0.4
	self.SecondDraw = self.DrawBoard
	self.ActivePlayer = self.Ply1
end

function ENT:TurnOff() 
	self.ImageZoom = 0.25
	self.SecondDraw = self.DrawWaiting	
end

function ENT:DrawSidePlayer( ply ) // Draws half of the image that is shown when the game is waiting for players to join.

	local col = Color( 255, 0, 0, 50 )
	local PlyName = "No Player"
	
	if IsValid( ply ) && ply:IsPlayer() then
		col = Color( 0, 255, 0, 50 )
		PlyName = ply:Nick()
	end
	
	local x,y = -self.NegativeSize / self.ImageZoom, 2
	local w,h = self.TblSize / self.ImageZoom, self.NegativeSize / self.ImageZoom - 4

	draw.RoundedBox(2, x,y,w,h,	col)
	draw.SimpleText(PlyName, "ScoreboardText", x + w / 2, y + h / 2, Color(255,255,255,255),1,1)

end

function ENT:DrawRotatingBoard( pos, ang ) // Draws the rotating sign above the board.

	local LocalPos = LocalPlayer():EyePos()

	ang:RotateAroundAxis( ang:Up(), RealTime() * 25 % 360 )
	
	if (LocalPos - pos ):DotProduct( ang:Right() ) < 0 then
		ang:RotateAroundAxis( ang:Up(), 180 )
	end

	ang:RotateAroundAxis( ang:Forward(), 90 )
	
	local Scale = .35 //math.Clamp( LocalPos:Distance( pos ) / 450, 0.25, 1.0 )

	cam.Start3D2D( pos, ang, Scale )	
	
		draw.RoundedBox(2, -40, -16, 80, 32, Color( 25,25,25,250) )
		draw.SimpleText("CHECKERS", "GTowerHUDMain", 0,0, Color(255,255,255,255),1,1)
		
	cam.End3D2D()

end

function ENT:GetActivePlayer() // Returns the player whose turn it is.
	if IsValid( self.Ply1) && self.PlyTurn == 1 then return self.Ply1
	elseif IsValid( self.Ply2) && self.PlyTurn == 2 then return self.Ply2
	else return LocalPlayer()
	end
end

function ENT:DrawBoard() // Draws the checkerboard, the checkers and highlights the blocks that each player is aiming at.

	local EntPos = self.Entity:GetPos()
	local EyeForward = self.Entity:EyeAngles():Up()
	
	local ang = self.Entity:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90 )
	
	local pos = EntPos + EyeForward * self.UpPos
	local TargetPly = self:GetActivePlayer()
	
	if !IsValid( TargetPly ) then
		return
	end
	
	local x,y = self:GetEyeBlock( TargetPly ) // Finds which block the player is looking at.
	
	local SizeBlock = (self.TblSize / self.ImageZoom) / self:GetNumBlocks()
	local MinPos = self.NegativeSize / self.ImageZoom
	
	cam.Start3D2D( pos, ang, self.ImageZoom )
		
		for j=0, self:GetNumBlocks()-1 do // For each row, do:
		
			for i=0, self:GetNumBlocks()-1 do // For each cell in a row, do:
			
				local BoxId = self:XYToNum( j, i ) // The block's number.
				local BoxOwner = self.Blocks[ BoxId ] // The block's color.
				local Checkcol = Color(255,255,255)
				local DiscMat = nil
				
				// CHECKERED BOARD AND HIGHLIGHTING:
				if j == x && i == y then // If the block is being looked at:
					if TargetPly == LocalPlayer() then
						Checkcol = Color(100,255,100) // If you are looking at the block, it is highlighted green.
					else
						Checkcol = Color(255,255,100) // If the other person is looking at it, it is highlighted yellow.
					end
				elseif BoxId == self.HighBlock then
					Checkcol = Color(100,100,255) // If the block has been selected, it is highlighted blue.
				end

				if j % 2 == i % 2 then
					surface.SetMaterial( MatLightSquare )
				else
					surface.SetMaterial( MatDarkSquare )
				end

				surface.SetDrawColor( Checkcol.r, Checkcol.g, Checkcol.b )
				surface.DrawTexturedRect( j*SizeBlock - MinPos, i*SizeBlock - MinPos, SizeBlock * 1.1, SizeBlock * 1.1 )
				//draw.RoundedBox( 0, j*SizeBlock - MinPos, i*SizeBlock - MinPos, SizeBlock, SizeBlock, Checkcol ) // CHECKERED BOARD
	
				// CHECKER DISC COLOR:
				if BoxOwner == 1 || BoxOwner == 3 then // White checkers are White.
					DiscMat = MatWhite
				elseif BoxOwner == 2 || BoxOwner == 4 then // Black checkers are black.
					DiscMat = MatBlack
				end
				
				if BoxOwner == 3 || BoxOwner == 4 then // If the disc is a king, it draws a yellow ring around it.
					if DiscMat == MatWhite then
						DiscMat = MatWhiteKing
					else
						DiscMat = MatBlackKing
					end

					/*draw.RoundedBox( 6, 
						j * SizeBlock - MinPos + SizeBlock*0.15, 
						i * SizeBlock - MinPos + SizeBlock*0.15, 
						SizeBlock*0.7, 
						SizeBlock*0.7, 
						Color(255,255,0,255)
					)*/
				end

				if DiscMat then
					surface.SetMaterial( DiscMat )
					surface.SetDrawColor( 255, 255, 255 )
					surface.DrawTexturedRect( j * SizeBlock - MinPos + SizeBlock*0.2, i * SizeBlock - MinPos + SizeBlock*0.2, SizeBlock*0.6, SizeBlock*0.6 )
				end
				
				/*draw.RoundedBox( 6, // DRAW DISCS
					j * SizeBlock - MinPos + SizeBlock*0.2, 
					i * SizeBlock - MinPos + SizeBlock*0.2, 
					SizeBlock*0.6, 
					SizeBlock*0.6, 
					Boxcol
				)*/
				
			end
		end		
		
		// BORDERS:
		local Bordercol = Color(100,54,35,255)
		draw.RoundedBox( 0, -(SizeBlock * 4) - 5, -(SizeBlock * 4) - 5, 5, (SizeBlock * 8) + 10, Bordercol) // bottom barrier
		draw.RoundedBox( 0, (SizeBlock * 4), -(SizeBlock * 4) - 5, 5, (SizeBlock * 8) + 10, Bordercol) // top
		draw.RoundedBox( 0, -(SizeBlock * 4), -(SizeBlock * 4) - 5, (SizeBlock * 8), 5, Bordercol) // left
		draw.RoundedBox( 0, -(SizeBlock * 4), (SizeBlock * 4), (SizeBlock * 8), 5, Bordercol) // right
			
	cam.End3D2D()

end

function ENT:DrawWaiting() // Draws the whole image that is shown when the game is waiting for players to join.

	local EntPos = self.Entity:GetPos()
	local EyeForward = self.Entity:EyeAngles():Up()
	
	local ang = self.Entity:GetAngles()
	//ang:RotateAroundAxis(ang:Up(), 		90 )
	
	local pos = EntPos + EyeForward * self.UpPos
	
	cam.Start3D2D( pos, ang, self.ImageZoom )	
		self:DrawSidePlayer( self.Ply1 )
	cam.End3D2D()
	
	ang:RotateAroundAxis(ang:Up(), 		180 )
	
	cam.Start3D2D( pos, ang, self.ImageZoom )		
		self:DrawSidePlayer( self.Ply2 )
	cam.End3D2D()
	
	local ang2 = ang
	
	ang:RotateAroundAxis(ang:Up(), CurTime() * 25 % 360 )
	
	cam.Start3D2D( pos, ang, 0.1 )		
		draw.RoundedBox( 16, -40, -40, 80, 80, Color(0,0,0,150))
		draw.SimpleText("?", "GTowerhuge", 0,0, Color(255,255,255,255),1,1)
	cam.End3D2D()
	
	self:DrawRotatingBoard( EntPos + EyeForward * 64, ang2 )	
	
	
end

ENT.SecondDraw = ENT.DrawWaiting // The game starts of in the 'waiting' position.

function ENT:Draw()
	self.Entity:DrawModel()
end

function ENT:DrawTranslucent()
	self:SecondDraw()
end


local CheckersLocalPlaying = false

hook.Add( "PlayerThink", "FadePlayersCheckers", function()
	//LocalPlayer():HideLocalPlayers( CheckersLocalPlaying )
end )

function ENT:OnRemove()
	if self.Ply1 == LocalPlayer() || self.Ply2 == LocalPlayer() then
		CheckersLocalPlaying = false
	end
end


function ENT:CheckersNet()
	local MsgId = net.ReadUInt( 1 )
	
	if MsgId == 0 then
		self.Blocks = {}
	
		self.HighBlock = net.ReadUInt( 7 ) // highlighted block
	
		for i=1, (self:GetNumBlocks() * self:GetNumBlocks()) do
			
			if net.ReadBool() then
				self.Blocks[ i ] = net.ReadUInt( 3 )
			else
				self.Blocks[ i ] = nil
			end
		
		end	
			
		local initGame = net.ReadBool()
		
		if initGame then self:TurnOn() end
		if !initGame then self:TurnOff() end
		
		local ply1 = net.ReadEntity()
		local ply2 = net.ReadEntity()
		self.PlyTurn = net.ReadUInt( 2 )
		
		self.Ply1 = ply1 or NULL
		self.Ply2 = ply2 or NULL

		if ply1 == LocalPlayer() || ply2 == LocalPlayer() then
			CheckersLocalPlaying = true
		else
			CheckersLocalPlaying = false
		end
	end

end

net.Receive( "boarddata", function( len, ply )
	local ent = net.ReadEntity()

	if IsValid( ent ) && ent.CheckersNet then
		ent:CheckersNet()
	end
end )

net.Receive( "checkersH", function( len )
	if ValidPanel( CheckersHelp ) then
		CheckersHelp:Remove()
	end

	CheckersHelp = vgui.Create("DFrame")
	local text = vgui.Create("DLabel", CheckersHelp)
	
	CheckersHelp.Close = function()
		CheckersHelp:Remove()
		CheckersHelp = nil
		GtowerMainGui:GtowerHideMenus()
	end
	
	
	text:SetText( HELP )
	text:SizeToContents()
	text:SetPos( 5, 27 )
	
	CheckersHelp:SetTitle("Rules of Checkers")
	CheckersHelp:SetSize( text:GetWide() + 10, text:GetTall() + 5 + 27 )
	CheckersHelp:Center()
	
	GtowerMainGui:GtowerShowMenus()
end )

hook.Add("CanCloseMenu", "CheckersHelp", function()
	if ValidPanel( CheckersHelp ) then
		return false
	end
end )