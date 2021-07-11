if CLIENT then

	function Money()
		return LocalPlayer().GTMoney or 0
	end

	function Afford( price )
		return Money() >= price
	end

end