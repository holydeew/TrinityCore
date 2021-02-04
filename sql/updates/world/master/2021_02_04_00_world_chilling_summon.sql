-- Add areatrigger template (box definition)
DELETE FROM `areatrigger_template` WHERE `Id` = 3 AND `IsServerSide` = 1;
INSERT INTO `areatrigger_template` (`Id`, `IsServerSide`, `Type`, `Flags`, `Data0`, `Data1`, `Data2`, `Data3`, `Data4`, `Data5`, `ScriptName`, `VerifiedBuild`) VALUES
  (3, 1, 1, 0, 100, 100, 100, 0, 0, 0, '', 0);
  
-- Add areatrigger (serverside, position)
DELETE FROM `areatrigger` WHERE `SpawnId` = 3;
INSERT INTO `areatrigger` (`SpawnId`, `AreaTriggerId`, `IsServerSide`, `MapId`, `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`, `Comment`) VALUES
(3, 3, 1, 0,  -8490.584961, 393.610077, 115.806328, 0.5923, 1, 0, 0, 'Chilling Summon Quest - Personal Summon');
 
-- Add action on player entering areatrigger: cast spell (summon darion)
DELETE FROM `areatrigger_template_actions` WHERE `AreaTriggerId` = 3 AND `IsServerSide` = 1;
INSERT INTO `areatrigger_template_actions` (`AreaTriggerId`, `IsServerSide`, `ActionType`, `ActionParam`, `TargetType`) VALUES
(3, 1, 0, 333606, 5);

-- -------------------------

-- High Inquisitor Whitemane
SET @ENTRY := 167340;
SET @GUID := 459918;
SET @GOSSIP := 57020;
SET @QUEST := 60545; -- A chilling summon
SET @QUEST_OBJ_ONE := 406744;

DELETE FROM `creature` WHERE `guid` = @GUID;
INSERT INTO `creature` (`guid`, `id`, `zoneId`, `areaId`, `position_x`, `position_y`, `position_z`, `orientation`, `terrainSwapMap`) VALUES
(@GUID, @ENTRY, 1519, 1519, -8491.144531, 390.496735, 115.821030, 2.255547, -1);

UPDATE `creature_template` SET AIName="SmartAI" WHERE `entry` = @ENTRY;

-- -------------------------

-- SAI - trigger for when a player gets near High Inquisitor Whitemane
DELETE FROM `smart_scripts` WHERE `entryorguid` = -@GUID AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,
`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,
`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,
`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,
`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,
`target_z`,`target_o`,`comment`) VALUES
(-@GUID, 0, 0, 0, 9, 
0, 100, 0, 0, 100, 
0, 0, 11, 333606, 2, 
0, 0, 0, 0, 2, 
0, 0, 0, 0, 0, 
0, 0, "On near high inquisitor whitemane cast summon");


-- Add condition for spell implicit target for 333606
-- ConditionTypeOrReference = CONDITION_OBJECT_ENTRY_GUID=31
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceGroup` = 1 AND `SourceEntry` = 333606;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(13, 1, 333606, 0, 0, 0, 1, 0, 0, 0, 0, 0, '', "Allow teleport only once 1st quest objective is complete");


