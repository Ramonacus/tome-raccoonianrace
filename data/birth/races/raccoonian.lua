--
-- Define Raccoonian race and subrace
--

newBirthDescriptor {
    type = "race",
    name = "Raccoonian",
    desc = {
        "The Raccoonians are a timid folk dedicated to their families and forestal lands.",
    },
    descriptor_choices = {
        subrace = {
            __ALL__ = "disallow",
            Raccoonian = "allow",
        },
    },
    copy = {
        faction = "allied-kingdoms",
        type = "humanoid",
        subtype = "raccoonian",
        default_wilderness = { "playerpop", "allied" },
        starting_zone = "trollmire",
        starting_quest = "start-allied",
        starting_intro = "raccoonian",
        size_category = 2,
        resolvers.inscription("INFUSION:_REGENERATION", { cooldown = 10, dur = 5, heal = 60 }),
        resolvers.inscription("INFUSION:_WILD", { cooldown = 12, what = { physical = true }, dur = 4, power = 14 }),
        resolvers.inventory({ id = true, transmo = false, alter = function(o) o.inscription_data.cooldown = 12 o.inscription_data.heal = 50 end, { type = "scroll", subtype = "infusion", name = "healing infusion", ego_chance = -1000, ego_chance = -1000 } }),
        resolvers.inventory({ id = true, { defined = "ORB_SCRYING" } }),
    },
    random_escort_possibilities = { { "tier1.1", 1, 2 }, { "tier1.2", 1, 2 }, { "daikara", 1, 2 }, { "old-forest", 1, 4 }, { "dreadfell", 1, 8 }, { "reknor", 1, 2 }, },
}

newBirthDescriptor {
    type = 'subrace',
    name = 'Raccoonian',
    desc = {
        'Raccoonians are usually timid and reclusive, albeit some individuals crave for a more adventurous lifestyle.',
        'They possess agile limbs, natural cunning, keen senses and no talent for magic whatsoever.',
        '#GOLD#Stat modifiers:',
        '#LIGHT_BLUE# * +0 Strength, +2 Dexterity, +0 Constitution',
        '#LIGHT_BLUE# * -4 Magic, +0 Willpower, +5 Cunning',
        '#GOLD#Life per level:#LIGHT_BLUE# 11',
        '#GOLD#Experience penalty:#LIGHT_BLUE# +15%'
    },
    inc_stats = { dex = 2, mag = -4, cun = 5 },
    experience = 1.15,
    copy = {
        moddable_tile = "raccoonian",
        random_name_def = "halfling_#sex#",
        life_rating = 11,
    }
}

getBirthDescriptor("world", "Maj'Eyal").descriptor_choices.race.Raccoonian = "allow"
getBirthDescriptor("world", "Infinite").descriptor_choices.race.Raccoonian = "allow"
getBirthDescriptor("world", "Arena").descriptor_choices.race.Raccoonian = "allow"