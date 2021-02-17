-- Add Guardian Of The Elune script
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dru_tooth_and_claw';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(135288, 'spell_dru_tooth_and_claw');
