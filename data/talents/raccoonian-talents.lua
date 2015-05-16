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
newTalent{
    name = "Raccoonian Senses",
    type = { "race/raccoonian", 1 },
    mode = "sustained",
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
    activate = function(self, t)
        local slow = -0.2
        local rad = self:getTalentRadius(t)
        local ret = {
            sid = self:addTemporaryValue("global_speed_add", slow),
            rid = self:addTemporaryValue("detect_range", rad),
            aid = self:addTemporaryValue("detect_actor", rad)
        }
        game.level.map.changed = true
        return ret
    end,
    deactivate = function(self, t, p)
        self:removeTemporaryValue("global_speed_add", p.sid)
        self:removeTemporaryValue("detect_range", p.rid)
        self:removeTemporaryValue("detect_actor", p.aid)
    end,
    info = function(self, t)
        local rad = self:getTalentRadius(t)
        return ([[Focus on the scents and noises around you.
Reveal all creatures in a radius of %d. Your deep focus will also slow you down a 20%% while active.]]):format(rad)
    end,
}
newTalent{
    name = "Raccoonian Rage",
    type = { "race/raccoonian", 1 },
    mode = "passive",
    require = racial_req1,
    points = 5,
    maxSpeedup = function(self, t)
        return self:combatTalentScale(t, 0.08, 0.3, 0.75)
    end,
    speedup = function(self, t)
        return t.maxSpeedup(self, t) * (self.max_life - self.life) / self.max_life
    end,
    callbackOnActBase = function(self, t)
        self:updateTalentPassives(t)
    end,
    passives = function(self, t, p)
        self:talentTemporaryValue(p, "global_speed_base", t.speedup(self, t))
    end,
    info = function(self, t)
        return ([[Your animal nature makes you react to pain and wounds with a wild frenzy.
Gives you action speed scaling with your missing live percentage up to %0.1f%% at 0 life. Speed boost may increase further when below 0 life.
Currently: %0.1f%%]]):format(100 * t.maxSpeedup(self, t), 100 * t.speedup(self, t))
    end,
}