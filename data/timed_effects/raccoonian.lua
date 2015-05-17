--
-- Timed
--

newEffect{
    name = "RACCOONIAN_RAGE",
    image = "talents/raccoonian_rage.png",
    desc = "Raccoonian rage",
    long_desc = function(self, eff) return ("Increases global action speed by %d%%."):format(eff.power * 100) end,
    type = "physical",
    subtype = {
        tactic=true
    },
    status = "beneficial",
    decrease = 0,
    no_remove = true,
    parameters = {
        power = 1
    },
    charges = function(self, eff)
        return ("%d%%"):format(eff.power * 100)
    end,
    activate = function(self, eff)
        eff.tmpid = self:addTemporaryValue("global_speed_add", eff.power)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("global_speed_add", eff.tmpid)
    end
}
