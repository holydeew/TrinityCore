DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_gen_arena_drink','spell_wintergrasp_tenacity_refresh','spell_gen_chains_of_ice'/*,'spell_gen_one_tick_dummy'*/);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(430, 'spell_gen_arena_drink'),
(431, 'spell_gen_arena_drink'),
(432, 'spell_gen_arena_drink'),
(1133, 'spell_gen_arena_drink'),
(1135, 'spell_gen_arena_drink'),
(1137, 'spell_gen_arena_drink'),
(10250, 'spell_gen_arena_drink'),
(22734, 'spell_gen_arena_drink'),
(27089, 'spell_gen_arena_drink'),
(34291, 'spell_gen_arena_drink'),
(43182, 'spell_gen_arena_drink'),
(43183, 'spell_gen_arena_drink'),
(46755, 'spell_gen_arena_drink'),
(49472, 'spell_gen_arena_drink'),
(57073, 'spell_gen_arena_drink'),
(61830, 'spell_gen_arena_drink'),
(72623, 'spell_gen_arena_drink'),
(58549, 'spell_wintergrasp_tenacity_refresh'),
(59911, 'spell_wintergrasp_tenacity_refresh'),
-- (45524, 'spell_gen_chains_of_ice'),
(66020, 'spell_gen_chains_of_ice'),
-- (55342, 'spell_gen_one_tick_dummy'),
(80166, 'spell_gen_arena_drink'), -- master
(80167, 'spell_gen_arena_drink'), -- master
(87958, 'spell_gen_arena_drink'), -- master
(87959, 'spell_gen_arena_drink'), -- master
(92736, 'spell_gen_arena_drink'), -- master
(92797, 'spell_gen_arena_drink'), -- master
(92800, 'spell_gen_arena_drink'), -- master
(92803, 'spell_gen_arena_drink'); -- master
