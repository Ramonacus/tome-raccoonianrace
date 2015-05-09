--
-- Define raccoonian related hooks.
--

local class = require "engine.class"
local Birther = require "engine.Birther"

local load = function(self, data)
    Birther:loadDefinition("/data-raccoonianrace/birth/races/raccoonian.lua")
end

class:bindHook("ToME:load", load)