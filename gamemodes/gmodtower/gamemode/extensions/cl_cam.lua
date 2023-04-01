if _G.__CAM_HOOKED then return end --Only Once

print("HOOK CAM")

local Matrix = Matrix
local table = table
local hook = hook
local cam = cam
local ErrorNoHalt = ErrorNoHalt
local _G = _G

module( "cam" )

local _PushModelMatrix = cam.PushModelMatrix
local _PopModelMatrix = cam.PopModelMatrix
local _MatrixStack = {}
local _Pushed = false

function GetTop() return _MatrixStack[ 1 ] or Matrix() end

local function SafePush( mtx )

	if _Pushed then _PopModelMatrix() end
	_PushModelMatrix( mtx )
	_Pushed = true

end

local function SafePop()

	if _Pushed then _PopModelMatrix() end
	_Pushed = false

end

function MatrixMultiply( mtx, preTransform )

	local top = _MatrixStack[ 1 ]
	if top then

		if preTransform then 
			mtx = mtx * top
		else
			mtx = top * mtx
		end

		SafePush( mtx )
		
		_MatrixStack[ 1 ] = mtx

		return mtx

	else

		ErrorNoHalt( "cam.MatrixMultiply: Must have a matrix pushed on the stack" )

	end

end

function PushModelMatrix( mtx, preTransform )

	if not mtx then 
		ErrorNoHalt( "cam.PushModelMatrix: No matrix provided" )
		return 
	end

	local top = _MatrixStack[ 1 ]
	if top then

		if preTransform then 
			mtx = mtx * top
		else
			mtx = top * mtx
		end

	end

	table.insert( _MatrixStack, 1, mtx )

	SafePush( mtx )

	return mtx

end

function PopModelMatrix()

	if #_MatrixStack > 1 then

		local top = _MatrixStack[ 1 ]

		SafePush( top )
		table.remove( _MatrixStack, 1 )

		return top

	else

		SafePop()

		local top = _MatrixStack[ 1 ]
		if top then
			table.remove( _MatrixStack, 1 )
		end

		return top

	end

end

hook.Add( "PostRender", "_matrixStackClear", function() 
	
	if #_MatrixStack > 0 then

		_MatrixStack = {}
		SafePop()

		ErrorNoHalt( "MATRIXSTACK: STACK ISN'T EMPTY, ARE YOU MISSING A CALL TO 'cam.PopModelMatrix'?" )

	end

end )

_G.__CAM_HOOKED = true