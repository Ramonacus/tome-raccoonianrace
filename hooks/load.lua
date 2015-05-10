--
-- Define raccoonian related hooks.
--

local class = require "engine.class"
local ActorTemporaryEffects = require "engine.interface.ActorTemporaryEffects"
local ActorTalents = require "engine.interface.ActorTalents"
local Birther = require "engine.Birther"

local load = function(self, data)
    ActorTemporaryEffects:loadDefinition("/data-raccoonianrace/timed_effects/raccoonian.lua")
    ActorTalents:loadDefinition("data-raccoonianrace/talents/raccoonian-category.lua")
    Birther:loadDefinition("/data-raccoonianrace/birth/races/raccoonian.lua")
end

class:bindHook("ToME:load", load)