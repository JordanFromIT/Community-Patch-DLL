UPDATE Worlds
SET
	MinDistanceCities = 5,
	MinDistanceCityStates = 3,
	NumCitiesPolicyCostMod = 5,
	NumCitiesTourismCostMod = 5,
	NumCitiesTechCostMod = 5,
	NumCitiesUnitSupplyMod = 5,
	ResearchPercent = 100;

UPDATE Worlds
SET
	ReformationPercentRequired = 250,
	NumCitiesUnhappinessPercent = 150,
	TradeRouteDistanceMod = 80
WHERE Type = 'WORLDSIZE_DUEL';

UPDATE Worlds
SET
	ReformationPercentRequired = 200,
	NumCitiesUnhappinessPercent = 125,
	TradeRouteDistanceMod = 80
WHERE Type = 'WORLDSIZE_TINY';

UPDATE Worlds
SET
	ReformationPercentRequired = 150,
	NumCitiesUnhappinessPercent = 115,
	TradeRouteDistanceMod = 90
WHERE Type = 'WORLDSIZE_SMALL';

UPDATE Worlds
SET
	ReformationPercentRequired = 100,
	NumCitiesUnhappinessPercent = 100,
	TradeRouteDistanceMod = 100
WHERE Type = 'WORLDSIZE_STANDARD';

UPDATE Worlds
SET
	ReformationPercentRequired = 80,
	NumCitiesUnhappinessPercent = 80,
	TradeRouteDistanceMod = 130
WHERE Type = 'WORLDSIZE_LARGE';

UPDATE Worlds
SET
	ReformationPercentRequired = 60,
	NumCitiesUnhappinessPercent = 60,
	TradeRouteDistanceMod = 160
WHERE Type = 'WORLDSIZE_HUGE';

-- Jordan: Trading Posts (Villages) restricted to flat land, so the AI stops
-- spamming them on hills. Replaces the standalone "Global - Trading Posts Flat
-- Land" mod. NOTE: that mod also disabled Forts (PrereqTech=TECH_NO_EXIST);
-- intentionally NOT ported here because it conflicts with GLOBAL_PASSABLE_FORTS.
UPDATE Improvements
SET RequiresFlatlands = 1
WHERE Type = 'IMPROVEMENT_TRADING_POST';
