--
-- Define raccoonian related hooks.
--

local class = require "engine.class"
local Birther = require "engine.Birther"
local ActorTalents = require "engine.interface.ActorTalents"

local load = function(self, data)
    ActorTalents:loadDefinition("data-raccoonianrace/talents/raccoonian-category.lua")
    Birther:loadDefinition("/data-raccoonianrace/birth/races/raccoonian.lua")
end

class:bindHook("ToME:load", load)