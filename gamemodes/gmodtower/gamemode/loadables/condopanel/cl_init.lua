--
-- Media player
--

include "mp/cl_init.lua"


--
-- App
--

include "shared.lua"
include "cl_graphics.lua"

module("panelos", package.seeall )

mx, my, visible = 0,0,false -- These will be used pretty much everywhere in the 'os'
scrw, scrh = 0,0
