surface.CreateFont( "TetrisLeaderTitle", {
	font = "Oswald",
	size = 130,
	weight = 800,
	antialias = true,
	additive = false
} )

local ScoreTable = {}

local lastAng

local blockColors = {
	["r"] = Color(255, 0, 0, 25),
	["g"] = Color(0, 255, 0, 25),
	["b"] = Color(0, 0, 255, 25),
	["c"] = Color(0, 255, 255, 25),
	["y"] = Color(255, 255, 0, 25),
	["p"] = Color(255, 0, 255, 25),
	["w"] = Color(255, 255, 255, 25),
	["x"] = Color(0, 0, 0, 0)
}

local blocks = {
	blockColors.p, blockColors.p, blockColors.b, blockColors.b,
	blockColors.g, blockColors.w, blockColors.w, blockColors.c,
	blockColors.c, blockColors.c, blockColors.c, blockColors.r,
	blockColors.g, blockColors.g, blockColors.g, blockColors.b,
	blockColors.b, blockColors.g, blockColors.y, blockColors.p,
	blockColors.b, blockColors.b, blockColors.g, blockColors.g,
	blockColors.w, blockColors.w, blockColors.p, blockColors.p,
	blockColors.p, blockColors.r, blockColors.r, blockColors.p,
	blockColors.g, blockColors.b, blockColors.b, blockColors.g,
	blockColors.g, blockColors.g, blockColors.y, blockColors.p,
	blockColors.x, blockColors.x, blockColors.x, blockColors.g,
	blockColors.c, blockColors.c, blockColors.c, blockColors.c,
	blockColors.p, blockColors.r, blockColors.x, blockColors.p,
	blockColors.p, blockColors.p, blockColors.c, blockColors.c,
	blockColors.c, blockColors.c, blockColors.y
}

local function drawLeaderBlocks(w, h)
	surface.SetDrawColor(255, 255, 255)

	local s = 31

	local lineOffset = 0
	local rowOffset = 0

	for i=1, #blocks do
		surface.SetDrawColor( blocks[i] )
		
		if i % 20 == 0 then
			lineOffset = lineOffset + 1
			rowOffset = 0
		end
		
		surface.DrawRect((-(w/2)-20) + ( rowOffset * (s + 2) ), h-s-20 + ((s + 2) * -lineOffset), s, s)
		
		rowOffset = rowOffset + 1
	end
	
	surface.SetDrawColor( blockColors.y )
	surface.DrawRect(297, h - 51, s, s)
end

local pos = Vector(-1390, 2275, -50)
local entryMargin = 62
local entryStartHeight = 128

hook.Add( "PostDrawTranslucentRenderables", "DrawTetrisBoard", function()
	local Wobbl = (math.sin( CurTime() ) * 2)
	
	if LocalPlayer():GetPos():Distance(pos) > 785 then return end

	local localRank = LocalPlayer()._TetrisHighScoreRank
	if localRank and localRank <= 10 then
		entryMargin = 68
	end

	local plyVec, plyAng = WorldToLocal( LocalPlayer():GetPos(), LocalPlayer():GetAngles(), pos, Angle(0,0,0) )
	
	local ang = Angle(0, plyVec:Angle().y + 90, 90)
	if not lastAng then lastAng = ang end
	
	lastAng = LerpAngle( RealFrameTime() * 2, lastAng, ang )

	cam.Start3D2D( Vector( pos.x, pos.y, pos.z + Wobbl ), lastAng, 0.25 )
		surface.SetDrawColor( Color(0, 0, 0, 180) )
			
		local w, h = 620, 850
		local m = 24
		
		surface.DrawRect(-m - (w/2), -16, w + (m*2), h)
	
		local color = colorutil.Smooth( .25 )

		surface.SetDrawColor( color.r, color.g, color.b, 150 )
		
		surface.DrawOutlinedRect(-m - (w/2), -16, w + (m*2), h, 2)
	
		drawLeaderBlocks(w, h)
	
		draw.DrawText("BLOCKLES LEADERBOARD", "TetrisLeaderTitle", -(w/2), -m, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT)
		
		surface.SetDrawColor( Color(255, 255, 255) )
		surface.DrawRect(-(w/2), 100, 620, 3)
		
		local players = ""
		local scores = ""

		for k, v in pairs(ScoreTable) do
			if not v.Name or not v.Score then continue end
			if v.Local and v.Pos <= 10 then continue end

			local name = v.Name
			
			if #name > 12 then
				name = name:sub(1, 12) .. "..."
			end
			
			local nameString = "#" .. v.Pos .. "  -  " .. name .. "\n"
			local scoreString = string.FormatNumber( v.Score ) .. "\n"

			local textColor = Color( 255, 255, 255, 255 )

			if v.Id == LocalPlayer():SteamID() then
				textColor = Color( 255, 255, 0, 255 )
			end

			local heightOffset = (k-1) * entryMargin

			draw.DrawText(nameString, "GTowerSkyMsgSmall", -(w/2), entryStartHeight + heightOffset, textColor, TEXT_ALIGN_LEFT)
			draw.DrawText(scoreString, "GTowerSkyMsgSmall", -(w/2) + 620, entryStartHeight + heightOffset, textColor, TEXT_ALIGN_RIGHT)
		end
		
	cam.End3D2D()
end )

net.Receive("UpdateTetrisBoard",function()
	local tbl = net.ReadTable()
  
	if !tbl then return end

	-- Inserting the scores by key so the 11th entry (your own) remains at the bottom.
	for i = 1, #tbl do
		ScoreTable[i] = tbl[i]
	end
end)
  
net.Receive("UpdatePersonalTetrisScore", function()
	local score = net.ReadInt(32)
	local rank = net.ReadInt(32)
  
	if !score or !rank then return end
  
	LocalPlayer()._TetrisHighScore = score
	LocalPlayer()._TetrisHighScoreRank = rank
  
	-- This can be better! Up for the challenge?
	ScoreTable[11] = {
	  ["Name"] = LocalPlayer():Nick(),
	  ["Score"] = score,
	  ["Id"] = LocalPlayer():SteamID(),
	  ["Pos"] = rank,
	  ["Local"] = true
	}
end)
