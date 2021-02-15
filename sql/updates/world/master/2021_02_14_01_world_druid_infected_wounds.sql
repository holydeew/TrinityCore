-- Add infected wounds
DELETE FROM `spell_proc` WHERE `SpellId` IN (48484, 345208);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`, `ProcFlags`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance` , `Cooldown`, `Charges`) VALUES
(48484, 1, 7, 0x1000, 0, 0, 0, 0x10, 1, 1, 0x403, 0, 0, 0, 100, 0, 0), -- Caused by Rake 1822
(345208, 1, 7, 0x800, 0x40, 0, 0, 0x10, 1, 1, 0x403, 0, 0, 0, 100, 0, 0); -- Caused by Maul 6807 and Mangle 33917

-- 1s: Rake conflict with ferocious bite?
-- 2nd: Test 
