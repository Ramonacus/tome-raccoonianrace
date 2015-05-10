--
--
--

-- Copia del "track"
newEffect{
    name = "SENSE", image = "talents/track.png",
    desc = "Sensing",
    long_desc = function(self, eff) return "Improves senses, allowing the detection of unseen things." end,
    type = "physical",
    subtype = { sense=true },
    status = "beneficial",
    parameters = { range=10, actor=1, object=0, trap=0 },
    activate = function(self, eff)
        eff.rid = self:addTemporaryValue("detect_range", eff.range)
        eff.aid = self:addTemporaryValue("detect_actor", eff.actor)
        eff.oid = self:addTemporaryValue("detect_object", eff.object)
        eff.tid = self:addTemporaryValue("detect_trap", eff.trap)
        self.detect_function = eff.on_detect
        game.level.map.changed = true
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("detect_range", eff.rid)
        self:removeTemporaryValue("detect_actor", eff.aid)
        self:removeTemporaryValue("detect_object", eff.oid)
        self:removeTemporaryValue("detect_trap", eff.tid)
        self.detect_function = nil
    end,
}
