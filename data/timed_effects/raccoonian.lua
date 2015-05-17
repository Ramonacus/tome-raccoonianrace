--
-- Timed effects for Raccoonians.
--

-- Raccoonian rage.
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
local Map = require "engine.Map"
local DamageType = require "engine.DamageType"

-- Raccoonian rampage.
newEffect{
    name = "RACCOONIAN_RAMPAGE",
    image = "talents/rockstar_raccoon_rampage.png",
    desc = "Raccoon rampage",
    long_desc = function(self, eff)
        return ("Increases %d%% movement speed and grants free attacks to random targets while moving."):format(eff.power * 100)
    end,
    type = "physical",
    subtype = {
        speed=true
    },
    status = "beneficial",
    parameters = {
        power = 0.2
    },
    callbackOnMove = function(self, eff, moved, force, ox, oy)
        local tgts = {}
        for _, c in pairs(util.adjacentCoords(self.x, self.y)) do
            local target = game.level.map(c[1], c[2], Map.ACTOR)
            if target and self:reactionToward(target) < 0 then tgts[#tgts+1] = target end
        end
        if #tgts > 0 then
            self.turn_procs.raccoonian_rampage = true
            DamageType:projectingFor(self, {project_type={talent=self:getTalentFromId(self.T_ROCKSTAR_RACCOON_RAMPAGE)}})
            self:attackTarget(rng.table(tgts), DamageType.PHYSICAL, self:combatTalentWeaponDamage(self.T_ROCKSTAR_RACCOON_RAMPAGE, 0.5, 1.1), true)
            DamageType:projectingFor(self, nil)
        end
    end,
    activate = function(self, eff)
        eff.tmpid = self:addTemporaryValue("movement_speed", eff.power)
    end,
    deactivate = function(self, eff)
        self:removeTemporaryValue("movement_speed", eff.tmpid)
    end
}
