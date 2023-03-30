
-----------------------------------------------------


module("composite", package.seeall)



local CMODE_ADD = 1

local CMODE_SUB = 2



function render.SetupEZStencil()

	render.SetStencilFailOperation( STENCILOPERATION_KEEP )

	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )

	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )

	render.SetStencilWriteMask( 0xFF )

	render.SetStencilTestMask( 0xFF )

end



function render.EZStencil(stencilwrite,stencildraw,invert,noclear)

	if stencilwrite then

		if not noclear then render.ClearStencil() end

		render.SetStencilEnable(true)

		render.SetStencilReferenceValue( invert and 0 or 1 )

		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )

		render.OverrideColorWriteEnable( true, stencildraw )

	elseif stencildraw then

		render.OverrideColorWriteEnable( false, false )

		render.SetStencilReferenceValue( 1 )

		render.SetStencilCompareFunction(

			invert and STENCILCOMPARISONFUNCTION_NOTEQUAL or

			STENCILCOMPARISONFUNCTION_EQUAL )

	else

		render.SetStencilEnable(false)

	end

end



local function mkCall(call, ...)

	local args = {...}

	return {func = call, args = args}

end



local Meta = {}

Meta.__index = Meta



function New(...)

	return setmetatable({}, Meta):Init(...)

end



function Meta:Init()

	self.drawcalls = {}

	return self

end



function Meta:Clear()

	self.drawcalls = {}

end



function Meta:Add(call, ...)

	local c = mkCall(call, ...)

	c.mode = CMODE_ADD

	table.insert(self.drawcalls, c)

end



function Meta:Subtract(call, ...)

	local c = mkCall(call, ...)

	c.mode = CMODE_SUB

	table.insert(self.drawcalls, c)

end



function Meta:Draw()

	render.SetupEZStencil()

	render.ClearStencil()



	local calls = self.drawcalls

	for i=#calls, 1, -1 do



		local call = calls[i]

		local mode = call.mode



		if mode == CMODE_SUB then

			render.EZStencil(true,false,false,true)

		elseif mode == CMODE_ADD then

			render.EZStencil(false,true,true,true)

		end



		local b,e = pcall(call.func, unpack(call.args))

		if not b then print(e) end



	end



	render.OverrideColorWriteEnable( false, false )

	render.SetStencilEnable(false)

end
