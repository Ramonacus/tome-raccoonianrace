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
        local lev = self:getTalentLevelRaw(t)
        self.inc_stats[self.STAT_LCK] = self.inc_stats[self.STAT_LCK] + 3
        self:onStatChange(self.STAT_LCK, 3)
        self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] + 2
        self:onStatChange(self.STAT_CUN, 2)
    end,
    on_unlearn = function(self, t)
        local lev = self:getTalentLevelRaw(t)
        self.inc_stats[self.STAT_LCK] = self.inc_stats[self.STAT_LCK] - 3
        self:onStatChange(self.STAT_LCK, -3)
        self.inc_stats[self.STAT_CUN] = self.inc_stats[self.STAT_CUN] - 2
        self:onStatChange(self.STAT_CUN, -2)
    end,
    info = function(self, t)
        return ([[Boosts your racial aptitudes for malice and thievery.
Increases Cunning by %d and Luck by %d.]]):format(2 * self:getTalentLevelRaw(t), 3 * self:getTalentLevelRaw(t))
    end,
}

-- Raccoonian musk. (Copied from cursed earth for the moment)
newTalent {
    name = "Raccoonian Musk",
    type = { "race/raccoonian", 1 },
    require = racial_req1,
    points = 5,
    no_energy = true,
    no_npc_use = true,
    cooldown = 30,
    radius = function(self, t)
        return math.floor(self:combatScale(self:getTalentLevel(t), 4, 0, 6, 5))
    end,
    range = 1,
    random_ego = "defensive",
    tactical = { DEFEND = 2 },
    getDuration = function(self, t)
        return math.min(15, 8 + math.floor(self:getTalentLevel(t)))
    end,
    getIncDamage = function(self, t)
        return math.floor(math.min(40, 15 + (math.sqrt(self:getTalentLevel(t)) - 1) * 23))
    end,
    getPowerPercent = function(self, t)
        return math.floor((math.sqrt(self:getTalentLevel(t)) - 1) * 20)
    end,
    action = function(self, t)
        local range = self:getTalentRange(t)
        local duration = t.getDuration(self, t)
        local incDamage = t.getIncDamage(self, t)

        -- project first to immediately start the effect
        local tg = {type="ball", radius=range}
        self:project(tg, self.x, self.y, DamageType.WEAKNESS, { incDamage=incDamage, dur=3 })

        game.level.map:addEffect(self,
            self.x, self.y, duration,
            DamageType.WEAKNESS, { incDamage=incDamage, dur=3 },
            range,
            5, nil,
            MapEffect.new{color_br=20, color_bg=220, color_bb=70, effect_shader="shader_images/poison_effect.png"}
        )

        return true
    end,
    info = function(self, t)
        return ([[Mark your surroundings with you musk glands, making others feel ill-at-ease.]])
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
Reveal all creatures in a radius of %d. Your deep focus will also slow you down a 20%% while active.]]):format(rad)
    end,
}

-- Raccoonian rage.
newTalent{
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
        self:setEffect(self.EFF_RACCOONIAN_RAGE, 1, {power=t.speedup(self, t)})
    end,
    info = function(self, t)
        return ([[Your animal nature makes you react to pain and wounds with a wild frenzy.
Gives you action speed scaling with your missing live percentage up to %0.1f%% at 0 life. Speed boost may increase further when below 0 life.]]):format(100 * t.maxSpeedup(self, t), 100 * t.speedup(self, t))
    end,
}