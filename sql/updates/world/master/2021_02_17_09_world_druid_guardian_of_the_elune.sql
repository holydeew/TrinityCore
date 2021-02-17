-- Add Guardian Of The Elune script
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dru_guardian_of_the_elune';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(155578, 'spell_dru_guardian_of_the_elune');
