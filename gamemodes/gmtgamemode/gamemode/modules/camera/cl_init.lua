module( "camsystem", package.seeall )

LateJoinCameraForced = false
LateJoinCamera = nil

hook.Add( "Think", "ForceCamera", function()

	if !LateJoinCamera || LateJoinCameraForced then return end

	if LocalPlayer():GetCamera() != LateJoinCamera then
		LocalPlayer():SetCamera( LateJoinCamera, 0 )
		LateJoinCameraForced = true
	end

end )