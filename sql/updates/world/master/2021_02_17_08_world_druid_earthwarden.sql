-- Add earthwarden script
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dru_earthwarden';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(203974, 'spell_dru_earthwarden');
