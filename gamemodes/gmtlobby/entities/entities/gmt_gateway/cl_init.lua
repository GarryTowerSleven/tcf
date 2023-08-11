include('shared.lua')

net.Receive("TurtleUse",function()
	local bool = net.ReadBool()
	local turtle = net.ReadEntity()
	
	print(bool)

	if IsValid(turtle) then
	
		if bool then
			turtle:EmitSound( "garrysmod/save_load1.wav", 60, 50, 1, CHAN_AUTO )
		else
			turtle:EmitSound( "garrysmod/save_load3.wav", 60, 25, 1, CHAN_AUTO )
		end
	
	end
end)