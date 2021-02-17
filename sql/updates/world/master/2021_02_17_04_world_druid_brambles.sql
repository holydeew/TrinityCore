-- Add brambles spell script
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'spell_dru_brambles';
INSERT INTO `spell_script_names` (`spell_id`,`ScriptName`) VALUES
(203953, 'spell_dru_brambles');
