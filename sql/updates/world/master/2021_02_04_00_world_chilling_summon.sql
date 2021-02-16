
-- ------------------------- Variables

SET @ATT_START = 3; -- Initial highest value of `Id` in areatrigger_template, + 1
SET @AT_START = 3; -- Initial highest value of `Id` in areatrigger, + 1
-- SET @WSF_START = 7583;

SET @INQ_ENTRY := 171789; -- High Inquisitor Whitemane
-- SET @GUID := 459918;
SET @GOSSIP := 57020;
SET @QUEST := 60545; -- A chilling summon
SET @QUEST_OBJ_ONE := 406744; -- Learn about your leaders' fate
SET @QUEST_OBJ_TWO := 406745; -- Take the Death Gate to Acherus
SET @QUEST_OBJ_THREE := 405017; -- Take the teleporter to the Frozen Throne

SET @GATE_ENTRY := 171039;
SET @GATE_GUID := 459923;
SET @GATE_SPELL_TELEPORT := 333607;

SET @GATE_POS_X := -8483.441406;
SET @GATE_POS_Y := 384.078461;
SET @GATE_POS_Z := 115.857712;
SET @GATE_POS_O := 2.28637;

SET @DARION_SW_ENTRY := 176554; -- Darion at stormwind
SET @DARION_ICC_ENTRY := 169070; -- Darion at icecrown citadel, after the 1st teleporter

SET @BOLVAR_ENTRY := 169076; -- highlord-bolvar-fordragon

SET @SCOURGE_SPELL_TELEPORT := 328796;

-- ------------------------- Part 1: Summon personal spawns

-- Add areatrigger template (box definition)
DELETE FROM `areatrigger_template` WHERE `Id` = @ATT_START AND `IsServerSide` = 1;
INSERT INTO `areatrigger_template` (`Id`, `IsServerSide`, `Type`, `Flags`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `ScriptName`, `VerifiedBuild`) VALUES
  (@ATT_START, 1, 1, 0, 100, 100, 100, 0, 0, 0, 'SmartAreaTriggerAI', 0);
  
-- Add areatrigger (serverside, position)
DELETE FROM `areatrigger` WHERE `SpawnId` = @AT_START;
INSERT INTO `areatrigger` (`SpawnId`, `AreaTriggerId`, `IsServerSide`, `MapId`, `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`, `Comment`) VALUES
(@AT_START, @ATT_START, 1, 0,  -8490.584961, 393.610077, 115.806328, 2.16309632679, 1, 0, 0, 'Chilling Summon Quest - Personal Summon');
 
