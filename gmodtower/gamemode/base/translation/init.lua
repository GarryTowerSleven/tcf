---------------------------------
include("shared.lua")

local function UMsgT( icon, target, trans, ... )

	umsg.Start("t7", target)
		umsg.String( trans )
		umsg.String( icon )
		umsg.Char( select('#', ...) )

		for _, v in ipairs( {...} ) do
			umsg.String( v )
		end

	umsg.End()

end

local meta = FindMetaTable( "Player" )

if !meta then
    Msg("ALERT! Could not hook Player Meta Table\n")
    return
end

function meta:Msg2( msg, icon )

	if !msg || type(msg) != "string" then return end

	if #msg > 251 then
		SQLLog('error', "Tried to send a message that would overflow umsg [" .. str .. "]")
		return
	end
	
	if icon == nil then icon = "" end
	
	umsg.Start("t6", self)
		umsg.String( msg )
		umsg.String( icon )
	umsg.End()

end

function meta:MsgI( icon, trans, ... )
	UMsgT( icon, self, trans, ... )
end

function meta:MsgT( trans, ... )
	UMsgT( "", self, trans, ... )
end

