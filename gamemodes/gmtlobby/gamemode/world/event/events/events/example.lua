local EVENT = {}

EVENT.MinLength = 10
EVENT.MaxLength = 30

// Called when the events is created and started
function EVENT:Start()
	
end

// Called every frame the event is active
function EVENT:Think()

end

// Called when the event has ended and needs to be cleaned
function EVENT:End()

end

// SERVER ONLY: Use extra net to send information to the client
function EVENT:ExtraNet()
	
end

// CLIENT ONLY: Receive all the extra net messages
function EVENT:ReceiveNet()
	
end

minievent.Register("exemple", EVENT )