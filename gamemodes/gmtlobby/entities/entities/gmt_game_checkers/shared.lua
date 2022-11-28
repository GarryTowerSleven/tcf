ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Checkers Table"
ENT.Author			= "PixelTail Games & Clockwork"
ENT.Contact			= ""
ENT.Purpose			= "For GMod Tower"
ENT.Instructions	= ""
ENT.Spawnable		= false
ENT.AdminSpawnable	= false

//ENT.Model			= Model( "models/props_wasteland/kitchen_counter001b.mdl")
ENT.Model			= Model( "models/gmod_tower/gametable.mdl")

ENT.TblSize = 60 //Actually 64, but do not include the borders
ENT.NegativeSize = ENT.TblSize / 2
ENT.UpPos = 20.25

function ENT:ReloadOBBBounds()
	local mins = self:OBBMins()
	local maxs = self:OBBMaxs()
	
	local TblSize = maxs.x - mins.x
	
	if TblSize > maxs.y - mins.y then
		TblSize = maxs.y - mins.y
	end
	
	self.TblSize = math.floor( TblSize * 0.94 )
	self.UpPos = maxs.z
	self.NegativeSize = self.TblSize / 2
end

function ENT:Get2DPos( ply ) // Converts an aim position into a 2D position.

	local tr = util.QuickTrace( ply:GetShootPos(), ply:GetAimVector() * 128, ply )	
	local LocalPos = self:WorldToLocal( tr.HitPos )

	return (LocalPos.x + self.NegativeSize) / self.TblSize, (LocalPos.y + self.NegativeSize) / self.TblSize

end

function ENT:GetEyeBlock( ply ) // Returns the x,y value of the block that the player is aiming at.

	//Y, X because it is rotated
	local y,x = self:Get2DPos( ply )
	local EachBlock = 1 / self:GetNumBlocks()
	
	return math.ceil( x / EachBlock ) - 1, math.ceil( y / EachBlock ) - 1
	
end

function ENT:NumToXY( num ) // Converts an x,y value into a block number.

	local NumBlocks = self:GetNumBlocks()
	
	num = num - 1
	
	/*local x = ( (num - 1) % NumBlocks ) + 1
	local y = math.ceil( num / (x * NumBlocks))*/
	
	local y = num % NumBlocks
	local x = (num - y) / NumBlocks
	
	return x,y
	
end

function ENT:XYToNum( x, y ) // Converts a block number into an x,y value.

	local NumBlocks = self:GetNumBlocks()
	return x * NumBlocks + y + 1
	
end

function ENT:GetNumBlocks() // Returns 8.
	return 8
end

