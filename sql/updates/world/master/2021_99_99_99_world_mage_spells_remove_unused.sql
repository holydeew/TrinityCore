-- Remove old unused spell scripts
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('spell_mage_imp_mana_gems');
