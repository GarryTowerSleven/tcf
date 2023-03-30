---------------------------------
include('shared.lua')

local DrawPlayers = CreateClientConVar( "gmt_tetris_drawplayers", 0, true, false )

local bullets = {}
local explosions = {}
local enemies = { {"fly", 0, 0} }

local score = 0

surface.CreateFont( "GalagaFont", { font = "Arcade Normal", size = 8, weight = 500, } )

function ENT:Draw()

	self:DrawModel()

	local curAng = self:GetAngles()
	curAng:RotateAroundAxis( curAng:Up(), 180 )
	curAng:RotateAroundAxis( curAng:Forward(), 90 )
	curAng:RotateAroundAxis( curAng:Right(), 90 )

	local pos = self:GetPos() + (self:GetUp() * 77) + (self:GetForward() * 6) + (self:GetRight() * 22)
	local ang = curAng
	local scl = 0.25

	cam.Start3D2D( pos, ang, scl )
		self:DrawBackdrop()
		self:DrawStars()
		self:DrawShip()

		for k,v in pairs(bullets) do
			self:DrawBullet( v[1], v[2], k )
		end

		for k,v in pairs(explosions) do
			self:DrawExplosion( v[1], v[2], k )
		end

		for k,v in pairs(enemies) do
			self:DrawEnemy( k )
		end

		self:DrawStats()

	cam.End3D2D()

end

function ENT:DrawStats()
	draw.DrawText( "HIGH SCORE",
		"GalagaFont",
		(self.DoorWidth * 4) / 2,
		5,
		Color( 255, 0, 0, 255 ),
		TEXT_ALIGN_CENTER
	)

	local scoreStr = ""

	if #tostring(score) < 6 then
		local n = (6 - #scoreStr)

		for i=1,n do
			scoreStr = scoreStr .. "0"
		end

		scoreStr = scoreStr .. tostring(score)

	end

	draw.DrawText( scoreStr,
		"GalagaFont",
		(self.DoorWidth * 4) / 2,
		15,
		Color( 255, 255, 255, 255 ),
		TEXT_ALIGN_CENTER
	)
end

function ENT:DrawBackdrop()
	surface.SetDrawColor( Color( 0, 0, 0, 255 ) )
	surface.DrawRect( 0, 0, self.DoorWidth * 4, self.DoorHeight * 4 )
end

local fly = Material("gmod_tower/arcade/galaga/fly_0001.png")

local moveX
local moveReverse = 50

function ENT:DrawEnemy( num )
	surface.SetMaterial(fly)
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

	moveX = (moveX or 0) + (FrameTime() * moveReverse)
	if moveX > self.DoorWidth * 4 - 25 then moveReverse = -50 end
	if moveX < 15 then moveReverse = 50 end

	enemies[num][1] = moveX
	enemies[num][2] = 75

	surface.DrawTexturedRect( moveX, 75, 10, 10 )

end

local EFrames = {
	[1] = Material("gmod_tower/arcade/galaga/enemy_explosion_0001.png"),
	[2] = Material("gmod_tower/arcade/galaga/enemy_explosion_0002.png"),
	[3] = Material("gmod_tower/arcade/galaga/enemy_explosion_0003.png"),
	[4] = Material("gmod_tower/arcade/galaga/enemy_explosion_0004.png"),
}

function ENT:DrawExplosion( x,y,num )
	--if !explosions[num] then return end

	if !explosions[num].Start then explosions[num].Start = CurTime() end

	local time = CurTime() - explosions[num].Start

	local spr = EFrames[1]

	if time > 0.25 then spr = EFrames[2] end
	if time > 0.5 then spr = EFrames[3] end
	if time > 0.75 then spr = EFrames[4] end

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial(spr)
	local s = 15 + (time * 25)
	surface.DrawTexturedRect( x-(s/4), y-(s/4), s-(s/2), s-(s/2) )

	if time > 1 then explosions[num] = nil end

end

local bullet = Material("gmod_tower/arcade/galaga/rocket_0001.png")

function ENT:DrawBullet( sX, sY, num )

	if !bullets[num] then return end

	if !bullets[num].CurrentY then
		bullets[num].CurrentY = sY
	end

	bullets[num].CurrentY = bullets[num].CurrentY + (FrameTime() * -250)

	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.SetMaterial(bullet)
	surface.DrawTexturedRect( sX, bullets[num].CurrentY, 5, 7 )

	for k,v in pairs( enemies ) do
		if bullets[num].CurrentY < v[2]+10 && bullets[num].CurrentY > v[2]-10 && sX < v[1]+10 && sX > v[1]-10 then
			table.insert( explosions, { v[1], v[2] } )
			bullets[num] = nil
			enemies[k] = nil
			score = score + 10
		end
	end

	if bullets[num] && bullets[num].CurrentY < 0 then bullets[num] = nil end

end

local ship = Material("gmod_tower/arcade/galaga/ship_white.png")
local shipSize = 15

local x = 0
local y = ENT.DoorHeight * 4 - 25

local isShooting = false

function ENT:DrawShip()
	local shipStartX = (self.DoorWidth * 4) / 2 - (shipSize/2)
	surface.SetMaterial(ship)
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

	local holdingL, holdingR = input.IsKeyDown( KEY_LEFT ), input.IsKeyDown( KEY_RIGHT )

	local holdingShoot = input.IsKeyDown( KEY_Z )

	if holdingL then
		x = x + (FrameTime() * -100)
	end

	if holdingR then
		x = x + (FrameTime() * 100)
	end

	if holdingShoot then

		if !isShooting then
			table.insert( bullets, { x + ( shipSize / 2 ) - 2.5, y } )
		end

		isShooting = true
	else
		isShooting = false
	end

	if x < 10 then x = 10 end
	if x > self.DoorWidth * 4 - 15 - 10 then x = self.DoorWidth * 4 - 15 - 10 end

	surface.DrawTexturedRect( x, y, shipSize, shipSize )
end

local stars = {}
local globalY = 0

local StarClrs = {
	Color( 255, 255, 255, 255 ),
	Color( 255, 100, 100, 255 ),
	Color( 100, 255, 100, 255 ),
	Color( 100, 100, 255, 255 )
}

function ENT:DrawStars()

	for i=1, 50 do

		if !stars[i] then
			stars[i] = {}
			stars[i][1] = math.random( 0, self.DoorWidth * 4 ) // Start X pos
			stars[i][2] = math.random( 0, 5 ) // Start Y pos
			stars[i][3] = math.random( 0.9, 0.95 ) // Start size
			stars[i][4] = math.random(50,150) // Move speed
			stars[i][5] = table.Random( StarClrs ) // Star color
			stars[i][6] = math.random( 0.25, 0.5 ) // Flash rate
			stars[i][7] = true // Draw
		end

		surface.SetDrawColor( stars[i][5] )

		local x = stars[i][1]
		stars[i][2] = ( stars[i][2] + (FrameTime() * stars[i][4]) )
		local strSize = 1

		if stars[i][2] > ( self.DoorHeight * 4 ) then
			stars[i] = nil
			continue
		end

		if CurTime() > (stars[i].FlashRate or 0) then
			stars[i][7] = !stars[i][7]
			stars[i].FlashRate = CurTime() + stars[i][6]
		end

		if !stars[i][7] then continue end

		surface.DrawRect( x, stars[i][2], strSize, strSize )
	end
end

function ENT:Think()

	local playing = self:GetNWBool("initGame")

end
