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

-- Raccoonian malice.
newTalent {
    name = "Raccoonian Malice",
    type = { "race/raccoonian", 1 },
    mode = "passive",
    require = racial_req1,
    points = 5,
    on_learn = function(self, t)
        self.inc_stats[self.STAT_DEX] = self.inc_stats[self.STAT_DEX] + 1
        self:onStatChange(self.STAT_DEX, 1)
        self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] + 3
        self:onStatChange(self.STAT_CUN, 3)
    end,
    on_unlearn = function(self, t)
        self.inc_stats[self.STAT_DEX] = self.inc_stats[self.STAT_DEX] - 1
        self:onStatChange(self.STAT_DEX, -1)
        self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] - 3
        self:onStatChange(self.STAT_CUN, -3)
    end,
    info = function(self, t)
        return ([[Boosts your racial aptitudes for malice and thievery.
Increases Cunning by %d and Dexterity by %d.]]):format(3 * self:getTalentLevelRaw(t), self:getTalentLevelRaw(t))
    end,
}

-- Racconian senses.
newTalent {
    name = "Raccoonian Senses",
    type = { "race/raccoonian", 2 },
    mode = "sustained",
    require = racial_req2,
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
        return true
    end,
    info = function(self, t)
        local rad = self:getTalentRadius(t)
        return ([[Focus on the scents and noises around you.
Reveal all creatures in a radius of %d. Your deep focus will also slow you down a 20%% while active.
Radius will increase with your Cunning.]]):format(rad)
    end,
}

-- Rockstar Raccoon Rampage.
newTalent {
    name = "Rockstar Raccoon Rampage",
    type = { "race/raccoonian", 3 },
    require = racial_req3,
    points = 5,
    no_energy = true,
    no_npc_use = true,
    cooldown = 30,
    range = 1,
    random_ego = "defensive",
    tactical = { DEFEND = 2 },
    getMovementSpeed = function(self, t)
        return self:combatScale(self:getCun(10, true) * self:getTalentLevel(t), .3, 0, 1, 50)
    end,
    getDuration = function(self, t)
        return (4 + math.floor(self:getTalentLevel(t) / 2))
    end,
    action = function(self, t)
        local duration = t.getDuration(self, t)
        local movementSpeed = t.getMovementSpeed(self, t)

        self:setEffect(self.EFF_RACCOONIAN_RAMPAGE, duration, { power = movementSpeed })

        return true
    end,
    info = function(self, t)
        return ([[Enter a destructive rampage state, boosting your movement speed by %d%% for %d turns.
Every movement action will let you unleash your destructive behaviour, granting a free attack to a random adjacent enemy as phyisical damage.]]):format(100 * t.getMovementSpeed(self, t), t.getDuration(self, t))
    end,
}

-- Raccoonian rage.
newTalent {
    name = "Raccoonian Rage",
    type = { "race/raccoonian", 4 },
    mode = "passive",
    require = racial_req4,
    points = 5,
    maxSpeedup = function(self, t)
        return self:combatTalentScale(t, 2.08, 0.3, 0.75)
    end,
    speedup = function(self, t)
        return t.maxSpeedup(self, t) * (1 - (self.life / self.max_life))
    end,
    callbackOnAct = function(self, t)
        self:setEffect(self.EFF_RACCOONIAN_RAGE, 1, { power = t.speedup(self, t) })
    end,
    info = function(self, t)
        return ([[Your animal nature makes you react to pain and wounds with a wild frenzy.
Gives you action speed scaling with your missing live percentage up to %0.1f%% at 0 life. Speed boost may increase further when below 0 life.]]):format(100 * t.maxSpeedup(self, t), 100 * t.speedup(self, t))
    end,
}