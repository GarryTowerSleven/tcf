
-----------------------------------------------------
include('shared.lua')

ENT.SaleAmount = 200
ENT.StoreName = "Invisible\nStore"

ENT.Width = 27

ENT.FrontAttachmentName = "sign_front"
ENT.BackAttachmentName = "sign_back"

ENT.ID = 0
local ActiveSales = {}
local GUIScale = 4

surface.CreateFont( "SaleFontLarge", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size 		= 5.5 * GUIScale
} )

surface.CreateFont( "SaleFontSmall", {
	font		= "Clear Sans Medium",
	antialias	= true,
	weight		= 400,
	size 		= 3 * GUIScale
} )

function ENT:Initialize()

	self.Attachments = {}
	table.insert(self.Attachments, self:LookupAttachment(self.BackAttachmentName))
	table.insert(self.Attachments, self:LookupAttachment(self.FrontAttachmentName))
end

function ENT:OnRemove()

end

local function SplitByLineLength(str, width, font)
	surface.SetFont(font)

	local words = string.Explode(' ', str, false )
	local lines = {} -- All inserted lines so far
	local curLine = "" -- The text of the current line
	local wordNum = 0 -- Keep track of the number of words inserted this line

	for _, word in pairs(words) do

		-- Add the next word to the current line to 'test' it
		local testLine = curLine .. ((#lines + wordNum > 0) and ' ' or '') ..  word
		local w, h = surface.GetTextSize(testLine)

		-- If it went over and there's more than one word there, create a new line
		if w > width and wordNum > 0 then
			-- Insert into stored lines
			table.insert(lines, curLine)

			-- New line
			wordNum = 1
			curLine = word

			continue
		end

		-- Only have a space if there is already a word inserted
		curLine = testLine
		wordNum = wordNum + 1
	end
	table.insert(lines, curLine)

	-- Seperate each line with a newline character
	return string.Implode("\n", lines)
end

function ENT:Think()
	-- Try getting some info from our store entity
	local id = self:GetStoreID()
	if not GTowerStore.ActiveSales[id] then return end

	-- Only run this once, when the id changes
	if self.ID == id then return end
	self.ID = id

	self.SaleAmount = math.floor( GTowerStore.ActiveSales[id] * 100 )

	-- Try to fit it onto the store sign
	local text = SplitByLineLength(GTowerStore.Stores[id].WindowTitle, self.Width*GUIScale, "SaleFontLarge")

	self.StoreName = text
end

function ENT:Draw()
	self:DrawModel()

	-- Draw for each attachment
	for k, attch in pairs( self.Attachments ) do
		local p = self:GetAttachment(attch)
		if not p then continue end

		-- Rotate to make it on each side of the sign
		p.Ang:RotateAroundAxis(p.Ang:Forward(), 90)
		p.Ang:RotateAroundAxis(p.Ang:Right(), k * 180)

		-- Push it out a bit to prevent zfighting
		p.Pos = p.Pos + p.Ang:Up() * 0.25

		local color = render.ComputeLighting(p.Pos, p.Ang:Up())
		color = color + render.GetLightColor(p.Pos) -- + render.GetAmbientLightColor()
		cam.Start3D2D( p.Pos, p.Ang, 1/GUIScale )
			draw.DrawText(tostring(self.SaleAmount) .. "% OFF!", "SaleFontLarge", self.Width*GUIScale/2, GUIScale * 10, color*255, TEXT_ALIGN_CENTER )
			draw.DrawText("AT THE", "SaleFontSmall", self.Width*GUIScale/2, GUIScale * 20, color*255, TEXT_ALIGN_CENTER )
			draw.DrawText(self.StoreName, "SaleFontLarge", self.Width*GUIScale/2, GUIScale * 23, color*255, TEXT_ALIGN_CENTER )
		cam.End3D2D()
	end
end

hook.Add("StoreSaleChange", "GMTSaleSignSpawner", function(storeid, saleamt)
	-- Store the sales amount ourselves, GTowerStore.Discount only stores the ~last~ discount
	ActiveSales[storeid] = saleamt
end )

concommand.Add("gmt_getpos", function(ply, cmd, args)
	local pos, ang = ply:GetPos(), ply:EyeAngles()

	Msg( "Vector(" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. "), ")
	Msg( "Angle(" .. ang.p .. ", " .. ang.y .. ", " .. ang.r .. ")\r\n")
end )
