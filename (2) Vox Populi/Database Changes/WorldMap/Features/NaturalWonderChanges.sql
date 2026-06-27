INSERT INTO Feature_EraYieldChanges
	(FeatureType, YieldType, Yield)
VALUES
	('FEATURE_POTOSI', 'YIELD_PRODUCTION', 1),
	('FEATURE_EL_DORADO', 'YIELD_CULTURE', 1),
	('FEATURE_EL_DORADO', 'YIELD_GOLD', 1),
	('FEATURE_EL_DORADO', 'YIELD_GOLDEN_AGE_POINTS', 500),
	('FEATURE_FOUNTAIN_YOUTH', 'YIELD_SCIENCE', 1),
	('FEATURE_FOUNTAIN_YOUTH', 'YIELD_CULTURE', 1),
	('FEATURE_SOLOMONS_MINES', 'YIELD_PRODUCTION', 1),
	('FEATURE_VOLCANO', 'YIELD_SCIENCE', 1),
	('FEATURE_LAKE_VICTORIA', 'YIELD_FOOD', 1),
	('FEATURE_FUJI', 'YIELD_CULTURE', 1),
	('FEATURE_FUJI', 'YIELD_GOLD', 1),
	('FEATURE_FUJI', 'YIELD_SCIENCE', 1),
	('FEATURE_MT_KAILASH', 'YIELD_FAITH', 1),
	('FEATURE_KILIMANJARO', 'YIELD_CULTURE', 1),
	('FEATURE_MT_SINAI', 'YIELD_FAITH', 1),
	('FEATURE_GEYSER', 'YIELD_CULTURE', 1),
	('FEATURE_GEYSER', 'YIELD_SCIENCE', 1),
	('FEATURE_GIBRALTAR', 'YIELD_GOLD', 1),
	('FEATURE_SRI_PADA', 'YIELD_FOOD', 1),
	('FEATURE_CRATER', 'YIELD_SCIENCE', 1),
	('FEATURE_MESA', 'YIELD_FOOD', 1),
	('FEATURE_REEF', 'YIELD_SCIENCE', 1),
	('FEATURE_REEF', 'YIELD_FOOD', 1),
	('FEATURE_REEF', 'YIELD_CULTURE', 1),
	('FEATURE_ULURU', 'YIELD_PRODUCTION', 1);

-- No happiness, first discovery gold or adjacent promotion in VP
-- OccurrenceFrequency in this table is unused in VP, setting it to 1 to not confuse modders
UPDATE Features
SET InBorderHappiness = 5, FirstFinderGold = 1000, AdjacentUnitFreePromotion = NULL, OccurrenceFrequency = 1;

-- Instead, owning some NWs grants free promotions to all units
UPDATE Features
SET FreePromotionIfOwned = 'PROMOTION_SACRED_STEPS'
WHERE Type = 'FEATURE_SRI_PADA';

UPDATE Features
SET FreePromotionIfOwned = 'PROMOTION_EVERLASTING_YOUTH'
WHERE Type = 'FEATURE_FOUNTAIN_YOUTH';

UPDATE Features
SET FreePromotionIfOwned = 'PROMOTION_ALTITUDE_TRAINING'
WHERE Type = 'FEATURE_KILIMANJARO';

-- Not tall enough to be mountains?
UPDATE Natural_Wonder_Placement
SET ChangeCoreTileToMountain = 0
WHERE NaturalWonderType IN (
	'FEATURE_MESA',
	'FEATURE_ULURU'
);

UPDATE Features
SET SeeThrough = 1
WHERE Type IN (
	'FEATURE_MESA',
	'FEATURE_ULURU'
);

-- Mountains are now taller
UPDATE Features
SET SeeThrough = 3
WHERE Type IN (
	SELECT NaturalWonderType FROM Natural_Wonder_Placement WHERE ChangeCoreTileToMountain = 1
);

-- Non-mountains are no longer impassable
UPDATE Features
SET Impassable = 0, Movement = 2, Defense = 10
WHERE Type IN (
	'FEATURE_CRATER',
	'FEATURE_GEYSER',
	'FEATURE_FOUNTAIN_YOUTH',
	'FEATURE_EL_DORADO',
	'FEATURE_MESA',
	'FEATURE_REEF',
	'FEATURE_ULURU',
	'FEATURE_SOLOMONS_MINES'
);

-- OccurrenceFrequency: mountains are boring and should have a lower rate
UPDATE Natural_Wonder_Placement
SET OccurrenceFrequency = 20;

UPDATE Natural_Wonder_Placement
SET OccurrenceFrequency = 10
WHERE ChangeCoreTileToMountain = 1;

UPDATE Features
SET AddsFreshWater = 1
WHERE Type = 'FEATURE_FOUNTAIN_YOUTH';

UPDATE Features SET Help = 'TXT_KEY_CIV5_FEATURES_SRI_PADA_HELP' WHERE Type = 'FEATURE_SRI_PADA';
UPDATE Features SET Help = NULL WHERE Type = 'FEATURE_EL_DORADO';
