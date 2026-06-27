UPDATE GameOptions SET Visible = 0 WHERE Type = 'GAMEOPTION_NEW_RANDOM_SEED';

-- Jordans Custom Changes:
DELETE FROM Feature_YieldChanges
WHERE FeatureType IN (
    'FEATURE_POTOSI',
    'FEATURE_EL_DORADO',
    'FEATURE_FOUNTAIN_YOUTH',
    'FEATURE_SOLOMONS_MINES',
    'FEATURE_VOLCANO',
    'FEATURE_LAKE_VICTORIA',
    'FEATURE_FUJI',
    'FEATURE_MT_KAILASH',
    'FEATURE_KILIMANJARO',
    'FEATURE_MT_SINAI',
    'FEATURE_GEYSER',
    'FEATURE_GIBRALTAR',
    'FEATURE_SRI_PADA',
    'FEATURE_CRATER',
    'FEATURE_MESA',
    'FEATURE_REEF',
    'FEATURE_ULURU'
);
INSERT INTO Feature_YieldChanges
    (FeatureType, YieldType, Yield)
VALUES
    -- Natural Wonder base yields
    ('FEATURE_POTOSI', 'YIELD_PRODUCTION', 5),
    ('FEATURE_EL_DORADO', 'YIELD_CULTURE', 5),
    ('FEATURE_EL_DORADO', 'YIELD_GOLD', 5),
    ('FEATURE_EL_DORADO', 'YIELD_GOLDEN_AGE_POINTS', 500),
    ('FEATURE_FOUNTAIN_YOUTH', 'YIELD_SCIENCE', 5),
    ('FEATURE_FOUNTAIN_YOUTH', 'YIELD_CULTURE', 5),
    ('FEATURE_SOLOMONS_MINES', 'YIELD_PRODUCTION', 10),
    ('FEATURE_VOLCANO', 'YIELD_SCIENCE', 10),
    ('FEATURE_LAKE_VICTORIA', 'YIELD_FOOD', 10),
    ('FEATURE_FUJI', 'YIELD_CULTURE', 5),
    ('FEATURE_FUJI', 'YIELD_GOLD', 5),
    ('FEATURE_FUJI', 'YIELD_SCIENCE', 5),
    ('FEATURE_MT_KAILASH', 'YIELD_FAITH', 10),
    ('FEATURE_KILIMANJARO', 'YIELD_CULTURE', 10),
    ('FEATURE_MT_SINAI', 'YIELD_FAITH', 10),
    ('FEATURE_GEYSER', 'YIELD_CULTURE', 5),
    ('FEATURE_GEYSER', 'YIELD_SCIENCE', 5),
    ('FEATURE_GIBRALTAR', 'YIELD_GOLD', 5),
    ('FEATURE_SRI_PADA', 'YIELD_FOOD', 5),
    ('FEATURE_CRATER', 'YIELD_SCIENCE', 5),
    ('FEATURE_MESA', 'YIELD_FOOD', 5),
    ('FEATURE_REEF', 'YIELD_SCIENCE', 5),
    ('FEATURE_REEF', 'YIELD_FOOD', 5),
    ('FEATURE_REEF', 'YIELD_CULTURE', 5),
    ('FEATURE_ULURU', 'YIELD_PRODUCTION', 5);
	
-- Jordan: ONLY Petra is made NON-UNIQUE (MaxGlobalInstances/MaxPlayerInstances = -1) so any
-- civ can build it as many times as they want. It stays a regular building that keeps the
-- wonder art/splash/desert yields; confirmed crash-safe with many copies in testing.
-- Pyramid / Notre Dame / Temple of Artemis are LEFT as normal one-per-world VP wonders:
-- duplicating those trips a divide-by-zero in the clean (un-rebuildable) DLL, so they must
-- stay capped at one in the world. The bonuses we wanted for every civ live on the Palace.
UPDATE BuildingClasses
SET MaxGlobalInstances = -1,
    MaxPlayerInstances = -1
WHERE DefaultBuilding = 'BUILDING_PETRA';
