
function GAMEMODE:EndServer()

	//I guess it it good bye
	GTowerServers:EmptyServer()
	GTowerServers:ResetServer()

end

function GAMEMODE:EnterPlayingState()
	if self.CurrentLevel == 0 then
		self:AdvanceLevelStatus()
	end

	self:SetState( 2 )
end
