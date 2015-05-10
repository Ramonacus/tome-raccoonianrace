--
--
--

-- Copia del "track"
newEffect {
    name = "RACCOONIAN_SENSES",
    image = "talents/raccoonian_senses.png",
    desc = "Raccoonian senses",
    long_desc = function(self, eff)
        return "Focus on your keen senses, allowing the detection of unseen creatures but slowing you down for 20%."
    end,
    type = "physical",
    subtype = { sense = true },
    status = "beneficial",
    parameters = {
        range = 10,
        actor = 1,
        object = 0,
        trap = 0
    },
    activate = function(self, eff)
        eff.sid = self:addTemporaryValue("global_speed_add", eff.speed)
        eff.rid = self:addTemporaryValue("detect_range", eff.range)
        eff.aid = self:addTemporaryValue("detect_actor", eff.actor)
        self.detect_function = eff.on_detect
        game.level.map.changed = true
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("global_speed_add", eff.sid)
        self:removeTemporaryValue("detect_range", eff.rid)
        self:removeTemporaryValue("detect_actor", eff.aid)
        self.detect_function = nil
    end,
}