-- Smart scripts: summon personal spawns
DELETE FROM `smart_scripts` WHERE `entryorguid` = @AT_START AND `source_type` = 12;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@AT_START, 12, 0, 1, 46, 0, 100, 0, 0, 0, 0, 0, 12, @INQ_ENTRY,       8, 0, 0, 3, 0, 8, 0, 0, 0, -8491.144531, 390.496735,  115.821030,  2.255547, "On areatriggerserver - summon high inquisitor, personal spawn"),
(@AT_START, 12, 1, 2, 61, 0, 100, 0, 0, 0, 0, 0, 12, @DARION_SW_ENTRY, 8, 0, 0, 3, 0, 8, 0, 0, 0, -8490.584961, 393.610077,  115.806328,  2.255547, "On link - summon darion, personal spawn"),
(@AT_START, 12, 2, 3, 46, 0, 100, 0, 0, 0, 0, 0, 12, @GATE_ENTRY,      8, 0, 0, 3, 0, 8, 0, 0, 0, @GATE_POS_X,  @GATE_POS_Y, @GATE_POS_Z, 2.255547, "On areatriggerserver - summon gate, if completed objective already. Conditioned with quest objective");

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` IN (1, 3) AND `SourceEntry` = @AT_START AND `SourceId` = 12;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22, 1, @AT_START, 12, 1, 47, 0, @QUEST,         10,   0, 0, 0, '', "Script 1: Allow smart script only if the player has the chillin summon quest as completed or in progress (not rewarded)"),
(22, 1, @AT_START, 12, 1, 29, 0, @INQ_ENTRY,     110, 0, 1, 0, '', "Script 1: AND summon once - we are not near high inquistor Whitemane. We use distance higher than areatrigger to make sure we only trigger this once"),
(22, 3, @AT_START, 12, 1, 48, 0, @QUEST_OBJ_ONE, 0,   0, 0, 0, '', "Script 3: Only summon gate if quest objective is complete"),
(22, 3, @AT_START, 12, 1, 29, 0, @GATE_ENTRY,    140, 0, 1, 0, '', "Script 3: AND summon once - we are not near gate");

-- ------------------------- Part 2: Allow player to interact and complete 1st objective

-- Allow interaction on high inquisitor
UPDATE `creature_template` SET `gossip_menu_id` = @GOSSIP, `npcflag` = 1, `AIName` = 'SmartAI' WHERE `entry` = @INQ_ENTRY;

-- Gossip
DELETE FROM `gossip_menu` WHERE `MenuId` = @GOSSIP;
INSERT INTO `gossip_menu` (`MenuId`, `TextId`, `VerifiedBuild`) VALUES (@GOSSIP, 1, -1);

DELETE FROM `gossip_menu_option` WHERE `MenuId` = @GOSSIP;
INSERT INTO `gossip_menu_option` (`MenuId`, `OptionIndex`, `OptionText`, `OptionType`, `OptionNpcFlag`, `VerifiedBuild`) VALUES
(@GOSSIP, 0, "Tell me what happened.", 1, 1, -1);


-- conditions: only allow interaction if player has quest but didn't take
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 15 AND `SourceGroup` = @GOSSIP;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference` ,`ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(15, @GOSSIP, 0, 0, 0, 47, 0, @QUEST        , 8, 0, 0, 0, '', "Script 1: Display gossip only if quest is taken"),
(15, @GOSSIP, 0, 0, 0, 48, 0, @QUEST_OBJ_ONE, 0, 0, 1, 0, '', "Script 1: AND Display gossip only if quest objective isn't complete");


-- SAI: give credits (kills a creature that gives credit)
DELETE FROM `smart_scripts` WHERE `entryorguid` = @INQ_ENTRY AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@INQ_ENTRY, 0, 0, 1, 62, 0, 100, 0, @GOSSIP, 0, 0, 0, 72, 2,           3000, 0, 0, 0, 0, 1, 0, 0, 0,  0,           0,           0,           0, "On gossip action 0 from menu selected - None: Close gossip"),
(@INQ_ENTRY, 0, 1, 2, 61, 0, 100, 0, 0,       0, 0, 0, 33, 173227,      0,    0, 0, 0, 0, 7, 0, 0, 0,  0,           0,           0,           0, "On link - Loot recipient: Give kill credit [DNT] Credit: Abduction Scene"),
(@INQ_ENTRY, 0, 2, 0, 61, 0, 100, 0, 0,       0, 0, 0, 12, @GATE_ENTRY, 8,    0, 0, 3, 0, 8, 0, 0, 0,  @GATE_POS_X, @GATE_POS_Y, @GATE_POS_Z, @GATE_POS_O, "On link - Summon the gate (personal spawn)");

-- ------------------------- Part 3: Gate
-- Allow interaction on gate creature
UPDATE `creature_template` SET `npcflag` = 16777216 WHERE `entry` = @GATE_ENTRY;

-- add spell click for gate
DELETE FROM `npc_spellclick_spells` WHERE `npc_entry` = @GATE_ENTRY;
INSERT INTO `npc_spellclick_spells` (`npc_entry`, `spell_id`, `cast_flags`, `user_type`) VALUES (@GATE_ENTRY, @GATE_SPELL_TELEPORT, 3 ,0);

-- Only allow spell teleport if quest objective 1st is complete
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 18 AND `SourceGroup` = @GATE_ENTRY;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup` ,`SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(18, @GATE_ENTRY, @GATE_SPELL_TELEPORT, 0, 0, 48, 0, @QUEST_OBJ_ONE, 0, 0, 0, 0, '', "Allow teleport only once 1st quest objective is complete");

-- Gate teleport spell target position
DELETE FROM `spell_target_position` WHERE `id` = @GATE_SPELL_TELEPORT;
INSERT INTO `spell_target_position` (`id`, `EffectIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`) VALUES
(@GATE_SPELL_TELEPORT, 0, 2147, -642.88, 2208.25, 550.71); 

-- Add script to complete objective when clicking on the gate

-- ------------------------- Part 4: Scourge Transporter - from Deathbringer's Rise to The Frozen Throne

-- Add areatrigger template (box definition)
DELETE FROM `areatrigger_template` WHERE `Id` = @ATT_START+1 AND `IsServerSide` = 1;
INSERT INTO `areatrigger_template` (`Id`, `IsServerSide`, `Type`, `Flags`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `ScriptName`, `VerifiedBuild`) VALUES
  (@ATT_START+1, 1, 1, 0, 3.6, 3.442, 2, 0, 0, 0, '', 0);

-- Add areatrigger (serverside, position)
DELETE FROM `areatrigger` WHERE `SpawnId` = @AT_START+1;
INSERT INTO `areatrigger` (`SpawnId`, `AreaTriggerId`, `IsServerSide`, `MapId`, `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`, `Comment`) VALUES
(@AT_START+1, @ATT_START+1, 1, 2147,  -548.971923828125, 2211.219970703125, 539.2769775390625, 0, 1, 0, 0, 'Deathbringer\'s Rise - Teleport to The Frozen Throne');

-- Add area trigger action to cast the teleport spell
DELETE FROM areatrigger_template_actions WHERE `AreaTriggerId` = @AT_START+1 AND `IsServerSide` = 1;
INSERT INTO areatrigger_template_actions (`AreaTriggerId`, `IsServerSide`, `ActionType`, `ActionParam`, `TargetType`) VALUES
(@AT_START+1, 1, 0, @SCOURGE_SPELL_TELEPORT, 5);

-- Teleporter spell target position
DELETE FROM `spell_target_position` WHERE `id` = @SCOURGE_SPELL_TELEPORT;
INSERT INTO `spell_target_position` (`id`, `EffectIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`) VALUES
(@SCOURGE_SPELL_TELEPORT, 0, 2147, 559.020, -2124.869, 840.857); 

-- ------------------------- Part 5: The Frozen Throne

-- Add areatrigger template (box definition)
DELETE FROM `areatrigger_template` WHERE `Id` = @ATT_START+2 AND `IsServerSide` = 1;
INSERT INTO `areatrigger_template` (`Id`, `IsServerSide`, `Type`, `Flags`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `ScriptName`, `VerifiedBuild`) VALUES
  (@ATT_START+2, 1, 1, 0, 50, 50, 50, 0, 0, 0, 'SmartAreaTriggerAI', 0);

-- Add areatrigger (serverside, position)
DELETE FROM `areatrigger` WHERE `SpawnId` = @AT_START+2;
INSERT INTO `areatrigger` (`SpawnId`, `AreaTriggerId`, `IsServerSide`, `MapId`, `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`, `Comment`) VALUES
(@AT_START+2, @ATT_START+2, 1, 2147, 559.020, -2124.869, 840.857, 0, 1, 0, 0, 'SL The Frozen Throne - Summon personal spawns');


DELETE FROM `smart_scripts` WHERE `entryorguid` = @AT_START+2 AND `source_type` = 12;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(@AT_START+2, 12, 0, 1, 46, 0, 100, 0, 0, 0, 0, 0, 12, @BOLVAR_ENTRY,    8, 0, 0, 3, 0, 8, 0, 0, 0, 500.71182, -2127.2188, 840.9403, 0.647, "On areatriggerserver - summon high inquisitor, personal spawn");


-- 328796 




DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 22 AND `SourceGroup` = 1 AND `SourceEntry` = @AT_START+2 AND `SourceId` = 12;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(22, 1, @AT_START+2, 12, 1, 47, 0, @QUEST,           2,   0, 0, 0, '', "Script 1: If the player has the chillin summon quest as incomplete"),
(22, 1, @AT_START+2, 12, 1, 48, 0, @QUEST_OBJ_THREE, 0,   0, 0, 0, '', "Script 1: AND quest objective 3 is complete"),
(22, 1, @AT_START+2, 12, 1, 29, 0, @BOLVAR_ENTRY,    100, 0, 1, 0, '', "Script 1: AND there is no personal summon nearby (assuring summmon once)");







-- ------------------------- Part 1: Summon personal spawns

-- Smart scripts


