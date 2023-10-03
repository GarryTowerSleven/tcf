module( "minievent", package.seeall )

base = {}
base.__index = base

base.__EndTime = 0
base.__IsValid = true
base.__Length = 0

base.MinLength = 10
base.MaxLength = 30

//Called when the events is created and started
function base:Start()
	
end

//Called every frame the event is active
function base:Think()

end

//Called when the event has ended and needs to be cleaned
function base:End()


end

//Call to destroy the object and remove it from the list
function base:Destroy()

	// Clear decals
	BroadcastLua( "RunConsoleCommand('r_cleardecals')" )

	//Invalidate the object
	self.__IsValid = false
	
	//End it for all the pretty effents, make it safe so the program can keep it's flow
	SafeCall( self.End, self )
	
	//Remove it from the list
	for k, v in pairs( minievent.Active ) do
		if v == self then
			minievent.Active[ k ] = nil
		end
	end
	
end


//Returns how many seconds are left until the end
function base:Timeleft()
	return math.max( self.__EndTime - CurTime(), 0 )
end

//Return the total length in seconds of this event
function base:GetLength()
	return self.__Length
end

//Return the CurTime() of when this event will end
function base:GetEndTime()
	return self.__EndTime
end

function base:IsValid()
	return self.__IsValid
end

if SERVER then
	function base:__SendToClient()
		//Send to the client about our new stuff!
		net.Start("minievent")
			net.WriteUInt( 0, 4 )
			net.WriteUInt( 1, 8 )

			self:__SendToClientMessage()
		net.Broadcast()
	end
	
	function base:__SendToClientMessage()
		net.WriteString( self.Name )
		net.WriteFloat( self:GetEndTime() )
			
		self:ExtraNet()
	end
	
	function base:ExtraNet()
		
	end
	
else
	
	function base:ReceiveNet()
		
	end
	
end

