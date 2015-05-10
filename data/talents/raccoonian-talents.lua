--
-- Define all 4 Raccoonian talents.
--

-- Generic racial prerequisites:
local racial_req1 = {
    level = function(level) return 0 + (level - 1) end,
}
local racial_req2 = {
    level = function(level) return 8 + (level - 1) end,
}
local racial_req3 = {
    level = function(level) return 16 + (level - 1) end,
}
local racial_req4 = {
    level = function(level) return 24 + (level - 1) end,
}

-- Racconian senses.
newTalent {
    name = "Raccoonian Senses",
    type = { "race/raccoonian", 1 },
    require = racial_req1,
    points = 5,
    no_energy = true,
    no_npc_use = true,
    cooldown = function(self, t)
        return math.ceil(self:combatTalentLimit(t, 10, 46, 30))
    end,
    radius = function(self, t)
        return math.floor(self:combatScale(self:getCun(10, true) * self:getTalentLevel(t), 5, 0, 55, 50))
    end,
    action = function(self, t)
        local rad = self:getTalentRadius(t)
        -- Hardcoded duration to 3 and speed to -0.2.
        self:setEffect(self.EFF_RACCOONIAN_SENSES, 3, {
            speed = -0.2,
            range = rad,
            actor = 1,
        })
        return true
    end,
    info = function(self, t)
        local rad = self:getTalentRadius(t)
        return ([[Focus on the scents and noises around you.
All creatures in a radius of %d for 3 turns. Your deep focus will also slow you down a 20%% for the duration.]]):format(rad)
    end,
}
newTalent{
    name = "Raccoonian Rage",
    type = {"race/raccoonian", 2},
    mode = "passive",
    require = racial_req2,
    points = 5,
    on_learn = function(self, t)

    end,
    on_unlearn = function(self, t)

    end,
    info = function(self, t)
        return ([[Lorem ipsum dolor sit amet]])
    end,
}