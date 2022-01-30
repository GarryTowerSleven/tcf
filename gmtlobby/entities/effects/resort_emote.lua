local fallback = Material("icon16/monkey.png")
function EFFECT:Init(data)
	self.Origin = data:GetOrigin()
	self.Angles = data:GetAngles()
	self.StartVelMagnitude = data:GetMagnitude()
	self.Size = data:GetRadius() or 10
	
	local emoteid = data:GetAttachment()
	local emoji = emotes[data:GetAttachment()]
	-- if it doesn't exist, load it
	if not emoji.mat then
		CasinoKit.getRemoteMaterial(emoji.img, function(mat)
			emoji.mat = mat
		end, true)		
		self.sprite = fallback
		self.loadingMat = emoji
	else
		self.sprite = emoji.mat
	end
	self.StartTime = CurTime()
end


function EFFECT:Think()
   if (self.StartTime + 3) < CurTime() then
      return false
   end
   
   local elapsed = CurTime() - self.StartTime
   self.Pos = self.Angles:Up() * elapsed *5 + self.Origin

   return true
end

local col_white = Color(255,255,255)
function EFFECT:Render()

	local size = self.Size * 15-- 1.5 + 10 * elapsed
	if not self.Pos then
		return
	end
	
	if self.loadingMat and self.loadingMat.mat then
		self.sprite = self.loadingMat.mat
		self.loadingMat = nil
	end
	
	--render.DrawSphere(self.Pos, 8, 8, 8)
	render.SetMaterial(self.sprite)
	render.DrawSprite(self.Pos, size, size, col_white)
end
