--
-- Define all 4 Raccoonian talents.
--

-- Generic racial prerequisites:
local racial_req1 = {
    level = function(level) return 0 + (level-1)  end,
}
local racial_req2 = {
    level = function(level) return 8 + (level-1)  end,
}
local racial_req3 = {
    level = function(level) return 16 + (level-1)  end,
}
local racial_req4 = {
    level = function(level) return 24 + (level-1)  end,
}

-- Racconian senses.
newTalent {
    name = "Raccoonian Senses",
    type = { "race/raccoonian", 1 },
    require = racial_req1,
    points = 5,
    on_learn = function(self, t)

    end,
    on_unlearn = function(self, t)

    end,
    info = [[Focus on the scents and noises around you, revealing all creatures in a radius of 10 while slowing you down for 20%]],
}