---------------------------------
local meta = FindMetaTable( "Player" )
if (!meta) then
    Msg("ALERT! Could not hook Player Meta Table\n")
    return
end

function meta:SQLId()
	if !self._GTSqlID then

		if !self.SteamID then
			debug.traceback()
			Error("Trying to get player steamid before player is created!")
		end

		local SteamId = self:SteamID()
		local Findings = {}

		for w in string.gmatch( SteamId , "%d+") do
			table.insert( Findings, w )
		end

		if #Findings == 3 then
			self._GTSqlID = (tonumber(Findings[3]) * 2) + tonumber(Findings[2])
		else
			if SteamId != "STEAM_ID_PENDING" && SteamId != "UNKNOWN" then
				SQLLog( 'error', "sql id could not be found (".. tostring(SteamId) ..")\n" )
			end
			return
		end

	end

	return self._GTSqlID
end


function meta:Money()
    return self:GetSetting("GTMoney")
end

function meta:SetMoney( amount )
    self.GTMoney = math.Clamp( tonumber( amount ), 0, 2147483647 ) // math.pow( 2, 31 )  - 1  -- only allow 31 bits of numbers!
	self:SetSetting( "GTMoney", self.GTMoney )
end

function meta:AddMoney( amount, nosend )
	function math.Fit2( val, valMin, valMax, outMin, outMax )
		return ( val - valMax ) * ( outMax - outMin ) / ( valMin - valMax ) + outMin
	end

	if amount == 0 then return end

    self:SetMoney( self:Money() + amount )

	if nosend != true then
		if amount > 0 then
			self:MsgI( "money", "MoneyEarned", string.FormatNumber( amount ) )

      local pitch = math.Clamp( math.Fit( amount, 1, 500, 90, 160 ), 90, 160 )
      self:EmitSound( "GModTower/misc/gmc_earn.wav", 50, math.ceil( pitch ) )

    if !nobezier then

      local ent = ents.Create("gmt_money_bezier")

      if IsValid( ent ) then
        ent:SetPos( self:GetPos() + Vector( 0, 0, -10 ) )
        ent.GoalEntity = self
        ent.GMC = amount
        ent.RandPosAmount = 50
        ent:Spawn()
        ent:Activate()
        ent:Begin()
      end
    end

		else
			self:MsgI( "moneylost", "MoneySpent", string.FormatNumber( -amount ))
	  local pitch = math.Clamp( math.Fit2( -amount, 1, 500, 90, 160 ), 90, 160 )
      self:EmitSound( "gmodtower/misc/gmc_lose.wav", 50, math.ceil( pitch ) )
		end
	end

end

function meta:Afford( price )
    return self:Money() >= price
end

function meta:IsBot()
	return IsValid(self) && self:SteamID() == "BOT"
end
