
include("shared.lua")
include("load.lua")
include("cl_scoregui.lua")
include("cl_smallachigui.lua")

GTowerAchievements.NextUpdate = 0

local DEBUG = false

function GTowerAchievements:GetValue( id )

	local Achievement = self.Achievements[ id ]

	if Achievement == nil then
		Msg("ACHIEVEMENT: Attemping to get value of " .. id .. ", a nonexistance achievement.")
		return
	end

	local Value = Achievement.PlyVal or 0 //or cookie.GetNumber("GTachievement" .. id, 0 )

	if Achievement.GetValue then
		return Achievement.GetValue( Value )
	end

	return Value

end

function GTowerAchievements:RequestUpdate()

	if self.NextUpdate > CurTime() then
		return
	end

	self.NextUpdate = CurTime() + 3

	RunConsoleCommand("gmt_reqachi")
end

function GTowerAchievements:NumUnlocked()



	local completed = 0



	for id, achievement in pairs( GTowerAchievements.Achievements ) do



		local value = GTowerAchievements:GetValue( id )

		local maxValue = nil



		if achievement.GetMaxValue then

			maxValue = achievement.GetMaxValue()

		end



		if maxValue then

			if value == maxValue then

				completed = completed + 1

			end

			continue

		end



		if tobool( value ) then

			completed = completed + 1

		end



	end



	return completed

end

function GTowerAchievements:RecieveMessage( um )

	while true do

		local Id = um:ReadShort()
		if !Id || Id == 0 then break end

		local Item = self:Get( Id )
		if Item then
		Item.PlyVal = um[ "Read" .. Item._NWInfo[1] ]( um )
		Item.HasRecieved = true

		if Item._NWInfo[3] then
			Item.PlyVal = Item.PlyVal + Item._NWInfo[3]
		end
		end

	end

	hook.Call("AchievementUpdate", GAMEMODE )

end

usermessage.Hook("GTAch", function( um )
	GTowerAchievements:RecieveMessage( um )
end)

usermessage.Hook("GTAchWin", function( um )
	local Id = um:ReadShort()

	local Achievement = GTowerAchievements:Get( Id )

	if Achievement then
		MsgI( "trophy", T("AchievementsGot", Achievement.Name) )
	end
end)

usermessage.Hook("GTAchRest", function( um )

	local Count = um:ReadChar()

	Msg2( Count .. " trophies were deposited in your bank.")

end )

/*
concommand.Add("gmt_resetachievement", function()
	Msg("Clearing client-side achievement cookies!\n")
	sql.Query("DELETE FROM cookies WHERE key='GTachievement%'")

	for _, v in pairs( GTowerAchievements.Achievements ) do
		if v.HasRecieved != true then
			v.PlyVal = 0
		end
	end
end )
*/
